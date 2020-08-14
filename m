Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D68A244923
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgHNLjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728117AbgHNLjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:39:51 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2FBC061385
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:39:50 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c15so8037461wrs.11
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZMwswRr+OImQYjmw7l/E8TzYSmNdiYoxWwAodNgtACY=;
        b=UiyD6Jii1LOQLLjARIww/2EHZGil9CEhQQoNcfeOB/w/wxnz8mUJR37gK0yGidtAQQ
         atVaJI75zk78BsO52FBLhSA5ZTaL2DZn/gDdzbN0e6hCr+OxY0FZjLmXobESjdj2ozmA
         GLTSmNS2xGD8YZGrjIC38bTfDbkgPVWbXB5zSc3l9KeDKd6+V9Fn51Sp8wQjRycaJz56
         aDl2/HkDvx8fJScR7BlJXy3nkrhYCSrXzWgi/+c1MFLYWo93CdGeogbHjR8g0Fhl2Lex
         sEPn0Jxh6eLFznGJcfcEUBu+6xOzgURZMgbdRQ33lRmhkHa+ZFaOv/649GJr3F4SSLOZ
         Z7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZMwswRr+OImQYjmw7l/E8TzYSmNdiYoxWwAodNgtACY=;
        b=gh/Y/oU0d5J5TezC6i1Skr7xbpXIAUpvGpqTAD3pJtTSSZXG2lGiT/qoaJgizhjfbj
         YtFYOl9Rl3rwOpXH7XoJdHsanduBVLAs6vte0Y2pGlOUmY/Wv+kZcgZ/IQMRVN8vcsP1
         8Ito3NUUtavdEiAhN3Vuy8QagZaZ+iC6CvIJfdSEr7OlSLLl9o/toTJ7bGJTNvZV3RKb
         /SUQOErGp2kgoAfaZUOSCmV89faW46dLYEt1q8D0uYkAJcfHKX39Zzs3/k4Q69ImETXU
         z/FVEy8PBLp+RC6YB1PkMbHcLxxG8fxAF7suHNznj+7SvP/nRldqS3aJXQ3wBmrYBHTB
         FpdQ==
X-Gm-Message-State: AOAM531yaZZZ9KTEwh4BSQuNbyq8BUYyg8YLZNuTNNe6OzdiiltUShyR
        KWBwE08+a4xyDLVcNybWuSorGw==
X-Google-Smtp-Source: ABdhPJxBIbPtwyMiHlThcvPK2rIwSNAKbuEMthQoEfjESrCTnUINMWJpIWcVBeReVuxX8twgIbmXXw==
X-Received: by 2002:adf:edc3:: with SMTP id v3mr2355759wro.193.1597405189077;
        Fri, 14 Aug 2020 04:39:49 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:39:48 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Martin Langer <martin-langer@gmx.de>,
        Stefano Brivio <stefano.brivio@polimi.it>,
        Michael Buesch <m@bues.ch>, van Dyk <kugelfang@gentoo.org>,
        Andreas Jaggi <andreas.jaggi@waterwave.ch>,
        Albert Herranz <albert_herranz@yahoo.es>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH 07/30] net: wireless: broadcom: b43: main: Add braces around empty statements
Date:   Fri, 14 Aug 2020 12:39:10 +0100
Message-Id: <20200814113933.1903438-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/broadcom/b43/main.c: In function ‘b43_dummy_transmission’:
 drivers/net/wireless/broadcom/b43/main.c:785:3: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
 drivers/net/wireless/broadcom/b43/main.c: In function ‘b43_do_interrupt_thread’:
 drivers/net/wireless/broadcom/b43/main.c:2017:3: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Martin Langer <martin-langer@gmx.de>
Cc: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Michael Buesch <m@bues.ch>
Cc: van Dyk <kugelfang@gentoo.org>
Cc: Andreas Jaggi <andreas.jaggi@waterwave.ch>
Cc: Albert Herranz <albert_herranz@yahoo.es>
Cc: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/broadcom/b43/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index a54dd4f7fa54a..2a29fa69f692c 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -781,8 +781,9 @@ void b43_dummy_transmission(struct b43_wldev *dev, bool ofdm, bool pa_on)
 	b43_write16(dev, B43_MMIO_XMTSEL, 0x0826);
 	b43_write16(dev, B43_MMIO_TXE0_CTL, 0x0000);
 
-	if (!pa_on && phy->type == B43_PHYTYPE_N)
+	if (!pa_on && phy->type == B43_PHYTYPE_N) {
 		; /*b43_nphy_pa_override(dev, false) */
+	}
 
 	switch (phy->type) {
 	case B43_PHYTYPE_N:
@@ -2013,8 +2014,9 @@ static void b43_do_interrupt_thread(struct b43_wldev *dev)
 		handle_irq_beacon(dev);
 	if (reason & B43_IRQ_PMQ)
 		handle_irq_pmq(dev);
-	if (reason & B43_IRQ_TXFIFO_FLUSH_OK)
+	if (reason & B43_IRQ_TXFIFO_FLUSH_OK) {
 		;/* TODO */
+	}
 	if (reason & B43_IRQ_NOISESAMPLE_OK)
 		handle_irq_noise(dev);
 
-- 
2.25.1

