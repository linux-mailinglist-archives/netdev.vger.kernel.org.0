Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAA733A7DE
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 21:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbhCNUTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 16:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhCNUSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 16:18:52 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D577C061574;
        Sun, 14 Mar 2021 13:18:52 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ga23-20020a17090b0397b02900c0b81bbcd4so13235099pjb.0;
        Sun, 14 Mar 2021 13:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZsjA6u5KqVwWCVQJoGoMMsT0yRwzlqjV0EQl7XQThrM=;
        b=iKLzYKnGiPUXq/0hntnFz2hjdUzfnQVe7o7Ai7mbltRfC/cQ15Zq9pQgK//Vbduh7O
         P+x26+jWi7WIWopdzaQYJjVzRIckpXI09rs9tLhxYY9hHVOykj30ZE2nC84r1lRZptAf
         oqKzu7txlpF6pzxB3WrxZ5tsf8ofR7Ut2A1sEkp46EnSwyiR6G9pMWZp9eylMXFAfrNE
         ap4X9neccB75KwibFRAZF/pAAqr34TtSOYyPYQRIRBcMhbqsAtphN+YPSE8iext9jVqa
         ggoMsCo/5i75/f+CT8NQU5YKTaUaK619lkAaZd1lncqgeQ87uexNB2W7ZuTkB9GUDg7N
         7r9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZsjA6u5KqVwWCVQJoGoMMsT0yRwzlqjV0EQl7XQThrM=;
        b=pfq0mgu8knOry7JjGUbkK3F4d7fU4XdCX8zkFsrRr7n4s4aJdr9tDgLiMcAZ8vzM0a
         mJC6WBxd+es1E3s+UYa2gI2TzoMTKGvMWBgaWeJPnzrG9TKHd1DOscFO7D4zB7xm1wCB
         MWo5ahtNA19FKEFxDco+ClX6NqtKlC5Ejr4NX+DL4ggyyNAHiEAOhzVP9MYIG99RcHE0
         dr9OqRXrftVWQ8c0HUTzX7WKWMzZuUvGvDgD8BpgyiLSmdNbFcni/9nALVnaewaEPCKZ
         c4KRBLLKy7d9RWHNRmQrSAUV3j/FDLBQHMheX0BE1Nj+vQotjua1Tw3PFNwT11329BqN
         nHIA==
X-Gm-Message-State: AOAM5334wEIMMfdzAhChWxKjmBcoWNZv0ykVWMgbpn68Xvjx82iCP53R
        EKfkwg19GepJAzDI8sEqGdg=
X-Google-Smtp-Source: ABdhPJwNvEjILF4VuJrPUgCWTeMNhxUWAI2rXM0zvdoDtvW/9TA8iGAQbF+JxlXRtUCvvdjpvTwHGQ==
X-Received: by 2002:a17:902:e2d4:b029:e4:be01:1d9a with SMTP id l20-20020a170902e2d4b02900e4be011d9amr8247099plc.43.1615753131720;
        Sun, 14 Mar 2021 13:18:51 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:acdc:a5a5:c438:c1e3])
        by smtp.googlemail.com with ESMTPSA id n10sm10943793pgk.91.2021.03.14.13.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 13:18:51 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     siva8118@gmail.com
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] rsi: rsi_mgmt: fix file header comment syntax
Date:   Mon, 15 Mar 2021 01:48:13 +0530
Message-Id: <20210314201818.27380-6-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210314201818.27380-1-yashsri421@gmail.com>
References: <20210314201818.27380-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.

The header comment used in drivers/net/wireless/rsi/rsi_mgmt.h
follows kernel-doc syntax, i.e. starts with '/**'. But the content
inside the comment does not comply with kernel-doc specifications (i.e.,
function, struct, etc).

This causes unwelcomed warning from kernel-doc:
"warning: wrong kernel-doc identifier on line:
 * Copyright (c) 2014 Redpine Signals Inc."

Replace this comment syntax with general comment format, i.e. '/*' to
prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/wireless/rsi/rsi_mgmt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 2ce2dcf57441..236b21482f38 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
-- 
2.17.1

