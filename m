Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02074613B7
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 12:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239556AbhK2LTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 06:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237081AbhK2LRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 06:17:03 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC41C0619D8
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 02:30:29 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id t5so69909094edd.0
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 02:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y/+vMn6bPWB3K6AvZrRajw9Y36sjPoNxVrEu1AarL/Q=;
        b=XB6Wf4kAAnde9wUZ4ttCjqVruZXc7hzBlULw0t3bqbBji3+ehVl4r51CjoPdMbFSZ2
         Df2FEezcAGX4WmO20rqkWLMft/Xa1l0Aizj/Gu/a+xEqxfw1fQPiWLWZVLmD1co87w0i
         j6rmVl9VGpqDfzNsk3Rpj0hqJbJWb7prZWeaw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y/+vMn6bPWB3K6AvZrRajw9Y36sjPoNxVrEu1AarL/Q=;
        b=yJAHFIe6ke5b8Qz1QEHNVNbkZA6DtR0Kckr9W2fZ9SDXzg+Srwc0cs1RSOHJ0wTTu7
         oRaoD0Si6EF5UsprB2TQBEBAR0vxQ4QA+x09mowSMGu1jeHTvUFC584nrKSqljpvdCy3
         0Gl7K6C/+tBttTQqq9MtBRqcaQPef63SDZfJ7JdxdPmaOt2zDU26T7YU97n823A1gcJe
         8ssi3AljWbDNDlvFeYO2nmrF268ZHNFJte2I3xQ7+LBNRSbjENHWYPpKmFykCqNGCIU6
         otJhgXGm9Er8z87Bm2cDSk7U2Rjtuthg1NgF+VgswGPxB/o0qrjnTLlGyS/SehzyUQWs
         jwCQ==
X-Gm-Message-State: AOAM5323Q9G2zeC7RCxV6mfter/ysrj73uuRDsbVql0hRAwYTM+XVM4e
        q2VSPCOGT6VeN+fQIm5R42rj91VA8PrJ5+GL
X-Google-Smtp-Source: ABdhPJwyVoTBOPb4sTvoLkKLheERqOCCuJmW6wam0ReYl49EZXAeJ0il48Cl2WZyrFmq0B6TSEXy0A==
X-Received: by 2002:a17:906:dc8d:: with SMTP id cs13mr58469452ejc.109.1638181828052;
        Mon, 29 Nov 2021 02:30:28 -0800 (PST)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id cy26sm9008402edb.7.2021.11.29.02.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 02:30:27 -0800 (PST)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        vivien.didelot@gmail.com, hkallweit1@gmail.com,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net v2 2/3] net: dsa: rtl8365mb: fix garbled comment
Date:   Mon, 29 Nov 2021 11:30:18 +0100
Message-Id: <20211129103019.1997018-2-alvin@pqrs.dk>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211129103019.1997018-1-alvin@pqrs.dk>
References: <20211129103019.1997018-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/rtl8365mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

v2: no change

diff --git a/drivers/net/dsa/rtl8365mb.c b/drivers/net/dsa/rtl8365mb.c
index baaae97283c5..c52225d115d4 100644
--- a/drivers/net/dsa/rtl8365mb.c
+++ b/drivers/net/dsa/rtl8365mb.c
@@ -276,7 +276,7 @@
 		(RTL8365MB_PORT_ISOLATION_REG_BASE + (_physport))
 #define   RTL8365MB_PORT_ISOLATION_MASK			0x07FF
 
-/* MSTP port state registers - indexed by tree instancrSTI (tree ine */
+/* MSTP port state registers - indexed by tree instance */
 #define RTL8365MB_MSTI_CTRL_BASE			0x0A00
 #define RTL8365MB_MSTI_CTRL_REG(_msti, _physport) \
 		(RTL8365MB_MSTI_CTRL_BASE + ((_msti) << 1) + ((_physport) >> 3))
-- 
2.34.0

