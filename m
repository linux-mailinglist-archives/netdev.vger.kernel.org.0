Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A456841B66E
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 20:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242178AbhI1Siq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 14:38:46 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:58167 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbhI1Sin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 14:38:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632854224; x=1664390224;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p47ihjltdJKVdxd8quCmufYkMCouLxbnDJw1udtkFMU=;
  b=w4zq7VEBgoD6cBYsNHWyQNAo0ug/ipt3GJZYtAbV9CUqDnZPOjtGPy9c
   z47XfmSb6gldWFQc3mvl6IaLX24e3BNkedUxTaPmyvDeb5+mzSKWajWsJ
   rikBbvplpUbhoJ85WsJnVkCAdWXQsdGXT4Zg7wBNQBV+m3w/FA/7omNCH
   IyrBHqkz+taBfuDjr5hI6FTRYbubl1Q61tr2R6tBqr9GhB0sq8dWbngng
   qM2OYHGBWo5FXGeucCAtA1Plbf6MjVV9g88+9jHNBTbWom4LjjPA1qbRm
   8c3jlLPpAyaYsjtR1k70A8rp9ilZ7FRZdCgQP1IMASuUSbmHnwV/MwEIb
   g==;
IronPort-SDR: UrP/0OJBehLYyed6jSRgK0b+JVbzJHslbpsJ2u8qthRiu07/e056T9Ndn+MpdMJDO9qZCme+6q
 h34qEdSBMR8EQBJRJTqh1l22BxVarrfvKwKZi5tx3JqkIxzocRe1AQdrGZTORqVYYsbgRb/HSr
 DcYdWIzuMAAa0trh+iNLvOpxZV8ePNSlm0RnBbc4HI6Jzk8tDnhyC4be+QiLWAbZy1VuFyVWFC
 6L6Fcq6IKkzLX/60BWca6PrDDKcV+Y312HZkEUBpUCzkQoSVxVhluMGcj0gmmk8dlBu5yt1s+m
 wwWRYvA0gVjUoCDv/zfFi3r0
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="133511756"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 11:37:03 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 11:37:03 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 11:37:02 -0700
Date:   Tue, 28 Sep 2021 20:38:23 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: mchp: Add support for LAN8804 PHY
Message-ID: <20210928183823.zmauxjbzxxu2pnvz@soft-dev3-1.localhost>
References: <20210928073502.2108815-1-horatiu.vultur@microchip.com>
 <YVMGkmgwIQDMwldp@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YVMGkmgwIQDMwldp@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/28/2021 14:12, Andrew Lunn wrote:
> 
> On Tue, Sep 28, 2021 at 09:35:02AM +0200, Horatiu Vultur wrote:
> > The LAN8804 PHY has same features as that of LAN8814 PHY except that it
> > doesn't support 1588, SyncE or Q-USGMII.
> 
> Sorry, i missed it first time. The subject line is wrong. There is no
> mchp driver in mainline.

No worries, thanks for reviewing the patch.
I will send soon another version.

> 
> When you fix it, please add my Reviewed-by.
> 
>      Andrew

-- 
/Horatiu
