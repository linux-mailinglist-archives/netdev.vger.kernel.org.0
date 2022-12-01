Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3077063EDB4
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiLAK17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiLAK14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:27:56 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603A3178A1
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 02:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669890473; x=1701426473;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZRRN/gh34ooKBuRKPMiTWz3cr8oGbiQbdhz78VcuBm4=;
  b=lZtjJmfYooABKsmn+niIAgQxEZtLeuaBKVjArSyS7uH0IPmYxa51B9Jz
   SFNLdpsO0Vf8si7Ix++U2hFmlbViEyZzSrNdE8uvsjLzJ5IrSytUGTU6r
   r95FZfDdml8Lf9z4+/5n2Rh0mWSCxxzCeYlyrOADPt2bs77RHueJvitEJ
   fw87/DMRHZ30TaYrJVJsHCiV4KoU8ZTjs8bkiU9CUJWAUnEbbYs9FwlYy
   W6qgSp9vlxZwFK0ZJbbY41Rs3zt8Re4sjshlVyhY6vHek2963akrVS+UR
   N8BMJsmXpDIbJeKepkDFM/9cfDZL+93UkZEBVyRPlTJmtc7iqRXHwcwZs
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="313277980"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="313277980"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 02:27:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="769184471"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="769184471"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 02:27:50 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, przemyslaw.kitszel@intel.com,
        jiri@resnulli.us, wojciech.drewek@intel.com, dsahern@gmail.com,
        stephen@networkplumber.org,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH iproute2-next v2 0/4] Implement new netlink attributes for devlink-rate in iproute2
Date:   Thu,  1 Dec 2022 11:26:22 +0100
Message-Id: <20221201102626.56390-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch implementing new netlink attributes for devlink-rate got merged to
net-next.
https://lore.kernel.org/netdev/20221115104825.172668-1-michal.wilczynski@intel.com/

Now there is a need to support these new attributes in the userspace
tool. Implement tx_priority and tx_weight in devlink userspace tool. Update
documentation.

v2:
 - Re-send series without bug-fix

Michal Wilczynski (4):
  devlink: Add uapi changes for tx_priority and tx_weight
  devlink: Introduce new attribute 'tx_priority' to devlink-rate
  devlink: Introduce new attribute 'tx_weight' to devlink-rate
  devlink: Add documentation for tx_prority and tx_weight

 devlink/devlink.c            | 55 ++++++++++++++++++++++++++++++++++--
 include/uapi/linux/devlink.h |  3 ++
 man/man8/devlink-rate.8      | 22 +++++++++++++++
 3 files changed, 77 insertions(+), 3 deletions(-)

-- 
2.37.2

