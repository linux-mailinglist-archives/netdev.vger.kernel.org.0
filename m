Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F65022AFE
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 06:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbfETEtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 00:49:43 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37076 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfETEtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 00:49:42 -0400
Received: by mail-pg1-f194.google.com with SMTP id n27so3544728pgm.4;
        Sun, 19 May 2019 21:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WJihdVFCj9zt/y+fV9fLCitQBlg5VsGOFzdBpJHqCRo=;
        b=ouoKv7LNcMyq2ltHkk3DL2nflGq0AqhsEGQumeCmva1L/yc53Yo3ck2s8UrfFrKXFj
         V6M7XYEk8Id+GBzU1NikD1lunrs/5ezWKO3Mamll1PxF21OL79W7LQYW7xL1JaVBuk4l
         zp+UzZsEUQiuU1f4+6Mg9Py276hVMIzbtLTM/CnpBAe+BcBwOPEmbMQTOiz5grhT5UIO
         keLrlaHnnEs7SlvIf0Rxz40gjp+CDW+W0LjxbNAsvahh8gDzQ34RFx59ZYJhB4O3jfrA
         NCs6OJR80bWfQaAWXJKC3/yDJuC7E13w+HyxflOEom6AVSIVEjYpSAPm+Lfrr3PQJ0sP
         zBGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WJihdVFCj9zt/y+fV9fLCitQBlg5VsGOFzdBpJHqCRo=;
        b=HKwB+d0mzed8mcJL86Bg//4yezQcketqP7aC5Hy7jgUUEU2kwvy/9C4gzJbwnZZJ5F
         eoFwMqQ2CakoZii8vhoU13Uf1eC+48CxvU/+MkqzbkAU/Si78j8JtpqVh36rBnRETiRe
         IVGtY1Ud7CmF4iFZKl77RXW/narPLY9iaeUOl+mrSgCoiydG1ZVh1sPPWoEjjKVU8NTb
         iw1XDkMLi8gYtI4OrJPO6BCQKWQ1zvT/J/ZKsfbLnQqnRjS27v6ZPvqfkesiKdIJbVRF
         wueXbtgnO7jtVcQuxOTuAbMehZLN3wWpNH+Z+AlQPgOkXABJNkwI0eMJiplJp1k4ewba
         xsNg==
X-Gm-Message-State: APjAAAX1fYvwVRA6urApyINqQB8heGVkSycnK1X4RUUXubgqsltMqhgN
        sfiNIySGPevD2uV6SDz9qHw=
X-Google-Smtp-Source: APXvYqx4+UBOBzVSuBNUJtZCJhbOZtf34kjle0wDGrMECqiObWuiDM095Jc9S/P8S6POakDXJk2/qA==
X-Received: by 2002:aa7:8b57:: with SMTP id i23mr57252329pfd.54.1558327782123;
        Sun, 19 May 2019 21:49:42 -0700 (PDT)
Received: from localhost ([43.224.245.181])
        by smtp.gmail.com with ESMTPSA id y17sm17794720pfn.79.2019.05.19.21.49.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 May 2019 21:49:41 -0700 (PDT)
From:   Weitao Hou <houweitaoo@gmail.com>
To:     davem@davemloft.net, houweitaoo@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fddi: fix typos in code comments
Date:   Mon, 20 May 2019 12:49:38 +0800
Message-Id: <20190520044938.23158-1-houweitaoo@gmail.com>
X-Mailer: git-send-email 2.18.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix abord to abort

Signed-off-by: Weitao Hou <houweitaoo@gmail.com>
---
 drivers/net/fddi/skfp/hwmtm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/fddi/skfp/hwmtm.c b/drivers/net/fddi/skfp/hwmtm.c
index abbe309051d9..3d0f417e8586 100644
--- a/drivers/net/fddi/skfp/hwmtm.c
+++ b/drivers/net/fddi/skfp/hwmtm.c
@@ -1206,7 +1206,7 @@ void process_receive(struct s_smc *smc)
 		}
 		/*
 		 * SUPERNET 3 Bug: FORMAC delivers status words
-		 * of aborded frames to the BMU
+		 * of aborted frames to the BMU
 		 */
 		if (len <= 4) {
 			DB_RX(2, "Frame length = 0");
@@ -1343,7 +1343,7 @@ void process_receive(struct s_smc *smc)
 				break ;
 			default :
 				/*
-				 * unknown FC abord the frame
+				 * unknown FC abort the frame
 				 */
 				DB_RX(2, "unknown FC error");
 				smt_free_mbuf(smc,mb) ;
-- 
2.18.0

