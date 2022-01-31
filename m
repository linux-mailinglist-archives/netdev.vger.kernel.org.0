Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08ABD4A3EC7
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 09:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345019AbiAaInX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 03:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344458AbiAaInU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 03:43:20 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34269C061714;
        Mon, 31 Jan 2022 00:43:20 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id c190-20020a1c9ac7000000b0035081bc722dso8793510wme.5;
        Mon, 31 Jan 2022 00:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qi/zABG7gb+Ye7V/MnSI6gU9BC7CUhBAHbHLsfakjjg=;
        b=ilm+gX1nWIdPMtjzH4LqVjrzofZ696k8Ch3KNgYXZKsWOwDCQliegGhpCKO2KtUlI1
         w8mEhQFXfpPBy1U8LHO+wUpJ8Kg5aQ0Uz25gOjpOYezx9RU4rRNp6E6LHFZPQHE4ex8E
         ECSs5dRtIR6oo06ArkejwMwzqFvza6d8gmenHBOQCHYU/+3+Q2frrRXKH820dspOD5yz
         BQmSm0E/rVkfBXh+5U+UVRqpQdhdIC+VMkPdc9od71bmjUDKEA17RXrshciYIKOAKVYR
         W9yWnWKJ4GGqzkqVOiW/ShdECI85UdS/7q166dF8//izRTORCSOWNAITEaR0fUHNcx+C
         BpnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qi/zABG7gb+Ye7V/MnSI6gU9BC7CUhBAHbHLsfakjjg=;
        b=qS20DZuZC4a1KV8aqgR6yP19IXv9r/oiOIH0xB5Zf4H6cpVHa9SGdkE372FuwXkoFy
         tkkWun5d3wSIzS36ijtvVzOrkZYJi7qRHSq3fIepBLpSTHlSPa4Jy0Q/amZCqQNAKrgQ
         NDtfI69yGNga1HVXz87SvPErq6mtLp7xP9xUkpcFezw7eKnzxC2/6ThB7eu2nf5Ooh2n
         lxf/LJDm4lDWHB3Xzdeg5IZjoOZvzl5IcvUMdPvtyS0QfSglg8zzgdD/DvxC3rm5TTF/
         efNwH0cjLHytuQQbCPWecB7uWKEEsCA50wu1q7GGO/zlTnHBxlejqc7VsWm/QINUzdNi
         x78Q==
X-Gm-Message-State: AOAM533e6myjUqYaWyJJSs7RKhsRROwlzyDGG191w9PBs50+nfJ6ZXxo
        BhktLP62dxYdmTOFtwbE9ZQ=
X-Google-Smtp-Source: ABdhPJzHvE1IQ6rmKoRZ07ClcR/2PZ+8R8gDBkyt60+ezc0zvMeoI+wS/4xKMMpqZzZ70aREXPwukg==
X-Received: by 2002:a1c:1dd2:: with SMTP id d201mr17530355wmd.141.1643618598742;
        Mon, 31 Jan 2022 00:43:18 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id n15sm13421102wrf.37.2022.01.31.00.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 00:43:18 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/mlx5e: Fix spelling mistake "supoported" -> "supported"
Date:   Mon, 31 Jan 2022 08:43:17 +0000
Message-Id: <20220131084317.8058-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a NL_SET_ERR_MSG_MOD error
message.  Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
index 85f0cb88127f..9fb1a9a8bc02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -21,7 +21,7 @@ tc_act_can_offload_ct(struct mlx5e_tc_act_parse_state *parse_state,
 	}
 
 	if (parse_state->ct && !clear_action) {
-		NL_SET_ERR_MSG_MOD(extack, "Multiple CT actions are not supoported");
+		NL_SET_ERR_MSG_MOD(extack, "Multiple CT actions are not supported");
 		return false;
 	}
 
-- 
2.34.1

