Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B7358A096
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 20:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240019AbiHDSjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 14:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235406AbiHDSjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 14:39:48 -0400
Received: from mx02lb.world4you.com (mx02lb.world4you.com [81.19.149.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561A36A49D
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 11:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=v8pKhGLZkwz4ot3pJacuUK9BtMjczpd4O7Snhf7JjsA=; b=i/lz14l6PowS5+3kGRZJLaRXuk
        euDUKXT80Iax3HVwQ/lt20xTT2EYx10twW92miolaWDjLwqjd6qjuBBJ1q+oCpscwPb9MTuZYDz/z
        5WDpSVCxXyC5NlJgs8sPLwDdcg38CeLJeYyHlfTmm9CGUW2FmCcgTL+YnfeykLmWQh+8=;
Received: from [88.117.54.219] (helo=hornet.engleder.at)
        by mx02lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oJfky-0003IC-Qf; Thu, 04 Aug 2022 20:39:40 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 0/2] tsnep: Two fixes for the driver
Date:   Thu,  4 Aug 2022 20:39:33 +0200
Message-Id: <20220804183935.73763-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two simple bugfixes for tsnep driver.

Gerhard Engleder (2):
  tsnep: Fix unused warning for 'tsnep_of_match'
  tsnep: Fix tsnep_tx_unmap() error path usage

 drivers/net/ethernet/engleder/tsnep_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
2.30.2

