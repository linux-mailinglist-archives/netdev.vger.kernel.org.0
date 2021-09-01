Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C216E3FE43C
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 22:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhIAUsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 16:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbhIAUsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 16:48:01 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B097C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 13:47:04 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id r13so775060pff.7
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 13:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oGcfzRwuEjNqiUqIVpLt//YpwLSRZMlFKC0ZRLUko74=;
        b=qoDZg+vePOJRZyN1NhSWEbHXW3BdONQqywd/fS0PGReDWljIuwu0P+gQAoKkmupz5G
         Gr98/0GOrIxYWdahgtLHRjheKEntI+/BknXwJJUY4D2AGsqCvrVZnDIwVVglIvR9pXKr
         +2oDzkk5yGNijHkuBaJTN4cccJTtGIEHz9M0YHgF2kslfsYxUAvUSPw5jAmWi3VMIOAy
         sUoU1wVA/z9MoKlR7bYIuGp+0PY8MUzWNHWau44t4AGvL5PDNuCQzjD+GCkkWpe7iNbi
         RJE4misQYrWK0qKPgLqWIJ7sIDCIL+DyGhpIHTlNM61SWDFKKVia2kZ0W/zpXPMPuDph
         UhAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oGcfzRwuEjNqiUqIVpLt//YpwLSRZMlFKC0ZRLUko74=;
        b=CzkdPKUHIY9vX08uIhFHcDOY2qVbhz30kEb0Ntt2uBi2HrB0bjJbmHTT9wjLMVWrPv
         ma/a1o4SDDSGLSVCFz2GQPu1ph3pLwRRm2MY65sXhf75pBo5r2qT4ReRgg6k/19flK0z
         ndSlACTi3q4kl8PkZUxGw6hCb4iYamwM0MZYdqCbXKcHMrfPXFheoOf4AGQLelbD4JbU
         +AEDLRPPRiJW2MkBnHGpLH89LjRxwBEC/xTTrYnfqHaEOpyij7CSWwHwZUmmZj//dpqo
         U9rk269xlmfIc/JDVKHQS9DEEenIsbVYlmJoBEeyHvwc0yCMWiYjQK7tv7yp0XuZD9ZA
         my5w==
X-Gm-Message-State: AOAM533nZcD/wtyYwyubSKL1KRWeFTxstsUcYDjFBsl/C/hj6qLBVIsR
        XdRCd1P0EiGVe/XLGd6Fto+5spzjxrJu3A==
X-Google-Smtp-Source: ABdhPJwEUGGUukS1Y4KC+NYn5u4EN9CzTcanjT5GqOTJwWq1YW4guqi+pO5fvckq40SrDyHQvGEfpg==
X-Received: by 2002:a63:145a:: with SMTP id 26mr849782pgu.243.1630529223556;
        Wed, 01 Sep 2021 13:47:03 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id g26sm565073pgb.45.2021.09.01.13.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 13:47:02 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH iproute2-next 0/4] Cleanup of ip scripts
Date:   Wed,  1 Sep 2021 13:46:57 -0700
Message-Id: <20210901204701.19646-1-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove several old useless scripts and fix the routel script
by rewriting it.

Stephen Hemminger (4):
  ip: remove old rtpr script
  ip: remove ifcfg script
  ip: remove routef script
  ip: rewrite routel in python

 ip/Makefile       |   2 +-
 ip/ifcfg          | 150 ----------------------------------------------
 ip/routef         |  10 ----
 ip/routel         | 124 ++++++++++++++++++--------------------
 ip/rtpr           |   5 --
 man/man8/ifcfg.8  |  48 ---------------
 man/man8/routef.8 |   1 -
 man/man8/routel.8 |  17 ++----
 man/man8/rtpr.8   |  25 --------
 9 files changed, 64 insertions(+), 318 deletions(-)
 delete mode 100755 ip/ifcfg
 delete mode 100755 ip/routef
 delete mode 100755 ip/rtpr
 delete mode 100644 man/man8/ifcfg.8
 delete mode 100644 man/man8/routef.8
 delete mode 100644 man/man8/rtpr.8

-- 
2.30.2


Stephen Hemminger (4):
  ip: remove old rtpr script
  ip: remove ifcfg script
  ip: remove routef script
  ip: rewrite routel in python

 ip/Makefile       |   2 +-
 ip/ifcfg          | 150 ----------------------------------------------
 ip/routef         |  10 ----
 ip/routel         | 124 ++++++++++++++++++--------------------
 ip/rtpr           |   5 --
 man/man8/ifcfg.8  |  48 ---------------
 man/man8/routef.8 |   1 -
 man/man8/routel.8 |  36 ++++++-----
 man/man8/rtpr.8   |  25 --------
 9 files changed, 79 insertions(+), 322 deletions(-)
 delete mode 100755 ip/ifcfg
 delete mode 100755 ip/routef
 delete mode 100755 ip/rtpr
 delete mode 100644 man/man8/ifcfg.8
 delete mode 100644 man/man8/routef.8
 delete mode 100644 man/man8/rtpr.8

-- 
2.30.2

