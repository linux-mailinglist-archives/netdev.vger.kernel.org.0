Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4E250AB8A
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 00:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442496AbiDUWeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 18:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241336AbiDUWeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 18:34:20 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65891427D0
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 15:31:29 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id p3so4933599pfw.0
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 15:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iY0BfdvSNkeoxaOKGPm9iaWnqzRV35nyfRl0UlSd4dg=;
        b=GysBrLeWdwzLILGUWNEz8Mvxg5rAQ0GUqTLZk0ccMbdBT5O2nxuAuWG7gGN9TMYu5D
         CFo48az9H01poSroE0Z+cp2Uc0hYUSgM8FmDyzFZsatDIaO1gQVJra0Q/5NHy3CreYBV
         cr8zcZVJ3/3wI4x9rugIoGmzVlPAr5t04kJAAPucLXer73nEVofWCLiKz6buI8QMUOj0
         HxuPA0LSje+5INiaPv33dJdUweM4Ey0ygb//f1IiHS24jeYLVjWL0BwYuh+WzKqURduf
         Nz4XJwTmcRUYoe1mY45w5s4Y2YBzeN1ynWKZ2A/5J/LzdRi3IUU4Hz8V97v+uscc76SN
         UdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iY0BfdvSNkeoxaOKGPm9iaWnqzRV35nyfRl0UlSd4dg=;
        b=ZAlLFJD1dEzZI6KetAmJdcxUAXwHA5zq6lKLprasWY4ZV7KKsYuCYj9gKyj16cEs8a
         Qa+Ip1fJY6jVKMXdd7ET8Q4GcJV7gxCnQYfr66I2O17WN7XaEdlmAeiybD7mldw1U2Zj
         e7mORq/kK9128fthqUb1KswMs9wvy/hl5l4Y5N7oIyEkrkAYdxTOBjT7g8BwSHwopAIG
         +XbhmO7Jl/h7TOA+6NqYdZZ83I3Be15LCpcxh1AtHEMBkj3JKvxUYSILZLjXYkwfPRR4
         2rI7xTvTyg2pE3xJxxZLZw7+tG9uVXghfTCQbolu7RwtjLgD0OCebtMW7kzM8/OiSqr3
         mwxQ==
X-Gm-Message-State: AOAM533Hl4MXq1yFXyopB7J4vQ7nhlYHu8PpoBZ+OYiHA8PB7Lbxj54k
        8iGtTEOHMimSOEd31kSc1ZW3QE8n0uI=
X-Google-Smtp-Source: ABdhPJzQXtWlfhb7Ngc4kjqCBgPbr0d1fLk9XYnouLmADF3DLx6wlRK7gSdCZw/WvqTOsuXXvRYpZQ==
X-Received: by 2002:a05:6a00:1a56:b0:50a:436f:6956 with SMTP id h22-20020a056a001a5600b0050a436f6956mr1823994pfv.20.1650580288840;
        Thu, 21 Apr 2022 15:31:28 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c9-20020a63a409000000b0039912d50806sm141801pgf.87.2022.04.21.15.31.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 15:31:28 -0700 (PDT)
Message-ID: <28bb4c50-c79e-8f09-2a00-ebbaa91ba1a6@gmail.com>
Date:   Thu, 21 Apr 2022 15:31:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 5/5] net: dsa: b53: mark as non-legacy
Content-Language: en-US
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <YhS3cko8D5c5tr+E@shell.armlinux.org.uk>
 <E1nMSDS-00A2Ru-6J@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <E1nMSDS-00A2Ru-6J@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 2/22/22 02:16, Russell King (Oracle) wrote:
> The B53 driver does not make use of the speed, duplex, pause or
> advertisement in its phylink_mac_config() implementation, so it can be
> marked as a non-legacy driver.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>   drivers/net/dsa/b53/b53_common.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index 50a372dc32ae..83bf30349c26 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1346,6 +1346,12 @@ static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
>   	/* Get the implementation specific capabilities */
>   	if (dev->ops->phylink_get_caps)
>   		dev->ops->phylink_get_caps(dev, port, config);
> +
> +	/* This driver does not make use of the speed, duplex, pause or the
> +	 * advertisement in its mac_config, so it is safe to mark this driver
> +	 * as non-legacy.
> +	 */
> +	config->legacy_pre_march2020 = false;

This patch appears to cause a regression for me, I am not sure why I did 
not notice it back when I tested it but I suspect it had to do with me 
testing only with a copper module and not with a fiber module.

Now that I tested it again, the SFP port (port 5 in my set-up) link up 
interrupt does not fire up when setting config->legacy_pre_march2020 to 
false.

Here is a working log with phylink debugging enabled:

# udhcpc -i sfp
udhcpc: started, v1.35.0
[   49.479637] bgmac-enet 18024000.ethernet eth2: Link is Up - 
1Gbps/Full - flow control off
[   49.488139] Generic PHY fixed-0:02: PHY state change UP -> RUNNING
[   49.488256] b53-srab-switch 18036000.ethernet-switch sfp: configuring 
for inband/1000base-x link mode
[   49.504062] b53-srab-switch 18036000.ethernet-switch sfp: major 
config 1000base-x
[   49.511800] b53-srab-switch 18036000.ethernet-switch sfp: 
phylink_mac_config: mode=inband/1000base-x/Unknown/Unknown 
adv=0000000,00000201
[   49.527504] b53-srab-switch 18036000.ethernet-switch sfp: mac link down
[   49.535044] sfp sfp: SM: enter present:down:down event dev_up
[   49.541006] sfp sfp: tx disable 1 -> 0
[   49.544897] sfp sfp: SM: exit present:up:wait
[   49.549509] IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
udhcpc: broadcasting discover
[   49.595185] sfp sfp: SM: enter present:up:wait event timeout
[   49.601064] sfp sfp: SM: exit present:up:link_up
[   52.388917] b53-srab-switch 18036000.ethernet-switch sfp: mac link up
[   52.396513] b53-srab-switch 18036000.ethernet-switch sfp: Link is Up 
- 1Gbps/Full - flow control rx/tx
[   52.406145] IPv6: ADDRCONF(NETDEV_CHANGE): sfp: link becomes ready
udhcpc: broadcasting discover
udhcpc: broadcasting select for 192.168.3.156, server 192.168.3.1
udhcpc: lease of 192.168.3.156 obtained from 192.168.3.1, lease time 600
deleting routers
adding dns 192.168.1.1

and one that is not working with phylink debugging enabled:

# udhcpc -i sfp
udhcpc: started, v1.35.0
[   27.863529] bgmac-enet 18024000.ethernet eth2: Link is Up - 
1Gbps/Full - flow control off
[   27.872021] Generic PHY fixed-0:02: PHY state change UP -> RUNNING
[   27.872120] b53-srab-switch 18036000.ethernet-switch sfp: configuring 
for inband/1000base-x link mode
[   27.887952] b53-srab-switch 18036000.ethernet-switch sfp: major 
config 1000base-x
[   27.895689] b53-srab-switch 18036000.ethernet-switch sfp: 
phylink_mac_config: mode=inband/1000base-x/Unknown/Unknown 
adv=0000000,00000201
[   27.895802] b53-srab-switch 18036000.ethernet-switch sfp: mac link down
[   27.911945] sfp sfp: SM: enter present:down:down event dev_up
[   27.923947] sfp sfp: tx disable 1 -> 0
[   27.927835] sfp sfp: SM: exit present:up:wait
[   27.932442] IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
udhcpc: broadcasting discover
[   27.978181] sfp sfp: SM: enter present:up:wait event timeout
[   27.984056] sfp sfp: SM: exit present:up:link_up
[   30.686440] b53-srab-switch 18036000.ethernet-switch sfp: mac link up
udhcpc: broadcasting discover
udhcpc: broadcasting discover

The mac side appears to be UP but not no carrier is set to the sfp 
network device. Do you have any idea why that would happen?
-- 
Florian
