Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C6C52AC19
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 21:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352812AbiEQTlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 15:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352800AbiEQTky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 15:40:54 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BEC658E;
        Tue, 17 May 2022 12:40:51 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id fd25so244667edb.3;
        Tue, 17 May 2022 12:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lFebp8GWm+E9ZaauBpIgSO5O2fr4/WEc+bz5v/1+8xY=;
        b=aSlm6sFNppPd7mY8twJg7ZgB184RbTToOakF+zNn9NUhHKmAhEE7Fr8lMJtCbZav+n
         wXwPoTGF8DPLcRIj7vcPqLYEF/EYJ4l+VS1/B8XxIJ2cCesB6XK7uO+CyggGB2wu+wSg
         /amgYedGTjSKM8JAhzSdWjVVuLLu1D7fYoxUtvNWhwW95nQDCfmaGFM26P2kS1Jag0ws
         DlElO+Rap9Wxdlegoe5Imrv69ODZ3w5XvFe8/t+wnNYSNFamj96N3O5hV94HOzs29QQ1
         MYVJft9UpbxKvW+ViVUywX6jdKxTo78NkiNrcTVyKxKLEIsdIHxxGtOpcv2gEdh0csHr
         PJcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lFebp8GWm+E9ZaauBpIgSO5O2fr4/WEc+bz5v/1+8xY=;
        b=vyrldxf4OENKnAT/PqwhdsxujeIBOhXazSh/vGz7U9Z7uLC6GcZAzi3ysbrcnniFGQ
         2k7ktVY214AOl0i8grJYTgavLi3pTP5aeXvC2nHw7bKTR5dt/ovayZsjz3j3fle89sqm
         6McIWa4J9QLJPU18x83yH/+cV+k9lWAU2l0Gkskkeq5xgI7zD0lpf48hLQmXxUNp+84j
         1/a/jf1+WI1CapP6rG+3FIIOpLWsE3alxCIvuQJJpfhw8zYVUJwJnzHwWQm8j+1f3KUs
         fzUbR5TUsOAi9GYpor9EOGq7+ZU6dq6iDeihzWP44MJQL+EGAkW0xrN88QFqhyQvDEfA
         btGw==
X-Gm-Message-State: AOAM531f4qdEegOLRRaFPajaAbYlxIukuAeAj++OsWprtMNKWe/UMXuH
        kvkWH0j+6y51XvjPNVT2s0yUte7CBSk=
X-Google-Smtp-Source: ABdhPJwVCd1Pp0u2Tmuxwr6j74apRR4jprZ/PyUfUQg9k4JUa5pJkWIIVZVHzWePXn2UkWvEphcZlg==
X-Received: by 2002:a05:6402:294e:b0:425:f016:24e7 with SMTP id ed14-20020a056402294e00b00425f01624e7mr20767419edb.111.1652816450081;
        Tue, 17 May 2022 12:40:50 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-118-074-246.95.118.pool.telefonica.de. [95.118.74.246])
        by smtp.googlemail.com with ESMTPSA id 25-20020a17090600d900b006fe0abb00f0sm40669eji.209.2022.05.17.12.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 12:40:49 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH net v1 2/2] net: dsa: lantiq_gswip: Fix typo in gswip_port_fdb_dump() error print
Date:   Tue, 17 May 2022 21:40:15 +0200
Message-Id: <20220517194015.1081632-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220517194015.1081632-1-martin.blumenstingl@googlemail.com>
References: <20220517194015.1081632-1-martin.blumenstingl@googlemail.com>
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

