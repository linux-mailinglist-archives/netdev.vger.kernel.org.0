Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75754B698C
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 11:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiBOKjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 05:39:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236620AbiBOKjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 05:39:42 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4C78AE56;
        Tue, 15 Feb 2022 02:39:23 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id m126-20020a1ca384000000b0037bb8e379feso1131350wme.5;
        Tue, 15 Feb 2022 02:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dY2qoYSu/ufPuibmcjrwAakA38kBxe3PyTTX05JNu5M=;
        b=eGMVegXMtfU89YJ+2QMpOisJ6p4W2cZT3XH93Lp7B+TJumy3ZAjqHYNNGRnUZ/q1f3
         pgOU9izly1xmrxbx+jXIhJA6DmaFzqQIgCVCXb2ZEvQbwWPBxP/ZmHGgJoULZYmCjHVb
         i9Iv0gI7vQ+0yK7FawVx1j17jDDoBpjnkq9XLNqrbz3A2vUrlW6A8ohU9QfqBwWhDbhQ
         LF6D7xEp8FTvbmVYxSqhE78rBQ2IkZBKWCPn4jQ6I674z8Eza8KO8niaFKM9W+NnyGEV
         qOmwkCKpAL7361ue5KStQA5Ilk5ZEl1wMBbCY2y/Syb9UQo4TGjEPF2SC3jdZLoNrL6p
         fFRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dY2qoYSu/ufPuibmcjrwAakA38kBxe3PyTTX05JNu5M=;
        b=CuptPR3U/STox2lnfeBriEnJdQY5f5VUgWMFufTH2J18beEIDoFBeUZsHnp+XITL+z
         +HOX9uRrkvtEGKNI0SYbsME/P2EwWg3RxM+dcShzNZTS7tEnRfJXZG5gmCIrbl5RnY27
         k1hu+0kAHMTUAEhJAfbxgqsJ6tvLURzAiTBBpKLoF8O+0jydZ3itzzM3BvwJHQtqQUbF
         Nxojh4bVWf0fms1Grwkz688r4PEjZmNydKaWN1D9XfOGLSCXjP/xIu9S3DgpCJqtipgZ
         +FT9oZRYR4z7x8l1ZbhBti/4t+5RW+hLmfSUx6Q+zwgB/D+NFXEDhqlh1bHTABjcqWTl
         waUQ==
X-Gm-Message-State: AOAM530WKKy4qlI21U5DSTra4N7HD+y2hsSzkA3BKDVXby327lSLtzqh
        Axza05nw1sjXC/BMmz7vHVE=
X-Google-Smtp-Source: ABdhPJwudJ2tF7gx/s45232Z3eqIWAB37px39FLPN+n6UA9ntFJydj6DLcA/ypdW3+6RwfN9kX1J9A==
X-Received: by 2002:a7b:cdfa:: with SMTP id p26mr2547773wmj.109.1644921562324;
        Tue, 15 Feb 2022 02:39:22 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id j15sm11949254wmq.6.2022.02.15.02.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 02:39:21 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joseph CHAMG <josright123@gmail.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: dm9051: Fix spelling mistake "eror" -> "error"
Date:   Tue, 15 Feb 2022 10:39:20 +0000
Message-Id: <20220215103920.78380-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

There are spelling mistakes in debug messages. Fix them.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/davicom/dm9051.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/davicom/dm9051.c
index d2513c97f83e..a63d17e669a0 100644
--- a/drivers/net/ethernet/davicom/dm9051.c
+++ b/drivers/net/ethernet/davicom/dm9051.c
@@ -771,11 +771,11 @@ static int dm9051_loop_rx(struct board_info *db)
 
 			if (db->rxhdr.status & RSR_ERR_BITS) {
 				db->bc.status_err_counter++;
-				netdev_dbg(ndev, "check rxstatus-eror (%02x)\n",
+				netdev_dbg(ndev, "check rxstatus-error (%02x)\n",
 					   db->rxhdr.status);
 			} else {
 				db->bc.large_err_counter++;
-				netdev_dbg(ndev, "check rxlen large-eror (%d > %d)\n",
+				netdev_dbg(ndev, "check rxlen large-error (%d > %d)\n",
 					   rxlen, DM9051_PKT_MAX);
 			}
 			return dm9051_all_restart(db);
-- 
2.34.1

