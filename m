Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2BC31892E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhBKLNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhBKLKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:10:25 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16805C061756;
        Thu, 11 Feb 2021 03:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NQS48P1FbVfy+/OxhFlzUnu21K3Voa9/8ZVmtwqIhr0=; b=VfouS6nwzL3LHApJP3WIfBg1X
        iKiC7b8HpN1ORgfUsEMO35dtZZI6PDqm6tp0/2b3STHYG8Yn7Oin94zntqhrsdaJ5L/tdrrVYQ1ps
        k2qIA17+7GRNocOGF1cau8NQwTJIsr4NQFjx+w5alFbMR+5Rid/J9kds+lpDR3cd94Z7Jr6ymF1Dw
        uz/z36FOkMkdMqjjZUl0lAHmARBdkWxKIlTP1bM8TJNNspFuJcgmiO2Gfeecigj+6eESwnYhFxm+S
        e0vYCwi23VLiIRrmZuyoIEdMp3hOYzqTr5zxQLqdWXvSRZcCZUCfeoBWqiHpVP7TAtNj2lCGkv/MT
        mrNUnSAbA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41992)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lA9qx-00062A-EQ; Thu, 11 Feb 2021 11:09:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lA9qw-00062T-Pt; Thu, 11 Feb 2021 11:09:42 +0000
Date:   Thu, 11 Feb 2021 11:09:42 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 net-next 06/15] net: mvpp2: increase BM pool and RXQ
 size
Message-ID: <20210211110942.GC1463@shell.armlinux.org.uk>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-7-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613040542-16500-7-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 12:48:53PM +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> BM pool and RXQ size increased to support Firmware Flow Control.
> Minimum depletion thresholds to support FC are 1024 buffers.
> BM pool size increased to 2048 to have some 1024 buffers
> space between depletion thresholds and BM pool size.
> 
> Jumbo frames require a 9888B buffer, so memory requirements
> for data buffers increased from 7MB to 24MB.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> Acked-by: Marcin Wojtas <mw@semihalf.com>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
