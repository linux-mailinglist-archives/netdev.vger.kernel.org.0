Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE23F6B611D
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 22:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjCKVrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 16:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCKVrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 16:47:04 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BBA64848
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 13:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:Cc:To:Subject:From:Message-Id:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=UobknoVjVhTQKQmwJRkippYo/sHiPpr2FU9cy0Sx/Sg=; b=nhEQwYgSDEGL9cssTdRsgQDaXy
        dnmTltqHS3ClJ6QEl4q8GOUZpEODH72BZT0Dotwcd7L2vDqOuSO7iVMOaF9wES1yKDuo5nWS7HLKx
        5GdKcwsaC8eywBja6Xt0fP02HH1N3//iJxivSTxdd2mRKas9YmyL4iKy6Tf0RdhQL9jlhlvpjLKZg
        RnN/v1p0oazHmlYK24dcGsu1m+TEjKj6Bt4CIhfVtKfB0EFBisA1MzRrGi16RK7HfNbK+QQ8z+rqw
        oUMoveHKkuES+RX7EMSnoyzjzq/yZKd3Fepfyf4HSNQwk4pxLDDTNMjTuwu0AI3Q5VpXR77kIMLNv
        UnJDNQIA==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pb73H-007lAH-A4; Sat, 11 Mar 2023 21:46:55 +0000
Message-Id: <cover.1678570942.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sat, 11 Mar 2023 13:42:22 -0800
Subject: [PATCH net v8 0/2] net/ps3_gelic_net: DMA related fixes
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Sat, 11 Mar 2023 21:46:55 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v8: Add more cpu_to_be32 calls.
v7: Remove all cleanups, sync to spider net.
v6: Reworked and cleaned up patches.
v5: Some additional patch cleanups.
v4: More patch cleanups.
v3: Cleaned up patches as requested.

Geoff Levand (2):
  net/ps3_gelic_net: Fix RX sk_buff length
  net/ps3_gelic_net: Use dma_mapping_error

 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 43 +++++++++++---------
 drivers/net/ethernet/toshiba/ps3_gelic_net.h |  5 ++-
 2 files changed, 27 insertions(+), 21 deletions(-)

-- 
2.34.1

