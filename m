Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DD148417F
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 13:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiADMJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 07:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiADMJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 07:09:17 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488F6C061761;
        Tue,  4 Jan 2022 04:09:17 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id a203-20020a1c7fd4000000b003457874263aso22601660wmd.2;
        Tue, 04 Jan 2022 04:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=jaqyMdJNQ92L1SoQFR/daU3pPOKRwHwALSLpJhqen9k=;
        b=cwzeN/qob+a0OJuuFE6Z8TOIP7VRVbhH7uHSIj8AD1Nnga/UOoHvCSQgTuicgfCPr0
         mNYT5OxcyEYxQ5Gi/kphWklpLzfOoUdcZRKxDApBUxxn5Z2eUsYMwnXjPitVNJ7w+BPs
         x1pVV2/nFr+SzOYxuvwU6fzs9bXZgrTpkk/dWXiEUbrQasLbAdwGCU/IqfE8DdExlxvF
         p/MNWRaoZ8ij4rc7tCkdfA6kateTwa+6dom8XitNA2e0RvOBfzdHsXxz9Ww0JFm8phf9
         iXES3WbIvuAE+56zqdXplzNblwE72dAKzNvA0GAzBAeVuO2lRyWqTyY8IPwzHWxBOyJK
         U/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jaqyMdJNQ92L1SoQFR/daU3pPOKRwHwALSLpJhqen9k=;
        b=gyKYgUwDFlhFCXpIkWIV+cS4BOhOEZp17RCvVF0f+JqAkeQNpQGg6C3b67IggqSep1
         FQJ+u0Kaz/Gbc1uFPJBbfAA2D55Ge4s2gdeYke+xR4CYMFo7hKoC2NCbx7VBXfydU5zU
         4FfGjqijrqKBlSwcWEoL4S5wivt5TYgUWgISfPH1sj1A10fIUSE5UraqjGrnaththIr1
         BNlb8WlVCjWKKOu91hYL+cNXpgxTiAE0VPR9O19WBdx+khSdbBCIQADtsMLbCuly8NjK
         urlfmBopxjoxJ/IDjhIbMDw33NOuqT4Yvq+b04edlWKxuWmyNeT3FUpZ1uIyBZCBIKUW
         qnwQ==
X-Gm-Message-State: AOAM532UV0gh9yAhkoUoOizIwh6AlKmBbfVuwk54f+y2y17NmMtRYeay
        mGMir6A5DhOS+5jKuHBVeHs=
X-Google-Smtp-Source: ABdhPJzwtHSsinhDjC9nNlm5oH9ALeaF0WE8I7TlbzhvXxzf+JSyTZJRT/cZ1rNAs0zs5Eic3SCYLw==
X-Received: by 2002:a05:600c:3844:: with SMTP id s4mr41619971wmr.124.1641298155935;
        Tue, 04 Jan 2022 04:09:15 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id u16sm6807769wrn.24.2022.01.04.04.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 04:09:15 -0800 (PST)
Date:   Tue, 4 Jan 2022 13:09:13 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     linus.walleij@linaro.org, ulli.kroll@googlemail.com,
        kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: marvell: network working with generic PHY and not with
 marvell PHY
Message-ID: <YdQ46conUeZ3Qaac@Red>
References: <YdQoOSXS98+Af1wO@Red>
 <YdQsJnfqjaFrtC0m@shell.armlinux.org.uk>
 <YdQwexJVfrdzEfZK@Red>
 <YdQydK4GhI0P5RYL@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YdQydK4GhI0P5RYL@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, Jan 04, 2022 at 11:41:40AM +0000, Russell King (Oracle) a écrit :
> On Tue, Jan 04, 2022 at 12:33:15PM +0100, Corentin Labbe wrote:
> > Le Tue, Jan 04, 2022 at 11:14:46AM +0000, Russell King (Oracle) a écrit :
> > > On Tue, Jan 04, 2022 at 11:58:01AM +0100, Corentin Labbe wrote:
> > > > Hello
> > > > 
> > > > I have a gemini SSI 1328 box which has a cortina ethernet MAC with a Marvell 88E1118 as given by:
> > > > Marvell 88E1118 gpio-0:01: attached PHY driver (mii_bus:phy_addr=gpio-0:01, irq=POLL)
> > > > So booting with CONFIG_MARVELL_PHY=y lead to a non-working network with link set at 1Gbit
> > > > Setting 'max-speed = <100>;' (as current state in mainline dtb) lead to a working network.
> > > > By not working, I mean kernel started with ip=dhcp cannot get an IP.
> > > 
> > > How is the PHY connected to the host (which interface mode?) If it's
> > > RGMII, it could be that the wrong RGMII interface mode is specified in
> > > DT.
> > > 
> > 
> > The PHY is set as RGMII in DT (arch/arm/boot/dts/gemini-ssi1328.dts)
> > The only change to the mainline dtb is removing the max-speed.
> 
> So, it's using "rgmii" with no delay configured at the PHY with the
> speed limited to 100Mbps. You then remove the speed limitation and
> it doesn't work at 1Gbps.
> 
> I think I've seen this on other platforms (imx6 + ar8035) when the
> RGMII delay is not correctly configured - it will work at slower
> speeds but not 1G.
> 
> The RGMII spec specifies that there will be a delay - and the delay can
> be introduced by either the MAC, PHY or by PCB track routing. It sounds
> to me like your boot environment configures the PHY to introduce the
> necessary delay, but then, because the DT "rgmii" mode means "no delay
> at the PHY" when you use the Marvell driver (which respects that), the
> Marvell driver configures the PHY for no delay, resulting in a non-
> working situation at 1G.
> 
> I would suggest checking how the boot environment configures the PHY,
> and change the "rgmii" mode in DT to match. There is a description of
> the four RGMII modes in Documentation/networking/phy.rst that may help
> understand what each one means.
> 

So if I understand, the generic PHY does not touch delays and so values set by bootloader are kept.

The boot environment give no clue on how the PHY is set.
Only debug showed is:
PHY 0 Addr 1 Vendor ID: 0x01410e11
mii_write: phy_addr=0x1 reg_addr=0x4 value=0x5e1 
mii_write: phy_addr=0x1 reg_addr=0x9 value=0x300 
mii_write: phy_addr=0x1 reg_addr=0x0 value=0x1200 
mii_write: phy_addr=0x1 reg_addr=0x0 value=0x9200 
mii_write: phy_addr=0x1 reg_addr=0x0 value=0x1200

Does it is possible to dump PHY registers when using generic PHY and find delay values ?
For example ethtool -d eth0 ?

If not, my only choice is to bruteforce all delay values until it works.
