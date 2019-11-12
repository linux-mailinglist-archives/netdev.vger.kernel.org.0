Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56079F9D17
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 23:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKLWcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 17:32:19 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33027 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbfKLWcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 17:32:19 -0500
Received: by mail-pg1-f195.google.com with SMTP id h27so12832316pgn.0
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 14:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=8fxgjMNqMkGnSKEvc2C3MzlGGdDVhd+xsdFMkD2s8O0=;
        b=b5AF2Mmh1soMuFVhsiSziMgJu3yCS7DK/znU8c3AOXRdG36HwJnegI0S4hm42eDidX
         Gl9KvFgo31SrCGwElwYWtQhuP9GzDhFjR+foAEAfGIqrcWSfja651RkmQzIxicAbWyPE
         n0M7Kt6hTx+EBVWFhZ58NNgQ9d2kd5x1M+6RLlRA9p3n5IGrqQlgffvbv2UFz9+ZUuEZ
         V05ssMryiB1kbZp1QgvsdqUFe9eF+WG3rElQBTEk0jS6CQB01c9Pd7EZ3sBluHWI56ar
         a93MeKK3USz3duPpLLbHuM7q33HhAvCMPpUt7x0I/Av7GyfVSdKPJmY99mzwWXL06GsB
         CojA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=8fxgjMNqMkGnSKEvc2C3MzlGGdDVhd+xsdFMkD2s8O0=;
        b=Te9tGZ3IMKas544T9/W4Pr70VYEavi//v94/VbP8p38GF3PgumjZdwwbtcAffqQSta
         riK3m7jiocQ2nWVc1SQnzc+ysdeuylrJdkoHiKAf3fsRmR7pImiRixZFBOXuz7Upjgb6
         ZNMyDUdX4WOGSaknleFuZRygnz5cKEp8pXkfXFhXhVU8hOgGUffz3N4o9MKbOKzwRxpF
         mu9UawVDKdygTpCxYBlFRUnNduoLoy+H2kuMH+wDS1mw+Gh6d+dBXAeg0TSiGhk/3JQW
         28nzMUBj4NEbh21u5A6q75jx/AOc2VOQenAzKAHRF7O6+CyLKDHNwhPB0qg3epYuoLLP
         hygQ==
X-Gm-Message-State: APjAAAXuG+eSu6M+5pI4D9U0+dPYBgZTnLA9jiDWAoCSu8t+LJdleKnw
        oSg4wSXWo0V2Wumb0GkFOeHAAC9r060=
X-Google-Smtp-Source: APXvYqyqw3Bf9ijNRW/7HEm9+SoEf+M8CuznTdTcgNacz00xfrnjyKPvqxR9e3zsN70GBx+bkQHhjA==
X-Received: by 2002:a62:7c91:: with SMTP id x139mr297093pfc.119.1573597938281;
        Tue, 12 Nov 2019 14:32:18 -0800 (PST)
Received: from Journey.localdomain ([45.112.69.238])
        by smtp.gmail.com with ESMTPSA id l33sm6361pgb.79.2019.11.12.14.32.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 14:32:17 -0800 (PST)
From:   Hritik Vijay <hritikxx8@gmail.com>
X-Google-Original-From: Hritik Vijay <Hritikxx8@gmail.com>
Date:   Wed, 13 Nov 2019 04:02:12 +0530
To:     netdev@vger.kernel.org
Subject: [PATCH] Show header for --processes/-p in ss
Message-ID: <20191112223212.GA173366@Journey.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


From 9b8bdd8bac2efae19d267e0262a795694590eaaf Mon Sep 17 00:00:00 2001
From: Hritik Vijay <hritikxx8@gmail.com>
Date: Wed, 13 Nov 2019 03:57:02 +0530
Subject: [PATCH] Show header for --processes/-p

ss by default shows headers for every column but omits it for --processes
for no apparent reason. This patch adds the "Process" header.

Signed-off-by: Hritik Vijay <hritikxx8@gmail.com>
---
 misc/ss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/misc/ss.c b/misc/ss.c
index efa87781..794c1895 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -133,6 +133,7 @@ enum col_id {
 	COL_RADDR,
 	COL_RSERV,
 	COL_EXT,
+	COL_PROC,
 	COL_MAX
 };
 
@@ -160,6 +161,7 @@ static struct column columns[] = {
 	{ ALIGN_LEFT,	"Port",			"",	0, 0, 0 },
 	{ ALIGN_RIGHT,	"Peer Address:",	" ",	0, 0, 0 },
 	{ ALIGN_LEFT,	"Port",			"",	0, 0, 0 },
+	{ ALIGN_LEFT,	"Process",		"",	0, 0, 0 },
 	{ ALIGN_LEFT,	"",			"",	0, 0, 0 },
 };
 
-- 
2.17.1

