Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC6020680C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388869AbgFWXJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388520AbgFWXJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:09:15 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55819C061573;
        Tue, 23 Jun 2020 16:09:15 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s10so348814pgm.0;
        Tue, 23 Jun 2020 16:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=20cLEjzx+rqddBqdsTZakkVLqM0BUzMvNhrL2tJ+gII=;
        b=KlPx64dLfhlELStyF076Q6a7CuZySJmGtp2w6ls7F7tR0bTGLhaanM9qTH4lMSMsaA
         MVml2WAFUdZ8/048Z8CjVFkMo6giXT+YLA5rQCtw/P14U/lQF2CXcKQFox/QDS9Bl2a3
         x5cap1MfS8YJrFaOdPZmCkgrVJZkdu/2ovXEMQyZH5KYFGxzAymmgIU1MY31U16Q9EY7
         ltgkalC39ECUfvtOEfNntlPMWRD3X2ycTbsdv3lTiGhS8NwwVKvDg5L0Kr3qYE4nY4pt
         U5eckWy+QJbsJlubFSWWZ48WzLuqWT7dXnDmKYcme8Kc9oDU5VFvPxWNZ3Pro/l3aI+I
         nYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=20cLEjzx+rqddBqdsTZakkVLqM0BUzMvNhrL2tJ+gII=;
        b=so974Yczq1kuBgrLkBmNbsnj3l7t0J0Ob+9Qm4TNaFgvtEYrwlflWMUM/1ZFLT8r4u
         r1DWmxFFgTEY78D222HRr0JuV0pb/qCu9Cwq3COn7psnGEctufIji7fPjNj1jbgN5sI0
         8Z+E0B/qHwGVPHc+Nq/p1F7Lo928bn8Sl5XpTu1t+Z031BcnC0GwImnCrbwXEx9BNsz6
         Z8SUGcJ9s6/3uiTjYBTltZ0DxZvHKkTt8RdKSQKd2tcrjovZXCSeuaNRd+Mj82C5hkcB
         Q4j1fOffYkExvVjPLtlVWUCaHC+vWlA4s/2BA6IXGazXFeDpQBlvt6YAeHZh56bgphFP
         TcAA==
X-Gm-Message-State: AOAM533pfZmKe4zyNd9BpimVqXQoPhJ4BB6EgcbLbaM3yublNf1rv432
        dTsqUY88VZEhPmP7fjiBtkA=
X-Google-Smtp-Source: ABdhPJxp02Ebd++0Lqh7vNPh/2xotDYYeQSH0iCdYhHZ7H+serJckU6zESKYdpcDWw6FyAOYFxg13w==
X-Received: by 2002:a63:8c4f:: with SMTP id q15mr17386899pgn.373.1592953754788;
        Tue, 23 Jun 2020 16:09:14 -0700 (PDT)
Received: from enonet.tok.corp.google.com ([2401:fa00:8f:2:8813:ed8e:96be:b3c7])
        by smtp.gmail.com with ESMTPSA id ev20sm3322314pjb.8.2020.06.23.16.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 16:09:14 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables] libxtables/xtables.c - compiler warning fixes for NO_SHARED_LIBS
Date:   Tue, 23 Jun 2020 16:09:02 -0700
Message-Id: <20200623230902.236511-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Fixes two issues with NO_SHARED_LIBS:
 - #include <dlfcn.h> is ifdef'ed out and thus dlclose()
   triggers an undeclared function compiler warning
 - dlreg_add() is unused and thus triggers an unused
   function warning

Test: builds without warnings
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 libxtables/xtables.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 7fe42580..8907ba20 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -206,6 +206,7 @@ struct xtables_target *xtables_targets;
 static bool xtables_fully_register_pending_match(struct xtables_match *me);
 static bool xtables_fully_register_pending_target(struct xtables_target *me);
 
+#ifndef NO_SHARED_LIBS
 /* registry for loaded shared objects to close later */
 struct dlreg {
 	struct dlreg *next;
@@ -237,6 +238,7 @@ static void dlreg_free(void)
 		dlreg = next;
 	}
 }
+#endif
 
 void xtables_init(void)
 {
@@ -267,7 +269,9 @@ void xtables_init(void)
 
 void xtables_fini(void)
 {
+#ifndef NO_SHARED_LIBS
 	dlreg_free();
+#endif
 }
 
 void xtables_set_nfproto(uint8_t nfproto)
-- 
2.27.0.111.gc72c7da667-goog

