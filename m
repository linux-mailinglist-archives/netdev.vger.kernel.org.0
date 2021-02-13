Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE7231A92B
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhBMA7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbhBMA6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:58:46 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A44C061574;
        Fri, 12 Feb 2021 16:57:02 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id lg21so2191635ejb.3;
        Fri, 12 Feb 2021 16:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YnG1dY4+JoETjprbMMKd9Fd4yUHPu6iZV8WqicLOG0k=;
        b=Ni8CnjM7wGzIZhwOczYwchAEvL2bw1ZnutYz57ARHCfqS9JAZR9HnzWXMsWpGvGRj/
         NySdyvp3QN1RbFwCDIRia9XZKT50zga57tk3KQMD7zXXeF9ewlkoEeTV3hgXqPXJR5cb
         YTAZ1t0Cu9p+bgzwhshm0lgIB1FChdMS9h6n5xpgumAlM2hYsK5Yj1x76IOMWElxPGYQ
         /ew1QmWVMS1WPOQye91twgfURF2haN74XzF67kLu56Z91J2ZUGSti17ggSTMyyqPYIre
         4YQBFbnIL4xZxjfm2SpFyh/9GJjcqSewv//ENnLsv/gwnZSz6mW1DO98onL+e8IxYB3T
         FNUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YnG1dY4+JoETjprbMMKd9Fd4yUHPu6iZV8WqicLOG0k=;
        b=YxIDPu2ief4SHq9ecJEIIV+ROLYFQE9Ix3cNp7i9RGR3+Ov+fA6CNG/8gMCw9GYzet
         OzmqQ2Ifo5cUJw5xXY06U0ezept5FtMNtP2nz7kFUtv8nWD1JjxqoVehWvmaIbviFYd/
         w/qRrUeMBj2UIO/t0IMrqbF+orWCwbb15CWuBBPfn+HTV2HO8GC+chmPgIBpgf+SzU8f
         cdrQDcGCEyNy/nmFFIqMw/ywyjF3vtVkLMMlnqgFk96lEDZ6RgdXPh3W4khozekXQYzz
         Sobz3NiWzaBLh7hTf7YFD56O/KH91xeB8UvMo+kDGo8WtHhOsXmuEe2eEiZhCixrSxaE
         UGGw==
X-Gm-Message-State: AOAM531s6OP/Fvuxo4xjWY5MtNkCp+OrnHL2ycnMpp530rOTWPOIYbDC
        NvfeO66JeZaEJ2so12WSFIc=
X-Google-Smtp-Source: ABdhPJx4HnlEuzmwL05g0Hd3GU93q1mzfVTBvknXYxdyfkRXPRcOqSzqmEx5KYoHs77zCvqbh44w/w==
X-Received: by 2002:a17:906:26ca:: with SMTP id u10mr5563252ejc.165.1613177821070;
        Fri, 12 Feb 2021 16:57:01 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id gz14sm7006672ejc.105.2021.02.12.16.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:57:00 -0800 (PST)
Date:   Sat, 13 Feb 2021 02:56:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>, michael@walle.cc
Subject: Re: [PATCH net-next 1/3] net: phy: broadcom: Remove unused flags
Message-ID: <20210213005659.enht5gsrh5dgmd7h@skbuf>
References: <20210212205721.2406849-1-f.fainelli@gmail.com>
 <20210212205721.2406849-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212205721.2406849-2-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 12:57:19PM -0800, Florian Fainelli wrote:
> We have a number of unused flags defined today and since we are scarce
> on space and may need to introduce new flags in the future remove and
> shift every existing flag down into a contiguous assignment. No
> functional change.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Good to see some of the dev_flags go away!

PHY_BCM_FLAGS_MODE_1000BX is used just from broadcom.c, therefore it can
probably be moved to a structure in phydev->priv.

PHY_BRCM_STD_IBND_DISABLE, PHY_BRCM_EXT_IBND_RX_ENABLE and
PHY_BRCM_EXT_IBND_TX_ENABLE are set by
drivers/net/ethernet/broadcom/tg3.c but not used anywhere.
