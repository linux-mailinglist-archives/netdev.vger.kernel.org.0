Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9814DB5E5
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441369AbfJQSWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33228 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441351AbfJQSWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:14 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so2185847pfl.0
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HXULXO0OCwPTnAGyz+4bYzGuZIimx+tZMvJUVJwAJkI=;
        b=onUmpLMhNi5taZHo6LQPeRYnU2Rxk1pc8skkeJRV3AgwL8x9OXSOwtweJ+Dnpl9noH
         pb7fmbKs6nEqcXnrv4oAT2VBUFCuIcP6ReNDlzaS70/YMiLPRTXEdlf1wx/BjPjAk9rm
         2MuypHMcjXMdsJqioRr1NMjulyUfmyHpjkjG0xudYJTtqhrWBemcN9xWfTWGMOkLrcUP
         TSwxDsDmDIb1Xcbj2Bq0tdqZQIiNxTDm7ygvneEtwbusfoA7rPpuEixHJY9kEwoeKlcG
         8WglNedVm/iF80flT2tgNqtOYpZwLEy25rYRb/6wTh/81OTEARwxwVL3mnAlB0FJFtSr
         usdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HXULXO0OCwPTnAGyz+4bYzGuZIimx+tZMvJUVJwAJkI=;
        b=Y3BCQMt8Pyfafy5Rp3Bhvhg3MA0ojVa8DqbplFhh5BbmdsQG2AARKjbA+D+45T5MRf
         lN8eogkUDIDDJkFN+0oCUOba20NAZlHfzFegTv4ETjbW46P0OqZh1aqu0nkoqVnLSvBv
         nvAjKuLlNaLN6nCzcEVKKshgSgZZYrI2c1Ktb3IAj5qdu1a4I3Zt2HggY4R6XmZzsf35
         ggSBJZ0vA0/GMj5omV4sRJ8S+kdw3rRMt13IdGtHAzy8SCQ2bwjElOMNx061WUhuYE9f
         2VXF7cXHoG5DnTG1Brjxx5Oe6jvDNElPWfev5rv2beWMI1K/fIqFnOST9c4I6EOwWKiX
         5eOQ==
X-Gm-Message-State: APjAAAVBzk56jAQSm1pX20UTcNeOvPqTZlZ2SqYAB9PqbSNCiLzCtjGw
        w2pvq2jMEvXDXp2xNv1TQbdwCZ8H
X-Google-Smtp-Source: APXvYqxB/D9QVbXkv3+0L1LH/8lVOdt9iQolrrzgNp+7NwRnh87PFlUDQn7kHMr639ZWEG0MeZEkmg==
X-Received: by 2002:a63:330f:: with SMTP id z15mr5537376pgz.231.1571336533894;
        Thu, 17 Oct 2019 11:22:13 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:22:12 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 26/33] fix unused parameter warning in at76c50x_usb_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:14 -0700
Message-Id: <20191017182121.103569-26-zenczykowski@gmail.com>
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
  external/ethtool/at76c50x-usb.c:16:48: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  at76c50x_usb_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I4ca9edb1b155c63f14268aebf7bdc81bce53b85d
---
 at76c50x-usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/at76c50x-usb.c b/at76c50x-usb.c
index 39e24a4..0121e98 100644
--- a/at76c50x-usb.c
+++ b/at76c50x-usb.c
@@ -12,8 +12,8 @@ static char *hw_versions[] = {
         "     505AMX",
 };
 
-int
-at76c50x_usb_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int at76c50x_usb_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+			   struct ethtool_regs *regs)
 {
 	u8 version = (u8)(regs->version >> 24);
 	u8 rev_id = (u8)(regs->version);
-- 
2.23.0.866.gb869b98d4c-goog

