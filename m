Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1B42B6DD
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 15:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfE0Nqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 09:46:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40131 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfE0Nqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 09:46:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id t4so8731312wrx.7
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 06:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bKRlBkskczdPPqv9G18ixpX6ovvQaVIENR175SCnaOw=;
        b=Y2h9scCMQNHAr/J4BkXemMWG7+qOJXI85w6nUml47YknMvh21D1C33+TH9ecDhi0J3
         33HiETE78tULCLjbE9xX5PD/N9RaXBdCxZiBBksLyv3Y1CuGzi9+PJJYiCmoAyxrFAHt
         hS9sHzMoyhjKzsvUqshogNg+X23j572m0NNVqjWlv2iBQ1+S5pRI4cloKUlh0TrFkmbm
         Y7QviWNkT382EgInRcLvghAmlHfRIMslBQOYNYspvIDf0lNPmPBQBO3ThXQR/9b0xj2K
         5p1mglM/4O9buzC+HLdOqKYt7/yY9gKWeV99jTnKddFSdQ4G6NhzpQ0TsrdDxEDBPDSS
         SyaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bKRlBkskczdPPqv9G18ixpX6ovvQaVIENR175SCnaOw=;
        b=na/N3A1zHJhPtJNNcn8A8Etnvjv2sxV48oS6txWRXgRDJQpIoZLgvqDS4bx4CadIRw
         uSGSqnXOB8pNGwX68aptkDBNHc56BeWkZN5AfWwg106j7kuMHEIR31nhTdG/V5my8UOb
         TNrR8hAy+MYb/ApTLN9P28KVYJN98tAbKcD5CwyLETGzr/svHsFRtDLHYJNaGwUBIEBe
         2w1o8w484Vp+LaZkeg3973yXrOmt++g4/XY+TWfAyKLTxcbv22FbM1d1wUMOx8GTNzT6
         NLkwkf8oErHG9NTWwFQbeh6M7tFWy4X6P6oEPK1EuhiCEafEimy7thdy2jKCD8cgt4U/
         j6Bw==
X-Gm-Message-State: APjAAAWOICGR0hXAh8hw65cy3Gkr00A9kuQKDqsMl7Tr9Z5RXvGjfK0A
        Mt+RJZJwjr1ontxtdD13DFvgCg==
X-Google-Smtp-Source: APXvYqw8OK0PYWWMEGHRAXt6wmuVUV8zRg5wDVw/kH7BVy+7OcrxCWVYYVRnB4crgUvSqGvtko3q+A==
X-Received: by 2002:adf:8bc5:: with SMTP id w5mr32380340wra.132.1558964790319;
        Mon, 27 May 2019 06:46:30 -0700 (PDT)
Received: from bender.baylibre.local (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id w2sm4611311wru.16.2019.05.27.06.46.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 May 2019 06:46:29 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH net-next 1/2] net: stmmac: dwmac-meson: update with SPDX Licence identifier
Date:   Mon, 27 May 2019 15:46:22 +0200
Message-Id: <20190527134623.5673-2-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190527134623.5673-1-narmstrong@baylibre.com>
References: <20190527134623.5673-1-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
index 7fdd1760a74c..5ae474ebaaed 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
@@ -1,14 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Amlogic Meson6 and Meson8 DWMAC glue layer
  *
  * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/device.h>
-- 
2.21.0

