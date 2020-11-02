Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255582A29E0
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgKBLsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728653AbgKBLpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:49 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE46C061A52
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:41 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id p22so9078835wmg.3
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=COHpN89YHkMBJqrtEu0XBsht05sYavnazN1Mt7fpBKk=;
        b=fkDL7huiZ/Lbz3WJpe3FUz+EUaM+KbGaFk1iFyWlFeSd2bcqw8hm37MhO3MJ6htLqy
         JLDY661w2YNbPsqhqbCosb25NmD/K/mrMbFZH/ZXja3tWnN9fQrrkLcTyJED65PPcQ26
         ReiWgVysf1NZNd6zzVjWGnh2IgWRGBCvjN3wshlM0HsgxFB2lh26QUwffnT1d39OIgxG
         p0pK9jHUemZJgMl4Qfl9555XLWzVezGBLWPfDfofPNecptc9TXw+6ENmJw3KvXfuAoLV
         cJ4Ueiwm49pLjS8qjXSS6uRqiTriGJR9mgwmWInTrUHYuXkjGvP+3/jjI9tBzUzAl57d
         xWKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=COHpN89YHkMBJqrtEu0XBsht05sYavnazN1Mt7fpBKk=;
        b=lfw4onLkVvh6UGHeyxtb4J8fOoq6x8zP8NovfLAOjMQD6nIHidqN7xU9p0YjvGMGos
         gijfnJzAY9LFRKV2gHsLp2mLTFdBnVtjdlC2dZNxSrkN2pwxAVYIJhDwhn9xqWS/B6HY
         TJgTtB3iTm5qIC1SHanwFQOcVMaqExC0ulpQsMsBm0k/u2J0uO9YXlLbyJ77Mi37ShzM
         RupxJ95lqzP5x8iRqK7atCOEoDWc0Ltf6AzSGe6gBC/K48TLBueqdF7rzd6oswaw18Xh
         iqjYwcrB+zIeCubHG5N5fk8K1HnTZpyQfyVb0b3NwOflXHsKzd2noPIHEeJ8o/4VzWRR
         m4bQ==
X-Gm-Message-State: AOAM532LSJz3pr41q6kNh3d54LqjlWY3zVHifSaeoxC1pDi+bGTrWi+x
        Scu36NvxwYPyLvw+zpbhk16jW7v4Xv6pPA==
X-Google-Smtp-Source: ABdhPJzxz1vv9WcVwfS8dl/02ZYd2VO65DE4GLXc2nxAtRpw8HSplQsQxz3SLsx+QCLxAfbog8H8+g==
X-Received: by 2002:a7b:c932:: with SMTP id h18mr18143994wml.82.1604317540218;
        Mon, 02 Nov 2020 03:45:40 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:39 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, Jakub Kicinski <kuba@kernel.org>,
        Yanir Lubetkin <yanirx.lubetkin@intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 17/30] net: wimax: i2400m: fw: Fix incorrectly spelt function parameter in documentation
Date:   Mon,  2 Nov 2020 11:44:59 +0000
Message-Id: <20201102114512.1062724-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wimax/i2400m/fw.c:647: warning: Function parameter or member '__chunk_len' not described in 'i2400m_download_chunk'
 drivers/net/wimax/i2400m/fw.c:647: warning: Excess function parameter 'chunk_len' description in 'i2400m_download_chunk'

Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: linux-wimax@intel.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Yanir Lubetkin <yanirx.lubetkin@intel.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/staging/wimax/i2400m/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wimax/i2400m/fw.c b/drivers/staging/wimax/i2400m/fw.c
index 9970857063374..edb5eba0898b0 100644
--- a/drivers/staging/wimax/i2400m/fw.c
+++ b/drivers/staging/wimax/i2400m/fw.c
@@ -636,7 +636,7 @@ ssize_t i2400m_bm_cmd(struct i2400m *i2400m,
  *
  * @i2400m: device descriptor
  * @chunk: the buffer to write
- * @chunk_len: length of the buffer to write
+ * @__chunk_len: length of the buffer to write
  * @addr: address in the device memory space
  * @direct: bootrom write mode
  * @do_csum: should a checksum validation be performed
-- 
2.25.1

