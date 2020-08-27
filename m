Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA403253D6D
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgH0GGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgH0GF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:05:59 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0E8C061247;
        Wed, 26 Aug 2020 23:05:58 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id k10so2286152lfm.5;
        Wed, 26 Aug 2020 23:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TyfqwcOqzI+LTCqOQsnVyQ4MKkXCO8VQFL1cTjyFH+c=;
        b=B30mTGxXAKNYGRQstG6YWQsAmtZNP5pSXIl9+9PQRuXlC6NlfBRq9rZbMfNllycRnf
         ExzR9IKBBRZ6JLycWvVYHsrrLIAQ45RSilxX7htvD1bwoSEecwpMQv/EHO/dlWjikyrF
         Bb5eRAZQ8gwB6UJyZ2SIjgdq/81hBWliDdjdRECF/cme60cmaXHHRyWJ3jnPSwJnxyrB
         EyCFym+c8dViDd4EdsPHUlFd0+AyTkJDCquy956GGE3oPaisbE6jWCXmKBfovrzdLvt5
         K2DQCcpzOxIyZJu29J/E4iBMijX/wASVYTrqVL1s2Sdn508vLkjbsnQGcgC0B0Fxy8Pm
         tuYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TyfqwcOqzI+LTCqOQsnVyQ4MKkXCO8VQFL1cTjyFH+c=;
        b=Ro1lvOeuLZFq/XOXekrI89+fg2WgM7xpBO8Lagx+dYWg0Xh55GYySpHnfyHcaQ+ywM
         hdPJliAM6FGQIno1V7cvaTX0GQjqEuTylNK3nCBGszKoKMbBZtCtue+LE6+s21O6uB9s
         2sE2LmNFjlgSBzuQbO+xvxiAH9ZxbMEKx4Cmt9KeXpDIr7bwcTk7WB79L/XwakZfkqqR
         cqoNYu7LbsEprBsv5nodu8pLGESR/V30H6h4zCnRLwiYjoabkrQlSpm70BcR46I5dbZ2
         k9qXkZqaCeThb4kzo7SbEuDB9Tayo+g9RSWMWoIfHibWfz2RBlR83UVqKSZ95KJsbolS
         EqGA==
X-Gm-Message-State: AOAM533aAtFA6VoXrELV4sBpV3ZXbS4i1DZBYqRAApHB0UDRD2VQTKf7
        o+Y9raOO2/QdQmyWOOVGMMEe/d1TdeQ=
X-Google-Smtp-Source: ABdhPJzSBA/pFB2/PN21Swo9ACb5wJXp06RjoytEa+wAUxh79r1KkvtyljqbTFP1ehYkms+fLBp5WQ==
X-Received: by 2002:a05:6512:1055:: with SMTP id c21mr9041396lfb.84.1598508357307;
        Wed, 26 Aug 2020 23:05:57 -0700 (PDT)
Received: from localhost.localdomain (109-252-170-211.dynamic.spd-mgts.ru. [109.252.170.211])
        by smtp.gmail.com with ESMTPSA id z7sm255295lfc.59.2020.08.26.23.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 23:05:56 -0700 (PDT)
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] brcmfmac: drop unnecessary "fallthrough" comments
Date:   Thu, 27 Aug 2020 09:04:39 +0300
Message-Id: <20200827060441.15487-3-digetx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200827060441.15487-1-digetx@gmail.com>
References: <20200827060441.15487-1-digetx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to insert the "fallthrough" comment if there is nothing
in-between of case switches. Hence let's remove the unnecessary comments
in order to make code cleaner a tad.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 2 --
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 1a7ab49295aa..0dc4de2fa9f6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -916,9 +916,7 @@ int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 		f2_blksz = SDIO_4373_FUNC2_BLOCKSIZE;
 		break;
 	case SDIO_DEVICE_ID_BROADCOM_4359:
-		/* fallthrough */
 	case SDIO_DEVICE_ID_BROADCOM_4354:
-		/* fallthrough */
 	case SDIO_DEVICE_ID_BROADCOM_4356:
 		f2_blksz = SDIO_435X_FUNC2_BLOCKSIZE;
 		break;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index ac3ee93a2378..b16944a898f9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4306,9 +4306,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 					   CY_43455_MESBUSYCTRL, &err);
 			break;
 		case SDIO_DEVICE_ID_BROADCOM_4359:
-			/* fallthrough */
 		case SDIO_DEVICE_ID_BROADCOM_4354:
-			/* fallthrough */
 		case SDIO_DEVICE_ID_BROADCOM_4356:
 			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes\n",
 				  CY_435X_F2_WATERMARK);
-- 
2.27.0

