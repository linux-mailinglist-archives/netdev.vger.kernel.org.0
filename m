Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC2767F17C
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 23:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbjA0WyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 17:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbjA0Wx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 17:53:57 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A71448F;
        Fri, 27 Jan 2023 14:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674860027; x=1706396027;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k0FW4EkggWQRCfPtZeaDhmMpy1hVsTfGGXcTPn3H24A=;
  b=HK7LdYqp860nFikrxJJbTA/PmbgW8uOK+ZrV6K5dUe1tDeD9eiDlqFSC
   JFeJwcq2KvG/Ddp6xM2eNdogM/v+HA7ysBsC2MXZpZbmWTwzhX90d5diJ
   8cwvUTZGxV3i2F+HWHJ0W0PGT9kYx/KHLBgpdfThQwxZEDnpKVvkJPO90
   +BZhheZSb+AW84Wsb1DwpfvasHNkjmUgOGu7Rw5ube1jqBmwfN97Qds/z
   t/9w1mmczb9lSA8DWUdhEHd1w8upMjkf5kp6MIbzQb+yD8du7MhVQqnOC
   xBWDQJxw+/CG8D+ChHPL8Qm9IqH9j53AQiqBx80Us1yXTiIOsFjg7ONke
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="327229824"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="327229824"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 14:53:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="805976405"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="805976405"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jan 2023 14:53:37 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Wilczynski <michal.wilczynski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com, corbet@lwn.net,
        linux-doc@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net v4 2/2] ice: Fix broken link in ice NAPI doc
Date:   Fri, 27 Jan 2023 14:53:33 -0800
Message-Id: <20230127225333.1534783-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127225333.1534783-1-anthony.l.nguyen@intel.com>
References: <20230127225333.1534783-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Wilczynski <michal.wilczynski@intel.com>

Current link for NAPI documentation in ice driver doesn't work - it
returns 404. Update the link to the working one.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 Documentation/networking/device_drivers/ethernet/intel/ice.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/ethernet/intel/ice.rst b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
index dc2e60ced927..b481b81f3be5 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/ice.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
@@ -819,7 +819,7 @@ NAPI
 ----
 This driver supports NAPI (Rx polling mode).
 For more information on NAPI, see
-https://www.linuxfoundation.org/collaborate/workgroups/networking/napi
+https://wiki.linuxfoundation.org/networking/napi
 
 
 MACVLAN
-- 
2.38.1

