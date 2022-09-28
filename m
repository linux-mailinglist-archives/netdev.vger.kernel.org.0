Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E0B5EE8B5
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 23:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbiI1VzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 17:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbiI1Vyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 17:54:43 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8FF219B;
        Wed, 28 Sep 2022 14:54:42 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id bq9so21782925wrb.4;
        Wed, 28 Sep 2022 14:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=CKa2zfuYvT6LOzaaLAsgRC9dlcWDXJe/7p1IdjAyr8E=;
        b=kEbhFWc+NkQemJ8VWiryQHBDTc+57yXQWoIt8aqDZ+djNOyIZE1cKt8e6drPAZL11K
         xHoiJNYRgboK0WTs5iEkM2qTMmg2zGHUsNlQVwWvmi36QndSdmDhM5lsIWBv9epjn6k9
         VChIiz64NuxkS0euR/A6MUwscMzRna0SjBnKw0XnJ1pJeZKqKOzO1kwvq6ZJ2h/imMf2
         zZHrYQGLlLd4qZ27xo5OL2Mp94kEhnBIMlpwXQY4mGhh+jdXnRGDH6eERdrzLWPiBTsv
         tAS1j408EhdDBS/OL93rKwOEcBlodzr9dvAIOxKUqNFpzG1uvTgDCD94XbR4Pi/bR5Ca
         L43A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=CKa2zfuYvT6LOzaaLAsgRC9dlcWDXJe/7p1IdjAyr8E=;
        b=dLi+D6HZzJBH52X1KzDZg+KWfnZ7beTwbhLFOsil5rwah7bCqgFpbvD4OXqf2VKwPY
         aUWs0xrU+9IE8unfESQ4YcIikCtEuP3CdQi0xkc5gMQ4nybEzlPYoNxM7an8Ose8LytF
         vH6ZqRh8Fsqh/XZ6nJF3Oom5FMmgy+o4L6WgNUJ2Cmf1wIqliAenJRPoKCrEi83uyL8Z
         G1nHTcetthTndoHa1CsMXo6989L2582NPw12xDVKUBIKq/t6UAHDDEX7Y7j435BhI4mL
         5lV3Q7+AwFURLnoUac9MF5GaP1A5X6DVxtb8jznZ83h2mASAjfxBAVcoDdHmFAAAn6i+
         dWgQ==
X-Gm-Message-State: ACrzQf3L0tIYekojez3q1HTmLXWaZT9tOp/uaK0xzu5Z4qaXJU3U0pug
        LJwsdF0bkYe91UgHFKTgZfY=
X-Google-Smtp-Source: AMsMyM6dtN1fo3Ta/Ms6G6asBfg0HUDlyUNoNan/kA+NNO9UyF/NDUwPjHly97fMJeJFKkXRCxxADQ==
X-Received: by 2002:adf:fe08:0:b0:22b:311:afcd with SMTP id n8-20020adffe08000000b0022b0311afcdmr22378891wrr.629.1664402081030;
        Wed, 28 Sep 2022 14:54:41 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id r7-20020adfda47000000b0021e51c039c5sm5053071wrl.80.2022.09.28.14.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 14:54:40 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: bna: Fix spelling mistake "muliple" -> "multiple"
Date:   Wed, 28 Sep 2022 22:54:39 +0100
Message-Id: <20220928215439.65962-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a literal string in the array
bnad_net_stats_strings. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
index 5d2c68ee1ea9..df10edff5603 100644
--- a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
+++ b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
@@ -114,7 +114,7 @@ static const char *bnad_net_stats_strings[] = {
 	"mac_tx_deferral",
 	"mac_tx_excessive_deferral",
 	"mac_tx_single_collision",
-	"mac_tx_muliple_collision",
+	"mac_tx_multiple_collision",
 	"mac_tx_late_collision",
 	"mac_tx_excessive_collision",
 	"mac_tx_total_collision",
-- 
2.37.1

