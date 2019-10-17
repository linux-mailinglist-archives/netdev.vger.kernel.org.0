Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7585DB5D9
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441321AbfJQSV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:21:57 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41534 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441250AbfJQSVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:21:55 -0400
Received: by mail-pf1-f195.google.com with SMTP id q7so2159794pfh.8
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yyCyPlQaHXoIoG0ZyCSv//v2+fsI3JceD15wWvxw1yw=;
        b=ufSwZsCS2UduFneFcSIrtySoyBmTHPTpnXYqGgZoYqRCRN6H4TUT0xsTpW13JPMcoZ
         RjkdMSe1OcpYNXVrAujMusPonVEoip2/DGgp7ED8qSpkq8y8O76IsVq/XNG5IMblXMnR
         H3fr/50IDPNhjTXONpU55p0iiVVFAG832LMbIRJ02eTWhyNdFvQv7ynefmXHADmnzSdw
         zoNoxNXJcQgEjGo76kKh1HTRzEyz9y2XUD0ewE4+DHbhIH8/AWHYz3Vya2y1Si9tKA/d
         IAuXSDq/k3RFZ3PPBnP/+5SceGsaO9Oyc9jpegxTDzoLyovytReRBsO2D2XzNCrkBMPB
         buIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yyCyPlQaHXoIoG0ZyCSv//v2+fsI3JceD15wWvxw1yw=;
        b=D0UDpUPF66k9SGP7joHY2eg7baGjHJTjbk2lZu7b44QUE1t+mYmbzJBSdqnMaEX3+Z
         GyGIzCtB6eLUz9W4/HDOX4ZoLB36q+GZrw3tROuVNoXvl1+O3R076zXTlNdHH1K/9a3p
         mAh5aXR7uVrH7OtSYfGHe2wc+GZatqgLqS5fpKMBTYR2y6gpjZx3nIHEesRjN3pFbef6
         Xs+v5tSzcEbG2iGdaqM03iEFa5nvMETGhnETe+fIFQZmIBNZ9Uy9T7uiiwsdYghlrfoP
         PqpovY5q1ueVKDfxh6QG/5VDiUy3CbFVsrIsnsa0cJYI0ytem3WyEJEibxSGvTlYBQuo
         0HKw==
X-Gm-Message-State: APjAAAVFtyi6XlGuYkcjfXHKDkL2rCMLOgP38Rz1LMzRpdA1x6dtmTQD
        zDEtZCkCWJzIWwR1RsLOMw96qVf1
X-Google-Smtp-Source: APXvYqxEtRlsSK1z0eKJaB1tee7RqpDn7cQk/vp/IkVdU0r3chLx3Tn6vBb5jjVusKT3WVQiCYKraA==
X-Received: by 2002:a63:5520:: with SMTP id j32mr5507985pgb.162.1571336512635;
        Thu, 17 Oct 2019 11:21:52 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:51 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 12/33] fix unused parameter warning in lan78xx_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:00 -0700
Message-Id: <20191017182121.103569-12-zenczykowski@gmail.com>
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
  external/ethtool/lan78xx.c:5:47: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  int lan78xx_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: Ibc67c27248ca623e9ca8534d43c888af3cf9997b
---
 lan78xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lan78xx.c b/lan78xx.c
index bb64e80..46ade1c 100644
--- a/lan78xx.c
+++ b/lan78xx.c
@@ -2,7 +2,8 @@
 #include <string.h>
 #include "internal.h"
 
-int lan78xx_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int lan78xx_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		      struct ethtool_regs *regs)
 {
 	unsigned int *lan78xx_reg = (unsigned int *)regs->data;
 
-- 
2.23.0.866.gb869b98d4c-goog

