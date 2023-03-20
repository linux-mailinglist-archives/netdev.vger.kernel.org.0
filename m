Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322FC6C0921
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 04:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCTDBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 23:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjCTDBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 23:01:02 -0400
Received: from mail.fintek.com.tw (mail.fintek.com.tw [59.120.186.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E904EB79;
        Sun, 19 Mar 2023 20:00:59 -0700 (PDT)
Received: from vmMailSRV.fintek.com.tw ([192.168.1.1])
        by mail.fintek.com.tw with ESMTP id 32K2xZ3J060873;
        Mon, 20 Mar 2023 10:59:35 +0800 (+08)
        (envelope-from peter_hong@fintek.com.tw)
Received: from [192.168.1.111] (192.168.1.111) by vmMailSRV.fintek.com.tw
 (192.168.1.1) with Microsoft SMTP Server id 14.3.498.0; Mon, 20 Mar 2023
 10:59:33 +0800
Message-ID: <186901f9-5d52-2315-f532-26471adcfb55@fintek.com.tw>
Date:   Mon, 20 Mar 2023 10:59:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] can: usb: f81604: add Fintek F81604 support
Content-Language: en-US
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
CC:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <mailhol.vincent@wanadoo.fr>, <frank.jungclaus@esd.eu>,
        <linux-kernel@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <hpeter+linux_kernel@gmail.com>
References: <20230317093352.3979-1-peter_hong@fintek.com.tw>
 <ZBRoCVHV3S3ugEoO@localhost.localdomain>
From:   Peter Hong <peter_hong@fintek.com.tw>
In-Reply-To: <ZBRoCVHV3S3ugEoO@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.1.111]
X-TM-AS-Product-Ver: SMEX-12.5.0.2055-9.0.1002-27514.001
X-TM-AS-Result: No-19.988400-8.000000-10
X-TMASE-MatchedRID: UuaOI1zLN1j/9O/B1c/QyzjNGpWCIvfTlmG/61+LLCeqvcIF1TcLYANw
        091XoRE6sLe9OFkv+Id3TaF7+lCZvoToZqUCO9J5UgKYbZFF6GjcAmu1xqeets+WYjg3WzyKByy
        VimjmJJMPHd/OW2VyD6ve1RQ6Ydsa4EtSNBzFpGASEYfcJF0pRdhQO8CvZj/XK36BWK75QOTVr0
        bDpfV8iIw9rt9E8A4oWo0SBooXS7Tm30AqBxefhDiEPRj9j9rvTJDl9FKHbrmhBPc4ZBrNkb6YV
        RYkPkYC+JitU/PMe9hkCRQbR4V/6j1I7Q1NCxg0+GYt8f/VhTvGYnoF/CTeZQAheUymmndfsMBr
        Nxxo1t/wOGawsB401V5974JFP0LmXHEPHmpuRH2DGx/OQ1GV8rHlqZYrZqdI+gtHj7OwNO0CpgE
        TeT0ynA==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--19.988400-8.000000
X-TMASE-Version: SMEX-12.5.0.2055-9.0.1002-27514.001
X-TM-SNTS-SMTP: E9B5BD1048C40DCF5A422C23447762A0AFA39FCD6982378C40C5FF645BFD0AAA2000:8
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL: mail.fintek.com.tw 32K2xZ3J060873
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Michal Swiatkowski 於 2023/3/17 下午 09:15 寫道:
> On Fri, Mar 17, 2023 at 05:33:52PM +0800, Ji-Ze Hong (Peter Hong) wrote:
>
> --- a/drivers/net/can/usb/Kconfig
> +++ b/drivers/net/can/usb/Kconfig
> @@ -147,4 +147,13 @@ config CAN_UCAN
>   	          from Theobroma Systems like the A31-ÂľQ7 and the RK3399-Q7
>   	          (https://www.theobroma-systems.com/rk3399-q7)
>   
> Hi,
>
> I am not familiar with CAN, so only style review :)

Thanks for your reviews :D
> +
> +	if (status) {
> +		dev_err(&dev->dev, "%s: reg: %x data: %x failed: %d\n",
> +			__func__, reg, data, status);
> +	}
> The { and } aren't needed as inside if is only one line.

Could I remove the { and } when the logical line to split multi-line ?

>> +static int f81604_set_normal_mode(struct net_device *netdev)
>> +{
>> +	struct f81604_port_priv *priv = netdev_priv(netdev);
>> +	int status, i;
>> +	u8 mod_reg_val = 0x00;
> RCT, mod_reg should be one line above

What mean about "RCT"?

Is this section should change to above like ??

     u8 mod_reg_val;
     ...

     mod_reg_val = 0;
>> +static int f81604_register_urbs(struct net_device *netdev)
>> +{
>> +	struct f81604_port_priv *priv = netdev_priv(netdev);
>> +	int status, i;
>> +
>> +	for (i = 0; i < F81604_MAX_RX_URBS; ++i) {
>> +		status = usb_submit_urb(priv->read_urb[i], GFP_KERNEL);
>> +		if (status) {
>> +			netdev_warn(netdev, "%s: submit rx urb failed: %d\n",
>> +				    __func__, status);
>> +			return status;
> Don't know usb subsytem, but shouldn't previously submitted urb be
> killed?

Yes, I had made kill operations in
     f81604_start()
         -> f81604_unregister_urbs()

>> +static void f81604_process_rx_packet(struct urb *urb)
>> +{
>> +	struct net_device_stats *stats;
>> +	struct net_device *netdev;
>> +	struct can_frame *cf;
>> +	struct sk_buff *skb;
>> +	u8 *data;
>> +	u8 *ptr;
>> +	int i;
>> +	int count;
> RCT
>
>> +
>> +	netdev = urb->context;
>> +	stats = &netdev->stats;
>> +	data = urb->transfer_buffer;
> netdev and data can be set in declaration

why only netdev & data ?? Could I set netdev, stats & data in declaration ?


>> +/* Called by the usb core when driver is unloaded or device is removed */
>> +static void f81604_disconnect(struct usb_interface *intf)
>> +{
>> +	struct f81604_priv *priv = usb_get_intfdata(intf);
>> +	int i;
>> +
>> +	for (i = 0; i < F81604_MAX_DEV; ++i) {
>> +		if (!priv->netdev[i])
>> +			continue;
>> +
>> +		unregister_netdev(priv->netdev[i]);
>> +		free_candev(priv->netdev[i]);
>> +	}
> What about closing USB device? It is called brefore disconnect or it
> should be done here?

When candev close in f81604_close(), It will call f81604_set_reset_mode() to
make candev to reset mode.

Thanks
