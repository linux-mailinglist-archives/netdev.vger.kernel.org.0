Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A78323A1B
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 16:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732858AbfETOe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 10:34:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37767 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731683AbfETOe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 10:34:59 -0400
Received: by mail-wm1-f67.google.com with SMTP id 7so13317190wmo.2
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 07:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bKRlBkskczdPPqv9G18ixpX6ovvQaVIENR175SCnaOw=;
        b=w4TOcDtrhR68jFkglzFkuS/h0l6AA7RAFMFTc1ZKS2SiFvUY5b5VaQTv8FiFD4pL6o
         xt1kKjn8KBaqQjp116lcsnPrEWIe7GjJLqo1tyGpZm6ENdDJ5uZVg9KbI3fqBHLuIReF
         dcBjR/OXXgHxFPBfGo7cx7D5iZY3WIcxzSxzmGfIbYwDJLT4wPAbkYwGnNzcJ7iEe00L
         tvB2S8ulKpTgKYHf6t8VTYikHcaKg2PMtZq8stskss9rc5cBWAeqknOpQ7CAab7TzMmb
         LO5SbbDoyb++CX868C4YmbfL3MhoR+Uy+Kr5d62dDx9k3DwpoWW52l5zxf191TFDBEH5
         +DkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bKRlBkskczdPPqv9G18ixpX6ovvQaVIENR175SCnaOw=;
        b=DXayciAnHpizqS2zebHzFdinG+7DhkmCoVV7XGOpwY/mc39hBuLgPNMXQ9y2PEdeKN
         sdU+g0h68cwIn7ILyIQWHSaJx5f/TQ0OQMlP3ZBj+X1Qg3lxZQ3odtglUfccT/7/8aaq
         LBxEKHe2AMFZ18GNU8dpBxkaScvtzlLo+rCipEj3Yp7yx4gIbzFpuelQGyTfz8zuToSQ
         xYtFBzlg7zZeIi9oJteHhse94ubF5oC4c+gshCQokOOQ6cEpIR+wH6OJjw/bjqRdXYBc
         liBvpiAp1nVQkEj/jCuPYLbn3M1Xljz/cxwWfevnw/IN7sDo5l/pY5XGWVpjqXW+tcye
         BtzQ==
X-Gm-Message-State: APjAAAU8KTWLGKKdeRbJdzYSKXWSb9D8ZcvkZvBvk9W4wDemopMl5tp6
        Eb909T01kPKrom1mTI8qrqoY8g==
X-Google-Smtp-Source: APXvYqx+UgKQ5uSpmtMVwgvlCWIXdlNSISmktEc+Chtb/r17fmqYen2EMJgEmkH9LBS7MXaGKdgbdA==
X-Received: by 2002:a1c:c5cf:: with SMTP id v198mr12197070wmf.84.1558362897089;
        Mon, 20 May 2019 07:34:57 -0700 (PDT)
Received: from bender.baylibre.local (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id c2sm12756186wrr.13.2019.05.20.07.34.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 May 2019 07:34:56 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH net-next 1/2] net: stmmac: dwmac-meson: update with SPDX Licence identifier
Date:   Mon, 20 May 2019 16:34:49 +0200
Message-Id: <20190520143450.2143-2-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520143450.2143-1-narmstrong@baylibre.com>
References: <20190520143450.2143-1-narmstrong@baylibre.com>
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

