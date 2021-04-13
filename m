Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3167035DAEE
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238238AbhDMJSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237787AbhDMJSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:18:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B909C061574;
        Tue, 13 Apr 2021 02:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6RTGtC27UlAcq0fr9UOGTdiAA9coaSDQ5gb68n6+EB8=; b=dAxsO3BQxiUv8/gpGGWsrbL11
        kaed+tTvegZtlg3UTTklLT/C+Ip+DlXkpPjHZohY/Cg3Dy/LIL8j0uP+aMRuVAh/oYDEj+zT4Lo8B
        b0tgoYYwdb5TQaOkdSPFz6Dc9+/HgtQ7bdmYOL2bHTgCV0hKBuQ7vHgTxnQ2lyYevXa6ueonNSPF+
        6/5zkwtACHHkUNq2WUqQaR0EuO22zZWpjcnSeyC2jLEHFh43Dql4m19YYO7qZhULwBOaFgBDyAL78
        mqtua1VoqmEDtPi+6y5ipMdJCAOWNpKqh7S/lodrUuHF2ZMrbKNaoMDkTaBTAOS0txTwCi7pEEmIz
        ch1k2xT1Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52368)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lWFB2-0005Ri-5E; Tue, 13 Apr 2021 10:17:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lWFB0-000858-1Z; Tue, 13 Apr 2021 10:17:42 +0100
Date:   Tue, 13 Apr 2021 10:17:42 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org, lironh@marvell.com,
        danat@marvell.com
Subject: Re: [PATCH net-next] net: mvpp2: Add parsing support for different
 IPv4 IHL values
Message-ID: <20210413091741.GL1463@shell.armlinux.org.uk>
References: <1618303531-16050-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618303531-16050-1-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 11:45:31AM +0300, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Add parser entries for different IPv4 IHL values.
> Each entry will set the L4 header offset according to the IPv4 IHL field.
> L3 header offset will set during the parsing of the IPv4 protocol.

What is the impact of this commit? Is something broken at the moment,
if so what? Does this need to be backported to stable kernels?

These are key questions, of which the former two should be covered in
every commit message so that the reason for the change can be known.
It's no good just describing what is being changed in the commit without
also describing why the change is being made.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
