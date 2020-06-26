Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7CF20BA99
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgFZUur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:50:47 -0400
Received: from mga07.intel.com ([134.134.136.100]:6194 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFZUuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 16:50:46 -0400
IronPort-SDR: VFadBMFE+uJSKkUN13RWEZTJ+lfF4xk3ULhsC33Yp6DNsSfXhI7MzDGea9p/M2T9VYmes9ifzf
 LlkRKJWZ9uIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="210549812"
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="210549812"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 13:50:46 -0700
IronPort-SDR: AuR8/NPV8hVVfs7GGCeAhJof99S+JiqdQoJgXcDV4kQ8g11utH7iJv2vhfl8d1cpqInkCOBzHv
 5qLZWt7FRIQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="294303365"
Received: from lkp-server01.sh.intel.com (HELO 538b5e3c8319) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 26 Jun 2020 13:50:42 -0700
Received: from kbuild by 538b5e3c8319 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jovJ3-0002Ro-GC; Fri, 26 Jun 2020 20:50:41 +0000
Date:   Sat, 27 Jun 2020 04:50:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc:     kbuild-all@lists.01.org, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>
Subject: [RFC PATCH] thermal: thermal_zone_device_set_mode() can be static
Message-ID: <20200626205028.GA2296@014f859222aa>
References: <20200626173755.26379-7-andrzej.p@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626173755.26379-7-andrzej.p@collabora.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 thermal_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 3181295075b9a..f02c57c986f0e 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -459,8 +459,8 @@ static void thermal_zone_device_reset(struct thermal_zone_device *tz)
 	thermal_zone_device_init(tz);
 }
 
-int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
-				 enum thermal_device_mode mode)
+static int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
+					enum thermal_device_mode mode)
 {
 	int ret = 0;
 
