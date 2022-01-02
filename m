Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14697482BBD
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 16:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbiABPv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 10:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbiABPv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 10:51:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2552C061761;
        Sun,  2 Jan 2022 07:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4KlxMSqwpI+8J07Pz0YWGyZ05XaJV5IHIKw4TRudFLE=; b=DG4+Kv7XE5pzB9ai02NSG8WMVm
        1jinkfqxPJ8NtcvCpXSZJueff4RpaoSJq3i69zkhTFmLznrhrVB8ORNjtX6GfUwn2hRyAG8JA97qH
        h9xLhye24g0CWJaKimYaFZ5aU08ZzktVQG9C9eNzzF1pMeOUwxZARVcapGTQgT1pdoEGQGJ0Oohcv
        BnIqg+IXb7xl14NwBkBUB0fqtEQUF6vqS5hgVg8cUoMPcXP4oo/UiwJrg20SLKCOV+6xMOsbB9Fxd
        o5NebSM/wUf4QBfKdPefWv6K1Mxp6FXmMLp7mVOS4TrxI1iF1dks+f7RzuWR16rkeBDug7GUtRh9+
        fuaCjBeA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56522)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n438j-0005Z5-L2; Sun, 02 Jan 2022 15:51:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n438e-0005TU-J5; Sun, 02 Jan 2022 15:51:16 +0000
Date:   Sun, 2 Jan 2022 15:51:16 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Michael Lee <igvtee@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v10 0/3] net: ethernet: mtk_eth_soc: refactoring and
 Clause 45
Message-ID: <YdHJ9Kkl4+zwCV1+@shell.armlinux.org.uk>
References: <YdCNZh5PsBwbfMtp@lunn.ch>
 <YdHJKLfFCJvYBcdB@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdHJKLfFCJvYBcdB@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 02, 2022 at 03:47:52PM +0000, Daniel Golle wrote:
> Rework value and type of mdio read and write functions in mtk_eth_soc
> and generally clean up and unify both functions.
> Then add support to access Clause 45 phy registers, using newly
> introduced helper macros added by a patch Russell King has suggested
> in a reply to an earlier version of this series [1].

Can you please stop threading each re-post to the previous posting of
the series. It's getting rather annoying after ten iterations to have
the subject lines disappearing off the right hand side of the field.
This is not a request to re-post, it is a request for the next posting.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
