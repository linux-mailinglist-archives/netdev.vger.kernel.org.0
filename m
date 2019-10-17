Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B5ADB5E3
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441359AbfJQSWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:11 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41576 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441308AbfJQSV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:21:57 -0400
Received: by mail-pl1-f196.google.com with SMTP id t10so1511867plr.8
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/m6cTV5024fC+LTkSswLEt3l/RgTbfd6zHvF1HsR5uo=;
        b=XVTxT56IaZxs6A5qX1PrlYBNb6XRN/GW5aPVDh3OpC5ZM8CESffc7Zj8k9wx9MCALp
         NHmQMiiRMgPmPbfFjBGnnV0IrfNK9j5KlqsYcytzuw5Bc9NIseJ5sTDs+Tpti568JtPZ
         3NWRLgIq3nzr97fSTWZJrRzv977Efgd64qxfmraeCwhmN68042TFsFS+yUiMug33FKn7
         TJZOUEwP04MRE5fZfLwHwGdd7EZZtVa4o1ppVROYdWTz+wHBk5oW0jZnz30kNQvR8v5G
         T6ovHjBTs+70k5aQH+2Bg0mcHZb0/pOYtlGKrsSeO8w6JYcBIv3+69TwfvxwYChviXae
         jfEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/m6cTV5024fC+LTkSswLEt3l/RgTbfd6zHvF1HsR5uo=;
        b=KOg7gdc8mOlJgSYSLGXfzOL03xBU2cVubyg03Hp/47iSzCMLzMzXUj2fLhTQtEYIU+
         cHiebEiYALsiwbX2yksmZ1aUse744HqR0TNKJurFxKljaCvt4SRqKiVPK4Cebw8J8yei
         bobuA+WEGoTNGgYktxcKHW+Kkx6V/2oP4DcxGyU1KayArPYC0fjBtw+d+Pky5Wv+vki4
         wNIxvQbJPmVx293390jLjmbJWSMjpf7FGfhcaiNauN34HBgCHhuNmrc7lyx+tHxaPxDT
         hmMapdsQl78qVumiIZqVGos+boIwbpo3t6fmKGe5nFnGmVYrXL4mthKeQKztA3ktyXXr
         WFqQ==
X-Gm-Message-State: APjAAAUcI9M+PgscpElPexWzHar6pdjfvf1NHBu3EEKL7k+BhABIOMWu
        hodqbKKs/9jnrSKLYbUQyVQ=
X-Google-Smtp-Source: APXvYqxOYesKv18Au7/17V0S0BYsqRB7TWN+ZSRWLysA6ID3a4JjnYVuG8W5RPHDixqUxhz7fhXqiQ==
X-Received: by 2002:a17:902:6b88:: with SMTP id p8mr5118957plk.251.1571336516759;
        Thu, 17 Oct 2019 11:21:56 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:55 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 15/33] fix unused parameter warning in vmxnet3_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:03 -0700
Message-Id: <20191017182121.103569-15-zenczykowski@gmail.com>
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
  external/ethtool/vmxnet3.c:6:43: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  vmxnet3_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I5494339c8d17e72424651e7056605cd61aa6d4b8
---
 vmxnet3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/vmxnet3.c b/vmxnet3.c
index 621d02f..c972145 100644
--- a/vmxnet3.c
+++ b/vmxnet3.c
@@ -3,7 +3,8 @@
 #include "internal.h"
 
 int
-vmxnet3_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+vmxnet3_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		  struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
 	u32 version = regs->version;
-- 
2.23.0.866.gb869b98d4c-goog

