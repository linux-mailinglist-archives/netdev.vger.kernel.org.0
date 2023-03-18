Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8C56BFBEE
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 18:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjCRRjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 13:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCRRjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 13:39:23 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80C71ABE1
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 10:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:Cc:To:Subject:From:Message-Id:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=EW6n/7TiO3BZ1/KOQcbwON/RWUDhm+9Hj2cU8uIwDxc=; b=BAEe2drzT/IpBIVxAChM1Q5mPH
        /ZGDIp4kHfxp8OZSndhTPlv25fJ9OexFnTnDlh4269qxq8SxwaZgpfD3NoPAr2iI9fUnplVY/IAZD
        6NGJMq4JIkNnl9HNSYu2uTZDRlD7SpXz2p+Bu5PBRp9b50XSipZ6H9fCJq++0M2ttdQqGbZTmO2XF
        fBB03m3g3InXKakHfEkxe5uVtZKryq8NdjO246pAKV6tiN5bMIU7Huchh5yDuq8dFQhBzWjJaEkPH
        e61O7illm2H0rs/x/8beq1mfmL9RfBP3QUgfBL0BLw1/B71X4mq9iWQ/aCg+wksqU1jJo+O5ND4pp
        +x/bM6BQ==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pdaWR-008xmw-OK; Sat, 18 Mar 2023 17:39:16 +0000
Message-Id: <cover.1679160765.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sat, 18 Mar 2023 10:32:45 -0700
Subject: [PATCH net v9 0/2] net/ps3_gelic_net: DMA related fixes
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Sat, 18 Mar 2023 17:39:15 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v9: Make rx_skb_size local to gelic_descr_prepare_rx.
v8: Add more cpu_to_be32 calls.
v7: Remove all cleanups, sync to spider net.
v6: Reworked and cleaned up patches.
v5: Some additional patch cleanups.
v4: More patch cleanups.
v3: Cleaned up patches as requested.

Geoff Levand (2):
  net/ps3_gelic_net: Fix RX sk_buff length
  net/ps3_gelic_net: Use dma_mapping_error

 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 41 +++++++++++---------
 drivers/net/ethernet/toshiba/ps3_gelic_net.h |  5 ++-
 2 files changed, 25 insertions(+), 21 deletions(-)

-- 
2.34.1

