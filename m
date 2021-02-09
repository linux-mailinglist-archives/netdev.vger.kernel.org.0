Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C02315AA5
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbhBJAHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbhBIXam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 18:30:42 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468A3C061788;
        Tue,  9 Feb 2021 15:29:41 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id c1so351941qtc.1;
        Tue, 09 Feb 2021 15:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FCzySfYlN/LAMWv+m8/NSEcLX72JeDg9cjMwwQeX7SY=;
        b=ayaNl9D+oKLQ1blTkbwDyocbPrnUunuRO4tCdYXMJnfkODFRedDSfdiUdG5BDuV8Ma
         pkY4A6DpD/7CJKH6leedn3WrsM9j5pYc2qsuXFo/Bbk29GkT9yuN15iUWYKdTszeRDgX
         45UkG58ynPpyiceKQr3OXzJZ/PLhWcJfsq0elPiQvEeRTsjXSPJ62otoKkJwXHfRHJ6T
         Lkc8C87yZy4Co53iFwJsTQvSMo22oxwplqJ0lYOsY8gSe6ZFWuYa7EL6NaJILbPnnwNm
         aDNJlYftQ/r2WdgSSoCKr3A5iaMVkkgao+NFK7xzuvu9iLxHtqCfHqiYue9obW593eG9
         oaew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FCzySfYlN/LAMWv+m8/NSEcLX72JeDg9cjMwwQeX7SY=;
        b=o9n8pxEEun3bMFoLEWUuiIOUGpWZtsl7Qkb4JLxe17ZIXgbgGCFA8HX9hMbyP0ZgLk
         5oBMwGS/iDTvfbZJ1d/5JOARDDvXgqJVFMb8e5mCzXBxQuC8pa2QjS9+bnhP1dGO6D4J
         6tPG3EKPNOkYv9+4mpzPxhQUMvTrBSmPdRQ5R9JZ3gWr+iTxafh+l72IdcZZ4ixvmlEp
         quzOwzvSc/CrZSDzc3yoNwd+vydqo14FiN0u7p6nU/gIJzgfxh5FY7ICWw+MBzsGkWxN
         XAwtyE70tE1Hv70XQd+eLNBPc+g/cqY8DeipnG85BIP61CVwCG3k34c+Qp8kfu5IZFNL
         siFQ==
X-Gm-Message-State: AOAM533ZuVeK2kiAvQkWg+7fcOx1ljxnsQxWNKHzQ8T0S91S7NTMHkoD
        H441OaRWn+6KL8JxKCo3O7o=
X-Google-Smtp-Source: ABdhPJzWjtd7mDkggf6eI3egIwv0oVz1HQJcpTau/MvDs9fwivqo1ixNGGF/w9cIEhCuItAKLyq2LA==
X-Received: by 2002:ac8:3a65:: with SMTP id w92mr417559qte.267.1612913380563;
        Tue, 09 Feb 2021 15:29:40 -0800 (PST)
Received: from localhost.localdomain ([138.199.13.164])
        by smtp.gmail.com with ESMTPSA id 17sm263168qtu.23.2021.02.09.15.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 15:29:39 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] wireless: brcm80211: Fix the spelling configation to configuration in the file d11.h
Date:   Wed, 10 Feb 2021 04:59:21 +0530
Message-Id: <20210209232921.1255425-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/configation/configuration/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h
index 9035cc4d6ff3..dc395566e495 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h
@@ -1469,7 +1469,7 @@ struct d11rxhdr {
 /* htphy PhyRxStatus_1: */
 /* core enables for {3..0}, 0=disabled, 1=enabled */
 #define PRXS1_HTPHY_CORE_MASK	0x000F
-/* antenna configation */
+/* antenna configuration */
 #define PRXS1_HTPHY_ANTCFG_MASK	0x00F0
 /* Mixmode PLCP Length low byte mask */
 #define PRXS1_HTPHY_MMPLCPLenL_MASK	0xFF00
--
2.30.0

