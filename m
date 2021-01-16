Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F4D2F8A0D
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 01:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbhAPAuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 19:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbhAPAuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 19:50:23 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E633DC061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 16:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LO8VWX2ZSap1P5OvOtOpuLo2tNTP19QgNOMyQjdHQ9U=; b=VBFGgyACqNeaVjn6gdL5Yk7MD
        3kQwY6jhi2zgYvhFeC7l5T9qYcqvpoJk+/c7CMzdCq/tvRMVMdYGLGYLAfZ/elvorB4ocBt3DDu2T
        pgoRawtXes/TPc18REQNNqGYfs8nnQPlCL2zzk6EPg9b3g4bvOEUgaN2rTCPp4eba5HDbEr6ylfVw
        71fcLjWgD5geRsy2OBbPYK6/Gj5NZKPBPEW/0wuDQbFsUmxnswx8vziVdwk3J7bZ9UIuHfIyR2AIA
        iq23wUJc4IRTRazUmP/KCzftqxmzZ0XC+W2zqsylgBcHrgfcXqXGhzRNxKRcd5b3mInWWGJPAbcrj
        81PKSpVUw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48506)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l0ZmI-0004Wn-Ug; Sat, 16 Jan 2021 00:49:18 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l0ZmB-0001Q9-HF; Sat, 16 Jan 2021 00:49:11 +0000
Date:   Sat, 16 Jan 2021 00:49:11 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH net-next v16 2/6] net: phy: Add 5GBASER interface mode
Message-ID: <20210116004911.GA1551@shell.armlinux.org.uk>
References: <20210114043331.4572-1-kabel@kernel.org>
 <20210114043331.4572-3-kabel@kernel.org>
 <20210116003116.4iajyx4i3in3fsut@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210116003116.4iajyx4i3in3fsut@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 02:31:16AM +0200, Vladimir Oltean wrote:
> On Thu, Jan 14, 2021 at 05:33:27AM +0100, Marek Behún wrote:
> > From: Pavana Sharma <pavana.sharma@digi.com>
> > 
> > Add 5GBASE-R phy interface mode
> > 
> > Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > Signed-off-by: Marek Behún <kabel@kernel.org>
> > ---
> 
> This patch now conflicts with commit b1ae3587d16a ("net: phy: Add 100
> base-x mode"). Could you resend and also carry over my review tags from
> the previous version?
> https://patchwork.kernel.org/project/netdevbpf/patch/20210112195405.12890-5-kabel@kernel.org/

It may make sense to get this patch merged separately from the rest of
the series - we're going to need it at some point anyway.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
