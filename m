Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA55D64AF3D
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 06:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbiLMFOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 00:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234579AbiLMFN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 00:13:28 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B034E1DDFE;
        Mon, 12 Dec 2022 21:11:45 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 4so8476977plj.3;
        Mon, 12 Dec 2022 21:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LwZPE+ixT2k2OBQibKeLmRdzXURkNe3D9Ty8fpZHr2M=;
        b=m8DcwU7WzluG5z+267vrpLNN19jQwpgSbckSX6HSWvg3cGIYzZ7kDIPyFBjDD7XSj9
         G17mb9w277wpl43IL1tGx72ax56y2iZcvom2b07qyLoIgMwxqaUv8h8xjo1ZJ/0gfcMN
         ehWMqpMKZCtceGwSoQ2G81/DESlmuS/N8xEwzLn4X4sbixc99l+8uFhIgtRtSKDrN/4Y
         c4YTEmb/A+X5LzFG4J+gMyVX7TPScmRCvncK73RNIJjICDN7hBsUYoYJWdPpJjRyiWa7
         nHptMigKIERYgvx0WOv0czDUkYatzb7999dJvOpt7O0WxaKEMyuotCoyYf45+K4fLDHi
         nz8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LwZPE+ixT2k2OBQibKeLmRdzXURkNe3D9Ty8fpZHr2M=;
        b=02IVMx01muXZZXEmeJidUPO7UeNEpBlE/3/j1ScrAkRDzanQKWTwLmZc/POOpsXIKK
         M2YQqCMxl2xj5LMrCfLz08zRyVvgJx4qGZBH1iliTSy+XQcVCgalBz3T/WlSYU4N1VF1
         txQbQGusePG3C8jSMkWETunCfslG2PqG93JJ+TXYG9TWYpt6H1yaAwhqtsXk2gmdxbMn
         4ljou1hKQDprl+BF/LbJHD08SG7AwG9eDF3VpvLQ627Cqxb8rd4AnHK6zrdALJYFl/3G
         0Otdz8Ry2VZgJnQzyyI2eh3gtyJTatukVokvG6rBk0bzBIJgfRXP4JJf3alPITCMMv4V
         496A==
X-Gm-Message-State: ANoB5pm5rRYsiJ54npkNsisWH714KENTlRw4JDeb1YmsbIBbe7HeGqmh
        JlevslTMvQtfpuwCOCNVXg0=
X-Google-Smtp-Source: AA0mqf67WGWXHqik5hN/0CkZa6BVvXnQUx51wi9kkEEtXmV3IJiBcjUnx/anS+g6D5LlYfsxqCh89w==
X-Received: by 2002:a17:902:6905:b0:189:340c:20d2 with SMTP id j5-20020a170902690500b00189340c20d2mr20750728plk.23.1670908305149;
        Mon, 12 Dec 2022 21:11:45 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b001788ccecbf5sm7363346pla.31.2022.12.12.21.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 21:11:44 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: [PATCH] Documentation: devlink: add missing toc entry for etas_es58x devlink doc
Date:   Tue, 13 Dec 2022 14:11:36 +0900
Message-Id: <20221213051136.721887-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221213153708.4f38a7cf@canb.auug.org.au>
References: <20221213153708.4f38a7cf@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

toc entry is missing for etas_es58x devlink doc and triggers this warning:

  Documentation/networking/devlink/etas_es58x.rst: WARNING: document isn't included in any toctree

Add the missing toc entry.

Fixes: 9f63f96aac92 ("Documentation: devlink: add devlink documentation for the etas_es58x driver")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
Hi, sorry for forgetting the toc. Right now, I do not have access to a
build environment to test the fix. Because the fix seems easy, I take
the risk to send it as-is.

Thank you.
---
 Documentation/networking/devlink/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 4b653d040627..fee4d3968309 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -50,6 +50,7 @@ parameters, info versions, and other features it supports.
    :maxdepth: 1
 
    bnxt
+   etas_es58x
    hns3
    ionic
    ice
-- 
2.25.1

