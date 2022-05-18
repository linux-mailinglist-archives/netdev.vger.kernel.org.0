Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E0652C5EB
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiERWE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiERWEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:04:30 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA2160DB9;
        Wed, 18 May 2022 15:01:21 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id en5so4756776edb.1;
        Wed, 18 May 2022 15:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TmqwtlizUr2sOMbeBCwgOr1QbN75jzLqPx0CYdczOAI=;
        b=DIx6xAC8R9pmwYcP9r/UqGNcsCgx9bFGbfOXPt+A/XuOrB0c1o723rf+E//tB5fyew
         5lYMh75OaHjK9bV5sm1TeZd7gt24kuWAmcaBGiw/Jy4Isrv6fInL6Myu1Q9KxLVwuMWV
         Cm2IlxxWpxtVmiMbvc5+ldHc/7X2TBNYe3gmKzgUV6qB8qOe+M7i2YbJlHCuFGQOhcEp
         uetsZmogXZaZs0WdkJNyGfvCZALPjHLLBD7xLiIt3rx14nY74K7IipqDeqCd6S/A84Gq
         vgq20ZJ5nAfzUXP8esdhIs/Ck6gLmJbCo6+8Zqq0mJDSFV4lq05NGN6uqKZ1wMyYk0lH
         B0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TmqwtlizUr2sOMbeBCwgOr1QbN75jzLqPx0CYdczOAI=;
        b=zq1tpttaxX/pw3F1RkRcyFH+bvdB+bpy/oUGkKtjRdJ6b1OMP5MQGe//tHOkHNAJpC
         Mt7C3m3hMOxdl6kDuuP0alOb5GCSSkqDBcDs1b73zSTlFrRqAj+XkgaSSLdae4rLB1Sj
         DbSpwWWIm1dqqkpyvgrWp4t8OX8jObU3X3V66N6ADFVawMFiK1U4wKm6Y/CsDIARcn3m
         7Gxo5kghDinGA0baBoyn5P2syxY9TNYkYd1L9w304qCE2ID3bXbXQW1uzCYvlYx4kb4Y
         54gSb1DyCkjGKGpp5Nzozs7uZNkocEEptFiTE7vLo3k3Tz5qkF3lmiOgw8X+Y82vmRl9
         S3XQ==
X-Gm-Message-State: AOAM531bosLVMPyWxw+n1jMUno5yLreBSIvVIqCWhUgWZN+0whr7Arzt
        X/7LfrjEAvno+l6H6zbhFhBXSaF8apg=
X-Google-Smtp-Source: ABdhPJyYWDW/lvChgZV6/YWUcLmvFEhmTGcnIQqQbpefdlCnZ375o+H0GxUCj+SvCuh01nJA+pmKXA==
X-Received: by 2002:aa7:dad0:0:b0:42a:b250:f078 with SMTP id x16-20020aa7dad0000000b0042ab250f078mr1994958eds.21.1652911280086;
        Wed, 18 May 2022 15:01:20 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-118-099-170.95.118.pool.telefonica.de. [95.118.99.170])
        by smtp.googlemail.com with ESMTPSA id ot2-20020a170906ccc200b006f3ef214dd0sm1478885ejb.54.2022.05.18.15.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 15:01:19 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH net-next v2 2/2] net: dsa: lantiq_gswip: Fix typo in gswip_port_fdb_dump() error print
Date:   Thu, 19 May 2022 00:00:51 +0200
Message-Id: <20220518220051.1520023-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518220051.1520023-1-martin.blumenstingl@googlemail.com>
References: <20220518220051.1520023-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gswip_port_fdb_dump() reads the MAC bridge entries. The error message
should say "failed to read mac bridge entry". While here, also add the
index to the error print so humans can get to the cause of the problem
easier.

Fixes: 58c59ef9e930c4 ("net: dsa: lantiq: Add Forwarding Database access")
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/dsa/lantiq_gswip.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 0c313db23451..8af4def38a98 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1426,8 +1426,9 @@ static int gswip_port_fdb_dump(struct dsa_switch *ds, int port,
 
 		err = gswip_pce_table_entry_read(priv, &mac_bridge);
 		if (err) {
-			dev_err(priv->dev, "failed to write mac bridge: %d\n",
-				err);
+			dev_err(priv->dev,
+				"failed to read mac bridge entry %d: %d\n",
+				i, err);
 			return err;
 		}
 
-- 
2.36.1

