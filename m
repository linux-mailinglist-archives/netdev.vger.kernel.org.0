Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CD22EB723
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbhAFAxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbhAFAxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:53:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5BDC061574;
        Tue,  5 Jan 2021 16:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KTdPw3GgA3/kea2wx5IKyFy0zwnHln1sWyX9MNUh0ls=; b=LuqBNmo6fno5boW6IJGneuHRV
        +ePC50sNz5VPd5ou5vRp7o1FZc4lfMY1UyhZBTR5BcC9sbuTI5olXvmSsfdyS+Pg+XNw55qsRY7XU
        ozPt7dvxGymJ3KDNglEoAKjjyhpsOq7KcZrx/cAqI0n7pbcoKItbiqBw366wOKxtP/OsjTxUCVHtu
        e7C39EFv1cB6919SoPI2EsmkCPzDozj972pBVZdNqFK2yzwfjrnuM8Yjj/t+RdCxD3hlEFjiPJI8K
        XNuag1fMjbsugZUayKbTdSKPZENZFJGyKstdH3Vl237ZoeKut9pkUqKMXkrX3WZS1g+YECcc3iX61
        xWf2E2Wyg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45164)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kwx4M-0001DS-FX; Wed, 06 Jan 2021 00:52:58 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kwx4M-0008B7-1M; Wed, 06 Jan 2021 00:52:58 +0000
Date:   Wed, 6 Jan 2021 00:52:58 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: iop32x: improve N2100 PCI broken parity quirk
Message-ID: <20210106005257.GH1551@shell.armlinux.org.uk>
References: <20210106002833.GA1286114@bjorn-Precision-5520>
 <9d2d3d61-8866-f7d3-09e9-a43b05128689@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d2d3d61-8866-f7d3-09e9-a43b05128689@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 01:44:03AM +0100, Heiner Kallweit wrote:
> The machine type check is there to protect from (theoretical) cases
> where the n2100 code (incl. the RTL8169 quirk) may be compiled in,
> but the kernel is used on another machine.

That is far from a theoretical case. The ARM port has always supported
multiple machines in a single kernel. They just had to be "compatible"
in other words, the same SoC. All the platforms supported by
arch/arm/mach-iop32x can be built as a single kernel image and run on
any of those platforms.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
