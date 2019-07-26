Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 355B2773CB
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 00:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbfGZWAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 18:00:09 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:36976 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfGZWAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 18:00:09 -0400
Received: by mail-pl1-f171.google.com with SMTP id b3so25244651plr.4
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 15:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/CCOqmS5C7w1fAR2WjeuYtXmras455xqxfht3AZMo30=;
        b=gA6QNk3VJ0qqJNJP3lr6ayqerm+0GB6hYPTqEgGvIpJ3JEeizolAfol8G2BLnqef3U
         mZBkZu9hTtEyLVLadXO5h2emSsg8UYurVze5svqYPlmUvnkarxlpM6lxnWuVUJYoT9n+
         7fa7AcWgNioBCmdV0PCuFKTa9olFcl2X3e8irZWa8xHdcGJT7AhViUyyhH9OO7FQ0i6Q
         tiWOnDKOVKXqK9TI+qGmw3K3llfteIpCr1t06/vsk6q0O32IFC6rrKj7s5SHl3mDd1rJ
         0CGFpecT0MxtpWIT80NagDlBp88AlbDOUu0IoxGs1SBGrIPFwWOz+D3YUf1Iw1TFwEPG
         UU5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/CCOqmS5C7w1fAR2WjeuYtXmras455xqxfht3AZMo30=;
        b=Jpp9qmBomp2R624cr3kDC0IiluB9e/dj+xh7sbC4hMxaBTIGoyYnFCWYpodrzZM6cx
         P1UH5FOMIi6qew55Kqu2PJIGYSVhae0JZ/kXFfFgDmRHdsk1p4LaYdLdHF9UnAtduYXV
         Zezdu/bN23o4zSLcePFU4YW3ZSCX2dbXm8jcolu2HCio2dcOPlD5CqqIO3kyHQAQQXnz
         zOLkjaPpPywiy+1BIGEJx5LwXergFLYXV+SpLRo95uN9Ir4y9NCg92h10XhjBbrb0lfJ
         s0zz8u9WhB7YahC3LbntKSvrcAuj8a9Z3hL77XRSXhnYkVTT28ezJmkpAD2GB8T+N2s9
         jUeQ==
X-Gm-Message-State: APjAAAWNM4gMfYgbq/q/as8puXU/QvMFiPGPnqAdE9xIGGToy4FvW9OI
        AFNKUnAbC8h/+56BnbNOgmg=
X-Google-Smtp-Source: APXvYqymKT1zGNxA9XVDB7zfZZsIZjnkLuugoTx6yJFpuyZCCE8JNUy+mxJNbRFLUgdrr7Prt1v4YA==
X-Received: by 2002:a17:902:6b44:: with SMTP id g4mr97878597plt.152.1564178408117;
        Fri, 26 Jul 2019 15:00:08 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b190sm44253279pga.37.2019.07.26.15.00.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 15:00:07 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH] iplink: document 'change' option to ip link
Date:   Fri, 26 Jul 2019 14:59:59 -0700
Message-Id: <20190726215959.6312-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190724191218.11757-1-mcroce@redhat.com>
References: <20190724191218.11757-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the command alias "change" to man page.
Don't show it on usage, since it is not commonly used.

Reported-off-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 man/man8/ip-link.8.in | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 883d88077d66..a8ae72d2b097 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1815,6 +1815,11 @@ can move the system to an unpredictable state. The solution
 is to avoid changing several parameters with one
 .B ip link set
 call.
+The modifier
+.B change
+is equivalent to
+.BR "set" .
+
 
 .TP
 .BI dev " DEVICE "
-- 
2.20.1

