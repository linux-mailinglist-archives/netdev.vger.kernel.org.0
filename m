Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C7A6B5D2A
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 16:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjCKPHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 10:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCKPHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 10:07:24 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADF511F2D3;
        Sat, 11 Mar 2023 07:07:23 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id p20so8524387plw.13;
        Sat, 11 Mar 2023 07:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678547243;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2MHUggUK+2m+zM3homvw7NgxPN+0IfTli+QcFyY8r0g=;
        b=WvryAaZ4h6MFTkncOXcpV5kCQq+2qDT2SoA/4o1mfT6PGdaLrzP6PpK+/a34X/m/Kh
         z9XZwACG5ow4gXI6++lL5U/UEQleiPt6mGWtfYiqb7ijek+eqG3q8sumVFMd0Abbws/e
         Wc3SHkngge8fGcnYFXogdC4svVATaKmUm9/X4cWjNDYlVoKcab2L30yjtUj12oP9FTL2
         MbPUP8LutRBzL5JOvV65hFhM84tgDZx10zicZsffLIBbaqwdXMEv0+N+JYBvbZb+oIg4
         XjExidJCu7Dpa+y2Y3CBYiqEw0KzN1T1LLlxV3YOIjwJ/gJtneZ/yPsMhW4Ii72NZipz
         6l5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678547243;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2MHUggUK+2m+zM3homvw7NgxPN+0IfTli+QcFyY8r0g=;
        b=Qy5gHIhqfv7Xr0ygJZc/meNbPgMMWWMEnmjPFuHjwi/KQzoIVTAT+Z5rofrjeRliIx
         s8d37GsDrBZ8Lncs+eTbMfz8xq41+UPB3pUh2D4xIfXgTt0CiX3H3nHfXYYrakZlS4a1
         w8KJ+VZF8mVaSoUwdI79/KLAFkLqvGUnswjehuNO3/cZo8HOar2uD0N3/ufqCJHyvnfK
         ML2bKxYS0KrvFcse+CDoTU/xXezOudeswj/JEqHdUMg2m8jtO/XESiEfKDCrslBcnZTF
         Cc24edGchfSb1BWTx4xC27djOmQ/7l8gN7djXQvyXK8LfsA8KNQvgSxn1FNqR92vaq2m
         1Zuw==
X-Gm-Message-State: AO0yUKUXQxdyAp4GUQJWsh6XzohmB4NZ7F0fEht2ifiY/RIUQ51Un/jf
        /zv8q4BdWbV7bqOkBfBhAJU=
X-Google-Smtp-Source: AK7set8nKRMTb4TqsdR/9/oeBYsMT4Wm0/wD+PjwkImrX8Vv3San2+RtxXD8kdGBU1BNOlwA9ew17w==
X-Received: by 2002:a17:90b:1c06:b0:236:76cb:99d3 with SMTP id oc6-20020a17090b1c0600b0023676cb99d3mr29920884pjb.12.1678547242642;
        Sat, 11 Mar 2023 07:07:22 -0800 (PST)
Received: from skynet-linux.local ([2a09:bac5:3b4c:11c3::1c5:3f])
        by smtp.googlemail.com with ESMTPSA id c10-20020a63d50a000000b00502fdc789c5sm1676470pgg.27.2023.03.11.07.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 07:07:21 -0800 (PST)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     loic.poulain@linaro.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, linux-kernel@vger.kernel.org
Cc:     Sireesh Kodali <sireeshkodali1@gmail.com>
Subject: [PATCH 0/1] net: wireless: wcn36xx: Add support for pronto-v3
Date:   Sat, 11 Mar 2023 20:36:46 +0530
Message-Id: <20230311150647.22935-1-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Pronto-v3 is a WiFi remoteproc found on MSM8953 and other Qualcomm
platforms. Support for booting the remoteproc has already been merged,
however, due to a slight change in the register map between v2 and v3,
the wcn36xx driver does not work on pronot-v3. This patch updates the
register definitions to make wcn36xx work on pronto-v3 as well.

Regards,
Sireesh Kodali

Vladimir Lypak (1):
  net: wireless: ath: wcn36xx: add support for pronto-v3

 drivers/net/wireless/ath/wcn36xx/dxe.c     | 23 +++++++++++-----------
 drivers/net/wireless/ath/wcn36xx/dxe.h     |  4 ++--
 drivers/net/wireless/ath/wcn36xx/main.c    |  1 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  1 +
 4 files changed, 16 insertions(+), 13 deletions(-)

-- 
2.39.2

