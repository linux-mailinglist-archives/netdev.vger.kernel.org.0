Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948E4318B55
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 14:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhBKNAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 08:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbhBKM5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:57:47 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B3BC0613D6;
        Thu, 11 Feb 2021 04:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hczxf3HIW10i9ZHaBQsIaDj5cQ6tVYBF+zj1VNBAG80=; b=lJYT4uDsLXbIOSHD560hGhTZE
        +9pGcejLyOYi14B6m/KKivFpZJjZZunsBcUVH/4yYIhg1KEfTcrU7NMSRHy7cpGKEO2nRBcq/Qfjj
        QW52KaB3YS3w0c8XMZK0ZSmPIlj1/9bSmKg0uOUXs5jYks1y/Md4Wm1rMjDrxJQzl4EDSXcbVJO7K
        4egBYiudOcl9o4fAci01i233XbkuSNw8iVxJVv4Ck/AgnR84cGDlAFhPqv4F0rkHXYzfyV2D8oGGd
        U6NhPaPgm0RbTU0JE0uBrJ9nlQ43trXCUUZe27ZAiuLJ0h1VTqmCbjKtk/iOv2WCln0csaxe6OSRs
        1HeT5fMNg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42036)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lABWq-0006BJ-26; Thu, 11 Feb 2021 12:57:04 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lABWp-00066q-DM; Thu, 11 Feb 2021 12:57:03 +0000
Date:   Thu, 11 Feb 2021 12:57:03 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 net-next 14/15] net: mvpp2: set 802.3x GoP Flow
 Control mode
Message-ID: <20210211125701.GI1463@shell.armlinux.org.uk>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-15-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613040542-16500-15-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 12:49:01PM +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> This patch fix GMAC TX flow control autoneg.
> Flow control autoneg wrongly were disabled with enabled TX
> flow control.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> Acked-by: Marcin Wojtas <mw@semihalf.com>

Should this patch be placed towards the start of this series (along with
the other fix for the thread number limit I mentioned previously?)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
