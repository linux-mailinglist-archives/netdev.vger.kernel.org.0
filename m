Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71EF47C616
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241075AbhLUSNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:13:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:10068 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237283AbhLUSNw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:13:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110432; x=1671646432;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2nRXbYjZ1tOQukGjXRiMMhhxm/GR8Qhok1q32Ub/AFg=;
  b=gsOt4C777/lrvFkjKQ5IEdY9ZUnLwfpRZhZCIQsdvIj+Hz1qtnVlXAr7
   rgj++5I1iP+z9cZrDS6V618HU3qZLdpnArkjLKFyTAbQ8BEhDoUr1JY3H
   mmyb8mWU92Hp3+t6rCVSsoHUHDZzHprWFJxEALBjIC1yIlpGCyreZ14cR
   NWZigu7Mh5xsmlLobNxZAkuTtnxpYKQ8523d+KjzdLuR0Bsxz6+ZbJU7V
   6/N3tWfY5B2bYPtSHPmjNoepHOZDe1+u81i0orYzKONoM5nia2rncO3JU
   r2FVdqExuKPCDXhfg0CNaLpksp4OyJkWZcF3HhwRo5+CoKj1/uF47GFvd
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240267198"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240267198"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 10:02:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="613557864"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 21 Dec 2021 10:02:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Xiang wangx <wangxiang@cdjrlc.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 8/8] fm10k: Fix syntax errors in comments
Date:   Tue, 21 Dec 2021 10:02:00 -0800
Message-Id: <20211221180200.3176851-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
References: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiang wangx <wangxiang@cdjrlc.com>

Delete the redundant word 'by'.

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_tlv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c b/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c
index 21eff0895a7a..f6d56867f857 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c
@@ -143,7 +143,7 @@ s32 fm10k_tlv_attr_put_mac_vlan(u32 *msg, u16 attr_id,
  *  @vlan: location of buffer to store VLAN
  *
  *  This function pulls the MAC address back out of the attribute and will
- *  place it in the array pointed by by mac_addr.  It will return success
+ *  place it in the array pointed by mac_addr.  It will return success
  *  if provided with a valid pointers.
  **/
 s32 fm10k_tlv_attr_get_mac_vlan(u32 *attr, u8 *mac_addr, u16 *vlan)
-- 
2.31.1

