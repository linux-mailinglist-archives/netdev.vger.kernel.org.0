Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D844827A0
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 13:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbiAAMio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 07:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiAAMio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jan 2022 07:38:44 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8F2C061574
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 04:38:43 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id z3so21787522plg.8
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 04:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=dKee10LPOQ8lHJfO6IhvX7z329Z/K3nO+p+MPBHNtPw=;
        b=CkYUegwmIGlXEAJFldbB0y1S5XEEA/94386iiUK7BwOFyS0twFtENoSJYJJiEM0oBx
         bjv5qgPs7F5KivzO8ACC0ukpkgnk/unhf1/aGISdu7yHVhzAIaVvhryeeU4HyGNZxKeS
         7VLhxHSns+yP+HRtyiSXb+qnFclqSP3+QCwAzFyDpfXQdI9q4npqzbXcNkLmot0Ycwxw
         tK0n+cOCtnhTx2ZjPl9Xyny501UYm2sJSUCsohjoxebiRcA4XoZShI0VsH1uPNk83J7D
         AqB+tbwsuPm0rzpn7x7SR1s7GJvcXQRs3uWVKfKEEpby9nFCnAvLtUmgrI9hL37HaxlA
         FBMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=dKee10LPOQ8lHJfO6IhvX7z329Z/K3nO+p+MPBHNtPw=;
        b=61fnsFfFktVG6PhrTIt/Oem227ETj4KTG9JBQ7XHnkfmePO24neMmpEOnaWKu8AeDv
         clWfPXlRbSeS6rMatguEW95nLWAQ60HpvgaSt+J/Qd4kRmnr9ZjvXS0TrVA35X3qzG3A
         yoPByWLtuO+5gdsNkLIX6EuR+s7sfj/TxptAQaDn/DHovFUpgBZtqAVLyUR3J/ReBUSw
         t5ef2FQ+soHe8oTmTnoqLHHZfGw9hxXuXSMOe9aWP31dYtfIiguyY0X87gSSNwF2H/42
         eb16X2IsPdKB/8RiSERTUZaYFssKD6fnfWWGRXtLCQ8aypVMpJbhFSGoQlgdM+ONh/0X
         //Cw==
X-Gm-Message-State: AOAM531TwPfSryceHbqTzOxZ+FV9k2R6v6uo43b1L/nLV4P186lPZ3ap
        CA7BBzqIkdMcEgIWNaOW4kcaSEM8C68=
X-Google-Smtp-Source: ABdhPJw2a2ejs+rxhEB8CZO+kOUV5D4SAuIGHEsovzwPLMLglltbSi4mECZBZ4xdtgzv3VEKsPW2Qw==
X-Received: by 2002:a17:90b:3ec5:: with SMTP id rm5mr47175833pjb.100.1641040723134;
        Sat, 01 Jan 2022 04:38:43 -0800 (PST)
Received: from elusivenode-Oryx-Pro ([121.210.74.231])
        by smtp.gmail.com with ESMTPSA id 72sm31731620pfu.70.2022.01.01.04.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Jan 2022 04:38:42 -0800 (PST)
Date:   Sat, 1 Jan 2022 22:38:25 +1000
From:   Hamish MacDonald <elusivenode@gmail.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net: socket.c: style fix
Message-ID: <20220101123825.GA28230@elusivenode-Oryx-Pro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removed spaces and added a tab that was causing an error on checkpatch

Signed-off-by: Hamish MacDonald <elusivenode@gmail.com>
---
 net/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index 7f64a6eccf63..f492a324f7f8 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1946,7 +1946,7 @@ int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
 	err = sock->ops->getname(sock, (struct sockaddr *)&address, 0);
 	if (err < 0)
 		goto out_put;
-        /* "err" is actually length in this case */
+	/* "err" is actually length in this case */
 	err = move_addr_to_user(&address, err, usockaddr, usockaddr_len);
 
 out_put:
-- 
2.25.1

