Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F206C0B65
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 08:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCTHcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 03:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjCTHcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 03:32:09 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6466A72;
        Mon, 20 Mar 2023 00:32:08 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h8so42869572ede.8;
        Mon, 20 Mar 2023 00:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679297526;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eSP4f1i+3RtA+4+ZzZ6IcerHS6aivGE2efGzwbPIBWg=;
        b=Lg39NmLlMe4XyfiXUH9h1cRjUHHL56vlHfrCfXo4mq8zg8/peIyUPkwZ32aIczVlbb
         gfv9k4wiGbeMY+y2U9uFtNQqvdOqtUdT8o2DidXtLJCHA7xyiiMN/bjfbopD7YOTAfD1
         TGfX6eL29YdYq+0cqS3ZSg8PTz95AeyNyk+1Bgr6p7SOmkMG6jGfAk5Qf+QMW8vlNa/L
         sSRvohZRwOpy9MGaL32nCnuw/j0i0omjJblWxdPNzW74Tuiba6XnkNdh4r4qlj92UpTw
         rKxJvMuZCIUPinPXF/+RtfXI/+KUme3yvOdKAeos3y7KryWhw8+Sg4rWH3u8bNKRJGnl
         Ne2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679297526;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eSP4f1i+3RtA+4+ZzZ6IcerHS6aivGE2efGzwbPIBWg=;
        b=bVB5BLRT+ulnqQFmN9FvfzZDZhVi6wT/DrVDYeO/BUhsEimx2zefHCPNW4/9SzOVkZ
         p9vm0lAa1KeVr/ehKLSAkWEw2q31EOUmgYo1r/dftUXbE+H08mBawahr+u0aXN1zAljx
         nT5vsQ6dYyBrH32WKRHaCgG24XEEa0coj9/IHvgEZ7fMxWf1M6b7zEpXq0ZIDSfnl+Wp
         uHD97qPQOMePmZ/N7gzrnDUFqIAx15+skivY4WrdUB0Hs+8czsoGK32vPf9eyP/jO2Ws
         GHqUHADNXBlaDviHewHsyX8flXVjtNb7atPKBv45XCCSBctam0DZdq8PsH17Oq60kxF5
         TPjw==
X-Gm-Message-State: AO0yUKVgzDGJ4iovWnMUrlI26a7CHXiUavZaw+VxUAZfqH1GR7Wh/Bf9
        28CsyWvRVNPKCxpFZvvuJqI=
X-Google-Smtp-Source: AK7set/sS+VFeNQbqvPWG6Y3vsg2LWvIO3a+M9NMtkh/NlYUcfwNt0h1S+1YmaCKQOHXonfm6jZYeA==
X-Received: by 2002:a17:907:64a:b0:92b:4f8e:dde1 with SMTP id wq10-20020a170907064a00b0092b4f8edde1mr7882644ejb.20.1679297526372;
        Mon, 20 Mar 2023 00:32:06 -0700 (PDT)
Received: from felia.fritz.box ([2a02:810d:2a40:1104:149a:8de0:b37a:3ec9])
        by smtp.gmail.com with ESMTPSA id qx20-20020a170906fcd400b008eaf99be56esm4118233ejb.170.2023.03.20.00.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 00:32:06 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Rob Herring <robh@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-nfc@lists.01.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: remove file entry in NFC SUBSYSTEM after platform_data movement
Date:   Mon, 20 Mar 2023 08:32:01 +0100
Message-Id: <20230320073201.32401-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 053fdaa841bd ("nfc: mrvl: Move platform_data struct into driver")
moves the nfcmrvl.h header file from include/linux/platform_data to the
driver's directory, but misses to adjust MAINTAINERS.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
broken reference.

Just remove the file entry in NFC SUBSYSTEM, as the new location of the
code is already covered by another pattern in that section.

Fixes: 053fdaa841bd ("nfc: mrvl: Move platform_data struct into driver")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Rob, Simon, please ack.

David, please pick this minor cleanup patch on top of the commit above.

 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 216a61805c93..bdfed3cfde9b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14703,7 +14703,6 @@ S:	Maintained
 B:	mailto:linux-nfc@lists.01.org
 F:	Documentation/devicetree/bindings/net/nfc/
 F:	drivers/nfc/
-F:	include/linux/platform_data/nfcmrvl.h
 F:	include/net/nfc/
 F:	include/uapi/linux/nfc.h
 F:	net/nfc/
-- 
2.17.1

