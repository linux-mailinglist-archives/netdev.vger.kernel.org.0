Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A22D62B6DC
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 15:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfE0Nqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 09:46:34 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38823 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfE0Nqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 09:46:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id d18so17011048wrs.5
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 06:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jL8EOSTC/B97Q4hYmRDMBEhteRV4Llk3yLW6XJX3YpI=;
        b=QyKXG70H1u2UgFiibJqKQV1vPScCiHh5bAhwADcaelYpW4zCUSLjX1xba7kJJgPIzm
         gQ3fytnMSzufHLRpKPZ0PdXOlXZHq9ysL1BSu6QpeHYw2iQbNspWhLXJPbWfxUdeNsDp
         Tq8NKj46EpnI3mPAIDI0v/HfNBmpKTZEeigo2v8v9ZsGLfT0ItVSS0PQufqEWQ/HiyMR
         61xVDWuHzws7/W8Nc/TVeK9EHB9aWnm6Ha3N8Rd1bEZH1UUcDEwkyo8eeX+W2tnHpWwz
         IRU7Q6hnV1EwNL0J5lgU52QePAAyAhrV2lAIOIGWdIL3xiLXpqwK5uksj6cwlK/Jwdji
         j9uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jL8EOSTC/B97Q4hYmRDMBEhteRV4Llk3yLW6XJX3YpI=;
        b=nptO/Vzr3gPyvaM6+jVINC1W/7O0/Fm92o8KOVGQA2VkYrXXy89bmiT/EvjMLgyS+e
         x5GkgWdfQ/Ekh8KHHhbWt/xFRrRjxBS5AG7mhyKX4Q4bUmskxUvO+7OsoOTHHasLahWs
         TMdyDtJ7cdwTGbPL0o5a/Db6qFEJOU/qiGTuU+xJwuL0KsB2CU9W4BBJ4uDXI3cHa6mP
         5Wa23ia36Wrql1OC2D/h76ioGdd0DpGCpeD2ZkWwDN6p5OurotrYhWSC0yXfmC3bZq2K
         NzE7MsYaHpsZy11YS049VcXmMktQ3DBGcpogFV6PfEfmjUgU0fq+vSCXibpt70gHp5RI
         kACg==
X-Gm-Message-State: APjAAAVoO1N3hiGK9qmdkLA/RW2naue+CoGnS6e4WwJmoM3eIZB+cRhA
        +aPSkrV8oeA42gP8H7JmA7Htig==
X-Google-Smtp-Source: APXvYqwCBkFUboFEpdyYeT2MB2m5qBA+jbGdF6IZ6832wSuIZrnvbPGDoxx2MAEeMgieqB2H0x8Gzg==
X-Received: by 2002:adf:ab45:: with SMTP id r5mr48449812wrc.100.1558964790971;
        Mon, 27 May 2019 06:46:30 -0700 (PDT)
Received: from bender.baylibre.local (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id w2sm4611311wru.16.2019.05.27.06.46.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 May 2019 06:46:30 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH net-next 2/2] net: stmmac: dwmac-meson8b: update with SPDX Licence identifier
Date:   Mon, 27 May 2019 15:46:23 +0200
Message-Id: <20190527134623.5673-3-narmstrong@baylibre.com>
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
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index c5979569fd60..c06295ec1ef0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -1,14 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Amlogic Meson8b, Meson8m2 and GXBB DWMAC glue layer
  *
  * Copyright (C) 2016 Martin Blumenstingl <martin.blumenstingl@googlemail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/clk.h>
-- 
2.21.0

