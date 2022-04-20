Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAC850863E
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 12:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377691AbiDTKs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 06:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377689AbiDTKsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 06:48:55 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EA11ADB5
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 03:46:05 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id u18so1738378eda.3
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 03:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5OVcjGSiJ+nlq65WcsbONfbpSCZlHZow1k2gE+HwcCo=;
        b=pldrgPUIn2R72Z4tJz+rlp+UluL86LT0jyZUo9kf++27hTM0pzPgHXY+I0M40I9NY+
         eXHUPwO7vQ/zVAdxzXO9RKovW5dOXy0S5vgPrJugzugD/sq0a2wj43vGseINag5cVdUp
         buPuCcPXISqc1w3yzNrwnzmOwhtZ0oLxlWmhbyJfxD8UXXjuKPksUTMSoVw5W80s0IQg
         bVQSOTj2RWia9S9xt0eVOxCzR9YWNhIAy7RyNMVAdlrNb1+wXoVQFsKqBO+PyXd6PNNq
         Eyk0d+inH3oMBNt0rtRAWn9mTvYqYFsYPUvCQfVRZVk4jEt03BzBm1WDPSE9X25GU3F7
         y5Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5OVcjGSiJ+nlq65WcsbONfbpSCZlHZow1k2gE+HwcCo=;
        b=EREwH3dlpPG7Br6S1b8lxWWe5jih5sYOEXuE17hxh91XQibjWO8yPt+5qpn6gUlVHA
         +ahi7hSNEnH3roCnJmj3PKRCyAuezBsUtgKL9I6BRUbXFWSFhIRmQumo64r95ezIHFZy
         agqJQYfTpkL1CPzwpuIoQ6W25am/DSubsBFiPJsXf4qIcrPD5lNJx6eJplGI9xrwftA3
         TF/Vg8ptFmixjsN+KYciDMUIu9eUQBN3ph1gMXyImxAWcHhdDTlYtQ4r+0ubt6jicmpd
         yL7NEOoc8THgGcieVzQFSAe8NRqUWQNedUM7/T5VaBnNkVhbMRvUdcgZWH7mEOU7/1bf
         gaTw==
X-Gm-Message-State: AOAM533jlATmSL/j0MGMqi3jrU3zWTsP8itQnPXt3djM8vK2CS3R3O/k
        4RWoHdfwoi9QFIHtlMOh6sx8EA==
X-Google-Smtp-Source: ABdhPJw/4gOK7xeclDA9097uwkEU8w5LJ7LCVdGl20UroQC9SxTNcI8HyNfFl0xGksOd2Y3YCOPhbQ==
X-Received: by 2002:aa7:d059:0:b0:41d:76b4:bcc1 with SMTP id n25-20020aa7d059000000b0041d76b4bcc1mr22299244edo.389.1650451563871;
        Wed, 20 Apr 2022 03:46:03 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id mv12-20020a170907838c00b006e87c0247f4sm6529912ejc.186.2022.04.20.03.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 03:46:03 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: MAINTAINERS: add Bug entry
Date:   Wed, 20 Apr 2022 12:46:01 +0200
Message-Id: <20220420104601.106540-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a Bug section, indicating preferred mailing method for bug reports,
to NFC Subsystem entry.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2d746723306a..1786cbdd43a2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13842,6 +13842,7 @@ M:	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
 L:	linux-nfc@lists.01.org (subscribers-only)
 L:	netdev@vger.kernel.org
 S:	Maintained
+B:	mailto:linux-nfc@lists.01.org
 F:	Documentation/devicetree/bindings/net/nfc/
 F:	drivers/nfc/
 F:	include/linux/platform_data/nfcmrvl.h
-- 
2.32.0

