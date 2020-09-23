Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35F5274FC1
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 06:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgIWEOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 00:14:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:61104 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIWEOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 00:14:35 -0400
IronPort-SDR: vzyaQQHVmyAXJvU40by2ivg61umtqsW15B1w2D2puEFnAGBxf3HbCpUEeYKNvkofv9Oe3Tjb1t
 7t/TSMjKIoVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9752"; a="160064472"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="160064472"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2020 21:14:34 -0700
IronPort-SDR: xkPdiT9nL2G3ZHar/RAQBfgeW3mQzjEX6uRkztIlf4Fz+42BPXgdZtT3DeXp//FTDZj8BYGUwk
 7PASCK1lnc6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="486261875"
Received: from lkp-server01.sh.intel.com (HELO 928d8e596b58) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 22 Sep 2020 21:14:32 -0700
Received: from kbuild by 928d8e596b58 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kKwAp-0000lW-J2; Wed, 23 Sep 2020 04:14:31 +0000
Date:   Wed, 23 Sep 2020 12:13:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [RFC PATCH] bonding: linkdesc can be static
Message-ID: <20200923041337.GA29158@0b758a8b4a67>
References: <20200922133731.33478-5-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922133731.33478-5-jarod@redhat.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 bond_procfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index 91ece68607b23..9b1b37a682728 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -8,7 +8,7 @@
 #include "bonding_priv.h"
 
 #ifdef CONFIG_BONDING_LEGACY_INTERFACES
-const char *linkdesc = "Slave";
+static const char *linkdesc = "Slave";
 #else
 const char *linkdesc = "Link";
 #endif
