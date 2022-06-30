Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F2656255B
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237562AbiF3Vfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237574AbiF3Vf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:35:29 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB06653D1C
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656624926; x=1688160926;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T80uiGPe3V8ZmN+3dfKZvC4iy+lzb48tDIkiAokZ/tI=;
  b=E0C0q0SamLXLcRqODVEcFHj2bj9mXLAAvOO9FOlibUHpmbiD9xM8pZso
   3i71T9EskcQfxczl45/ziso9tjW4wSXwrSm+4NLB7Fvk5C9kvqWiiEONJ
   Jwp1qI4ZIRkcpm2uir+/eXtkrNfEorpIPwFKLjNYdb59Gw1jd047nKhgp
   erS8F3mb3p1zncv676Ntf5gtDuww5bzyb3cR3uP4PdRNjHz1cCCW4Or+b
   qfOUfWJlnqW0ybXN9mC7pCH9oDsURQaesHJWxBBhi0nWx5VXa8hVlCoHY
   ISFIBP5jAYrREBFi/a93zLCPSk3PSNYXNkTMOuxkSbSpf48Sbngyh73hh
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282507752"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="282507752"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:35:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="837771827"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2022 14:35:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jilin Yuan <yuanjilin@cdjrlc.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 08/15] intel/fm10k:fix repeated words in comments
Date:   Thu, 30 Jun 2022 14:32:01 -0700
Message-Id: <20220630213208.3034968-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220630213208.3034968-1-anthony.l.nguyen@intel.com>
References: <20220630213208.3034968-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jilin Yuan <yuanjilin@cdjrlc.com>

Delete the redundant word 'by'.
Delete the redundant word 'a'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_tlv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c b/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c
index f6d56867f857..75cbdf2dbbe3 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_tlv.c
@@ -78,7 +78,7 @@ static s32 fm10k_tlv_attr_put_null_string(u32 *msg, u16 attr_id,
  *  @string: Pointer to location of destination string
  *
  *  This function pulls the string back out of the attribute and will place
- *  it in the array pointed by by string.  It will return success if provided
+ *  it in the array pointed by string.  It will return success if provided
  *  with a valid pointers.
  **/
 static s32 fm10k_tlv_attr_get_null_string(u32 *attr, unsigned char *string)
@@ -584,7 +584,7 @@ s32 fm10k_tlv_msg_parse(struct fm10k_hw *hw, u32 *msg,
  *  @mbx: Unused mailbox pointer
  *
  *  This function is a default handler for unrecognized messages.  At a
- *  a minimum it just indicates that the message requested was
+ *  minimum it just indicates that the message requested was
  *  unimplemented.
  **/
 s32 fm10k_tlv_msg_error(struct fm10k_hw __always_unused *hw,
-- 
2.35.1

