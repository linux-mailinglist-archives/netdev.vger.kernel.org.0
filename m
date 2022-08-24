Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4C35A022C
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 21:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238124AbiHXThz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 15:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237446AbiHXThy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 15:37:54 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94461792CD
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 12:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661369873; x=1692905873;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9xgQn1EQX72aSYdmk0buHarD0F+xS393ZMfg2cOyDes=;
  b=aM3zzGPNvMNLjrRAjPECIKhtQIiWRTTai+glcp0mtce1V/hcX8buh2W9
   7/AlUItbTFuCEq6TJPmSusXjt7qJllbA7Ax9fxZoAvMcqOm+qIjVJ+Lm7
   iHwUBjXJ4ASdyQp3tRU1q31P4kSuqLs2N7+j9CpFO9XPXy/VawCx3Z2o/
   p4Yn4S6PPPcuoOeJ/F6w5LewdgYOs9jxnqa1Lv7Mor//TOjSUVuRNvgka
   eRk0w6kVFhjrcueeadxMdhbt5WMKlRH134C/8YS38yWSxjnJHnPknPuzh
   1Y1Osn0xSKYCi0qBOj33UtODQOfvTyWPhRr7mpkxxFXYQohx8UwPSNXGf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="380351198"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="380351198"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 12:37:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="785742645"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 24 Aug 2022 12:37:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2022-08-24 (ixgbe, i40e)
Date:   Wed, 24 Aug 2022 12:37:45 -0700
Message-Id: <20220824193748.874343-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ixgbe and i40e drivers.

Jake stops incorrect resetting of SYSTIME registers when starting
cyclecounter for ixgbe.

Sylwester corrects a check on source IP address when validating destination
for i40e.

The following are changes since commit 0c4a95417ee4b1013ddf115fb6dbe36a2503a598:
  Merge branch 'sysctl-data-races'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 10GbE

Jacob Keller (1):
  ixgbe: stop resetting SYSTIME in ixgbe_ptp_start_cyclecounter

Sylwester Dziedziuch (1):
  i40e: Fix incorrect address type for IPv6 flow rules

 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  | 59 +++++++++++++++----
 2 files changed, 47 insertions(+), 14 deletions(-)

-- 
2.35.1

