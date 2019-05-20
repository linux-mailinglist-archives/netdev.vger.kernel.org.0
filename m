Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 836F723A1E
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 16:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732990AbfETOfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 10:35:00 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38042 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731959AbfETOe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 10:34:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id t5so11947080wmh.3
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 07:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jL8EOSTC/B97Q4hYmRDMBEhteRV4Llk3yLW6XJX3YpI=;
        b=WOQGo5E3cBke6q8UgR21NkLOtOUFmM9cJSAy8j0HGje6MfYqcjKkfQ6zQhG+HrG6yP
         tVTmu021qWNJ0EP6J/uvHe/UnTsSzLi58ScfYOr8hRnQr1aEligQKbtbWPPuK0zd66MP
         OgqWP2IGRpvc7D6/qBR6k95C6yNMuUtOYM9cBWSH6Lrj4MFrDPneMgbYJIvK6/rXx1S/
         ZB6nb4s0sRBxmATJZi2b+oG+T3TB9sJTG0jbi0xUo12BwK8Lz/Ze/0t4jJLf1yn5CICi
         ClQSm0KVnlq8x/QxBtZ6K4ZNrpSOiB7b3gvmL0sd4Xg7uOjpyms8cGcVg+5y/SmlEesx
         R40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jL8EOSTC/B97Q4hYmRDMBEhteRV4Llk3yLW6XJX3YpI=;
        b=TqOaiIKNoIDDEJReubqb04Q085tvpk4gvLKDt61PIVXeUH19jqxpj82UiOHNJhJDPM
         Idd+H1KpfDhDLHC1QYL82BTuE3bIe5GjFddBlCm97U6VDW0NFPLPRWd9tSf2v3R0QfHs
         2iaTLM9YNFvhQbAfcW8EeSg2P02B3/0hrGIqrem5CIGTIkIXUsuIuB4K99hnSHM14ky2
         AgY7mrUTfw25ah5diu2F6Jl+MrIpga0tasvbp5ks6wmnJ9VS3TFKgN5Qs3SuUY9qih2q
         bVS4yKZ/5LsHjYqqY00jrFVayD86LBM+c60VTT7qGLD9NPGs0zbH9A7ZIz5GxHJHgiQN
         RtEw==
X-Gm-Message-State: APjAAAUUT6mPvKqPMLsiMpJ9Ylth79C9rZ5fj2yeW79q3eeruCEtmHx4
        ibTKMqJH2aVg+F0oRT7o6gyRBA==
X-Google-Smtp-Source: APXvYqxZ3+v/oE9giWxGxEusI5X93pq9x7W3ufJ2uNkz5Lh5e9NxuHzhkG+fIq3auPMxo0dZb4l8gw==
X-Received: by 2002:a7b:cd0e:: with SMTP id f14mr28896695wmj.127.1558362897942;
        Mon, 20 May 2019 07:34:57 -0700 (PDT)
Received: from bender.baylibre.local (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id c2sm12756186wrr.13.2019.05.20.07.34.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 May 2019 07:34:57 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH net-next 2/2] net: stmmac: dwmac-meson8b: update with SPDX Licence identifier
Date:   Mon, 20 May 2019 16:34:50 +0200
Message-Id: <20190520143450.2143-3-narmstrong@baylibre.com>
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

