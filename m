Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C144337BF1A
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhELOCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:02:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58763 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbhELOCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 10:02:03 -0400
Received: from mail-vk1-f198.google.com ([209.85.221.198])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lgpPy-0001i8-Pm
        for netdev@vger.kernel.org; Wed, 12 May 2021 14:00:54 +0000
Received: by mail-vk1-f198.google.com with SMTP id w184-20020a1ff8c10000b02901f2426ccc76so3017928vkh.18
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:00:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u38nZ0pTtHkniDD+jsScJheTZTLEaNhZSOY8TVKmDRU=;
        b=TD+UhXjBT75VmFDRepGj3G192RGX7r52Npd/18FJ/FTSoIrl5PJxKgoA0C8VAD0XUG
         j3+fbU0X8T2GthW38/QRae+AZhLPhnQBgMy/mQcflUPQXreaapzshctkUATaDvYewXUK
         kZl7cZKmNnpXfQA1CMsIVqX0ezF3aiS2SCzadujeE/Fll55uZDApXIHYQvfnIQHdUh00
         uqZYVS76F3yGXWDETXcYfLtghAfp/+NH8T36FeXx9HBpe84/R3p2kZNKP2MIdlN4eDQF
         HImK3rW1azpNijfGjJVy57pUs/PwWkvgvm/cfHebwHw+ynXg6Mft21Bpe08zLn+KF8HD
         YQyw==
X-Gm-Message-State: AOAM533wopNbh3QKWti6sS2LUOH0jasFlcpuMYH+8a+ZoUbsKZiNO25C
        ZC7/RW2wWfMtetMsiTRU8Ca/b1JwBF2B9+zI1LmqDj1ECUl/+2c48iAYn5oyQ6ctYpOlZaZW0Xs
        dEtpssr2otTTnDaCX7yiRlRSUDhNTqsbiOw==
X-Received: by 2002:a05:6102:124d:: with SMTP id p13mr31050559vsg.21.1620828053637;
        Wed, 12 May 2021 07:00:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytaTLOcSZA3NzpgsIkFHShdPIHNDYEqFobPbJyqY0n/46iR+at+Pd1cdk9ox0eBJMtmUkyMA==
X-Received: by 2002:a05:6102:124d:: with SMTP id p13mr31050443vsg.21.1620828052929;
        Wed, 12 May 2021 07:00:52 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.2])
        by smtp.gmail.com with ESMTPSA id y4sm804927vsq.27.2021.05.12.07.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 07:00:52 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Charles Gorand <charles.gorand@effinnov.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH] =?UTF-8?q?MAINTAINERS:=20nfc:=20drop=20Cl=C3=A9ment=20Per?= =?UTF-8?q?rochaud=20from=20NXP-NCI?=
Date:   Wed, 12 May 2021 10:00:46 -0400
Message-Id: <20210512140046.25350-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Emails to Clément Perrochaud bounce with permanent error "user does not
exist", so remove Clément Perrochaud from NXP-NCI driver maintainers
entry.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index efeaebe1bcae..cc81667e8bab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13208,7 +13208,6 @@ F:	Documentation/devicetree/bindings/sound/tfa9879.txt
 F:	sound/soc/codecs/tfa9879*
 
 NXP-NCI NFC DRIVER
-M:	Clément Perrochaud <clement.perrochaud@effinnov.com>
 R:	Charles Gorand <charles.gorand@effinnov.com>
 L:	linux-nfc@lists.01.org (moderated for non-subscribers)
 S:	Supported
-- 
2.25.1

