Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530634B0215
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 02:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbiBJBZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 20:25:15 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiBJBZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:25:13 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77875205C0
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 17:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644456315; x=1675992315;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3rrsnoKd1ZR12c0sFe1pA9AOATsBnXmwt4Bb94WhWLQ=;
  b=DTkzyuuw34VYWI6JBcYGkwP4nm6JxpVQFl+rwF5PhPgaSonliqM0AtPh
   Fi8sNhBkgJyqJRJHTQ/zedVZv2l88b5kZR4LrheT9VpHYclDhT00zv5H4
   zSLJTvBYN0pEq8mSklQQRfeSiGmRfaCI1hnQqXt6hPjO5SvEACj52J9bi
   fAxcd3FElNaEb7kX/H2uOWOMTBeWDDSEGunJHaWB7o+HVDiitIOttZMcF
   Ee/sIcnus108FtIQc8+bXd6lFxesOfjvTYRnsVyWajBwL9T3/DWGmV3Gk
   8OLBcYgi0mVIa2s6ymVm1u8bChumIKBtPfHEAGkhUEg7I7qWCdX+zl1/3
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="230029674"
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="230029674"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 17:25:15 -0800
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="526263243"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.22.101])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 17:25:14 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net 0/2] mptcp: Fixes for 5.17
Date:   Wed,  9 Feb 2022 17:25:06 -0800
Message-Id: <20220210012508.226880-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 fixes a MPTCP selftest bug that combined the results of two
separate tests in the test output.

Patch 2 fixes a problem where advertised IPv6 addresses were not actually
available for incoming MP_JOIN requests.

Kishen Maloor (1):
  mptcp: netlink: process IPv6 addrs in creating listening sockets

Matthieu Baerts (1):
  selftests: mptcp: add missing join check

 net/mptcp/pm_netlink.c                          | 8 ++++++--
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)


base-commit: 3bed06e36994661a75bae6a289926e566b9b3c1a
-- 
2.35.1

