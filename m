Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBB4DB5E8
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503263AbfJQSWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:20 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41581 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503258AbfJQSWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:18 -0400
Received: by mail-pf1-f194.google.com with SMTP id q7so2160549pfh.8
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RZc/3IGoBamMgBKIt9a+uKJeMslMrlLH2aTtu4QzL84=;
        b=LixpAJTYaUqu6zYi8LErE3DecIm5mtd5XdWfW2z3ERRWj0vOgfh0PTgwpN45lbx3rC
         5a/F5r7wRctEWORT4mjHBfilk0QyYkGwozdWdoALCI1sqkCWRlExx3gjv0jZQivY8hr5
         VTu/vUFmMfECwyPPQprFTqzMg+7LmVjYrmM42sN9UDKtrHhL/eQRlpkiJ5XHcLPtvyA9
         I4UppNSSO6m8qe/WCpdOHljiA6pPZveHYyYa9Kk6n8GoCM/2ByBYc1O6EXTC8iDpW0wm
         esf9vpthR4vFVmhKouqWDrIOaGUafTCQJcX0oT0egdoOhE+uLKqMz13nVNAf8C8OiQQG
         13tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RZc/3IGoBamMgBKIt9a+uKJeMslMrlLH2aTtu4QzL84=;
        b=sbm0N2aq9bbCJxc1sT4KN15BkmBG++3LL/OGFTeJzwPMZh33OC3ATk/O4TidOGn6py
         tLVkrusr40IEJh4YThlkAOi7lTFTvaDMcw/oHAwa//Xnl/kjuiPhI1JI+6YYkLJvU114
         fgsoDE6xUq4r8fE23Q0yeWxAcneim52eY7LXKk1FMKUGTb/4IwOrF82z+Q/R7FIBbJvL
         VkHEhIymsmBYzJZK7G6sxCgDpTL1qLtbMPFgqGBvJ3aB5AgMGTvDJzVwbfVt3AgalJ0p
         gKUDedDRUlieVghrSKK39nb3mUoPXeVnXz29vcOmi7M4GWoHsVPaWnkrcZR9JXuCdEBB
         gdzw==
X-Gm-Message-State: APjAAAUfKGUbMA1W0qvNux1PPVBAZA6Qo97ND8A+0MB45LOo+fA74bW2
        M3QUWKxBJ1CVIsg0uDnflyw=
X-Google-Smtp-Source: APXvYqyuU3wF3iDFrke31F72MxNUmDF2tgG8US3UUQSOHnRy8PDegOuwYC8w4cNkLulIOHpqEubS2Q==
X-Received: by 2002:a17:90a:c094:: with SMTP id o20mr6023251pjs.37.1571336537885;
        Thu, 17 Oct 2019 11:22:17 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:22:16 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 29/33] fix unused parameter warning in et131x_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:17 -0700
Message-Id: <20191017182121.103569-29-zenczykowski@gmail.com>
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
  external/ethtool/et131x.c:5:46: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  int et131x_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I4e90a489bdd3a0a04817149b1b6a86e7ef9f106d
---
 et131x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/et131x.c b/et131x.c
index 36abaa2..1b06071 100644
--- a/et131x.c
+++ b/et131x.c
@@ -2,7 +2,8 @@
 #include <string.h>
 #include "internal.h"
 
-int et131x_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int et131x_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		     struct ethtool_regs *regs)
 {
 	u8 version = (u8)(regs->version >> 24);
 	u32 *reg = (u32 *)regs->data;
-- 
2.23.0.866.gb869b98d4c-goog

