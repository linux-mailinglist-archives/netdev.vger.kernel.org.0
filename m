Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072324FAA44
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 20:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243023AbiDISl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 14:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243027AbiDISl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 14:41:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4992B4B00
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 11:39:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BF92B80B2A
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 18:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0EEC385A4;
        Sat,  9 Apr 2022 18:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649529585;
        bh=kEgNdLeRVgpxFusA78BLAjFOH7WrFGAx+icLqpz3zEM=;
        h=From:To:Cc:Subject:Date:From;
        b=cFBQNxnV1mBpd7UXk1aRdZt6MMSQA/+D7YMx0IeDCIBTnHg+75Tj9Z44++2PydG6I
         2G8p6fA1dhvpAFVoCaTjo8+4eaU4dSmdg9TwxTaQxC4YhifNUiIqpUqqlBGNPhZXK7
         15OAD5F4I16h0W/slIYPgp7t0TfAn85bupSp9rYqo0JQvoJGLHDa7pkDo5yxTZDbrw
         s+4nc/9sUX7ssWKkv9PRO9EpPkwR+Gl2Lh8s971cbsXp+iNGc7zVNyWve1rcM7U88C
         QVPNqRrm81uDGs5hgrjiSoRS7CRU6Kn5WxTb/NolA0KzrwLdwyLsy8qbCI1LfuiruI
         yU7YFzN3GAwEA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        linux@armlinux.org.uk, jbrouer@redhat.com,
        ilias.apalodimas@linaro.org, jdamato@fastly.com, andrew@lunn.ch
Subject: [PATCH v3 net-next 0/2] net: mvneta: add support for page_pool_get_stats
Date:   Sat,  9 Apr 2022 20:39:09 +0200
Message-Id: <cover.1649528984.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce page_pool stats ethtool APIs in order to avoid driver duplicated
code.

Changes since v2:
- remove enum list of page_pool stats in page_pool.h
- remove leftover change in mvneta.c for ethtool_stats array allocation

Changes since v1:
- move stats accounting to page_pool code
- move stats string management to page_pool code

Lorenzo Bianconi (2):
  net: page_pool: introduce ethtool stats
  net: mvneta: add support for page_pool_get_stats

 drivers/net/ethernet/marvell/Kconfig  |  1 +
 drivers/net/ethernet/marvell/mvneta.c | 20 ++++++++-
 include/net/page_pool.h               |  4 ++
 net/core/page_pool.c                  | 64 ++++++++++++++++++++++++++-
 4 files changed, 87 insertions(+), 2 deletions(-)

-- 
2.35.1

