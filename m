Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61EB4EDE9C
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239812AbiCaQVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239801AbiCaQVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:21:31 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECECF146B44
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 09:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648743584; x=1680279584;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8ybBqSlbDL92l8jv990A4w9Ek43M1WaWaynKSy4y9eQ=;
  b=ObA5gJukN0CvLL5DVYGfFV1CCmw96Tq1TBO/SwOcwlZ67AM8iVlvRQQa
   FhhfqfoipdcE2XSmaKA7jUoRinqN4ZR0LRPsQIRTavfUWfK5H69wIodXx
   0V2m9iU5LtZEP674Gd1w65Re5zHWm1BntKtMIuk/hkGnGIVxRgqkx7c+o
   /aN0zMtS1BdswviKXn38L7gpywenl+SAdnvnGFAtCDg4XzEZ4iZ+/AtjV
   ZT0mqKgqAB0NdD1tH20Bp/k6Mzxcc0TILE7pO9FOiDsedeVEEhTQqMG5g
   8+Uq1TnVQUyW6WTNQTEg3jJV0M8yNIB7cPIcTNDtHTSgbrraZ2sW0a85J
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="260067487"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="260067487"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 09:19:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="522407013"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 31 Mar 2022 09:19:39 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     alice.michael@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/3] ice-fixups
Date:   Thu, 31 Mar 2022 09:20:05 -0700
Message-Id: <20220331162008.1891935-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series handles a handful of cleanups for the ice
driver.  Ivan fixed a problem on the VSI during a release,
fixing a MAC address setting, and a broken IFF_ALLMULTI
handling.

Ivan Vecera:
  ice: Clear default forwarding VSI during VSI release
  ice: Fix MAC address setting
  ice: Fix broken IFF_ALLMULTI handling

 drivers/net/ethernet/intel/ice/ice.h      |   1 -
 drivers/net/ethernet/intel/ice/ice_fltr.c |  44 +++++++-
 drivers/net/ethernet/intel/ice/ice_lib.c  |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c | 121 +++++++++++++++-------
 4 files changed, 128 insertions(+), 40 deletions(-)

-- 
2.31.1

