Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC63481BD1
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 12:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239038AbhL3Lzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 06:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbhL3Lzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 06:55:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748E6C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 03:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hfh7egCfvHMRIw1x8OQh1ETljoOz6Sf9BN8JTbm+pX8=; b=djWm+R8Q+fw2MBdpl4Je7BTLdR
        vaRKR3MxoTsN2tVgA8vgqSJEz/RqXHshrFaIkInCw3PGaCCIF3ni/UhUF7JOwJ7tKY2TmXTRJ1uFw
        NUlkZO8BfuJujaKAMbYCA/909DS6VSptPKdhJwJL6sxdYacbQV+y9y9vIyHxqNqLDkdqElCETZ4mT
        n6F0/uDXMk8EBQ8TNSGWcx2yh1ioNjS5zI8iArbbzaw7L25lvqbR2qkc+V2Eh8aaHOAmkRQoigWmG
        AN5+XhLyuXzXCkKtMdRyTKBQ60LzCT/e2f52ewLkXGikwbe5J6XCZaLWzavfOyDF9FQF8Zwu6XNHr
        ++pEMOxg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56490)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n2u2A-00039t-MH; Thu, 30 Dec 2021 11:55:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n2u28-0002WS-Pg; Thu, 30 Dec 2021 11:55:48 +0000
Date:   Thu, 30 Dec 2021 11:55:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     =?utf-8?B?54Wn5bGx5ZGo5LiA6YOO?= <teruyama@springboard-inc.jp>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net,stable] phy: sfp: fix high power modules without diag
 mode
Message-ID: <Yc2eRMqvSDbJYXyf@shell.armlinux.org.uk>
References: <20211130073929.376942-1-bjorn@mork.no>
 <20211202175843.0210476e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YaoFkZ53m7cILdYu@shell.armlinux.org.uk>
 <YaoUW9KHyEQOt46b@shell.armlinux.org.uk>
 <877dclkd2y.fsf@miraculix.mork.no>
 <YathNbNBob2kHxrH@shell.armlinux.org.uk>
 <877dcif2c0.fsf@miraculix.mork.no>
 <CAOZT0pVXzLWSBf_sKcZaDEbbnnm=FcZH0DCLZbKW7VXo013E_A@mail.gmail.com>
 <87ee5ul3m3.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ee5ul3m3.fsf@miraculix.mork.no>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 12:43:48PM +0100, Bjørn Mork wrote:
> 照山周一郎 <teruyama@springboard-inc.jp> writes:
> 
> > I will test Russell's patch in a few days.
> 
> Hello!
> 
> Sorry to nag, but I didn't see any followup.  Did I miss it?

If you missed it, then I missed it as well!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
