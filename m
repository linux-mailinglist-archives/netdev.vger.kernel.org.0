Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812473EF0F1
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhHQRaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhHQR3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 13:29:09 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F060C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 10:28:36 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso6405926pjh.5
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 10:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YiG0yf/5wgs/7bW0GtAApT1I94eSGtteWf/SCyGxK60=;
        b=Ab9w0u0f+XjH+v0VZ7oInuANGo0mNOViwHc1HjGyrPgONsg4iMEzLrsrpA9FaaqSnR
         22+d9QGjCMJO71WgC0f6H9v5cGG6iMz+12C3ZspYIQga4ujGt92KoURcP5Q+U/8wHra3
         h0Q3hL684ICK8OonsHjV6IlM//ovj6cabljsfs+AIN8HMGGfEUTezCaFW7aEj3PeNrSZ
         b5rnQ9C5o9XQ876AKzaHyh2Ew1fgnELQiDGo8g9MME7D7Cnat0aodUxMqOUT0sHd/ehN
         SYgSV3JO36M7hjLbaKg06Gs9Zxn5yKIVRhT0K0lj3LUi+iUaUZBq9WzbCoweW588IWxg
         sLAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YiG0yf/5wgs/7bW0GtAApT1I94eSGtteWf/SCyGxK60=;
        b=TZBNGWxAVdE0c0p21NateJnY/zp3wj0/zWd0yYq0j0BDphk0zpDKYnuWZpdpIl6zM3
         yvIk4z5WOQXq4deVK7FN9twijYm4U7v6DC0TTfn+TVvKUVr6vFsaKtvWtjguSRA09GhC
         NNkBHF11ZQi5I6CxoLdmwV1F90Qb8k05jARthemBNZkjc/SL+M3VezzVqaKr/JbMxyTw
         wgO1gpwg6TF4/qg1ty8hXFRlaPn70zcd8LtIk+Jkmfbee+1fn3kyeLFTBVN+ZItegqNh
         jsIOeDlo5hieiPjMZeo/YvQtacjYlxKkUSqU6wJUtJFgblmh/lv75T15ErdZoamCVdNl
         GY0Q==
X-Gm-Message-State: AOAM533g6PeZxj6d0MeHCoqtl7S3LZrG2hnq+/KlXemsHvibS8lN9OKJ
        eJhuvs4p3FJdJ7216QcEk4jTGLhNqHA7pEc1
X-Google-Smtp-Source: ABdhPJwD56RUEqAKTVsZq+kjRfQl3bIoVtTF2yL72ovLr8L5AGxiVtasHfZhH5Bo7viw4QCgApUY4g==
X-Received: by 2002:a17:902:ac87:b029:12d:3e59:cb7d with SMTP id h7-20020a170902ac87b029012d3e59cb7dmr3640415plr.22.1629221315796;
        Tue, 17 Aug 2021 10:28:35 -0700 (PDT)
Received: from lattitude.lan ([49.206.114.79])
        by smtp.googlemail.com with ESMTPSA id y5sm3872096pgs.27.2021.08.17.10.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 10:28:35 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>
Subject: [PATCH iproute2 v3 3/3] man: bridge: fix the typo to change "-c[lor]" into "-c[olor]" in man page
Date:   Tue, 17 Aug 2021 22:58:07 +0530
Message-Id: <20210817172807.3196427-4-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210817172807.3196427-1-gokulkumar792@gmail.com>
References: <20210817172807.3196427-1-gokulkumar792@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 3a1ca9a5b ("bridge: update man page for new color and json changes")
Signed-off-by: Gokul Sivakumar <gokulkumar792@gmail.com>
---
 man/man8/bridge.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index eec7df43..db83a2a6 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -22,7 +22,7 @@ bridge \- show / manipulate bridge addresses and devices
 \fB\-s\fR[\fItatistics\fR] |
 \fB\-n\fR[\fIetns\fR] name |
 \fB\-b\fR[\fIatch\fR] filename |
-\fB\-c\fR[\folor\fR] |
+\fB\-c\fR[\fIolor\fR] |
 \fB\-p\fR[\fIretty\fR] |
 \fB\-j\fR[\fIson\fR] |
 \fB\-o\fR[\fIneline\fr] }
-- 
2.25.1

