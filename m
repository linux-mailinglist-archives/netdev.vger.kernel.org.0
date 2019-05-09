Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D258818766
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 11:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfEIJEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 05:04:21 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43897 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfEIJEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 05:04:21 -0400
Received: by mail-wr1-f68.google.com with SMTP id r4so1867390wro.10;
        Thu, 09 May 2019 02:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JpLDmJ7s889veboW3Rv53oO/LHxCjZWmDgHuSW3TagQ=;
        b=PiVaQAlRCqcaxH/t1Ma0i3Mv3txU3+BTLiQ709cQeQESh9ShOWallWzcSJfmgI/jKx
         yXPtQXSV9IO2sowYJ8/0mMEdlDC1houJq2slnF41bqMBfMb7r3LB8NuA7fRN0sIrm87S
         tH6iyFvGktgqAlJgR6nOnRaHCkB+jutadvwTQWA7wDhq8alYs4JmpYmSShEsu2qOcTtS
         9XqO1NN9gPhPv71gscI6jmzlp+j08Yt9Q2Gg4QqCnO5ii/muZz6ZgLnzq8ZaGeA2RzH5
         +9OsLguIkPPQsuiL1RyJXa5tZmyNw8ZXEqysIMg3Zurs8TaMSpMTeqjSVrGab3JuvgEK
         rJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JpLDmJ7s889veboW3Rv53oO/LHxCjZWmDgHuSW3TagQ=;
        b=EufEkL9LpuwGhPjzAch28uRj06Y4XUIRS7FoCThJAwLz5QSsKjGbXfjVaFzGVpp9Xl
         URYkY4uFC6MmMJ3bTZdtfcWLttsLXw8eQ+6D0JtI/2gVW0TxLllaxP9392qOB6HEOgfc
         W7ySvHWIBzGi6sN1b7LKnJHSWw+rk1VkEU6aOVwZxPu3880/ShtI1JxS/npMaiuDPFob
         igF8du5uYQzKAdR0ozoGEHBk1jA26D1jvYp1Cm0pouQo8pgr7gXh+6YtVLm1TZlc4ARN
         lMzb/ZM2nYr0rVgyXusPF0eNOMpnC6atv0OT1di284HcQdhgQzvbLgm28dlkGKW3RmSP
         SoVw==
X-Gm-Message-State: APjAAAUwZqnCjlkT7DGAgm81W/+Cvqyt+XGiRS6/Liv3NyWVdF0wjBAk
        9U4KScm6Zunu/evigp0h2EM=
X-Google-Smtp-Source: APXvYqyttn1Qx8cKR4bIGf+yaqR0e3OpYZiBxXqTERuvfXIerrcaq5xBFdU42WbLdfKODFctvuI9xA==
X-Received: by 2002:adf:e845:: with SMTP id d5mr2295362wrn.154.1557392659400;
        Thu, 09 May 2019 02:04:19 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id l12sm975072wmj.0.2019.05.09.02.04.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 02:04:18 -0700 (PDT)
Date:   Thu, 9 May 2019 11:04:16 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH net-next 00/11] net: stmmac: Selftests
Message-ID: <20190509090416.GB1605@Red>
References: <cover.1557300602.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1557300602.git.joabreu@synopsys.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 09:51:00AM +0200, Jose Abreu wrote:
> [ Submitting with net-next closed for proper review and testing. ]
> 
> This introduces selftests support in stmmac driver. We add 4 basic sanity
> checks and MAC loopback support for all cores within the driver. This way
> more tests can easily be added in the future and can be run in virtually
> any MAC/GMAC/QoS/XGMAC platform.
> 
> Having this we can find regressions and missing features in the driver
> while at the same time we can check if the IP is correctly working.
> 
> We have been using this for some time now and I do have more tests to
> submit in the feature. My experience is that although writing the tests
> adds more development time, the gain results are obvious.
> 
> I let this feature optional within the driver under a Kconfig option.
> 
> For this series the output result will be something like this
> (e.g. for dwmac1000):
> ----
> # ethtool -t eth0
> The test result is PASS
> The test extra info:
> 1. MAC Loopback                 0
> 2. PHY Loopback                 -95
> 3. MMC Counters                 0
> 4. EEE                          -95
> 5. Hash Filter MC               0
> 6. Perfect Filter UC            0
> 7. Flow Control                 0
> ----
> 
> (Error code -95 means EOPNOTSUPP in current HW).
> 

Hello

I have started to patch dwmac_sun8i for using your patchset and get the following:
The test result is FAIL
The test extra info:
 1. MAC Loopback         	 0
 2. PHY Loopback         	 -95
 3. MMC Counters         	 -95
 4. EEE                  	 -95
 5. Hash Filter MC       	 0
 6. Perfect Filter UC    	 1
 7. Flow Control         	 -95

What means 1 for "Perfect Filter UC" ?

I have added my patch below

Regards

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -976,6 +976,18 @@ static void sun8i_dwmac_exit(struct platform_device *pdev, void *priv)
                regulator_disable(gmac->regulator);
 }
 
+static void sun8i_dwmac_set_mac_loopback(void __iomem *ioaddr, bool enable)
+{
+       u32 value = readl(ioaddr + EMAC_BASIC_CTL0);
+
+       if (enable)
+               value |= EMAC_LOOPBACK;
+       else
+               value &= ~EMAC_LOOPBACK;
+
+       writel(value, ioaddr + EMAC_BASIC_CTL0);
+}
+
 static const struct stmmac_ops sun8i_dwmac_ops = {
        .core_init = sun8i_dwmac_core_init,
        .set_mac = sun8i_dwmac_set_mac,
@@ -985,6 +997,7 @@ static const struct stmmac_ops sun8i_dwmac_ops = {
        .flow_ctrl = sun8i_dwmac_flow_ctrl,
        .set_umac_addr = sun8i_dwmac_set_umac_addr,
        .get_umac_addr = sun8i_dwmac_get_umac_addr,
+       .set_mac_loopback = sun8i_dwmac_set_mac_loopback,
 };
 
 static struct mac_device_info *sun8i_dwmac_setup(void *ppriv)
