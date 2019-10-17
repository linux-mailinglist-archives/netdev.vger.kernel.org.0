Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD16DB5D5
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503218AbfJQSVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:21:49 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41155 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503202AbfJQSVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:21:47 -0400
Received: by mail-pg1-f193.google.com with SMTP id t3so1814127pga.8
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FwN5eoleijw1bwB/u7U25AK5bQbAfvkNF7vhCimFGuI=;
        b=oDvHrh+KTcSV9kc/226UoRalE2SnWkWu5fmnEjsixLTBj+6SshWuETzGVQg4KCZ8fx
         QzX9itUoymZbADudmZPo8363vlrllyP37FJNmDhYwK3gAqwJ0lnI+kHjnFTlkO3k7Ubn
         ebzhU3wsNGnQXosPS3V2Sr2RYC/sv+Ow5UXyDqlcv+wYQ0reU6R07bMnPXQ7psX5GBf1
         8CfLsd4749cTg5jYQB96lJc5TsVp4nxxcRMNuomqlXlRiXxg5xjUBItK0uP6pDt+UiCa
         AGTxP/PInzBrVtpz+AwrM09JRuFiqwQT6Sm4lb4GdQf7dxe4sT3gLiWaIqLfc0Ha2+k3
         PMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FwN5eoleijw1bwB/u7U25AK5bQbAfvkNF7vhCimFGuI=;
        b=kpn9ISzZvMheMbvrAL9pARrF8FbcjUuL2dO7RwEMaJyZg8hUmHgKRipCeRef2lDwfQ
         w9LaCVAcIW7BTL5/m2ja8Gkl17RzlDhT+n2wsPbD3p0Ea9+KkFJb96Oo1tbUTmJ7dB8d
         kX2p3io5OVaGTB0BaJFrm8JtGjT13ljyUX4tZ0a+eW4jOJqmrhal9F9PueegZ8ax7MnA
         0Csih1RFQ4rWOa9Sk5JsU2LAzXsARmnsZEtLeyqaCIoohI+5B3jRcjYq51Du4YgbJ7Ev
         u9lw2Z81Km90DbdHLsJxpcgjIabAIwgK5dj46pQSIgF7Sprmi0/yYyaVqM8n1Yl1O4ib
         0+AA==
X-Gm-Message-State: APjAAAW0/NW6h55nEeb8G0yxTTpKgfzk3NoncWSmfUoHim4Lejizk4Iq
        PHA8dKE5pvEUtoymVrkNh2BwWm0X
X-Google-Smtp-Source: APXvYqyY080PPVUD7kcMSvfeJSYUqlyzJVIXunxe73Xt+w6VdyDdxITaaLqaAHLpxndh+pQsQBm5jw==
X-Received: by 2002:a17:90a:8d82:: with SMTP id d2mr6077604pjo.31.1571336506069;
        Thu, 17 Oct 2019 11:21:46 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:45 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 07/33] fix unused parameter warning in print_simple_table()
Date:   Thu, 17 Oct 2019 11:20:55 -0700
Message-Id: <20191017182121.103569-7-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
In-Reply-To: <20191017182121.103569-1-zenczykowski@gmail.com>
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
 <20191017182121.103569-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This fixes:
  external/ethtool/sfc.c:3811:29: error: unused parameter 'revision' [-Werror,-Wunused-parameter]
  print_simple_table(unsigned revision, const struct efx_nic_reg_table *table,

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I253158a534c295b13e13dd02461952927cf8814c
---
 sfc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sfc.c b/sfc.c
index 69c61e2..f56243d 100644
--- a/sfc.c
+++ b/sfc.c
@@ -3808,8 +3808,7 @@ print_single_register(unsigned revision, const struct efx_nic_reg *reg,
 }
 
 static const void *
-print_simple_table(unsigned revision, const struct efx_nic_reg_table *table,
-		   const void *buf)
+print_simple_table(const struct efx_nic_reg_table *table, const void *buf)
 {
 	const struct efx_nic_reg_field *field = &table->fields[0];
 	size_t value_width = (field->width + 3) >> 2;
@@ -3918,7 +3917,7 @@ sfc_dump_regs(struct ethtool_drvinfo *info maybe_unused, struct ethtool_regs *re
 		    revision <= table->max_revision) {
 			printf("\n%s:\n", table->name);
 			if (table->field_count == 1)
-				buf = print_simple_table(revision, table, buf);
+				buf = print_simple_table(table, buf);
 			else
 				buf = print_complex_table(revision, table, buf);
 		}
-- 
2.23.0.866.gb869b98d4c-goog

