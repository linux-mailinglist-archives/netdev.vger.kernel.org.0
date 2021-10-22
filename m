Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1385437692
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 14:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhJVMP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 08:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhJVMP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 08:15:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FA0C061764;
        Fri, 22 Oct 2021 05:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3wIAhdbhEaLw/yRwzmamNQcdld+HiTYFy2ksoftYD9w=; b=SVu7st9wzFxaS9T7pl1sZoT4c6
        vOkd0l7xskv7YHCReQwSnv3wi/2oLmNVvNvS0e3lusLRUnlH48vvCvd+wAsHqOYVCSkfbm5QXwBWy
        BACVkGkQlB0hU9sg10AfEQzmfjtMwR1zL9Kppdt58Fjy4UokJDXc+Z+dwmpbNi1d5TvS5uH2JYXCQ
        eyXf9EeX9UtoI3SnwuLvc1DKz0psHp5v07mG8Ah7Wd+j5mKpDMSmlin4UkKauc0ynils+HmFi8yXb
        xYIPA/WmSVznVwpFfiYUFfANYVlXbDPRmUufMxL4FlPZdxIntPpwqCX8hy+RL4Pppo4tLaoWAQOBd
        ZFt0rOxA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55232)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mdtQS-0001fz-At; Fri, 22 Oct 2021 13:13:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mdtQQ-0001Al-PH; Fri, 22 Oct 2021 13:13:30 +0100
Date:   Fri, 22 Oct 2021 13:13:30 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v4 01/14] net: phy: at803x: replace AT803X_DEVICE_ADDR
 with MDIO_MMD_PCS
Message-ID: <YXKq6j/CnQ/i34ZB@shell.armlinux.org.uk>
References: <20211022120624.18069-1-luoj@codeaurora.org>
 <20211022120624.18069-2-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022120624.18069-2-luoj@codeaurora.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 08:06:11PM +0800, Luo Jie wrote:
> Replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS defined in mdio.h.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

On v3, Andrew gave you a reviewed-by. You need to carry those forward
especially if the patches have not changed.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
