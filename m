Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652CC437697
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 14:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhJVMSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 08:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhJVMSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 08:18:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440E4C061764;
        Fri, 22 Oct 2021 05:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tMcncN+nU20vHkHS0MH7EphxShy9Vb10AfNBzoZbi9k=; b=YZfHLFztNVMqjNETxTuuEUbuyT
        iz9e/KVkvXelzRcW6e/0TvUCcwaqGcjJU9MeeRRpWFde2/SqFfvEtemW1zhAwWO9grHVspxDwD7va
        +NhGtFk01MWu3s7w3nyhXftvny8U32RYcD+qMovhBg7WpG9WEzQbo2zl9lKDao628E68aThOPEk41
        A/pGfVU0GCrZRY6SELebpin/TenPDh0D/NdGABSnJwJEZihOVEFNZ0zK7EB/jONJiEPFPs1Y6ik7c
        l7SirOy3pxKXRm4YXitiEGirom99s6Pau6ECEnWX9Xn58zllTj9JwVNwvH4vqIdKAmbW65tvlUJP5
        lzStK/dQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55234)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mdtSd-0001gN-FX; Fri, 22 Oct 2021 13:15:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mdtSd-0001At-2G; Fri, 22 Oct 2021 13:15:47 +0100
Date:   Fri, 22 Oct 2021 13:15:47 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v4 02/14] net: phy: at803x: use phy_modify()
Message-ID: <YXKrcxYAJukg71xB@shell.armlinux.org.uk>
References: <20211022120624.18069-1-luoj@codeaurora.org>
 <20211022120624.18069-3-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022120624.18069-3-luoj@codeaurora.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 08:06:12PM +0800, Luo Jie wrote:
> Convert at803x_set_wol to use phy_modify.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

On v3, Andrew gave you a reviewed-by. You need to carry that forward
especially if nothing has changed.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
