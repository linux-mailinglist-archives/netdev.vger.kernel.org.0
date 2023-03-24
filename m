Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF7D6C798C
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 09:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjCXISu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 04:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjCXISt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 04:18:49 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CDC7A80;
        Fri, 24 Mar 2023 01:18:26 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t10so4578494edd.12;
        Fri, 24 Mar 2023 01:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679645905;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OjSUxUwRJucB2mvsJMNP8LiRg/5RwK8jwPvjNan6jTk=;
        b=CU9IbzkGaEQy1zPpW4M09QBTedqvMXYo+Ug19vY7LnZy0DMaaZnKu/U13S/XHJDN0V
         LsCcVqfIdsaDPENt+ABcX9hBhaWDgWZN9C1tcheyNCKgsaiFpJgpJhkUKPCyD+j1wtVF
         gP2lzU+o1/gNiIp4ihhL6vvooIl9Q62mvCoUmRUuTc98reu4/NgoTPaQXxNmJvclosDL
         PByTBDdYmusyPCl4IGrn0oJClHHB3MGwIrlf5n6Yup+fFCdxUv9c22+hYpcPSZrGYkl+
         ofmNyj1e7XXbdIUGoAR+YbtAxj8KOLb4roZSki300CimupM3oT4LRO461/yRJ41VacKf
         lRcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679645905;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OjSUxUwRJucB2mvsJMNP8LiRg/5RwK8jwPvjNan6jTk=;
        b=61LchpCLWPrOuGKr08rFPx12q7UFSWfZhs9xzTMlgBELgSc/h3VxJAr+wrO5W/LPNX
         v9kcirkbeVILxcCh0D43R2Ez0XdrlG5Jwi2CkuQ9EwROxOJKiBOKbtCq5i5lF/0PXojg
         BJF+/+8FfIMoytxlOYGa53S7C6bMI0fxKMkoAYfZv1TXE9YStfrJXJWdepTCIDyMHbwS
         IuJwAaj1+/AGVcqmcuURm6GhkGEinrKDsQ8xhbiRGnG8tzmZSCKKI/gock4qGY5vUmzw
         knskSCOHjlqXhmMcjozvOk6EGb+eGHymT1aTf1+8pL7q79tMW2l3SUVoKau+d1m/lH4M
         3Liw==
X-Gm-Message-State: AAQBX9eEmPuOFGq0Kn9V38MXNg7L6CL57UdNttFzdenXiIPdNNCMxwm3
        jYLuAjnwMaQkNhPRip8mj0k=
X-Google-Smtp-Source: AKy350Zq2gp7nz7LOBOMYjJFpLY8UPjh7A6bnyx0rpvamXXo+6aUhRnFQoe0p1mWugKR3uiXejUvmA==
X-Received: by 2002:aa7:c74d:0:b0:4ac:bbaa:867a with SMTP id c13-20020aa7c74d000000b004acbbaa867amr1728744eds.24.1679645904555;
        Fri, 24 Mar 2023 01:18:24 -0700 (PDT)
Received: from felia.fritz.box (ipbcc1d920.dynamic.kabel-deutschland.de. [188.193.217.32])
        by smtp.gmail.com with ESMTPSA id i17-20020a50d751000000b0050214930f5csm1682713edj.10.2023.03.24.01.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 01:18:24 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: remove the linux-nfc@lists.01.org list
Date:   Fri, 24 Mar 2023 09:16:13 +0100
Message-Id: <20230324081613.32000-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some MAINTAINERS sections mention to mail patches to the list
linux-nfc@lists.01.org. Probably due to changes on Intel's 01.org website
and servers, the list server lists.01.org/ml01.01.org is simply gone.

Considering emails recorded on lore.kernel.org, only a handful of emails
where sent to the linux-nfc@lists.01.org list, and they are usually also
sent to the netdev mailing list as well, where they are then picked up.
So, there is no big benefit in restoring the linux-nfc elsewhere.

Remove all occurrences of the linux-nfc@lists.01.org list in MAINTAINERS.

Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/all/CAKXUXMzggxQ43DUZZRkPMGdo5WkzgA=i14ySJUFw4kZfE5ZaZA@mail.gmail.com/
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 MAINTAINERS | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 617eed07496a..293f90229b72 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14703,10 +14703,8 @@ F:	net/ipv4/nexthop.c
 
 NFC SUBSYSTEM
 M:	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
-L:	linux-nfc@lists.01.org (subscribers-only)
 L:	netdev@vger.kernel.org
 S:	Maintained
-B:	mailto:linux-nfc@lists.01.org
 F:	Documentation/devicetree/bindings/net/nfc/
 F:	drivers/nfc/
 F:	include/net/nfc/
@@ -14716,7 +14714,6 @@ F:	net/nfc/
 NFC VIRTUAL NCI DEVICE DRIVER
 M:	Bongsu Jeon <bongsu.jeon@samsung.com>
 L:	netdev@vger.kernel.org
-L:	linux-nfc@lists.01.org (subscribers-only)
 S:	Supported
 F:	drivers/nfc/virtual_ncidev.c
 F:	tools/testing/selftests/nci/
@@ -15088,7 +15085,6 @@ F:	Documentation/devicetree/bindings/sound/nxp,tfa989x.yaml
 F:	sound/soc/codecs/tfa989x.c
 
 NXP-NCI NFC DRIVER
-L:	linux-nfc@lists.01.org (subscribers-only)
 S:	Orphan
 F:	Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
 F:	drivers/nfc/nxp-nci
@@ -18552,7 +18548,6 @@ F:	include/media/drv-intf/s3c_camif.h
 
 SAMSUNG S3FWRN5 NFC DRIVER
 M:	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
-L:	linux-nfc@lists.01.org (subscribers-only)
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
 F:	drivers/nfc/s3fwrn5
@@ -21054,7 +21049,6 @@ F:	drivers/iio/magnetometer/tmag5273.c
 TI TRF7970A NFC DRIVER
 M:	Mark Greer <mgreer@animalcreek.com>
 L:	linux-wireless@vger.kernel.org
-L:	linux-nfc@lists.01.org (subscribers-only)
 S:	Supported
 F:	Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml
 F:	drivers/nfc/trf7970a.c
-- 
2.17.1

