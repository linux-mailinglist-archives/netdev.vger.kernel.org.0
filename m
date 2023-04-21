Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531ED6EA244
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 05:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjDUDQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 23:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbjDUDQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 23:16:32 -0400
Received: from mail.fintek.com.tw (mail.fintek.com.tw [59.120.186.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA117ED4;
        Thu, 20 Apr 2023 20:15:57 -0700 (PDT)
Received: from vmMailSRV.fintek.com.tw ([192.168.1.1])
        by mail.fintek.com.tw with ESMTP id 33L3EHlK047385;
        Fri, 21 Apr 2023 11:14:17 +0800 (+08)
        (envelope-from peter_hong@fintek.com.tw)
Received: from [192.168.1.132] (192.168.1.132) by vmMailSRV.fintek.com.tw
 (192.168.1.1) with Microsoft SMTP Server id 14.3.498.0; Fri, 21 Apr 2023
 11:14:17 +0800
Message-ID: <51991fc1-0746-608f-b3bb-78b64e6d1a3e@fintek.com.tw>
Date:   Fri, 21 Apr 2023 11:14:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH V5] can: usb: f81604: add Fintek F81604 support
Content-Language: en-US
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
CC:     <wg@grandegger.com>, <mkl@pengutronix.de>,
        <michal.swiatkowski@linux.intel.com>,
        <Steen.Hegelund@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <frank.jungclaus@esd.eu>, <linux-kernel@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <hpeter+linux_kernel@gmail.com>
References: <20230420024403.13830-1-peter_hong@fintek.com.tw>
 <CAMZ6RqKWrtBMFSD=BzGuCbvj=+3X-A-oW9haJ7=4kyL2AbEuHQ@mail.gmail.com>
From:   Peter Hong <peter_hong@fintek.com.tw>
In-Reply-To: <CAMZ6RqKWrtBMFSD=BzGuCbvj=+3X-A-oW9haJ7=4kyL2AbEuHQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.1.132]
X-TM-AS-Product-Ver: SMEX-12.5.0.2055-9.0.1002-27556.001
X-TM-AS-Result: No-12.873000-8.000000-10
X-TMASE-MatchedRID: +f/wAVSGjuj/9O/B1c/Qy3UVR7WQKpLPt3aeg7g/usBXPwnnY5XL5Db8
        2EsUng9V+EyB0khHCYBQSUm5CsBM4duUUgUooFtQG9TMqjxt7zGYasbATu5ay3qSbXH7IxjN4Q6
        Ie8Gz9n8qTzT1pjjbPFkqRpu1VKDV9xWd9ZideujfSQNpZkETVEqAhuLHn5fEjvbyyGrQ98gNle
        G9Mx1C7zXbr7+yAv7is82x9VbfAVRvrBnHW6XSnErOO5m0+0gEq143/xQVN4BrRM6wvXgDaaTXp
        5VFvysvNnWiLfhauyUsWi4sXciGhWUqiBgJ+bf40oNxPV/0KMTId1+nCKlIfpsoi2XrUn/Jsuf7
        RWbvUtww5jKeVBgYbwtuKBGekqUpI/NGWt0UYPClPA/MtF0LWCeA6vKCgHR06iMafQ3JMAVaEMp
        ze3s0hdfOOh2Ygt5I
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.873000-8.000000
X-TMASE-Version: SMEX-12.5.0.2055-9.0.1002-27556.001
X-TM-SNTS-SMTP: 6DAED8AEC355360EF9BF6AF7F4F9CF6DBF94DF1A67544A25B6ECF6A03954B71A2000:8
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL: mail.fintek.com.tw 33L3EHlK047385
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

Vincent MAILHOL 於 2023/4/20 下午 08:02 寫道:
> Hi Peter,
>
> Here are my comments. Now, it is mostly nitpicks. I guess that this is
> the final round.
>
> On Thu. 20 avr. 2023 at 11:44, Ji-Ze Hong (Peter Hong)
> <peter_hong@fintek.com.tw> wrote:
>> +static void f81604_read_bulk_callback(struct urb *urb)
>> +{
>> +       struct f81604_can_frame *frame = urb->transfer_buffer;
>> +       struct net_device *netdev = urb->context;
>> +       int ret;
>> +
>> +       if (!netif_device_present(netdev))
>> +               return;
>> +
>> +       if (urb->status)
>> +               netdev_info(netdev, "%s: URB aborted %pe\n", __func__,
>> +                           ERR_PTR(urb->status));
>> +
>> +       switch (urb->status) {
>> +       case 0: /* success */
>> +               break;
>> +
>> +       case -ENOENT:
>> +       case -EPIPE:
>> +       case -EPROTO:
>> +       case -ESHUTDOWN:
>> +               return;
>> +
>> +       default:
>> +               goto resubmit_urb;
>> +       }
>> +
>> +       if (urb->actual_length != F81604_DATA_SIZE) {
> It is more readable to use sizeof() instead of a macro.
>
>         if (urb->actual_length != sizeof(*frame)) {
>
>> +               netdev_warn(netdev, "URB length %u not equal to %u\n",
>> +                           urb->actual_length, F81604_DATA_SIZE);
> Idem.
>
>> +               goto resubmit_urb;
>> +       }
> In v4, actual_length was allowed to be any multiple of
> F81604_DATA_SIZE and f81604_process_rx_packet() had a loop to iterate
> through all the messages.
>
> Why did this disappear in v5?

I had over design it. The F81604 will only report 1 frame at 1 bulk-in, 
So I change it to
process 1 frame only.



>> +static void f81604_handle_tx(struct f81604_port_priv *priv,
>> +                            struct f81604_int_data *data)
>> +{
>> +       struct net_device *netdev = priv->netdev;
>> +       struct net_device_stats *stats;
>> +
>> +       stats = &netdev->stats;
> Merge the declaration with the initialization.

If I merge initialization into declaration, it's may violation RCT?
How could I change about this ?

>> +
>> +       /* transmission buffer released */
>> +       if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT &&
>> +           !(data->sr & F81604_SJA1000_SR_TCS)) {
>> +               stats->tx_errors++;
>> +               can_free_echo_skb(netdev, 0, NULL);
>> +       } else {
>> +               /* transmission complete */
>> +               stats->tx_bytes += can_get_echo_skb(netdev, 0, NULL);
>> +               stats->tx_packets++;
>> +       }
>> +
>> +       netif_wake_queue(netdev);
>> +}
>> +
>> +static void f81604_handle_can_bus_errors(struct f81604_port_priv *priv,
>> +                                        struct f81604_int_data *data)
>> +{
>> +       enum can_state can_state = priv->can.state;
>> +       struct net_device *netdev = priv->netdev;
>> +       enum can_state tx_state, rx_state;
>> +       struct net_device_stats *stats;
>> +       struct can_frame *cf;
>> +       struct sk_buff *skb;
>> +
>> +       stats = &netdev->stats;
> Merge the declaration with the initialization.
>
> Especially, here it is odd that can_state and netdev are initialized
> during declaration and that only stats is initialized separately.

idem

>> +               tx_state = data->txerr >= data->rxerr ? can_state : 0;
>> +               rx_state = data->txerr <= data->rxerr ? can_state : 0;
>> +
>> +               can_change_state(netdev, cf, tx_state, rx_state);
>> +
>> +               if (can_state == CAN_STATE_BUS_OFF)
>> +                       can_bus_off(netdev);
>> +       }
>> +
>> +       if (priv->clear_flags)
>> +               schedule_work(&priv->clear_reg_work);
>> +
>> +       if (skb)
>> +               netif_rx(skb);
>> +}
>> +
>> +static void f81604_read_int_callback(struct urb *urb)
>> +{
>> +       struct f81604_int_data *data = urb->transfer_buffer;
>> +       struct net_device *netdev = urb->context;
>> +       struct f81604_port_priv *priv;
>> +       int ret;
>> +
>> +       priv = netdev_priv(netdev);
> Merge the declaration with the initialization.

idem

>> +               id = (cf->can_id & CAN_SFF_MASK) << F81604_SFF_SHIFT;
>> +               put_unaligned_be16(id, &frame->sff.id);
>> +
>> +               if (!(cf->can_id & CAN_RTR_FLAG))
>> +                       memcpy(&frame->sff.data, cf->data, cf->len);
>> +       }
>> +
>> +       can_put_echo_skb(skb, netdev, 0, 0);
>> +
>> +       ret = usb_submit_urb(write_urb, GFP_ATOMIC);
>> +       if (ret) {
>> +               netdev_err(netdev, "%s: failed to resubmit tx bulk urb: %pe\n",
>> +                          __func__, ERR_PTR(ret));
>> +
>> +               can_free_echo_skb(netdev, 0, NULL);
>> +               stats->tx_dropped++;
> Stats is only used once. Maybe better to not declare a variable and do:
>
>                 netdev->stats.tx_dropped++;
>
> Also, more than a drop, this looks like an error. So:
>                 netdev->stats.tx_errors++;

Due to lable nomem_urb and tx_dropped/ tx_errors will not only use once, 
so I'll remain it.

Thanks,

