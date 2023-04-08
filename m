Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A683E6DBDD9
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 00:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjDHWdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 18:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDHWdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 18:33:46 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B6F7DA9
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 15:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:To:Subject:From:Message-Id:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=XKQ1wHxgFghimrbfn1xs6cant2ToSvUcp0jlVfegwI0=; b=uVP0UF5QueAXD6MR4XfROaAKHI
        PUXSheHSZq8ODD+ERxKr/hbIGhR7pvAFKs9qKk6Io36zx97smqyqD66xN4SUtVFkNN7heWNtWSl+H
        +KPzmLsCATndnCkFvrgvm0KTwhOHDFKO//uLxKN+2cLOCc/bUKLuxgCL36dZvX3GnrF4V9YyOqsz2
        ZrQQn4MCzq3RkFRSPpZA6R2zu3LlMFr+Am+pIJsiKI5aaWrrl3WuiY16cktfEqfer2PP6qIarD9AW
        7Pf1pE6Vmn4MGXLGtuWXo1JF7D11Ls24jdseQRWV6TMHtmg/gvlNt6EkIwuwT88uZiDMcIq7FVgC3
        LIpxDtYA==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1plH7i-00D6sB-AS; Sat, 08 Apr 2023 22:33:30 +0000
Message-Id: <cover.1680992691.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sat, 8 Apr 2023 15:24:51 -0700
Subject: [PATCH net-next v1 0/2] net/ps3_gelic_net: Driver cleanups
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
v1:     Add gelic_descr structures, use napi routines.
Date:   Sat, 08 Apr 2023 22:33:30 +0000
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geoff Levand (2):
  net/ps3_gelic_net: Add gelic_descr structures
  net/ps3_gelic_net: Use napi routines for RX SKB

 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 215 ++++++++++---------
 drivers/net/ethernet/toshiba/ps3_gelic_net.h |  28 ++-
 2 files changed, 132 insertions(+), 111 deletions(-)

-- 
2.34.1

