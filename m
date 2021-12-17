Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBA7478677
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 09:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhLQIsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 03:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbhLQIse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 03:48:34 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FAFC061574;
        Fri, 17 Dec 2021 00:48:34 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id j17so1924364qtx.2;
        Fri, 17 Dec 2021 00:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bE4XJY/cU2Uh/WZZUlAnTe6lzAEixS41+9wWGwhPPdk=;
        b=W3/FPdDwOzjE8v7k+4CL/FftB7fwSq4WjG0gv4QScV3wtw34nalrf2d/YS9y3A9Gmf
         +v8DBhQ5qSHwRFJYng938g5I8R+dgseLrzMTfx3ksAP2W0omrp43RfLFUGBU8EpIB2Rt
         iKKPWkiMtEbuYRfzTmqaLXRt1Hhhs4pWt3w+vGp5rgdQI6VkDIbuKkc9lx3RJfQu2LQl
         I0lRMmcfBxDKmNSN3FeE9G4FKODORVNeJ6UP37u9AduNpXYu2tQ1kEX3KSL/m8h0gGnQ
         8o3jjceIPyhtgS8/89wp9TWjMyU1AKsU/n8EVJ3uMMB0qOJSG+GZw1uKT2i7HYVT5KVj
         s/LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bE4XJY/cU2Uh/WZZUlAnTe6lzAEixS41+9wWGwhPPdk=;
        b=tgz2JcJuaSYeszSow/DdEaICJ0BayGI1iRuiTmNx0TNnJMSK6fxRfae236+vqacZRm
         7ihlEn2oJ6wDx9m9YG6MTp+7RuAVsO/mSagnP4k1c36XD4YMyy3RfaL/RUVG7Gz/Ehww
         98EMxdEUgNhYkd2dhf0VXKOi8wfk2btz38DBqtPwxgjsgS1tBpWWlYXhVhtGeqgHA5N0
         D+/l41Kk7jT8sw4rSetod7QYCnizm4P5I0e1KTaCippFCfr6bnaWQflLzADTrqFQ75LP
         OQPDoCn7glHKDKzbSmHf0OFB8SMImiV9jV+wvWZI41L/qtBok73p1sAqU9k4g8QEg4uk
         MQzQ==
X-Gm-Message-State: AOAM530hsiq0eB4Qmx4wFlXS3zzdtgy+dxzmV90c58BTsxcoopD+r4of
        +m1HSu2SwR6DQt28VSH3bqs=
X-Google-Smtp-Source: ABdhPJw7hmMXJr0e0KGODaJWd6bBR02VJK7qw3qlxzcjNZisFF1+RuYKbaqlK57uJZX5zZTiujrsoQ==
X-Received: by 2002:a05:622a:1828:: with SMTP id t40mr1472840qtc.0.1639730913667;
        Fri, 17 Dec 2021 00:48:33 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id i11sm4214021qko.116.2021.12.17.00.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 00:48:33 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, deng.changcheng@zte.com.cn,
        stefan.wahren@i2se.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: vertexcom: Remove unneeded semicolon
Date:   Fri, 17 Dec 2021 08:48:27 +0000
Message-Id: <20211217084827.452729-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Fix the following coccicheck review:
./drivers/net/ethernet/vertexcom/mse102x.c: 414: 2-3: Unneeded semicolon

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/net/ethernet/vertexcom/mse102x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/ethernet/vertexcom/mse102x.c
index a3c2426e5597..89a31783fbb4 100644
--- a/drivers/net/ethernet/vertexcom/mse102x.c
+++ b/drivers/net/ethernet/vertexcom/mse102x.c
@@ -411,7 +411,7 @@ static int mse102x_tx_pkt_spi(struct mse102x_net *mse, struct sk_buff *txb,
 		} else {
 			msleep(20);
 		}
-	};
+	}
 
 	ret = mse102x_tx_frame_spi(mse, txb, pad);
 	if (ret)
-- 
2.25.1

