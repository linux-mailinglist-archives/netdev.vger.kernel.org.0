Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0564A663468
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 23:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237387AbjAIWxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 17:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237486AbjAIWx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 17:53:26 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A53165BA
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 14:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673304804; x=1704840804;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/Kj9J1xmPmQfhfkAnJln9EEyySkGjjngpOCX1Br7Bzk=;
  b=Ksv83AVM3mUQPt53YZdanNI2hmgZGfKlzub9mSjv87Nvkbe4hvBQwVL8
   CoP3QGTPvEfZOheicka6+VzY8sEUVnAs1dMjwe4xNPeq7cGzl93tfdVXX
   eOzFK88WV4u1NyHTSN6zGPAo5chd6lgx1oleD+8MHEACGXOoUogbbk5k4
   0FyHhVNuyGNs8XurrxuM4nWPSl/u7WMxBAwSHMjs3IHHWnNI+ufQaNA6B
   vA3g0ufHPBNP7LhQt7vdw1qH5nYRGYtAwqzLJQeA2anQoKNHiqYu1tTES
   lcmxChsHngdHZ0QBJ24ZHzu2ttINAJ1nQYqiVeGXKHfOdccMfnzxTbtrf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="387456069"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="387456069"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 14:53:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="689197472"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="689197472"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 09 Jan 2023 14:53:23 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2023-01-09 (ice)
Date:   Mon,  9 Jan 2023 14:53:56 -0800
Message-Id: <20230109225358.3478060-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
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

This series contains updates to ice driver only.

Jiasheng Jiang frees allocated cmd_buf if write_buf allocation failed to
prevent memory leak.

Yuan Can adds check, and proper cleanup, of gnss_tty_port allocation call
to avoid memory leaks.

The following are changes since commit 7d6ceeb1875cc08dc3d1e558e191434d94840cd5:
  af_unix: selftest: Fix the size of the parameter to connect()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Jiasheng Jiang (1):
  ice: Add check for kzalloc

Yuan Can (1):
  ice: Fix potential memory leak in ice_gnss_tty_write()

 drivers/net/ethernet/intel/ice/ice_gnss.c | 24 ++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

-- 
2.38.1

