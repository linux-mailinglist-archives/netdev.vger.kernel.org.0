Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD5D4F1FE2
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 01:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241821AbiDDXKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 19:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242361AbiDDXJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 19:09:53 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A71E57165
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 15:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649112181; x=1680648181;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aQdpnoJ8xqpApYSJj+Mck8+6aAwU0XTiRfg15ICySOI=;
  b=fOIqxnWIYnKYjZoO4Qsjfr7wWMcz8PdEvKX9NsP9socY5iU9m607jnqs
   bdsIoeY7ZzPtjIgCKebfvo1d13P3Y0HjLL0GzgwtJfLiA9jcQr1/wdJKv
   GF79Tx4Wd0D+8fOUHE4hITNq9Yphc9yqMjfLBS6ZQ/P6ZPrpF1ZHh/KAx
   rN6HL0X/eDTvLA5loh6f4ihpiHnHF3nzwv7XwY659Umuc0FQgsmriqAje
   2k4AsT2uz17VopkUqmG4XgtYf97fI1fE0jV7dCyq5htyfKDFQAsc5c/Yd
   mB8z0xdwgLnmvAxCk71c8NrphVxZrHSeEJolrbbyhTO2N9ipNiQcwcQ/b
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="260800910"
X-IronPort-AV: E=Sophos;i="5.90,235,1643702400"; 
   d="scan'208";a="260800910"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 15:43:01 -0700
X-IronPort-AV: E=Sophos;i="5.90,235,1643702400"; 
   d="scan'208";a="789642150"
Received: from vcostago-mobl3.jf.intel.com ([10.24.14.61])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 15:43:01 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, andrew@lunn.ch,
        mkubecek@suse.cz
Subject: [PATCH ethtool] ethtool.8: Fix typo in man page
Date:   Mon,  4 Apr 2022 15:40:05 -0700
Message-Id: <20220404224005.1012651-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove an extra 'q' in the cable-test section of the documentation.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 ethtool.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ethtool.8.in b/ethtool.8.in
index 12940e1b32aa..e1577765acf9 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -1426,7 +1426,7 @@ Sub command to apply. The supported sub commands include --show-coalesce and
 --coalesce.
 .RE
 .TP
-q.B \-\-cable\-test
+.B \-\-cable\-test
 Perform a cable test and report the results. What results are returned depends
 on the capabilities of the network interface. Typically open pairs and shorted
 pairs can be reported, along with pairs being O.K. When a fault is detected
-- 
2.35.1

