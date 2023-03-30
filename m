Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42326CFBDE
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjC3Grg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjC3Grf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:47:35 -0400
Received: from mail.fintek.com.tw (mail.fintek.com.tw [59.120.186.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A7340C9;
        Wed, 29 Mar 2023 23:47:30 -0700 (PDT)
Received: from vmMailSRV.fintek.com.tw ([192.168.1.1])
        by mail.fintek.com.tw with ESMTP id 32U6kGAt030478;
        Thu, 30 Mar 2023 14:46:16 +0800 (+08)
        (envelope-from peter_hong@fintek.com.tw)
Received: from [192.168.1.132] (192.168.1.132) by vmMailSRV.fintek.com.tw
 (192.168.1.1) with Microsoft SMTP Server id 14.3.498.0; Thu, 30 Mar 2023
 14:46:16 +0800
Message-ID: <8f43fc07-39b1-4b1b-9dc6-257eb00c3a81@fintek.com.tw>
Date:   Thu, 30 Mar 2023 14:46:16 +0800
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
 <5bdee736-7868-81c3-e63f-a28787bd0007@fintek.com.tw>
 <CAMZ6Rq++N9ui5srP2uBYz0FPXttBYd2m982K8X-ESCC=qu1dAQ@mail.gmail.com>
From:   Peter Hong <peter_hong@fintek.com.tw>
In-Reply-To: <CAMZ6Rq++N9ui5srP2uBYz0FPXttBYd2m982K8X-ESCC=qu1dAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.1.132]
X-TM-AS-Product-Ver: SMEX-12.5.0.2055-9.0.1002-27534.001
X-TM-AS-Result: No-6.128700-8.000000-10
X-TMASE-MatchedRID: xcONGPdDH5r/9O/B1c/Qy3UVR7WQKpLPC/ExpXrHizwN76LiU8zntn38
        DhskX88zx3iFO+XIjdu/eowh/j6Um43oygjMeK7edXu122+iJtqRgLeuORRdEr5TVqwOzxj8g9t
        cUGEsbFi/s1GDQQhvSgZ9zGXanbSHylZSvmQ+LQ/cgUVP3Cp+vTKEtjy6tQe+TPm/MsQarwPL8H
        XOTyBD/Epqkmsma/qjSStLDpMKadI6Vyyhf+5DyC9iVDu7EPf8KCXi8INqrihLWMri+QqmsfcLT
        3NnoHhsA8l7UD+NOVgaHZJ0H9OHSy22mMFMFtfH8IK7yRWPRNHJ5SXtoJPLyBS1r4tCARkw3LFu
        yqUR8Gz2kn1T4rnnxUrF/mVEVKMJOgYgCO6OAmY1yhbbA7We00SHIG5/MB3rGPh40PSDz6yGPne
        COFgqRISbWwTw5+ybBK8aOafFdfy/WXZS/HqJ2lZ0V5tYhzdWxEHRux+uk8hxKpvEGAbTDsD+t6
        ElWayBm+xY9xpNA0vfYqmHh24tZjg+MjKEa72hNRzQ9pfg2bVN+6bP0i/wWntZotgvfkXTjSn/v
        dN28UuTh4s9IQvhLK8HNTat3IL0MX9Za3DD1UB2TpWhzRt8y+UdbwqxQvmt
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.128700-8.000000
X-TMASE-Version: SMEX-12.5.0.2055-9.0.1002-27534.001
X-TM-SNTS-SMTP: 9803C5386770317E68586C722A5D039EB0BE9672EA7B5719D78991E0136CAF842000:8
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL: mail.fintek.com.tw 32U6kGAt030478
X-Spam-Status: No, score=0.0 required=5.0 tests=NICE_REPLY_A,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

Vincent MAILHOL 於 2023/3/28 下午 12:49 寫道:
>>>> +static int f81604_set_reset_mode(struct net_device *netdev)
>>>> +{
>>>> +       struct f81604_port_priv *priv = netdev_priv(netdev);
>>>> +       int status, i;
>>>> +       u8 tmp;
>>>> +
>>>> +       /* disable interrupts */
>>>> +       status = f81604_set_sja1000_register(priv->dev, netdev->dev_id,
>>>> +                                            SJA1000_IER, IRQ_OFF);
>>>> +       if (status)
>>>> +               return status;
>>>> +
>>>> +       for (i = 0; i < F81604_SET_DEVICE_RETRY; i++) {
>>> Thanks for removing F81604_USB_MAX_RETRY.
>>>
>>> Yet, I still would like to understand why you need one hundred tries?
>>> Is this some paranoiac safenet? Or does the device really need so many
>>> attempts to operate reliably? If those are needed, I would like to
>>> understand the root cause.
>> This section is copy from sja1000.c. In my test, the operation/reset may
>> retry 1 times.
>> I'll reduce it from 100 to 10 times.
> Is it because the device is not ready? Does this only appear at
> startup or at random?

I'm using ip link up/down to test open/close(). It's may not ready so fast.
but the maximum retry is only 1 for test 10000 times.

>>>> +static int f81604_set_termination(struct net_device *netdev, u16 term)
>>>> +{
>>>> +       struct f81604_port_priv *port_priv = netdev_priv(netdev);
>>>> +       struct f81604_priv *priv;
>>>> +       u8 mask, data = 0;
>>>> +       int r;
>>>> +
>>>> +       priv = usb_get_intfdata(port_priv->intf);
>>>> +
>>>> +       if (netdev->dev_id == 0)
>>>> +               mask = F81604_CAN0_TERM;
>>>> +       else
>>>> +               mask = F81604_CAN1_TERM;
>>>> +
>>>> +       if (term == F81604_TERMINATION_ENABLED)
>>>> +               data = mask;
>>>> +
>>>> +       mutex_lock(&priv->mutex);
>>> Did you witness a race condition?
>>>
>>> As far as I know, this call back is only called while the network
>>> stack big kernel lock (a.k.a. rtnl_lock) is being hold.
>>> If you have doubt, try adding a:
>>>
>>>     ASSERT_RTNL()
>>>
>>> If this assert works, then another mutex is not needed.
>> It had added ASSERT_RTNL() into f81604_set_termination(). It only assert
>> in f81604_probe() -> f81604_set_termination(), not called via ip command:
>>       ip link set dev can0 type can termination 120
>>       ip link set dev can0 type can termination 0
>>
>> so I'll still use mutex on here.
> Sorry, do you mean that the assert throws warnings for f81604_probe()
> -> f81604_set_termination() but that it is OK (no warning) for ip
> command?
>
> I did not see that you called f81604_set_termination() internally.
> Indeed, rtnl_lock is not held in probe(). But I think it is still OK.
> In f81604_probe() you call f81604_set_termination() before
> register_candev(). If the device is not yet registered,
> f81604_set_termination() can not yet be called via ip command. Can you
> describe more precisely where you think there is a concurrency issue?
> I still do not see it.

Sorry, I had inverse the mean of ASSERT_RTNL(). It like you said.
     f81604_probe() not held rtnl_lock.
     ip set terminator will held rtnl_lock.

Due to f81604_set_termination() will called by f81604_probe() to 
initialize, it may need mutex in
situation as following:

User is setting can0 terminator when f81604_probe() complete generate 
can0 and generating can1.
So IMO, the mutex may needed.

>>>> +               port_priv->can.do_get_berr_counter = f81604_get_berr_counter;
>>>> +               port_priv->can.ctrlmode_supported =
>>>> +                       CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_3_SAMPLES |
>>>> +                       CAN_CTRLMODE_ONE_SHOT | CAN_CTRLMODE_BERR_REPORTING |
>>>> +                       CAN_CTRLMODE_CC_LEN8_DLC | CAN_CTRLMODE_PRESUME_ACK;
>>> Did you test the CAN_CTRLMODE_CC_LEN8_DLC feature? Did you confirm
>>> that you can send and receive DLC greater than 8?
>> Sorry, I had misunderstand the define. This device is only support 0~8
>> data length,
>    ^^^^^^^^^^^
>
> Data length or Data Length Code (DLC)? Classical CAN maximum data
> length is 8 but maximum DLC is 15 (and DLC 8 to 15 mean a data length
> of 8).
>

This device can't support DLC > 8. It's only support 0~8.

Thanks

