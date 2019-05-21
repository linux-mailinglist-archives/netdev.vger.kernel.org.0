Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3982578B
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 20:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfEUS20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 14:28:26 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46243 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbfEUS2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 14:28:25 -0400
Received: by mail-pf1-f193.google.com with SMTP id y11so9467517pfm.13
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 11:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ck0uPtr7bXLodYgdeImNxgRE5JM837C4+WbENEh4sqw=;
        b=Glrdqtv5loBWDi+mKyJaDv6grqgDeVlye4MG1L7gXdEzuouS0XpLaXoXgiYwRyT8gF
         T78yo7vv3iPcB15SfQ3E4BODJqifW1Q4r9X8vCXVCeS7icHy4D3aDA0w1GN4j8dL3iSB
         dFPQRRxctwOeSz4cKjyM1MgjzN0mcWgrHdLEE4qz0RuuHnkra8369wFWNeMDurWxmtoB
         aphjt0T9rosirRcXe4yPm+9zD9N5FjSJ9qR21YyNFK66nBsHmUr6Lyjh/AtRoAF7jsOQ
         GKqHCkskxZEBiBrFSF2KUgl9MaNAtS5APeZjZCeQK01wtLQSkboeS6Ww0lyClXock4il
         pAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ck0uPtr7bXLodYgdeImNxgRE5JM837C4+WbENEh4sqw=;
        b=Z4uf3I3nQRBswWUxsZP4HnarsgI96SdxCgssUNBXMUyScuT48i5iTXRGlWEXvR88/q
         Tz9LkHTjnq2NxFeONrID+nSQmlm3Y/Qh8N43/IUJGhOPkW+xpDWxfmVgeGk7U5JXzTub
         uEpn2wwypTIZIsNy7AOiFtGR/GhdrIj2iWghXQ92bVelaFepsW+nJo74IzYgcYgvmm6q
         nk6O7qh9kTfr720m8x+J2yY8KJ3p01jMu3lMtN3E2ieGcnmVDf6GlryQvGW5qxxgQVeh
         mVBfXZwahayWNMlKyAurHkC14M+qmFTwKg4XiLypWyDI8sQ6DPw2UuDp987EDzvQVKsO
         rZdQ==
X-Gm-Message-State: APjAAAWpt/806YqP3kxbTuCK9MzCUp9PGyhyG1XH5WnR2pMc0PN/+kBq
        7kFKJwWQNZ0jA5/3NtxKfDrvSuSvLgc=
X-Google-Smtp-Source: APXvYqyek+gKQUDGPMEGwejjdLSnBHONNM28YEbqaXBySR2dzx9g15m98xqj7erFFfn/2Hi6SE4ytQ==
X-Received: by 2002:aa7:8d89:: with SMTP id i9mr89876096pfr.77.1558463304657;
        Tue, 21 May 2019 11:28:24 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k9sm25524670pfa.180.2019.05.21.11.28.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 11:28:23 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] man: fix macaddr section of ip-link
Date:   Tue, 21 May 2019 11:28:16 -0700
Message-Id: <20190521182816.19701-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The formatting of setting mac address was confusing.
Break lines and fix highlighting.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 man/man8/ip-link.8.in | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index d035a5c92ed5..883d88077d66 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -154,10 +154,15 @@ ip-link \- network device configuration
 .br
 .RB "[ " addrgenmode " { " eui64 " | " none " | " stable_secret " | " random " } ]"
 .br
-.RB "[ " macaddr " { " flush " | { " add " | " del " } "
-.IR MACADDR " | set [ "
-.IR MACADDR " [ "
-.IR MACADDR " [ ... ] ] ] } ]"
+.RB "[ " macaddr
+.RI "[ " MACADDR " ]"
+.br
+.in +10
+.RB "[ { " flush " | " add " | " del " } "
+.IR MACADDR " ]"
+.br
+.RB "[ " set
+.IR MACADDR " ] ]"
 .br
 
 .ti -8
-- 
2.20.1

