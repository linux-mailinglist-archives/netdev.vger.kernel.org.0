Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BC06A2D28
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 03:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjBZCZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 21:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBZCZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 21:25:52 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CA25BB9
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 18:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:To:Subject:From:Message-Id:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=O1GBuxD8LszEWnq+GrTBNyGMMFdklpIaFoSfgy+bfVU=; b=WHM6bqgtjNniU99XXx9cPw1LRa
        muCY5QgDWzmbuGqiTPDNSze57Xq8STWhWDuNfytginN9ZExtP8mfTy3HAv/eJshfGRDE/jSnMGSze
        LrTV1p0DU/QqQuM7LCulTcayFBnkqeD59sbj6DfSWSqEqHlp+/4DxLPWa1yrQhZTXqFgATl6HhLrf
        6l9pOps77/6yhBo9ufbojl0A95rxay55g0yj7OEbFw0PGo14bWxXqlXRbedtzUz/5Yhs5Ki9TN1Jv
        mdqzvR4LQdnPqhts+8JOmqSPwbtjGrIUrzCTZJik0jIoq1edfJAlwjvIFK+3dW/cVlyglJm5fL1ju
        wf0rWF2Q==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pW6jO-005Uik-EW; Sun, 26 Feb 2023 02:25:42 +0000
Message-Id: <cover.1677377639.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sat, 25 Feb 2023 18:13:59 -0800
Subject: [PATCH net v6 0/2] net/ps3_gelic_net: DMA related fixes
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Sun, 26 Feb 2023 02:25:42 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v6: Reworked and cleaned up patches.
v5: Some additional patch cleanups.
v4: More patch cleanups.
v3: Cleaned up patches as requested.

Geoff Levand (2):
  net/ps3_gelic_net: Fix RX sk_buff length
  net/ps3_gelic_net: Use dma_mapping_error

 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 103 ++++++++++---------
 drivers/net/ethernet/toshiba/ps3_gelic_net.h |   2 +-
 2 files changed, 58 insertions(+), 47 deletions(-)

-- 
2.34.1

