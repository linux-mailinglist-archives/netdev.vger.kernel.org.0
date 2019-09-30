Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB87DC285B
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732054AbfI3VMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:12:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50322 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731802AbfI3VMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:12:54 -0400
Received: by mail-wm1-f65.google.com with SMTP id 5so982641wmg.0
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 14:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X5TBVXkGBF3Up21B+a9o0PZ8LbEhHWuKc4xupoakIB0=;
        b=diWYWJDUnNlO8NVZeFeqXBWdqfjb6960znPb7yeeCLtAPUy5ycMZINUtZgDKtuTRYw
         QoRNK04/iVTJXqTCvwSOIJaOWjShNfR/At2JBMiybobSeLA/MNtLoeo7UOXq4cUL65rv
         /HLed8dgXNV6eUVW2fWfgh3hC7rN81uG8zueZhjbwukxHMoxiz3XnxBxy8GffFad3Ssb
         t9HgiYE32OoBaPFOhwGuUie8j2lQs916c0IBS+CHDammhllGPAVircnGH1e9P3K6ubPX
         /BKwo+yR1c+C4CQ5iuWFzr+FsD8PasWd/xx4kHszzkEX89SqxRWapu8kGfJk1Hkhrqfs
         G3KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X5TBVXkGBF3Up21B+a9o0PZ8LbEhHWuKc4xupoakIB0=;
        b=B0HUhH+EEL3I5O+QBIGNx1Z5qrVrUisvUlmdwzOCrw13BRamAFCY/vOYTUfi3hxqMC
         XFuvfphbbM1+wgjWcbmjysv8YwS55IDr91Vvjl26Bl0LWTIATpzUV9m8vlm6jWiqIF9d
         mGyVI5dCIbbne9owDTXJs4x55lnwtLWXU2Om2V7tCxlGyPH/VAuVeSudxYb8OSxVMoJx
         YAQzAIwGH/bSXybuh/2+WgvTs5Rl/DEyIqyeDhIeBvtvu+SlQFqylSo9gYrki/3Eo0vh
         7DSpH3IR54fdIohAEuOFyn5ixjnc1KkMvh3vRkJ1CRuOWtWSoRNQULVBkgxQkZ8BI+f4
         Do/w==
X-Gm-Message-State: APjAAAWjXk3lXdb0/hyTcX5xVNkcf41Aul+oAQTX35yELw52vnSAagB1
        pfMG7EDKI2WjG+E6r1iMsf4=
X-Google-Smtp-Source: APXvYqxwGTklIPfqPhJXNXGjp5eFpDSdKuQ6AfQOyuuiRHilzxaaU+eNr8kZl+ngVCYXKnZIxgDQsQ==
X-Received: by 2002:a7b:c398:: with SMTP id s24mr891512wmj.78.1569877971825;
        Mon, 30 Sep 2019 14:12:51 -0700 (PDT)
Received: from localhost.localdomain (87-231-246-247.rev.numericable.fr. [87.231.246.247])
        by smtp.gmail.com with ESMTPSA id v6sm1353623wma.24.2019.09.30.14.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 14:12:51 -0700 (PDT)
From:   Damien Robert <damien.olivier.robert@gmail.com>
X-Google-Original-From: Damien Robert <damien.olivier.robert+git@gmail.com>
To:     stephen@networkplumber.org
Cc:     Damien Robert <damien.olivier.robert+git@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH 1/1] man: add reference to `ip route add encap ... src`
Date:   Mon, 30 Sep 2019 23:11:37 +0200
Message-Id: <20190930211137.337516-1-damien.olivier.robert+git@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ability to specify the source adresse for 'encap ip' / 'encap ip6'
was added in commit 94a8722f2f78f04c47678cf864ac234a38366709 but the man
page was not updated.

Also fixes a missing page in ip-route.8.in.

Signed-off-by: Damien Robert <damien.olivier.robert+git@gmail.com>
---
Apologies if this is the wrong way to send patches for iproute2.

 man/man8/ip-route.8.in | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/man/man8/ip-route.8.in b/man/man8/ip-route.8.in
index a61b263e..34763cc3 100644
--- a/man/man8/ip-route.8.in
+++ b/man/man8/ip-route.8.in
@@ -206,6 +206,8 @@ throw " | " unreachable " | " prohibit " | " blackhole " | " nat " ]"
 .IR TUNNEL_ID
 .B  dst
 .IR REMOTE_IP " [ "
+.B src
+.IR SRC " ] ["
 .B tos
 .IR TOS " ] ["
 .B  ttl
@@ -740,11 +742,13 @@ is a set of encapsulation attributes specific to the
 .I TUNNEL_ID
 .B  dst
 .IR REMOTE_IP " [ "
+.B src
+.IR SRC " ] ["
 .B tos
 .IR TOS " ] ["
 .B  ttl
 .IR TTL " ] [ "
-.BR key " ] [" csum " ] [ " seq " ] "
+.BR key " ] [ " csum " ] [ " seq " ] "
 .in -2
 .sp
 
-- 
Patched on top of v5.3.0-35-g0d82ee99 (git version 2.23.0)

