require 'saharspec/matchers/ret'
require 'saharspec/matchers/send_message'

RSpec.describe "combine matchers" do
  let(:obj) {
    Object.new.tap { |o|
      def o.meth
        other_meth
      end

      def o.other_meth
        10
      end
    }
  }

  it do
    expect { obj.meth }.to ret(10)
  end

  it do
    expect { obj.meth }
      .to  send_message(obj, :other_meth).returning(20)
      .and ret(20)
  end

  it do
    expect { obj.meth }
    .to  ret(20)
    .and send_message(obj, :other_meth).returning(20)
  end

  it do
    allow(obj).to receive(:other_meth).and_return(20)

    expect { obj.meth }
      .to ret(20)
  end

  it do
    expect(obj).to receive(:other_meth).and_return(20)

    expect { obj.meth }
      .to ret(20)
  end
end
