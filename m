Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCF02A295E
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgKBL2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728679AbgKBLYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:35 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F399C061A4C
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:35 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id e2so9131720wme.1
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=64CEfunw0Swc50bQt2+cwn7fqQh5uT3oHRs6EoyWU9E=;
        b=dtKvQLdkRazg4ZqZJN35vFHJcRcz7KG5R3YrIIrk1BqWZG52ptG3jTXh9dwINAFFaW
         jHMJxG3L01KDxZGM8DiRvM0pXhW1sifQQUg3+uI/mTs/IheMZhk9XOu3hEmKj6vFuzTJ
         J9HtYTh6XGVey5//Z1waQ0U8NaqUDbCX3Ens6q/oVSlUeNI78zF7s/c1dtNNf6jXGElV
         NKUX+Z3SVyP0aQjr4FH8l9Rvkx2lXRhmqV+xpB8LcmMUSr8WF9Q0nOvVq+hO3cNf4uoF
         69/hIIpY/oLAeAvtyQN68f9iPiFqnxPT11Og6kmJu+ARVbxQvjH44yzYyuJlh5LfUgK3
         mO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=64CEfunw0Swc50bQt2+cwn7fqQh5uT3oHRs6EoyWU9E=;
        b=GeCf6rHsZPGQEYycVYykj/F0Umw9dVJfJwaVEVHAk/l7TuoZq4r6L9cKzTEEfMBGFa
         DSVLn7IJjC11QwNfSeh43OMl1r0+GAgM4b+ot6qAdmkFOgHqJnGqbW2y14s5Gstru7nm
         l51yZ03rw4OO9k/gsrsmP4VyXIol/0Xc/grJWLjvfUY2KUZ1SWNLANYP+nb1nAySX9zz
         DYyLsS2DJFT0i+FA1aU894FxWKhRvHT9jcEt/oOEnsYUpj7WQj5wURkjcV/g2MTA5S9q
         lZRKVzZiiGM+qovoBoUNCrDBF7Y1zcgtr+OlcuKvapWVeacYyHe3pC32j6dLrZLbpI4P
         k9MA==
X-Gm-Message-State: AOAM530l/ZFodZyjPKfQ1hnBo/P9aLOjrjvc0jF8WDWdBd0ZptWROkB+
        ArSb6nrSysRow/nSx7Tz8SZDkQ==
X-Google-Smtp-Source: ABdhPJydIfAMGSt1CRrgd5Gr42T55jwHJBn2q8i6Ptcgr3b3uPbIhbh0BRsEugQbufM1iD3B5t8XbA==
X-Received: by 2002:a7b:cd10:: with SMTP id f16mr11032536wmj.69.1604316274037;
        Mon, 02 Nov 2020 03:24:34 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:33 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 13/41] ath9k: ar9003_2p2_initvals: Remove unused const variables
Date:   Mon,  2 Nov 2020 11:23:42 +0000
Message-Id: <20201102112410.1049272-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h:1734:18: warning: ‘ar9300PciePhy_clkreq_disable_L1_2p2’ defined but not used [-Wunused-const-variable=]
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h:1727:18: warning: ‘ar9300PciePhy_clkreq_enable_L1_2p2’ defined but not used [-Wunused-const-variable=]

Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index c07866a2fdf96..16d5c0c5e2a8d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -1724,20 +1724,6 @@ static const u32 ar9300PciePhy_pll_on_clkreq_disable_L1_2p2[][2] = {
 	{0x00004044, 0x00000000},
 };
 
-static const u32 ar9300PciePhy_clkreq_enable_L1_2p2[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x0825365e},
-	{0x00004040, 0x0008003b},
-	{0x00004044, 0x00000000},
-};
-
-static const u32 ar9300PciePhy_clkreq_disable_L1_2p2[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x0821365e},
-	{0x00004040, 0x0008003b},
-	{0x00004044, 0x00000000},
-};
-
 static const u32 ar9300_2p2_baseband_core_txfir_coeff_japan_2484[][2] = {
 	/* Addr      allmodes  */
 	{0x0000a398, 0x00000000},
-- 
2.25.1

