Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0401F95A
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 19:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfEOR32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 13:29:28 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40051 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfEOR32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 13:29:28 -0400
Received: by mail-wm1-f68.google.com with SMTP id h11so815045wmb.5;
        Wed, 15 May 2019 10:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Sf803I4SA3JX3Pgek3tMwi+IRlPrJZxRDuXTa88rrUY=;
        b=DnyOqQkxQIwZ/WAS4mXcFGsIp4mCMKvXCRPaefVzp8GXB8fBCID4v4MFFUnNGgqnA9
         cvF2IOmnOTKaRupcYuKKCCsOOfrkSJh8DjouBJ8AKbBunotXnIEzHHy7tU2ED4kCOXl7
         to1bSHy2Fs3FQYKClxT87YLmgek3s9UBpWi0AvA55zfSYZq2YYAPP3dNDMvYbEdIv05j
         Lodnyku8NidsRDPl4diqyw8krPWgVs3q9/wn2h94JDl0s+erdy4NM5P9G6ZkO7cxVgFR
         8tXUuWXeh6xvv9Y6Zil6Mn5gklJ4LZrZp35KywddCAjF+ieDnhyJgjfuiRsYmoT7v1h0
         /PpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Sf803I4SA3JX3Pgek3tMwi+IRlPrJZxRDuXTa88rrUY=;
        b=XPb7+wR+rK0EHfvb7+avNZv6T//A1QvLwlSQ0ycjF20nYsfjaWc9gQC009bfPOE4VE
         T5M0UTfee+ndo5WQTrIqmxOF2/J2NyWTtlB7lPZUlEvt5wz6KWgXg53oBHSsV+o0CUjX
         K1lamCcnkau5rZfWzb6sSg8usdRgNCOj+DOkqiT7SUWVafkuLXZ3vA0sXhLw8wufklFU
         gVeR/dXWDQIwnXBINJ1wmV6ZhbkHawcOYwx0BbsKPSkFLoFVPIDXtSf92U6VL9WnmWTm
         Uw+t+zooi7gSASrHPqPumzskzYGr0jpV3vPSCU9OrHjRZ1M1jiYFyiPTOftaRuraPEUb
         /VDw==
X-Gm-Message-State: APjAAAXZNHCWkOp+3d3AYeFfxZXNxOYXXAoT0pWt5HC39enucdZzRl8z
        0BrM1rP43S/nTzRpshtHguk8rcNG
X-Google-Smtp-Source: APXvYqzELxUsCNR308UfKXQUGIGcPvHhjGXhQrURCJixLkgTm7P3Ueek1U9VhfJW+w1xqCFo9rMPUw==
X-Received: by 2002:a1c:494:: with SMTP id 142mr25121736wme.115.1557941365627;
        Wed, 15 May 2019 10:29:25 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id u17sm1778872wmj.1.2019.05.15.10.29.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 10:29:24 -0700 (PDT)
Date:   Wed, 15 May 2019 19:29:22 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [RFC net-next v2 00/14] net: stmmac: Selftests
Message-ID: <20190515172922.GA30321@Red>
References: <cover.1557848472.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1557848472.git.joabreu@synopsys.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 05:45:22PM +0200, Jose Abreu wrote:
> [ Submitting with net-next closed for proper review and testing. ]
> 
> This introduces selftests support in stmmac driver. We add 9 basic sanity
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
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> 
> Corentin Labbe (1):
>   net: ethernet: stmmac: dwmac-sun8i: Enable control of loopback
> 
> Jose Abreu (13):
>   net: stmmac: Add MAC loopback callback to HWIF
>   net: stmmac: dwmac100: Add MAC loopback support
>   net: stmmac: dwmac1000: Add MAC loopback support
>   net: stmmac: dwmac4/5: Add MAC loopback support
>   net: stmmac: dwxgmac2: Add MAC loopback support
>   net: stmmac: Switch MMC functions to HWIF callbacks
>   net: stmmac: dwmac1000: Also pass control frames while in promisc mode
>   net: stmmac: dwmac4/5: Also pass control frames while in promisc mode
>   net: stmmac: dwxgmac2: Also pass control frames while in promisc mode
>   net: stmmac: Introduce selftests support
>   net: stmmac: dwmac1000: Fix Hash Filter
>   net: stmmac: dwmac1000: Clear unused address entries
>   net: stmmac: dwmac4/5: Fix Hash Filter
> 
>  drivers/net/ethernet/stmicro/stmmac/Kconfig        |   9 +
>  drivers/net/ethernet/stmicro/stmmac/Makefile       |   2 +
>  drivers/net/ethernet/stmicro/stmmac/common.h       |   1 +
>  drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |  13 +
>  drivers/net/ethernet/stmicro/stmmac/dwmac1000.h    |   1 +
>  .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |  22 +-
>  .../net/ethernet/stmicro/stmmac/dwmac100_core.c    |  13 +
>  drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |   3 +
>  drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  19 +-
>  drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |   2 +
>  .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |  15 +-
>  drivers/net/ethernet/stmicro/stmmac/hwif.c         |   9 +
>  drivers/net/ethernet/stmicro/stmmac/hwif.h         |  21 +
>  drivers/net/ethernet/stmicro/stmmac/mmc.h          |   4 -
>  drivers/net/ethernet/stmicro/stmmac/mmc_core.c     |  13 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  22 +
>  .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   8 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 846 +++++++++++++++++++++
>  19 files changed, 1014 insertions(+), 13 deletions(-)
>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
> 
> -- 
> 2.7.4
> 

Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Tested-on: sun7i-a20-cubieboard2
Tested-on: sun50i-a64-bananapi-m64
Tested-on: meson-gxl-s905x-libretech-cc

For information the output is:
On sun50i-a64-bananapi-m64
ethtool --test eth0 offline
The test result is PASS
The test extra info:
 1. MAC Loopback         	 0
 2. PHY Loopback         	 -95
 3. MMC Counters         	 -95
 4. EEE                  	 -95
 5. Hash Filter MC       	 0
 6. Perfect Filter UC    	 0
 7. MC Filter            	 0
 8. UC Filter            	 0
 9. Flow Control         	 -95
with onine I got
dwmac-sun8i 1c30000.ethernet eth0: Only offline tests are supported

on sun7i-a20-cubieboard2:
ethtool --test eth0 offline
The test result is PASS
The test extra info:
 1. MAC Loopback         	 0
 2. PHY Loopback         	 -95
 3. MMC Counters         	 -95
 4. EEE                  	 -95
 5. Hash Filter MC       	 0
 6. Perfect Filter UC    	 0
 7. MC Filter            	 0
 8. UC Filter            	 0
 9. Flow Control         	 -95
With online I got:
sun7i-dwmac 1c50000.ethernet eth0: Only offline tests are supported

on meson-gxl-s905x-libretech-cc:
ethtool --test eth0 offline
The test result is FAIL
The test extra info:
 1. MAC Loopback         	 0
 2. PHY Loopback         	 -95
 3. MMC Counters         	 -1
 4. EEE                  	 -95
 5. Hash Filter MC       	 0
 6. Perfect Filter UC    	 0
 7. MC Filter            	 0
 8. UC Filter            	 0
 9. Flow Control         	 -95
with onine I got
meson8b-dwmac c9410000.ethernet eth0: Only offline tests are supported

I will try to investigate the MMC failure. Does -1 (vs other -EXXXX) is the right error code to return from the driver ?
