Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020756CB4C4
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 05:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbjC1DTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 23:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjC1DTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 23:19:53 -0400
Received: from mail.fintek.com.tw (mail.fintek.com.tw [59.120.186.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4357710CA;
        Mon, 27 Mar 2023 20:19:50 -0700 (PDT)
Received: from vmMailSRV.fintek.com.tw ([192.168.1.1])
        by mail.fintek.com.tw with ESMTP id 32S3IiQi058277;
        Tue, 28 Mar 2023 11:18:44 +0800 (+08)
        (envelope-from peter_hong@fintek.com.tw)
Received: from [192.168.1.111] (192.168.1.111) by vmMailSRV.fintek.com.tw
 (192.168.1.1) with Microsoft SMTP Server id 14.3.498.0; Tue, 28 Mar 2023
 11:18:43 +0800
Message-ID: <5bdee736-7868-81c3-e63f-a28787bd0007@fintek.com.tw>
Date:   Tue, 28 Mar 2023 11:18:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH V3] can: usb: f81604: add Fintek F81604 support
Content-Language: en-US
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
CC:     <wg@grandegger.com>, <mkl@pengutronix.de>,
        <michal.swiatkowski@linux.intel.com>,
        <Steen.Hegelund@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <frank.jungclaus@esd.eu>, <linux-kernel@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <hpeter+linux_kernel@gmail.com>
References: <20230327051048.11589-1-peter_hong@fintek.com.tw>
 <CAMZ6Rq+ps1tLii1VfYyAqfD4ck_TGWBUo_ouK_vLfhoNEg-BPg@mail.gmail.com>
From:   Peter Hong <peter_hong@fintek.com.tw>
In-Reply-To: <CAMZ6Rq+ps1tLii1VfYyAqfD4ck_TGWBUo_ouK_vLfhoNEg-BPg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.1.111]
X-TM-AS-Product-Ver: SMEX-12.5.0.2055-9.0.1002-27530.001
X-TM-AS-Result: No-7.990000-8.000000-10
X-TMASE-MatchedRID: gzVbiXtWD9v/9O/B1c/Qy3UVR7WQKpLPC/ExpXrHizzNcDGAMPdV9+J1
        Z55wDcxTB1Q/hS3bW9EOLDetfgAGJuELIy87MLr+nVTWWiNp+v/0swHSFcVJ6OjMOEZ5AL0S8y0
        S9JacVy+7NbSZc60NuauVCdsHobg3xZYesGakkusZgmFGHqyx63607foZgOWytwi3bXRtaAjLqp
        eT6UXHoA0mmbOIq98WQZndHGkHvOfKVlK+ZD4tD9yBRU/cKn69MoS2PLq1B75M+b8yxBqvA46My
        bdCDh5gSpAFNe4DUJ6H+8KYiFISoinqwKmU0oYzhqdH8K9g7xd7hg5h3855AubnFWpNX1DBunqB
        IQj+1JmQn/TyVRWddCYHONDCYeA20qC4NoBZfqzEOJqSsn5KmR6OXxdRGLx8y3v7xMC1C6RsKs8
        i+cqOr5xuEByUpzTftB35FpYtHMZyNLIRgHOxXsp9Bgr5ONKhMVx/3ZYby7+q+LxFU7C3tmcduY
        7Ph1FD585VzGMOFzABi3kqJOK62QtuKBGekqUpnH7sbImOEBTIljWAt/a0oj3gWXE4r5BuZktF7
        gomgCu2Vh+y/eGrhbyH+tFkkwsg8UVNvYa2McYoDkna7QJAeA99pC5jqgWkq7qwdb6tHadiouj3
        9kMFs02viMYyOMeglkEG27gbXTQ3u31m+KVyduulxyHOcPoH
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.990000-8.000000
X-TMASE-Version: SMEX-12.5.0.2055-9.0.1002-27530.001
X-TM-SNTS-SMTP: 5C27E5AABC32B491905B4A7100DA75432EDE5757E0E3DDF12F1128D1E404E12E2000:8
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL: mail.fintek.com.tw 32S3IiQi058277
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

Vincent MAILHOL 於 2023/3/27 下午 06:27 寫道:
> eff->id is a 32 bit value. It is not aligned. So, you must always use
> {get|set}_unaligned_be32() to manipulate this value.
> N.B. on x86 architecture, unaligned access is fine, but some other
> architecture may throw a fault. Read this for more details:
>
>    https://docs.kernel.org/arm/mem_alignment.html

for the consistency of the code, could I also add get/put_unaligned_be16 
in SFF
sections ?

>> +static int f81604_set_reset_mode(struct net_device *netdev)
>> +{
>> +       struct f81604_port_priv *priv = netdev_priv(netdev);
>> +       int status, i;
>> +       u8 tmp;
>> +
>> +       /* disable interrupts */
>> +       status = f81604_set_sja1000_register(priv->dev, netdev->dev_id,
>> +                                            SJA1000_IER, IRQ_OFF);
>> +       if (status)
>> +               return status;
>> +
>> +       for (i = 0; i < F81604_SET_DEVICE_RETRY; i++) {
> Thanks for removing F81604_USB_MAX_RETRY.
>
> Yet, I still would like to understand why you need one hundred tries?
> Is this some paranoiac safenet? Or does the device really need so many
> attempts to operate reliably? If those are needed, I would like to
> understand the root cause.

This section is copy from sja1000.c. In my test, the operation/reset may 
retry 1 times.
I'll reduce it from 100 to 10 times.


>> +       int status, len;
>> +
>> +       if (can_dropped_invalid_skb(netdev, skb))
>> +               return NETDEV_TX_OK;
>> +
>> +       netif_stop_queue(netdev);
> In your driver, you send the CAN frames one at a time and wait for the
> rx_handler to restart the queue. This approach dramatically degrades
> the throughput. Is this a device limitation? Is the device not able to
> manage more than one frame at a time?
>

This device will not NAK on TX frame not complete, it only NAK on TX 
endpoint
memory not processed, so we'll send next frame unitl TX complete(TI) 
interrupt
received.

The device can polling status register via TX/RX endpoint, but it's more 
complex.
We'll plan to do it when first driver landing in mainstream.

>> +static int f81604_set_termination(struct net_device *netdev, u16 term)
>> +{
>> +       struct f81604_port_priv *port_priv = netdev_priv(netdev);
>> +       struct f81604_priv *priv;
>> +       u8 mask, data = 0;
>> +       int r;
>> +
>> +       priv = usb_get_intfdata(port_priv->intf);
>> +
>> +       if (netdev->dev_id == 0)
>> +               mask = F81604_CAN0_TERM;
>> +       else
>> +               mask = F81604_CAN1_TERM;
>> +
>> +       if (term == F81604_TERMINATION_ENABLED)
>> +               data = mask;
>> +
>> +       mutex_lock(&priv->mutex);
> Did you witness a race condition?
>
> As far as I know, this call back is only called while the network
> stack big kernel lock (a.k.a. rtnl_lock) is being hold.
> If you have doubt, try adding a:
>
>    ASSERT_RTNL()
>
> If this assert works, then another mutex is not needed.

It had added ASSERT_RTNL() into f81604_set_termination(). It only assert
in f81604_probe() -> f81604_set_termination(), not called via ip command:
     ip link set dev can0 type can termination 120
     ip link set dev can0 type can termination 0

so I'll still use mutex on here.

>> +               port_priv->can.do_get_berr_counter = f81604_get_berr_counter;
>> +               port_priv->can.ctrlmode_supported =
>> +                       CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_3_SAMPLES |
>> +                       CAN_CTRLMODE_ONE_SHOT | CAN_CTRLMODE_BERR_REPORTING |
>> +                       CAN_CTRLMODE_CC_LEN8_DLC | CAN_CTRLMODE_PRESUME_ACK;
> Did you test the CAN_CTRLMODE_CC_LEN8_DLC feature? Did you confirm
> that you can send and receive DLC greater than 8?

Sorry, I had misunderstand the define. This device is only support 0~8 
data length,
so I'll remove CAN_CTRLMODE_CC_LEN8_DLC in future patch.

Thanks,

