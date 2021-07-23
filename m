Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A2C3D3AEB
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 15:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbhGWM3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 08:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbhGWM3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 08:29:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5743C061575;
        Fri, 23 Jul 2021 06:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=W6wJL+7nnUO08SMNG3U7r9AB3QZ2lCJON3hvs8YkDQ4=; b=xIm9Fq7MVQRA/TIcmSnr9xclI
        gzYQspxawTMz64c+VbIHX8z/Gvg0dD7CuOCjhelSlSDK7BFiiFADWuTbyVCG3+GOCkMugGIQ4Cqd8
        XGN3GtVfDAumsyQILaR/JDmjDgFxSq2y9HteZZZ8BD5aomX56xcqO7Lv5DWiUoZ+/Ru/1+T9ybD77
        lY9KtWD8fdMCYFrNNLYSrY0Q9qIFKJvtyR/pqHWUpvAWldajwb6Av98Eyl7zMC7q2fwKYDZFY8bAu
        HsqKNbFel5/yBhLGDN2140iX/bjKoUnWxmEvtA4lXmtoDpWVXn0yN5j4gYwuMpw63evVxEpabb0ax
        V3FHarsaQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46512)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m6uwO-00020S-QA; Fri, 23 Jul 2021 14:10:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m6uwN-0001oq-2L; Fri, 23 Jul 2021 14:10:11 +0100
Date:   Fri, 23 Jul 2021 14:10:11 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     lxu@maxlinear.com, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: Remove unused including <linux/version.h>
Message-ID: <20210723131010.GC22278@shell.armlinux.org.uk>
References: <1627036707-73334-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1627036707-73334-1-git-send-email-jiapeng.chong@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 06:38:27PM +0800, Jiapeng Chong wrote:
> From: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> 
> Eliminate the follow versioncheck warning:
> 
> ./drivers/net/phy/mxl-gpy.c: 9 linux/version.h not needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
