Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF38F86AAA
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390275AbfHHTiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:38:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37811 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389995AbfHHTiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:38:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id b3so3658966wro.4;
        Thu, 08 Aug 2019 12:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o3cG9hx9o51gA6UlU4adUkWejV/q6+2bmEEqRa7TBxk=;
        b=eloLS1ZeIMWf2cnGJDNHNI4TN+f2S80Xe33nudsHH7n2Qalyz8TGaM1ieHpUocKrgS
         QAo8j8RWlS0N+8hTEUkZwP0EB3lYH8vP/0Xz/aFSKy7xZwM7YOvjtx7pczpL6Ah3AJEM
         aOPXS/Hn7c0hoOKjBIDuO4pPmpCRT49P0IGUAPWBKmC2/tD/fQ6JJTFbeUEZjel9nHeP
         b8k8mf7ltpySzrGqNeE0ddCQdNMdT43A2LsvL11Gm0eC5eQCgx2EdiuxWQn0458gX1SK
         THACp593UPpfciKOAbMZjtT/xU3Gl/bSVX+A6eYBcNLszL9l1vzx21dkVHPp2Kv6r+/7
         7dwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o3cG9hx9o51gA6UlU4adUkWejV/q6+2bmEEqRa7TBxk=;
        b=Ha0BIUCEbuo8mXij+a19PXXRtBtTLPDMvu7Bj7ISWUQ9nBI78evFS7Vzl51DgodKgU
         o9tBs8jtgm31nyYD0hnuhTTKkVH5A7hjhABr0HtCZkLxyxMuBnmKFKmBAb43Vkfm9zn2
         DGUZNVF0HjTjelbiS/zyiGydU1cRP5WVdeZMvUaq81HLbiodplmOBzvk9XndoQlhRv46
         dF8ikKCN608L5LnNe+49C0IXxsjdOdXsBPokWDjiOfQK304NYaqApZ9evsHoDAA12OLZ
         uWvN6Djo4M7dgHQHgSpufQrjTNXlHSxoHSgjzLb4W17IdLSOiB3T8ZcnVJhICSXPdffr
         nHwQ==
X-Gm-Message-State: APjAAAWpAB8VFSGcY3BYhLnQ6sJgtJTznwtBUltwyFCnfEE3Qqane95T
        iNljvGSzpmJeSCKhI8xXLXI=
X-Google-Smtp-Source: APXvYqxLGseFYed9tG+G/Sd0lVHZr4K0Ycf/CoGlRN2aEXurKCYiJl6evIeXgxVzg+zLHrVfySav9g==
X-Received: by 2002:adf:fe4f:: with SMTP id m15mr19059986wrs.36.1565293128101;
        Thu, 08 Aug 2019 12:38:48 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf? (p200300EA8F2F3200EC8A8637BF5F7FAF.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf])
        by smtp.googlemail.com with ESMTPSA id x6sm4578826wmf.6.2019.08.08.12.38.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 12:38:47 -0700 (PDT)
Subject: Re: [PATCH v2 13/15] net: phy: adin: configure downshift on
 config_init
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        f.fainelli@gmail.com, andrew@lunn.ch
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
 <20190808123026.17382-14-alexandru.ardelean@analog.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <420c8e15-3361-a722-4ad1-3c448b1d3bc1@gmail.com>
Date:   Thu, 8 Aug 2019 21:38:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190808123026.17382-14-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.08.2019 14:30, Alexandru Ardelean wrote:
> Down-speed auto-negotiation may not always be enabled, in which case the
> PHY won't down-shift to 100 or 10 during auto-negotiation.
> 
> This change enables downshift and configures the number of retries to
> default 8 (maximum supported value).
> 
> The change has been adapted from the Marvell PHY driver.
> 
Instead of a fixed downshift setting (like in the Marvell driver) you
may consider to implement the ethtool phy-tunable ETHTOOL_PHY_DOWNSHIFT.
See the Aquantia PHY driver for an example.
Then the user can configure whether he wants downshift and if yes after
how many retries.

> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  drivers/net/phy/adin.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
[...]

Heiner
