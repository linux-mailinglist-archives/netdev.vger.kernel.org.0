Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A0250BD58
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 18:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449808AbiDVQqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 12:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbiDVQqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 12:46:45 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2315F279
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 09:43:42 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id s17so12027076plg.9
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 09:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7RBBLesM4CISjM7z2uS2teEVhnF/MXpekf57tAMOUVM=;
        b=VpPAYQkfg644Z13JQsl6sk41sEvH3R5b2uuvwjzHqR7d/zGIyC7hLVXDn4+XibzLBl
         swru1Sll+NKoTumja9eNVX3SqhSy32Wppqu8/lavoTH/t/ZxXbeTxLJBtxa9zUpLCAuc
         ECGOWxOXt8Wb0dC1XBjm4W3G+GkkKD17819m8PVLoOLvFdl3BCOLk8ukuXE2sotMogKK
         y13R45YxVTOkQ8NY2biXeCJ5iGPXpLpFcBp+f4rsLs5fxanHySYEtjMffi3lLSeLWd6+
         RuJnkCEBYXR1gz18cL/3aRXMuFCYug5SnTfeeS4gV7RYw9P3aDO0VIj4+51BT9lgxDrz
         hDGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7RBBLesM4CISjM7z2uS2teEVhnF/MXpekf57tAMOUVM=;
        b=1Cbw/kshNPiXIluvwvKAo3njP1j+mBAxCI8D23J0uWmLBQ5hwt/iYHzvmqTwO1Q3s9
         HKm988mX2kLuxKucWPXrygZXG1b6nL3lzvDMs+32vf/RsdquTCdCVHXjRB6djhIkYxXD
         hc2jo+k9dOv7w2piBRmFXA0NKU0mdlt515VDCWOQK1Jgjp2n3oWz8HOdN8MBfCQm4sXO
         25oLPI0zMHFDjbYD2QvVHwtBdNyV2Sb9lwPVR1kKx8RG8YUHsRHj6hzzqmXZahLKIGeD
         +yNWK8WGduU+UlPz/QULR+gHZ3lwBmijmsOd3SJdvW/BnFjpY+6o9aPvhsWKrf2L970c
         kd9Q==
X-Gm-Message-State: AOAM530CD+onqzXe3MSFT9WWo49wX/o6yFhNuhzWusz5EY7K47Y7d+h0
        5qiDfuOIlh8uVgarUfi2/u46/JwI2to=
X-Google-Smtp-Source: ABdhPJzHef0R2kJ31hl9/24GSd2J5YxdI987RDiZFK97ygzRZnvJxeOLT/ILY/8RVxRhz9kjRYN3Ug==
X-Received: by 2002:a17:902:7247:b0:156:9d3d:756d with SMTP id c7-20020a170902724700b001569d3d756dmr5464527pll.6.1650645822022;
        Fri, 22 Apr 2022 09:43:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m1-20020a17090ade0100b001cb3feaddfcsm5592108pjv.2.2022.04.22.09.43.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 09:43:41 -0700 (PDT)
Message-ID: <18fa586c-9bfc-9c91-fbac-b3df35b496fc@gmail.com>
Date:   Fri, 22 Apr 2022 09:43:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 5/5] net: dsa: b53: mark as non-legacy
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <YhS3cko8D5c5tr+E@shell.armlinux.org.uk>
 <E1nMSDS-00A2Ru-6J@rmk-PC.armlinux.org.uk>
 <28bb4c50-c79e-8f09-2a00-ebbaa91ba1a6@gmail.com>
 <YmJbzay/OiSAxYWF@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YmJbzay/OiSAxYWF@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/22 00:39, Russell King (Oracle) wrote:
> On Thu, Apr 21, 2022 at 03:31:26PM -0700, Florian Fainelli wrote:
>> Hi Russell,
>>
>> On 2/22/22 02:16, Russell King (Oracle) wrote:
>>> The B53 driver does not make use of the speed, duplex, pause or
>>> advertisement in its phylink_mac_config() implementation, so it can be
>>> marked as a non-legacy driver.
>>>
>>> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>>> ---
>>>    drivers/net/dsa/b53/b53_common.c | 6 ++++++
>>>    1 file changed, 6 insertions(+)
>>>
>>> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
>>> index 50a372dc32ae..83bf30349c26 100644
>>> --- a/drivers/net/dsa/b53/b53_common.c
>>> +++ b/drivers/net/dsa/b53/b53_common.c
>>> @@ -1346,6 +1346,12 @@ static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
>>>    	/* Get the implementation specific capabilities */
>>>    	if (dev->ops->phylink_get_caps)
>>>    		dev->ops->phylink_get_caps(dev, port, config);
>>> +
>>> +	/* This driver does not make use of the speed, duplex, pause or the
>>> +	 * advertisement in its mac_config, so it is safe to mark this driver
>>> +	 * as non-legacy.
>>> +	 */
>>> +	config->legacy_pre_march2020 = false;
>>
>> This patch appears to cause a regression for me, I am not sure why I did not
>> notice it back when I tested it but I suspect it had to do with me testing
>> only with a copper module and not with a fiber module.
>>
>> Now that I tested it again, the SFP port (port 5 in my set-up) link up
>> interrupt does not fire up when setting config->legacy_pre_march2020 to
>> false.
>>
>> Here is a working log with phylink debugging enabled:
>>
>> # udhcpc -i sfp
>> udhcpc: started, v1.35.0
>> [   49.479637] bgmac-enet 18024000.ethernet eth2: Link is Up - 1Gbps/Full -
>> flow control off
>> [   49.488139] Generic PHY fixed-0:02: PHY state change UP -> RUNNING
>> [   49.488256] b53-srab-switch 18036000.ethernet-switch sfp: configuring for
>> inband/1000base-x link mode
>> [   49.504062] b53-srab-switch 18036000.ethernet-switch sfp: major config
>> 1000base-x
>> [   49.511800] b53-srab-switch 18036000.ethernet-switch sfp:
>> phylink_mac_config: mode=inband/1000base-x/Unknown/Unknown
>> adv=0000000,00000201
>> [   49.527504] b53-srab-switch 18036000.ethernet-switch sfp: mac link down
>> [   49.535044] sfp sfp: SM: enter present:down:down event dev_up
>> [   49.541006] sfp sfp: tx disable 1 -> 0
>> [   49.544897] sfp sfp: SM: exit present:up:wait
>> [   49.549509] IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
>> udhcpc: broadcasting discover
>> [   49.595185] sfp sfp: SM: enter present:up:wait event timeout
>> [   49.601064] sfp sfp: SM: exit present:up:link_up
>> [   52.388917] b53-srab-switch 18036000.ethernet-switch sfp: mac link up
>> [   52.396513] b53-srab-switch 18036000.ethernet-switch sfp: Link is Up -
>> 1Gbps/Full - flow control rx/tx
>> [   52.406145] IPv6: ADDRCONF(NETDEV_CHANGE): sfp: link becomes ready
>> udhcpc: broadcasting discover
>> udhcpc: broadcasting select for 192.168.3.156, server 192.168.3.1
>> udhcpc: lease of 192.168.3.156 obtained from 192.168.3.1, lease time 600
>> deleting routers
>> adding dns 192.168.1.1
>>
>> and one that is not working with phylink debugging enabled:
>>
>> # udhcpc -i sfp
>> udhcpc: started, v1.35.0
>> [   27.863529] bgmac-enet 18024000.ethernet eth2: Link is Up - 1Gbps/Full -
>> flow control off
>> [   27.872021] Generic PHY fixed-0:02: PHY state change UP -> RUNNING
>> [   27.872120] b53-srab-switch 18036000.ethernet-switch sfp: configuring for
>> inband/1000base-x link mode
>> [   27.887952] b53-srab-switch 18036000.ethernet-switch sfp: major config
>> 1000base-x
>> [   27.895689] b53-srab-switch 18036000.ethernet-switch sfp:
>> phylink_mac_config: mode=inband/1000base-x/Unknown/Unknown
>> adv=0000000,00000201
>> [   27.895802] b53-srab-switch 18036000.ethernet-switch sfp: mac link down
>> [   27.911945] sfp sfp: SM: enter present:down:down event dev_up
>> [   27.923947] sfp sfp: tx disable 1 -> 0
>> [   27.927835] sfp sfp: SM: exit present:up:wait
>> [   27.932442] IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
>> udhcpc: broadcasting discover
>> [   27.978181] sfp sfp: SM: enter present:up:wait event timeout
>> [   27.984056] sfp sfp: SM: exit present:up:link_up
>> [   30.686440] b53-srab-switch 18036000.ethernet-switch sfp: mac link up
>> udhcpc: broadcasting discover
>> udhcpc: broadcasting discover
>>
>> The mac side appears to be UP but not no carrier is set to the sfp network
>> device. Do you have any idea why that would happen?
> 
> Oh, it's because setting that flag means we're wanting the PCS methods
> rather than the legacy MAC methods for an_restart and getting the PCS
> link state - so the patch in question was submitted too early (it
> should have been _after_ the conversion to PCS.)

Meh, sorry I was really slow on this and did not even connect the dots. 
Indeed that is what it is.

> 
> If we get the patch reverted in net-next, and then convert b53 to use
> PCS support, we'll then be putting the patch back, so I wonder if it
> would just make sense to apply the PCS conversion patch, possibly
> adding a comment in the commit message pointing out that this fixes
> the b53 legacy_pre_march2020 patch. Thoughts?

I just responded to your other patch "net: dsa: b53: convert to 
phylink_pcs", so if we target that one for 'net' I think we should be 
good to go.

Thanks!
-- 
Florian
