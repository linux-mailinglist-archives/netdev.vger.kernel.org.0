Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22DB4B4280
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 08:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241064AbiBNHHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 02:07:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiBNHHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 02:07:45 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043D457B3D
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 23:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644822456; x=1676358456;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KgGVOrCAl1iyP5IY8bWwGT3QAYcpYZ3gipbrSnsWn68=;
  b=m9uRxgLfSkkYosMMQPyqHOO0IS8hiQAmHtGK2M4z8zNcwx68W+Bjoi3z
   BWoXrWRUvRVy5xN66AiXrkgtXrAeQJhGQSvOIdGmQsQh5ZZBkYMXMZ6TM
   E9i7ZC5DUanmiM8zepKA8bbLJvi4FsrGHV9ImmllG2w5J27CjrMc9F9pJ
   THFQgUjMND6rb6djFItMDLeWpOngAFcUR0LJV5Sdy5gCfQEfB7nTVZRtl
   /VBUXuoZLZtEJPM4At+ANzNnQt+wpnpRZ5fiT0PQVlIRbJecdIs/iYuim
   3HfGr0iyJ6DsXHaI2up3VYMlT17E+I7DfFXD7jNs4HpZLb+v2L1xGBKJr
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="248862561"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="248862561"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 23:07:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="680286196"
Received: from ccgwwan-desktop15.iind.intel.com (HELO BSWCG005.iind.intel.com) ([10.224.174.19])
  by fmsmga001.fm.intel.com with ESMTP; 13 Feb 2022 23:07:34 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH net-next 0/2] net: wwan: debugfs dev reference not dropped
Date:   Mon, 14 Feb 2022 12:46:51 +0530
Message-Id: <20220214071653.813010-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series contains WWAN subsystem & IOSM Driver changes to
drop dev reference obtained as part of wwan debugfs dir entry retrieval.

PATCH1: A new debugfs interface is introduced in wwan subsystem so
that wwan driver can drop the obtained dev reference post debugfs use.

PATCH2: IOSM Driver uses new debugfs interface to drop dev reference.

Please refer to commit messages for details.

M Chetan Kumar (2):
  net: wwan: debugfs obtained dev reference not dropped
  net: wwan: iosm: drop debugfs dev reference

 drivers/net/wwan/iosm/iosm_ipc_debugfs.c |  5 ++--
 drivers/net/wwan/iosm/iosm_ipc_imem.h    |  2 ++
 drivers/net/wwan/wwan_core.c             | 35 ++++++++++++++++++++++++
 include/linux/wwan.h                     |  2 ++
 4 files changed, 42 insertions(+), 2 deletions(-)

-- 
2.25.1

