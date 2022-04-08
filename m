Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5832E4F9A2D
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 18:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiDHQOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 12:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiDHQOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 12:14:45 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7418EB8E
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 09:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649434361; x=1680970361;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KJjFKKVIN37SeFR2fMe4XxCFJuSmW19jRHZJdkwFC4Y=;
  b=NQGla48niGfDy2HoZzPeZkeIdk4dXs1pA3zHPf9L/yKaOcAJrGXvAj1w
   fmH3fnIGQ0tefnqY+dcKBeKXce3/n2Z8yM6WyTEoy2IXrNOeQavKfRmAP
   A6SpeDYycX214ou5bVRQiuljMiukZE3C2yuv/bgYnVleG+hdviHurxoPt
   OTOOlLuqBkL8Y9Cq3B0UiDSzn3QMG9a/7uWjyjAAIjw4EDJlG3fhBo+s1
   LXjH3dKJO32I617SrrDxvfZEi6Qztlc9r/Rp51ILKy0NMKgKflZTYfyXg
   uI588SjlMRd+BH5lkI+X+l8iz01vPA32YS9R4uTJkD7Sqq/t4ejvZkJne
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="261622007"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="261622007"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 09:12:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="589269690"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 08 Apr 2022 09:12:40 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     linux-firmware@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [linux-firmware v1 0/2][pull request] Intel Wired LAN Firmware Updates 2022-04-08
Date:   Fri,  8 Apr 2022 09:13:22 -0700
Message-Id: <20220408161324.2224973-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the ice comms package to a newer version and add another
alternative package file, wireless edge, that can optionally be used.

The following are changes since commit 681281e49fb6778831370e5d94e6e1d97f0752d6:
  amdgpu: update PSP 13.0.8 firmware
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/firmware dev-queue

Arjun Anantharam (1):
  ice: update ice DDP comms package to 1.3.31.0

Guruprasad Rao (1):
  ice: Add wireless edge file for Intel E800 series driver

 WHENCE                                        |   3 ++-
 ...ms-1.3.20.0.pkg => ice_comms-1.3.31.0.pkg} | Bin 688388 -> 717176 bytes
 .../ice_wireless_edge-1.3.7.0.pkg}            | Bin 688388 -> 717176 bytes
 3 files changed, 2 insertions(+), 1 deletion(-)
 copy intel/ice/ddp-comms/{ice_comms-1.3.20.0.pkg => ice_comms-1.3.31.0.pkg} (75%)
 rename intel/ice/{ddp-comms/ice_comms-1.3.20.0.pkg => ddp-wireless_edge/ice_wireless_edge-1.3.7.0.pkg} (74%)

-- 
2.31.1

