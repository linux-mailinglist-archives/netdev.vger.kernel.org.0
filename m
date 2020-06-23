Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C5620543A
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 16:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732841AbgFWONI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 10:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732657AbgFWONH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 10:13:07 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21C9C061573;
        Tue, 23 Jun 2020 07:13:07 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y17so9171675plb.8;
        Tue, 23 Jun 2020 07:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kv/flmJxdITY06izPrpUM9DznPPretUt7mFM0eDenMQ=;
        b=bw86Y+sySkSfKdSRCx035M1Vp/ZVqfcWzUmz5PNcWw9I6HAGgdpn1cyxRWTKwCxeia
         6qgvqsGl87J7csGPxBJ2GqP3IdftZ0wk5JyVp+2h6YmHRS/uDH9MflYv6r+IWv32JAOo
         h2v3sspify5L+zezH3mtqT93bbvlfccE4a1Mf1VXpug5z3+Z35L7elgCbckVXZqx1ayD
         f9wiPZf2bO7KkCb/YIcFjouKS8rxJWhgyG79ewdW7KacDbrdbvAMK7Yl0zgDLfy/yFFj
         Ncv767ZZIN++BBU2JcIgz+CaMt8Q2yRbAe5K8oMBp8r6S3kDfz7G9SsauzYNJWE0yPSP
         kUVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kv/flmJxdITY06izPrpUM9DznPPretUt7mFM0eDenMQ=;
        b=RTS3n9bq0NG5c38bQpqRukv84OAn3r2ewku8VceZBxSCmhIadfw6nu4bectW17V+ZY
         05AUMQgmb6C/zazBlQ6908l85az3x2KavLKws+sfblvOdoO5hSspqlkg2VF4BLqSrhrg
         WUKF9cyW5GQV5gUoshT9uuQbETVURGBcFIgEWHK6SYBLiOKw12RZyUMH+u1cwEczhk5W
         GBNlvqe8t003gaacadB/C21wJdYJR78ldIbZXINF/22Xjs3/Q/HxSaXs1Y84tUIn7shc
         k5VcvLoNj/utUQ8IgDAWbO8EdkpjsUpBR+d5PF6jVkcs0jq6YJqAxELpSq606FAk5wDo
         3uBA==
X-Gm-Message-State: AOAM530MuyVUgP1GAHOSEdLtDrInxkdMkYGLqpARWnMd06dzu+oK0wgy
        vzoF1Lpyn4YHAN+QuncARhc=
X-Google-Smtp-Source: ABdhPJzuqJMlCo835PZD5abF8+zRIUHR1K4a7VPz2K3X+TQ81eo4NLWVzjkNhKWjRqWWM4Xp1aIvNg==
X-Received: by 2002:a17:90b:2042:: with SMTP id ji2mr24047010pjb.68.1592921587080;
        Tue, 23 Jun 2020 07:13:07 -0700 (PDT)
Received: from masabert (i118-21-156-233.s30.a048.ap.plala.or.jp. [118.21.156.233])
        by smtp.gmail.com with ESMTPSA id 25sm17083203pfi.7.2020.06.23.07.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 07:13:06 -0700 (PDT)
Received: by masabert (Postfix, from userid 1000)
        id CF0CE236023F; Tue, 23 Jun 2020 23:13:04 +0900 (JST)
From:   Masanari Iida <standby24x7@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, idosch@mellanox.com, jiri@mellanox.com
Cc:     Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH net-next] mlxsw: spectrum_dcb: Fix a spelling typo in spectrum_dcb.c
Date:   Tue, 23 Jun 2020 23:13:01 +0900
Message-Id: <20200623141301.168413-1-standby24x7@gmail.com>
X-Mailer: git-send-email 2.27.0.139.gc9c318d6bf26
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a spelling typo in spectrum_dcb.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index 49a72a8f1f57..f8e3d635b9e2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -138,7 +138,7 @@ static int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	err = mlxsw_sp_port_pg_destroy(mlxsw_sp_port, my_ets->prio_tc,
 				       ets->prio_tc);
 	if (err)
-		netdev_warn(dev, "Failed to remove ununsed PGs\n");
+		netdev_warn(dev, "Failed to remove unused PGs\n");
 
 	return 0;
 
-- 
2.27.0.139.gc9c318d6bf26

