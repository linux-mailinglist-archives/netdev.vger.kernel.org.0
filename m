Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6512C6DC35B
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 07:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDJFvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 01:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDJFvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 01:51:53 -0400
Received: from mail.fintek.com.tw (mail.fintek.com.tw [59.120.186.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAD23AA1;
        Sun,  9 Apr 2023 22:51:50 -0700 (PDT)
Received: from vmMailSRV.fintek.com.tw ([192.168.1.1])
        by mail.fintek.com.tw with ESMTP id 33A5oVrk078423;
        Mon, 10 Apr 2023 13:50:31 +0800 (+08)
        (envelope-from peter_hong@fintek.com.tw)
Received: from [192.168.1.132] (192.168.1.132) by vmMailSRV.fintek.com.tw
 (192.168.1.1) with Microsoft SMTP Server id 14.3.498.0; Mon, 10 Apr 2023
 13:50:30 +0800
Message-ID: <7e9c01da-74be-3d8d-bb0c-d90935d82081@fintek.com.tw>
Date:   Mon, 10 Apr 2023 13:50:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
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
 <8f43fc07-39b1-4b1b-9dc6-257eb00c3a81@fintek.com.tw>
 <CAMZ6RqLnWARxkJx0gBsee4NsyQicpg6=bPaysmoFo6KRc-j23g@mail.gmail.com>
From:   Peter Hong <peter_hong@fintek.com.tw>
In-Reply-To: <CAMZ6RqLnWARxkJx0gBsee4NsyQicpg6=bPaysmoFo6KRc-j23g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.1.132]
X-TM-AS-Product-Ver: SMEX-12.5.0.2055-9.0.1002-27556.001
X-TM-AS-Result: No-8.228900-8.000000-10
X-TMASE-MatchedRID: QW5G6BKkLTr/9O/B1c/Qy3UVR7WQKpLPt3aeg7g/usDkMnUVL5d0E5tX
        hf4dcLJZOelJXrqHws2rlQnbB6G4N82IoAvAG8Cy30kDaWZBE1R+tO36GYDlsgl4w4lfxz2cSnO
        y7poAHRrWsfhGDQA5PTAws7fV6qWw7aXkNnpvXLLwlvzzUUaf2fi4nVERfgwd1YzbHoRn9L0raq
        zVuCoM+DgcW36+ooYMdUeSBnFjAYDGY1kvv3J4DB1kSRHxj+Z5IfZjRfGTydhYfsHHDgAMI5Xwt
        1rkqwjUWjOVO3UV6ptftuJwrFEhTbew1twePJJB3QfwsVk0UbvqwGfCk7KUsxO22CBRpq1UPBMN
        rkVVX83sjZNB2Q/Fx0Av24nJL+j9q6WDBSb0v69tep0NvthBTC8Mf4EVVljDypn/B+ELFzmCGFs
        tHoGsHHzlz/HUVCh2B6+0uCqc8tyLs8R3TAgGUSPYQweeBxKQftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.228900-8.000000
X-TMASE-Version: SMEX-12.5.0.2055-9.0.1002-27556.001
X-TM-SNTS-SMTP: BB6645C25AD8B4BDB3877DC26628263DA85330F7ED6B42D0F785BF6F6B7E23D62000:8
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL: mail.fintek.com.tw 33A5oVrk078423
X-Spam-Status: No, score=-2.9 required=5.0 tests=NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

Vincent MAILHOL 於 2023/3/30 下午 09:11 寫道:
> Hmm, I am still not a fan of setting a mutex for a single concurrency
> issue which can only happen during probing.
>
> What about this:
>
>    static int __f81604_set_termination(struct net_device *netdev, u16 term)
>    {
>            struct f81604_port_priv *port_priv = netdev_priv(netdev);
>            u8 mask, data = 0;
>
>            if (netdev->dev_id == 0)
>                    mask = F81604_CAN0_TERM;
>            else
>                    mask = F81604_CAN1_TERM;
>
>            if (term == F81604_TERMINATION_ENABLED)
>                    data = mask;
>
>            return f81604_mask_set_register(port_priv->dev, F81604_TERMINATOR_REG,
>                                            mask, data);
>    }
>
>    static int f81604_set_termination(struct net_device *netdev, u16 term)
>    {
>            ASSERT_RTNL();
>
>            return __f81604_set_termination(struct net_device *netdev, u16 term);
>    }
>
>    static int f81604_init_termination(struct f81604_priv *priv)
>    {
>            int i, ret;
>
>            for (i = 0; i < ARRAY_SIZE(f81604_priv->netdev); i++) {
>                    ret = __f81604_set_termination(f81604_priv->netdev[i],
>                                                   F81604_TERMINATION_DISABLED);
>                    if (ret)
>                            return ret;
>            }
>    }
>
>    static int f81604_probe(struct usb_interface *intf,
>                            const struct usb_device_id *id)
>    {
>            /* ... */
>
>            err = f81604_init_termination(priv);
>            if (err)
>                    goto failure_cleanup;
>
>            for (i = 0; i < ARRAY_SIZE(f81604_priv->netdev); i++) {
>                    /* ... */
>            }
>
>            /* ... */
>    }
>
> Initialise all resistors with __f81604_set_termination() in probe()
> before registering any network device. Use f81604_set_termination()
> which has the lock assert elsewhere.

The f81604_set_termination() will transform into the following code:

static int f81604_write(struct usb_device *dev, u16 reg, u8 data);
static int f81604_read(struct usb_device *dev, u16 reg, u8 *data);
static int f81604_update_bits(struct usb_device *dev, u16 reg, u8 mask,
                                                u8 data);

static int __f81604_set_termination(struct usb_device *dev, int idx, u16 
term)
{
     u8 mask, data = 0;

     if (idx == 0)
         mask = F81604_CAN0_TERM;
     else
         mask = F81604_CAN1_TERM;

     if (term)
         data = mask;

     return f81604_update_bits(dev, F81604_TERMINATOR_REG, mask, data);
}

static int f81604_set_termination(struct net_device *netdev, u16 term)
{
     struct f81604_port_priv *port_priv = netdev_priv(netdev);
     struct f81604_priv *priv;

     ASSERT_RTNL();

     priv = usb_get_intfdata(port_priv->intf);

     return __f81604_set_termination(port_priv->dev, netdev->dev_id, term);
}

and also due to f81604_write() / f81604_read() / f81604_update_bits() 
may use
in f81604_probe() without port private data, so we'll change their first 
parameter
from "struct f81604_port_priv *priv" to "struct usb_device *dev". Is it OK ?


> Also, looking at your probe() function, in label clean_candev:, if the
> second can channel fails its initialization, you do not clean the
> first can channel. I suggest adding a f81604_init_netdev() and
> handling the netdev issue and cleanup in that function.

When the second can channel failed its initialization, the label 
"clean_candev" will
clear second "netdev" object and the first "netdev" will cleanup in
f81604_disconnect().

Could I remain this section of code ?

Thanks
