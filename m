Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436021CE77E
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 23:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgEKVeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 17:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725895AbgEKVeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 17:34:01 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251AFC061A0C;
        Mon, 11 May 2020 14:34:01 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a5so8490614pjh.2;
        Mon, 11 May 2020 14:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lbgIdJ/aL+x7yqr49pyrmYPxLoAsTpYoiESdy7iQrUY=;
        b=NqAHlu2A1agoX4CCVujsL6LsUQT0GKOG/1T+vxs7MNtyFVgRblmo3oBTkg/wFWqaep
         FwgINMXmFijwwBbqbfLm40dbySaZ2Bk1eqjfXKoabY0ZwQ5smyQNl6SoJkbQxCXyzZnY
         WYWuqFsdPhox5F4u8MdYT07MWimbU1uTA6MBGgSaZeheFmtI6OHxUM9hYDwwBg0nUNQr
         nLqAL7CQ2dPKUn4HhK8Ihin6yExQGdkjp+N0yxV+ESc5jAMVJQahJNRNyCzOO6GxmtXD
         youeJYnkEW5kKcC1SCzPxeiV2vL7XoMtiZx0RQy4sQGYT+JfeBpsfzSGJ++Usr71DNBw
         57UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lbgIdJ/aL+x7yqr49pyrmYPxLoAsTpYoiESdy7iQrUY=;
        b=V5JwJ0YJ3ERi7kFnr6gKT7R3/5FM3g/HCIgWd20eTPxcPgSvsdDdJolE/C/5bAmhdp
         +yMvZiMolL7jG7ad60GXsNz/xkZubzGBHBRcbINoe+kNvhbE1//fWUz+ncboqfyfmtCC
         18LGH0/BTXHpO48vaNOHNeJfUCKB4xXyh5snx0hNJJ3GOpVWtrmji3aQABIpAko0pNwo
         MTj2SF35V+yyq4aoid4zjXGcPIc84c1+Bf2j101rbIFEdA0PPK03vXMJXHmhX4Pl/jPI
         H00WdEcoNv2oqZ+DFkaFNPSUuku0FVx2+ounvGEhScphhYmM9YoAzu3ildxcLb5wZXa+
         73Lg==
X-Gm-Message-State: AGi0PuYJ7sGPEqb9SdU9pkD9h1icKHECtF/sVbWF09wl8bv53yWlmX9i
        hkbbc1HDKIeFsjHzwAg+BEk/1MZE
X-Google-Smtp-Source: APiQypIXEXsz03zbjw+rgJ+XcXRTDtPSai0/CzZvHBsVBvSv40QWrxAbTiCo2RNFo0OsNH0hYsnbJw==
X-Received: by 2002:a17:902:eb12:: with SMTP id l18mr17171749plb.269.1589232840552;
        Mon, 11 May 2020 14:34:00 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id c2sm10068665pfp.118.2020.05.11.14.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 14:33:59 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH] libip6t_srh.t: switch to lowercase, add /128 suffix, require success
Date:   Mon, 11 May 2020 14:33:49 -0700
Message-Id: <20200511213349.248618-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This looks like an oversight which is easy to fix.

Furthermore:
  git grep ';;OK'
does not find any other matches, so this is the last unverified test case.

Test:
  [root@f32vm IPT]# uname -r
  5.6.10-300.fc32.x86_64

  [root@f32vm IPT]# md5sum extensions/libip6t_srh.t
  b98864bdd6c39a0dd96022c47e652edb  extensions/libip6t_srh.t

  [root@f32vm IPT]# ./iptables-test.py extensions/libip6t_srh.t
  extensions/libip6t_srh.t: OK
  1 test files, 27 unit tests, 27 passed

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 extensions/libip6t_srh.t | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libip6t_srh.t b/extensions/libip6t_srh.t
index 07b54031..5b02a71b 100644
--- a/extensions/libip6t_srh.t
+++ b/extensions/libip6t_srh.t
@@ -23,6 +23,6 @@
 -m srh ! --srh-tag 0;=;OK
 -m srh --srh-next-hdr 17 --srh-segs-left-eq 1 --srh-last-entry-eq 4 --srh-tag 0;=;OK
 -m srh ! --srh-next-hdr 17 ! --srh-segs-left-eq 0 --srh-tag 0;=;OK
--m srh --srh-psid A::/64 --srh-nsid B:: --srh-lsid C::/0;;OK
--m srh ! --srh-psid A::/64 ! --srh-nsid B:: ! --srh-lsid C::/0;;OK
+-m srh --srh-psid a::/64 --srh-nsid b::/128 --srh-lsid c::/0;=;OK
+-m srh ! --srh-psid a::/64 ! --srh-nsid b::/128 ! --srh-lsid c::/0;=;OK
 -m srh;=;OK
-- 
2.26.2.645.ge9eca65c58-goog

