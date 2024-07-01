defmodule BcNode.Constants do
  def tcp_port do
    49999
  end

  def udp_port do
    49998
  end

  def broadcast_ip do
    {127, 255, 255, 255}
    #{255, 255, 255, 255}
  end
end
