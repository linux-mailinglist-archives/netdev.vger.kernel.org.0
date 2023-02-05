Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9E868B219
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 23:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjBEWKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 17:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBEWKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 17:10:22 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6339D1ABD6
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 14:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:To:Subject:From:Message-Id:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=84rydIRhJqmdFtGolluZOMObLempJC8Mb0CxN3mTR28=; b=jSTX9M8NnQNsn7bNnHuJ+XvvJg
        6Qvkqj8RrduymXIUT/YFz7aPtrYbvxk6+mv3a1w8/C7/q7SEANM3ynuRzNAL8DdeU7/xcghaN1i94
        TlLrSV/jMKBZN6orpH6Mi6FspcJgpJHCT0HHJZwb3cpv+tPA4MgkTD0TP1F0EUOOntjgJIVwKiv1h
        19ctxBMC8nOz4oIvuBIgDdKpAx7sGOlkaEHBbUaLuItlzKBEGoHQFUzWW5EgNqa1jGVo/ucTV1xqI
        JsXO9LGXdM4wAvltsBHpHm+NH7Crh9TUjrBgYf0g0JJft/YY259lugYuhyVwl3PkzKcaGORYLXN+I
        m4MSrB1g==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pOnDE-002Okw-JE; Sun, 05 Feb 2023 22:10:16 +0000
Message-Id: <cover.1675632296.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sun, 5 Feb 2023 13:24:56 -0800
Subject: [PATCH net v4 0/2] net/ps3_gelic_net: DMA related fixes
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sun, 05 Feb 2023 22:10:16 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v4: More patch cleanups.
v3: Cleaned up patches as requested.

Geoff Levand (2):
  net/ps3_gelic_net: Fix RX sk_buff length
  net/ps3_gelic_net: Use dma_mapping_error

 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 102 +++++++++++--------
 1 file changed, 58 insertions(+), 44 deletions(-)

-- 
2.34.1

