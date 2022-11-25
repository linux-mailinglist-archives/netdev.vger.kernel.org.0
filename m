Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA036389DE
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiKYMeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiKYMem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:34:42 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36F04B9AD
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 04:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669379677; x=1700915677;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=op4TR6w4INbTqyyAyBbOxl/z23kJqG0mw+scIscUPHY=;
  b=fYOjG2gluXPSNByCZx8uloUZo9f/3Xte6EfyeLnePoPg3qgDrT+GNhh3
   y9GLhE6vrmRx7yOoW9xZi+ptaRmRNzP6viti9qvwSp8GZex610xFwX6mH
   AWpu0cqwZ4XaO2ZjVJwSHjqAAD/PGRUDVcbCB5Q2s1xGHRDM3BiSa6cr4
   FhhF2HMhcpExM+eCU91o5RdRiMMdo5crPcZ/FgzcNxgfvFX1+ijRAnSX7
   q19MtIgrtGkYP+6Rt1dqVn5g3lKU2k4v+F5jTjyjBLbkHM6x0+caKM2J3
   9/X5m/Lf2etqsWEDyFWh92dXMEI3TlsqkEgOtL+Hyn2il+HkKWea2H+Mo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="314510187"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="314510187"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:34:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="711263990"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="711263990"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:34:35 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, przemyslaw.kitszel@intel.com,
        jiri@resnulli.us, wojciech.drewek@intel.com, dsahern@gmail.com,
        stephen@networkplumber.org,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH iproute2-next 0/5] Implement new netlink attributes for devlink-rate in iproute2
Date:   Fri, 25 Nov 2022 13:34:16 +0100
Message-Id: <20221125123421.36297-1-michal.wilczynski@intel.com>
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

Michal Wilczynski (5):
  devlink: Fix setting parent for 'rate add'
  devlink: Add uapi changes for tx_priority and tx_weight
  devlink: Introduce new attribute 'tx_priority' to devlink-rate
  devlink: Introduce new attribute 'tx_weight' to devlink-rate
  devlink: Add documentation for tx_prority and tx_weight

 devlink/devlink.c            | 56 ++++++++++++++++++++++++++++++++++--
 include/uapi/linux/devlink.h |  3 ++
 man/man8/devlink-rate.8      | 22 ++++++++++++++
 3 files changed, 78 insertions(+), 3 deletions(-)

-- 
2.37.2

