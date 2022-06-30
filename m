Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B1A56259F
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbiF3Vwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiF3Vwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:52:45 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A985564C2
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656625964; x=1688161964;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ObQunVxJ0WrA9vBydBC+pbIZ/2EB4FwMje8sOZuTTHg=;
  b=c76e4tSnXTdjnSwU+BHD4q6m5iRuVCqivuqkbnSkWUw1rmfnpbgNiDip
   g39GFPtBW9PFA9nHt7QKu3/W8aC5OeWq3IRSfLHILFyFeiLiuGMUHfUW9
   amb8u9v0nxD4J7Wu0kBjrlCHOo6itl6QrBHEWPNTheo3Gogk6nSgsexDG
   tA6VJGoW+xSmoKlxbYZGFrPsy8yLuUascCj7QNsq52tGKkhqKCjV/bbSP
   5kc0pdtJQwuTrnzqWnCG4E3tjJhzIHSDKjtEp2z+s+p2Y8A4TP0Pk3NCM
   q2bE3uYTruVwBW6zdtpFcpYuMJHa3cwqAazZOhpQT9+5syz3X8z6QbRCI
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="262881758"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="262881758"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:52:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="918221380"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 30 Jun 2022 14:52:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2022-06-30
Date:   Thu, 30 Jun 2022 14:49:38 -0700
Message-Id: <20220630214940.3036250-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Lukasz adds reporting of packets dropped for being too large into the Rx
dropped statistics.

Norbert clears VF filter and MAC address to resolve issue with older VFs
being unable to change their MAC address.

The following are changes since commit 58bf4db695287c4bb2a5fc9fc12c78fdd4c36894:
  net: dsa: felix: fix race between reading PSFP stats and port stats
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Lukasz Cieplicki (1):
  i40e: Fix dropped jumbo frames statistics

Norbert Zulinski (1):
  i40e: Fix VF's MAC Address change on VM

 drivers/net/ethernet/intel/i40e/i40e.h        | 16 ++++
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 73 +++++++++++++++++++
 .../net/ethernet/intel/i40e/i40e_register.h   | 13 ++++
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  1 +
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |  4 +
 5 files changed, 107 insertions(+)

-- 
2.35.1

