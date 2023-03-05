Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BADB6AADCD
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 03:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjCECIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 21:08:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjCECIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 21:08:21 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E942713D53
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 18:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:Cc:To:Subject:From:Message-Id:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=oG9rSn/CQT16xefRi+gwVt/B5qgBSPzt4HeaU7/+sIg=; b=Rb1sSJ3+ZKKNbICvRnZ2/Gjrtv
        9bHdk4kXdZJUVby0lAPfcWsNelWoqcFNYYDPxDkFpqWV9ModkgkF2jtUEP5oRcwg2NONGlVQW8oR8
        k3/E9EHNE/sBydflgUVHifjY9Mv7eW5dGFl5jp+n4zGgfSPQbnTZ8O32biLyhKeAlx/W2CmsxIIQ8
        1wJaLKFegq+tDSDuMrMtHCG5NgbBlg1ag9BH0r8caFs+1aywpHZC849wYp/xml/CcajpBMifKTTxa
        pbtBcO+lDZWzQzVcnUX9Dm/wdO4a4okzd0+chebdoHF3eLCgLD6KUUvbZVHydluUFkt0cm2HUm1U/
        1LHJS7Xw==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pYdnE-006Wcy-Kl; Sun, 05 Mar 2023 02:08:08 +0000
Message-Id: <cover.1677981671.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sat, 4 Mar 2023 18:01:11 -0800
Subject: [PATCH net v7 0/2] net/ps3_gelic_net: DMA related fixes
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Sun, 05 Mar 2023 02:08:08 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v7: Remove all cleanups, sync to spider net.
v6: Reworked and cleaned up patches.
v5: Some additional patch cleanups.
v4: More patch cleanups.
v3: Cleaned up patches as requested.

Geoff Levand (2):
  net/ps3_gelic_net: Fix RX sk_buff length
  net/ps3_gelic_net: Use dma_mapping_error

 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 16 +++++++++-------
 drivers/net/ethernet/toshiba/ps3_gelic_net.h |  5 +++--
 2 files changed, 12 insertions(+), 9 deletions(-)

-- 
2.34.1

