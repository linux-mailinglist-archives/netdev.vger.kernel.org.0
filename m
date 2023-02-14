Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6307F696EC9
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjBNVB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbjBNVBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:01:24 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609A628236
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676408484; x=1707944484;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sOc8M1eLMwcudngENOO0pUlTkaeNSCKlfXVxLrmzg/k=;
  b=ZHHdecP0klXZh4+nbyUOTEs92DRYE2YdY6Yhmnq8rzrRiukb3d36fGKQ
   puJ8btqcfHj/dlT8zzwolx/qJ8Upt9+UiqqmL/PX3iVn0A2vCyCnNqNFE
   ybo4bqQNBMnjXxddUUlpXuVnEgX3urcMgoHtyQkdavQgk03OZhhaq8zWz
   7S7wgyhQ7tBKv45l0ygn9U1C/HmHQs29wOhRSSiluEL3wsicJWQxlIjLd
   Xye6YRHWO/aW1xmVEzJB2OKsnbArJahiP10X7xLeXIAGLJfahu4xQU6lO
   oQOCK362u1ZygitLc5cWwmZAl/fov4Wn62u5+n2f6WzjMQ5G7PAEFXZSR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="417490078"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="417490078"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:01:24 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="699677918"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="699677918"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:01:23 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        edumazet@google.com, Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next v1 0/2] net/core: commmon prints for promisc
Date:   Tue, 14 Feb 2023 13:01:15 -0800
Message-Id: <20230214210117.23123-1-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.31.1
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

Add a print to the kernel log for allmulticast entry and exit, and
standardize the print for entry and exit of promiscuous mode.

These prints are useful to both user and developer and should have the
triggering driver/bus/device info that netdev_info (optionally) gives.

Jesse Brandeburg (2):
  net/core: print message for allmulticast
  net/core: refactor promiscuous mode message

 net/core/dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


base-commit: 2edd92570441dd33246210042dc167319a5cf7e3
-- 
2.31.1

