Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C93D50A09C
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiDUNYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiDUNYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:24:35 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8897BC22;
        Thu, 21 Apr 2022 06:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650547305; x=1682083305;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zqvgm7kii0++pXRqau1SCK4BDMeQHecoSUt0+M6vthI=;
  b=gdXQHL3SYOLNFZLBEnZv24BUCOp33iPd6p2FGkceh4IVfaxjSzwH9a2k
   R8/zAcAZ4SWQdLwkv1nNSkYwRABqKNF3b2iCbNy7PEYyGL6liGU37kOfI
   S0Ac1d1GW9mmm/i4UMtBPhT9S/D/+Q1PUwMuDBusL0E6VTaKrUTDbyvvm
   yF0g5OyZOgtpnNrutqsVKRol3bEfC4jClyKwfxIkNO5fp17m/e3TLSViB
   WRFdyQTK0PK48RfxEvLUu5gT/wITdMK8q1lTtkOSs555oO83i0/u1gm+g
   yYPGYB1OqCXgFuLjLpKorTYyUPHHOIqccvdMXDle5TK+2P1n1xO9albz2
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="251664906"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="251664906"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 06:21:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="593655729"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga001.jf.intel.com with ESMTP; 21 Apr 2022 06:21:43 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        sfr@canb.auug.org.au, andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        linux-next@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 0/2] xsk: remove reduntant 'falltrough' attributes
Date:   Thu, 21 Apr 2022 15:21:24 +0200
Message-Id: <20220421132126.471515-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up to recently applied set [0] to fix the build
warnings:

error: attribute 'fallthrough' not preceding a case label or default
label [-Werror]

that Stephen has stumbled upon when merging bpf-next to linux-next.
Apologies for these leftovers.

Thanks,
Maciej

[0]: https://lore.kernel.org/bpf/20220413153015.453864-1-maciej.fijalkowski@intel.com/

Maciej Fijalkowski (2):
  ixgbe: xsk: get rid of redundant 'fallthrough'
  i40e: xsk: get rid of redundant 'fallthrough'

 drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 1 -
 2 files changed, 2 deletions(-)

-- 
2.27.0

