Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCDB660FC1
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 16:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbjAGPB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 10:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbjAGPBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 10:01:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C689A61443;
        Sat,  7 Jan 2023 07:01:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71A9EB81913;
        Sat,  7 Jan 2023 15:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995D7C433EF;
        Sat,  7 Jan 2023 15:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673103668;
        bh=1N4qUATX9JRex5hZQtihEei+C+P46WN8C/vJ/eXH0n8=;
        h=From:To:Cc:Subject:Date:From;
        b=UhBNcTlXO5liRKqWrNuFIhsUlc80ucvZPcAzGbgOI9KENU8OGR0diRqhcpTzt9Xcz
         SoP8wAxjJO+Sz15YBiNjgdjUUbt+D1loZc3I6KHNzSdQfUrfqsAWod9/jGklD8cy3X
         QLJ2hCRo8AalA9POx1c7W+oWU7M8tMZ33dFRBJCc5JYycFA6gY/glsWrOeqyDNhVKl
         pNw5NAiG+gu9f+jeHyskUjzIJ45W5CilLK5v3Bd5kZpOEAQIuimtg65+oksvW72PX8
         /LeeC+qrrjgc/nxMFJnJGVWn+a1ZynB9Co4aBR/IZveYJBzaF/oew7ka13BD4bvcWZ
         3qAj6VL9t0RgA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org
Subject: [PATCH 0/4] mt76: add wed reset callbacks
Date:   Sat,  7 Jan 2023 16:00:35 +0100
Message-Id: <cover.1673103214.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce Wireless Ethernet Dispatcher reset callbacks in order to complete
reset requested by ethernet NIC.

This patch is based on the following mtk_eth_soc series:
https://lore.kernel.org/netdev/cover.1673102767.git.lorenzo@kernel.org/T/#m830c78ce34a4383ae1dedc5349bed19a74dbf4af

Lorenzo Bianconi (2):
  wifi: mt76: mt7915: add mt7915 wed reset callbacks
  wifi: mt76: mt7915: complete wed reset support

Sujuan Chen (2):
  wifi: mt76: dma: add reset to mt76_dma_wed_setup signature
  wifi: mt76: dma: reset wed queues in mt76_dma_rx_reset

 drivers/net/wireless/mediatek/mt76/dma.c      | 27 +++++++----
 drivers/net/wireless/mediatek/mt76/dma.h      |  1 +
 drivers/net/wireless/mediatek/mt76/mt76.h     |  3 ++
 .../net/wireless/mediatek/mt76/mt7915/dma.c   | 45 ++++++++++++++++---
 .../net/wireless/mediatek/mt76/mt7915/mac.c   |  6 +++
 .../net/wireless/mediatek/mt76/mt7915/mmio.c  | 42 +++++++++++++++++
 6 files changed, 111 insertions(+), 13 deletions(-)

-- 
2.39.0

