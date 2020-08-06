Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452D423DCF4
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 18:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbgHFQ6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 12:58:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:57635 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728735AbgHFQkm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 12:40:42 -0400
IronPort-SDR: s7fLl2craXggotxw4FwfUDCGZ6uhMZoBK0eBRR6La+WFXMCJH6LH8X4n7Mu5A2KUYXZrBZd59U
 ZlinOo32Y9yg==
X-IronPort-AV: E=McAfee;i="6000,8403,9704"; a="140382278"
X-IronPort-AV: E=Sophos;i="5.75,441,1589266800"; 
   d="scan'208";a="140382278"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2020 04:52:10 -0700
IronPort-SDR: l6nTZH8mrQIcFnp672HaOQMcJtWmLu+e4RnszIrL1bCGBjwtVbzuNcoyg2pU+rY1n8J86cUF34
 z1bzCWFQROBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,441,1589266800"; 
   d="scan'208";a="367559228"
Received: from lkp-server02.sh.intel.com (HELO 37a337f97289) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 06 Aug 2020 04:52:08 -0700
Received: from kbuild by 37a337f97289 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1k3eRM-0001GL-5w; Thu, 06 Aug 2020 11:52:08 +0000
Date:   Thu, 6 Aug 2020 19:51:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Hillf Danton <hdanton@sina.com>
Subject: [RFC PATCH] net: dev_attr_napi_threaded can be static
Message-ID: <20200806115104.GA134411@bf25ee3fa5a7>
References: <20200806095558.82780-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200806095558.82780-1-nbd@nbd.name>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 net-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 8765e075d7e94..2fbbf4b818df4 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -510,7 +510,7 @@ static ssize_t napi_threaded_show(struct device *dev,
 
 	return sprintf(buf, fmt_dec, enabled);
 }
-DEVICE_ATTR_RW(napi_threaded);
+static DEVICE_ATTR_RW(napi_threaded);
 
 static ssize_t phys_port_id_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
