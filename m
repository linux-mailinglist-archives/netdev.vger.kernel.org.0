Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA89249728
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgHSH0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgHSHZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:25:00 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEBFC061368
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:25 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id l2so20443895wrc.7
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=btNFyQ5gdRMB0au+Pev2O+MsXnfVNmHhW/htK7KWPAM=;
        b=C88o+Qk+rULR4JQYPoSUWw4wAno6u1L/Jayo2cvTR2KjNVmvEdSM1h1wku9pGwoOfs
         foI9eXC7YM1wMZh1+VDE1EwCzHjUczt4Ty7HGru7Etar8sY75PnzhPQddbcA8KzUrh5M
         c4KiaW/eol1akNCr2+CxRa8oIFM5Ph1jX4fLbV54K2bj33wlAGaTCq3N+vL20jMoiY/y
         yolCEAbTd153ahWYLyXSRsSAtZKHYmnOc1GQS4rOzAOVMMOjTfyQRCxnHYOwPrZMPluC
         c6IMEak/QYh3kbvu6LY3UNu6DW2P5LeoL3GTvR1BZYWxgk6e0fv/HLnk3BofM+GHyI1a
         K/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=btNFyQ5gdRMB0au+Pev2O+MsXnfVNmHhW/htK7KWPAM=;
        b=WoJR+EsWwNIYdBsylwm9l+S6nk8V5a5knwNOfx+THgvFZR8TiMu7oK+rFNlUpvFP5g
         iCZoYWST9O6PZdQRGzblqfE3WC5EhQ88MN5/suWnO4rMXwU5+QXxaf04bc9lvL03Z9IF
         iJVdhySEe6P8pyM+Xv7yZegLN7Gl2/MMnC2hAsV8NcTvEEdIScW1en9n8iiKwr/2kNUm
         5f0OcWnZaRM8307NjvcRTQtlGjtiX76syOiV+PUJOVzP0x4VacFObdB0/LQa+85zezpX
         EydwgWFuW/teD7GNNVZT3Bsur3ENP4y75EOOH2n80cE+eLIGRCJfXCm7sIYWwk42J5Fo
         q5eA==
X-Gm-Message-State: AOAM530aMF2MnWlnPdpvx6951YbIfNXzgZJGEzNPkk/QsWcRmsCM5k43
        +RRO1vcIYXa3umYrg1YZsZToRQ==
X-Google-Smtp-Source: ABdhPJxnEhoTD05y07X1+zSPuPGwAfaT9pqBtJ+nZfki86mWBsbbmdiKb7qdBf4fpwOBaVZEVRxcfA==
X-Received: by 2002:adf:e290:: with SMTP id v16mr23353013wri.259.1597821863746;
        Wed, 19 Aug 2020 00:24:23 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:23 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 15/28] wireless: mediatek: mt7601u: phy: Fix misnaming when documented function parameter 'dac'
Date:   Wed, 19 Aug 2020 08:23:49 +0100
Message-Id: <20200819072402.3085022-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/mediatek/mt7601u/phy.c:1216: warning: Function parameter or member 'dac' not described in 'mt7601u_set_tx_dac'
 drivers/net/wireless/mediatek/mt7601u/phy.c:1216: warning: Excess function parameter 'path' description in 'mt7601u_set_tx_dac'

Cc: Jakub Kicinski <kubakici@wp.pl>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-mediatek@lists.infradead.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/mediatek/mt7601u/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/phy.c b/drivers/net/wireless/mediatek/mt7601u/phy.c
index d863ab4a66c96..3c4462487ab5c 100644
--- a/drivers/net/wireless/mediatek/mt7601u/phy.c
+++ b/drivers/net/wireless/mediatek/mt7601u/phy.c
@@ -1210,7 +1210,7 @@ void mt7601u_set_rx_path(struct mt7601u_dev *dev, u8 path)
 /**
  * mt7601u_set_tx_dac - set which tx DAC to use
  * @dev:	pointer to adapter structure
- * @path:	DAC index, values are 0-based
+ * @dac:	DAC index, values are 0-based
  */
 void mt7601u_set_tx_dac(struct mt7601u_dev *dev, u8 dac)
 {
-- 
2.25.1

