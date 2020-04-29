Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAE51BEC41
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 00:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgD2W6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 18:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727813AbgD2W6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 18:58:19 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9192EC035494;
        Wed, 29 Apr 2020 15:58:18 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g12so3869435wmh.3;
        Wed, 29 Apr 2020 15:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8HomwQkeOd7sLkeelNSzkxrfcFngr7K6iKYixnhDrD0=;
        b=Nb9q424hA8MmSuTQhjuFcPWqPQRtJi86sbrzVyaAN3L8bqnYsXevIEcbTzNwohVBfr
         QDnlSOdWuhDc8mXJkWfKz0yNDYSZEJ/WWCEjofRk6yCNNGU6H54hF12RZwxckSB0VWIc
         Sbzqex0nqmC06aK2Fon7F8ILcv5wFqeY3hQJAh6GuIThAMrL5Wo4TfAeNZptAPH4ye0u
         JxM/rI2KxxVRB1wZwAaQN7oHb3ja9/tRlb8yaNr4GY4c/QqwkzlbfUEAWUkhqyv4JO/9
         wQNI/Xl90CBgIQ3bInpUSviRMTJ/KYGDzG4YMKXJVfeG86VK7TaPp6j5urtK9QwxVl4n
         dZBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8HomwQkeOd7sLkeelNSzkxrfcFngr7K6iKYixnhDrD0=;
        b=Tz0QmhwO82NoTiESNsmeXwUk/2Z3FU+QDiQWCSSf4S51P3hnsrvknFvCBjbMeeW/gl
         2fBmg/7GRWzIpMLVQBIG9nUU/cFA7OVaEJyX8HvkqmBR+j461AT5wPcVy919aAj/bYmF
         r9Wu1KhPpPymo2awj3wInznp1FW5kcIMX00+2vmqC+dm+28eQCCy+neqt8DwSOWYDxRt
         eJO6LcABpROIkKD4M7jXedsJ8C0y9unP8/H9XzjILdwZdotEdSUOVC2nxWGCX0+nDjE3
         Ulv94/fair6Z9PCiN+HqdA2WN3pCloubHIi/8dxA3Y+9eP1eYfJTfMjNaBy5CVYM2Rx2
         zp6g==
X-Gm-Message-State: AGi0PuYEg9Ney2KnT4H/Hxc4TAxVnN5/uZLvoKXEdNSPoXDbLsUgdSr6
        aTT5388YuiHCr1CihBhce/tnKpslPtL0
X-Google-Smtp-Source: APiQypJiHYIUBhW2se94qLAUyo/TCy0OKj1irvusJlLc5EPaOmX0lyr87p47FEujIOUm33Cy8Oaehg==
X-Received: by 2002:a1c:8049:: with SMTP id b70mr159994wmd.162.1588201097060;
        Wed, 29 Apr 2020 15:58:17 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-14-195.as13285.net. [2.102.14.195])
        by smtp.gmail.com with ESMTPSA id 91sm1247675wra.37.2020.04.29.15.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 15:58:16 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-spi@vger.kernel.org (open list:SPI SUBSYSTEM)
Subject: [PATCH 2/2] spi: atmel: Add missing annotation for atmel_spi_next_xfer_dma_submit()
Date:   Wed, 29 Apr 2020 23:57:23 +0100
Message-Id: <20200429225723.31258-3-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429225723.31258-1-jbi.octave@gmail.com>
References: <0/2>
 <20200429225723.31258-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at atmel_spi_next_xfer_dma_submit()

warning: context imbalance in atmel_spi_next_xfer_dma_submit()
	- unexpected unlock

The root cause is the missing annotation
	at atmel_spi_next_xfer_dma_submit()

Add the missing __must_hold(&as->lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/spi/spi-atmel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 013458cabe3c..57ee8c3b7972 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -706,6 +706,7 @@ static void atmel_spi_next_xfer_pio(struct spi_master *master,
 static int atmel_spi_next_xfer_dma_submit(struct spi_master *master,
 				struct spi_transfer *xfer,
 				u32 *plen)
+	__must_hold(&as->lock)
 {
 	struct atmel_spi	*as = spi_master_get_devdata(master);
 	struct dma_chan		*rxchan = master->dma_rx;
-- 
2.26.2

