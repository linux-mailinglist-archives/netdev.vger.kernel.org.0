Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 542E7DB603
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503214AbfJQSVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:21:48 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33173 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503189AbfJQSVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:21:44 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so2184946pfl.0
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ltCQH58XCbU6xC1frQPXYEowAn2dp9czm82hSYbkVao=;
        b=pTSvnCL3HEb1PNjf0CDcX/zGTprwDx9o7zcTp/z/MQLKqwONOD8Z1XmLvRQZC/C06O
         uGCW5QfMFZP/4czWdqL+CXHUq8EfyaR6bt4kwENiOxzYjTe0uPsNkMTdaor/N2D59S6V
         lX02SGvDVRHZ5iDJVouRPxJ+G+cL4JksUPQVNRxCffT00JZ1r4m+Zvg6k/HjrwijJAwh
         hzPkXsnTMm9Y5qhImDnnqm48zJa8WAeeDokRaVSW5wrxEb32Iq5scxPkVNn5jhf8sUJl
         7ZgsyGRxcQ+YNv66V9HB8p+FiKVXCQXLnjjZwyVK7nQPEUa/gGWOk4R9e4F6+UZYKd1s
         lCww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ltCQH58XCbU6xC1frQPXYEowAn2dp9czm82hSYbkVao=;
        b=QWY1BfpS1MgPW469p/hPfGjDWJbrxhfmLY+WwC5zxT5UQopCiEzPieYITeWDbWsHnd
         rcugwdFaTH2rHrNOgM/cHmPv7X0SJ602a0OlsXRde7k5N8WtqZNF4nGhn49Attpl40n5
         A4EFTMH7YroNnU177XFBQcv2yRJ0utgIxXk/gavRTELnb1XiipgFKuTqKcPUZJcK/7qW
         cfF686xkFcYie3aQoBlenJjk2d0ZZc/mesxSho+nKtTRVEhmrokiuBE8ppOQRp1ITBPZ
         mb3ocU85FyebT7M6zVbGymyDLt10HjXimQq7FgqM0qzJCXY1xek0jVrKaVJ79pTmhKeK
         HuVQ==
X-Gm-Message-State: APjAAAWAoVwJr9w1UXCf4T0gRLiWK+b1upMiSIhqcEfVvbijOffIoTwt
        /u/vSMRxjF3ly/wd8ATSg9TEXWCs
X-Google-Smtp-Source: APXvYqz9qVr4IwhoXu8Ho+HCBKv9Xd5xwrKxa4v395vdEIOEAaCqWd/iBo1hduLfxE0RlTMDafRZBA==
X-Received: by 2002:a17:90a:20cb:: with SMTP id f69mr5745562pjg.110.1571336502253;
        Thu, 17 Oct 2019 11:21:42 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:41 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 04/33] fix unused parameter warning in dump_eeprom()
Date:   Thu, 17 Oct 2019 11:20:52 -0700
Message-Id: <20191017182121.103569-4-zenczykowski@gmail.com>
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
  external/ethtool/ethtool.c:1271:70: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  static int dump_eeprom(int geeprom_dump_raw, struct ethtool_drvinfo *info,

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I57c65a8d21c6864d4c09f37bb3d408348ea03c4f
---
 ethtool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ethtool.c b/ethtool.c
index 0f3fe7f..acf183d 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -1275,7 +1275,8 @@ nested:
 	return 0;
 }
 
-static int dump_eeprom(int geeprom_dump_raw, struct ethtool_drvinfo *info,
+static int dump_eeprom(int geeprom_dump_raw,
+		       struct ethtool_drvinfo *info maybe_unused,
 		       struct ethtool_eeprom *ee)
 {
 	if (geeprom_dump_raw) {
-- 
2.23.0.866.gb869b98d4c-goog

