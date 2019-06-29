Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 366435A854
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 04:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfF2CV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 22:21:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:52514 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbfF2CV1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 22:21:27 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 19:21:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,429,1557212400"; 
   d="scan'208";a="156744806"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 28 Jun 2019 19:21:25 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hh2zV-000GDu-9g; Sat, 29 Jun 2019 10:21:25 +0800
Date:   Sat, 29 Jun 2019 10:21:16 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Catherine Sullivan <csully@google.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Subject: [RFC PATCH] gve: gve_version_prefix[] can be static
Message-ID: <20190629022116.GA25158@lkp-kbuild18>
References: <20190626185251.205687-2-csully@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626185251.205687-2-csully@google.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: ac22601d5bb7 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 gve_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index aa0428ef..505ca2c 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -21,7 +21,7 @@
 #define GVE_VERSION_PREFIX	"GVE-"
 
 const char gve_version_str[] = GVE_VERSION;
-const char gve_version_prefix[] = GVE_VERSION_PREFIX;
+static const char gve_version_prefix[] = GVE_VERSION_PREFIX;
 
 static int gve_alloc_counter_array(struct gve_priv *priv)
 {
