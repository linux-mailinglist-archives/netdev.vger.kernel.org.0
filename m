Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4BB34B2CE
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhCZXTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbhCZXSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:18:10 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0596C0613BD;
        Fri, 26 Mar 2021 16:18:07 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id s2so5412113qtx.10;
        Fri, 26 Mar 2021 16:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=79Z0/NPY7QvhQV2RNbg/BWSHnBPKin2d0GQjNBemZys=;
        b=P1gRZp6lN6E1edbYZARr/KMY2GAdey4KVwTYNuaK7fVQ2ZBlFMjygPD+DFLD4siT4m
         5ua9scxAR1eTUewvG8185jZmUv7yRRdOt3Dzn3Cppp/VKO8wez/KgCe26dp1Noz5gv9i
         jZoDfCUMtEHyAfPN0Sj8cvvS5VAnOpY4YWvDqS2yiNlRYfBPuOwjUqRk9SMqjNu7YRbw
         DqRU1Kd+TvTE9GCVuZvZqmaLTzRJI7FG7OxHHNtKcgB/Ij07Jrb+1l9c6voaN8XUnODx
         epZsHSeTJyNdn9lJdVlOnxnV5NbJ3CcUE/IsEDvd9XA0Wy7/reFQtJ2SwtMINvFy4pdN
         DQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=79Z0/NPY7QvhQV2RNbg/BWSHnBPKin2d0GQjNBemZys=;
        b=Yu5kswQDnH1iy0x1tqjgfoasONtdvd8DiqozMKfOg5VZ7co0h3VTiYiOwrpK1b0u5W
         ReyKuPMmKS0SIySbGYmYrhRXOY/nC8OXqszLiDqao2XBn6jWalhOaLB4vdFJ5c415f/v
         6kp5tU/BnqssLdu7bWJc7K9SIwlcvTX1fUAS58P7LBpR+arT+MljgO2oqmymoIFVesUL
         nPJG//gptB+of6EobSQYE+VYSOV9mvNmi0DjWznkI8W0g/p487zbQNvldPeXxf4lR1Q+
         OWMy8jpNr35SXrl079WgmFCZzgnfT9aU/oh/MPlv8fx4tuIh4Hoqu+AGk2W5yyLKV4Nz
         I9xw==
X-Gm-Message-State: AOAM533WHAS3gJgqgZ1dwPGzXwPl9JMTlZR5rYVinR9hlu/2MyDV3nZi
        SLZMlhsE2O2JdBkPyuoIMKqKE83RhdeakYan
X-Google-Smtp-Source: ABdhPJz2E/V7Yi0wnWDpzNHWHAkg5ZKhasDXbvVeKAlwEw2qJLXml5flHWe/04OYU5hxp6hVGGjqmw==
X-Received: by 2002:aed:2981:: with SMTP id o1mr13932801qtd.386.1616800686924;
        Fri, 26 Mar 2021 16:18:06 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:18:06 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 13/19] llc: llc_core.c: COuple of typo fixes
Date:   Sat, 27 Mar 2021 04:43:06 +0530
Message-Id: <df7672c227194629ba377c4b08903e58a892aa57.1616797633.git.unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/searchs/searches/  ...two different places.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/llc/llc_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/llc/llc_core.c b/net/llc/llc_core.c
index 64d4bef04e73..6e387aadffce 100644
--- a/net/llc/llc_core.c
+++ b/net/llc/llc_core.c
@@ -59,10 +59,10 @@ static struct llc_sap *__llc_sap_find(unsigned char sap_value)
 }

 /**
- *	llc_sap_find - searchs a SAP in station
+ *	llc_sap_find - searches a SAP in station
  *	@sap_value: sap to be found
  *
- *	Searchs for a sap in the sap list of the LLC's station upon the sap ID.
+ *	Searches for a sap in the sap list of the LLC's station upon the sap ID.
  *	If the sap is found it will be refcounted and the user will have to do
  *	a llc_sap_put after use.
  *	Returns the sap or %NULL if not found.
--
2.26.2

