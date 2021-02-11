Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31DC318916
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhBKLJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbhBKLC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:02:56 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D70C061788;
        Thu, 11 Feb 2021 03:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Tpeq1xfIzx+yLHJnjWVC+ZEcy8In7HLI4jkOouPG+0E=; b=wW2d4sMBETKTKCSC6tYt7vWap
        EC1kgw3o7TrEjQQ5KBBzL0yHvOe8+B92Go4j4hN1V0RNyOlREEbMf7IcyzbvtLbFmFnOmCOsPyy+A
        Ym9lkL2W+Y3gHqMRMT/6gRYIU2VTh26SJ018QD+/DtJSgc5bZOWQ5LyWBjOPmq+7yG4Wq/Qpm3zs6
        mBi5KYUdjQqyizUCA6kVfnWlU19Pb+cqwrW7QaySl95QDZ6zbRXtljHdfdbEpkCENC72ZU4pfxoIR
        B6RWN80NmtYP99HwO4grdy57Ldcq5utgS74WtElVpEo1eYz3kdx1JkGmafxyBZl9t/VCuOITqaGUH
        YIciXUQVA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41986)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lA9jh-00060O-13; Thu, 11 Feb 2021 11:02:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lA9jf-00061D-Kt; Thu, 11 Feb 2021 11:02:11 +0000
Date:   Thu, 11 Feb 2021 11:02:11 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 net-next 01/15] doc: marvell: add CM3 address space
 and PPv2.3 description
Message-ID: <20210211110211.GZ1463@shell.armlinux.org.uk>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-2-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613040542-16500-2-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 12:48:48PM +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Patch adds CM3 address space and PPv2.3 description.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> Acked-by: Marcin Wojtas <mw@semihalf.com>

It seems this is missing the ack that you got from Rob in your previous
posting. Your changelog says that only the module parameter was
removed, so I guess nothing changed in this patch.

Please wait to see if there are further comments before posting another
revision of this series.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
