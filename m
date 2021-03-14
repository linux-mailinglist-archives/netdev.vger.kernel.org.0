Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CCB33A433
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 11:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbhCNKjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 06:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234924AbhCNKj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 06:39:28 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36576C061574;
        Sun, 14 Mar 2021 03:39:28 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id p8so61435206ejb.10;
        Sun, 14 Mar 2021 03:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jjsmnr5FzYMoxt2sTlQ7jPd6uzhNAuqUavfnO0MllWI=;
        b=C3Ps+AyEjo30X/ua5dUcFTMc2/1wzyGikyEVOYts0yq88Nvc97piiqc7rkqUAMHu1S
         LMsVPcQSuwEnaZ+2S6uzQfrUlfRUH9HFoKUcAhsOkjvWnr81VMvvYlcXSNK1Xfo3KHGa
         e4oL0YgYI5YAkCUYVdWv4ba2Ltm06Jrf4IC0mvTNEX0mN/i2UNB/d2LgqbOk8P3P3Nw1
         chQOawVQiix8IkLgJPffD+UMfgzBjWxb4HrLjHqCTHZmgmWsEExuEqfCy6X5TLZKfvk7
         JPpnolbvwWljKmTvMIVDWM1aFgzs5iU4S2SCu7NuHvIZYRLyFs8zHPXLi5vqhc9asM1k
         +o7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jjsmnr5FzYMoxt2sTlQ7jPd6uzhNAuqUavfnO0MllWI=;
        b=AL7dl/AJhuFecJtN4GRx/tNcrKRHDdQfcnoorlhHkTT2TwEjHFuUbtKRedIRlC7xHp
         14EToToQnlPF1aqIna3cps8pb3kEAfe7G6XBMJ6MmuTUj/AhvalHQ1jDfblQDGrdifYH
         ItXKwcDhsY89hL1WBwl50an927G7oPOyojJrHor850Q7OM8+7Z835ZYSXZb+AUJHyur5
         mg3JYsCwTnL9TTtNfICLP0L9CjbSQCp9lJFgchTc2s306upS4Dgh2XVOTsn5CJIp99ij
         0KhtiHpFO5JAPMnRGszS1ymZr2mxwszT+sfciPiC3F7b5jZjQe+NtpN7CxxBGTAXQeH2
         8ZCA==
X-Gm-Message-State: AOAM531VG8aadt2EAsLde84OHiGLdlcm5ay0w7M+F0e/Qr85Nt4ss6aJ
        A2fU4Jv0rXtWKiVl/ctLdQU=
X-Google-Smtp-Source: ABdhPJxWgxN4PoB/cokJVbMonJFcjsPd6jis+Pn3rsvukjKRHYFSjOpz2IvaNc8qtfEJTj96MWWjhg==
X-Received: by 2002:a17:906:110d:: with SMTP id h13mr18343476eja.357.1615718366915;
        Sun, 14 Mar 2021 03:39:26 -0700 (PDT)
Received: from ubuntu2004 ([188.24.140.160])
        by smtp.gmail.com with ESMTPSA id cw14sm6219111edb.8.2021.03.14.03.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 03:39:25 -0700 (PDT)
Date:   Sun, 14 Mar 2021 12:39:26 +0200
From:   Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: ethernet: actions: Add Actions Semi Owl
 Ethernet MAC driver
Message-ID: <20210314103926.GA418860@ubuntu2004>
References: <cover.1615423279.git.cristian.ciocaltea@gmail.com>
 <158d63db7d17d87b01f723433e0ddc1fa24377a8.1615423279.git.cristian.ciocaltea@gmail.com>
 <YEwO33TR7ENHuMaY@lunn.ch>
 <20210314011324.GA991090@BV030612LT>
 <YE2S0MW62lVF/psk@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE2S0MW62lVF/psk@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 05:36:32AM +0100, Andrew Lunn wrote:
> > > > +	if (phy->interface != PHY_INTERFACE_MODE_RMII) {
> > > > +		netdev_err(netdev, "unsupported phy mode: %s\n",
> > > > +			   phy_modes(phy->interface));
> > > > +		phy_disconnect(phy);
> > > > +		netdev->phydev = NULL;
> > > > +		return -EINVAL;
> > > > +	}
> > > 
> > > It looks like the MAC only supports symmetric pause. So you should
> > > call phy_set_sym_pause() to let the PHY know this.
> > 
> > I did not find any reference related to the supported pause types,
> > is this normally dependant on the PHY interface mode?
> 
> There is a MAC / PHY split there. The PHY is responsible for the
> negotiation for what each end can do. But it is the MAC which actually
> implements pause. The MAC needs to listen to pause frames and not send
> out data frames when the link peer indicates pause. And the MAC needs
> to send a pause frames when its receive buffers are full. The code you
> have in this MAC driver seems to indicate the MAC only supports
> symmetric pause. Hence you need to configure the PHY to only auto-neg
> symmetric pause.

Thanks for explaining this, I will implement the indicated PHY
configuration and, additionally, also enable the SMII interface.

> > > > +	ret = crypto_skcipher_encrypt(req);
> > > > +	if (ret) {
> > > > +		dev_err(dev, "failed to encrypt S/N: %d\n", ret);
> > > > +		goto err_free_tfm;
> > > > +	}
> > > > +
> > > > +	netdev->dev_addr[0] = 0xF4;
> > > > +	netdev->dev_addr[1] = 0x4E;
> > > > +	netdev->dev_addr[2] = 0xFD;
> > > 
> > > 0xF4 has the locally administered bit 0. So this is a true OUI. Who
> > > does it belong to? Ah!
> > > 
> > > F4:4E:FD Actions Semiconductor Co.,Ltd.(Cayman Islands)
> > > 
> > > Which makes sense. But is there any sort of agreement this is allowed?
> > > It is going to cause problems if they are giving out these MAC
> > > addresses in a controlled way.
> > 
> > Unfortunately this is another undocumented logic taken from the vendor
> > code. I have already disabled it from being built by default, although,
> > personally, I prefer to have it enabled in order to get a stable MAC
> > address instead of using a randomly generated one or manually providing
> > it via DT.
> > 
> > Just for clarification, I did not have any agreement or preliminary
> > discussion with the vendor. This is just a personal initiative to
> > improve the Owl SoC support in the mainline kernel.
> > 
> > > Maybe it would be better to set bit 1 of byte 0? And then you can use
> > > 5 bytes from enc_sn, not just 4.
> > 
> > I included the MAC generation feature in the driver to be fully
> > compatible with the original implementation, but I'm open for changes
> > if it raises concerns and compatibility is less important.
> 
> This is not a simple question to answer. If the vendor driver does
> this, then the vendor can never assign MAC addresses in a controlled
> way, unless they have a good idea how the algorithm turns serial
> numbers into MAC addresses, and they can avoid MAC addresses for
> serial numbers already issued.
> 
> But should the Linux kernel do the same? If all you want is a stable
> MAC address, my personal preference would be to set the locally
> administered bit, and fill the other 5 bytes from the hash
> algorithm. You then have a stable MAC addresses, but you clearly
> indicate it is not guaranteed to by globally unique, and you do not
> need to worry about what the vendor is doing.

I fully agree, so I'm going to set byte 0 to value 0xF6 and replace
bytes 1 & 2 with entries from the computed hash. I will also document
this modification and the rationale behind.

> > > Otherwise, this look a new clean driver.
> > 
> > Well, I tried to do my best, given my limited experience as a self-taught
> > kernel developer. Hopefully reviewing my code will not cause too many
> > headaches! :)
> 
> This is actually above average for a self-taught kernel
> developer. Well done.

Thank you, Andrew!

> 	   Andrew
