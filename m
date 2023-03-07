Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936266AF83E
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjCGWIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjCGWIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:08:34 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0B48E3CA
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 14:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678226912; x=1709762912;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wwdp9AsixXX061lhK/eLAD1y9rTO47g4vUgxWLF81PA=;
  b=TvMru0SyDFIK2C7hO6+/R1KZy3BskBOTtlrF55EwbKQOqI8wJQAdQQ5C
   SFDT1sPAfCigw1mj/HFE7a8B9FTEHk2sqjiCByjZSRYLd24JZfFt3DBtX
   BczkvEUlQnQ0BWKwE2oUvkQ3KjflWEO+ku97uIgz6GNrhbcof3cqCymrO
   OmXrMUxbhVyoumA7fsNXIDPBl7uJNujN62FJEFqQ9BdlO8qRfoL5HtZV9
   WzvgMHTPnqboqL0DKMAWAfep/Rqc4DhVxgk6Lt8IvDEqRy7CIzrh+C/Wm
   Hf37j0EvkuBkNpgyi2p/vI03ep1L03hw+P6niLs8h0hYCZBsFSv3li58S
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="316386688"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="316386688"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 14:08:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="654123225"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="654123225"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga006.jf.intel.com with ESMTP; 07 Mar 2023 14:08:32 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2023-03-07 (ice)
Date:   Tue,  7 Mar 2023 14:07:11 -0800
Message-Id: <20230307220714.3997294-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Dave removes masking from pfcena field as it was incorrectly preventing
valid traffic classes from being enabled.

Michal resolves various smatch issues such as not propagating error
codes and returning 0 explicitly.

Arnd Bergmann resolves gcc-9 warning for integer overflow.

The following are changes since commit 382e363d5bed0cec5807b35761d14e55955eee63:
  net: usb: qmi_wwan: add Telit 0x1080 composition
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Arnd Bergmann (1):
  ethernet: ice: avoid gcc-9 integer overflow warning

Dave Ertman (1):
  ice: Fix DSCP PFC TLV creation

Michal Swiatkowski (1):
  ice: don't ignore return codes in VSI related code

 drivers/net/ethernet/intel/ice/ice_dcb.c    |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c    | 17 ++++++++++-------
 drivers/net/ethernet/intel/ice/ice_tc_lib.c |  8 ++++----
 3 files changed, 15 insertions(+), 12 deletions(-)

-- 
2.38.1

