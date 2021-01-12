Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11592F2872
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 07:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387801AbhALGns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 01:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729325AbhALGns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 01:43:48 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DD7C061575
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:07 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id j8so356793oon.3
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7nyJJKBRqvDvGLBaux0uBtTdhziNfFzJW2Ok8rMkyHo=;
        b=BDPVcXB+iU7YRIXhQzhibd9XxPn4rnQj5jaLSgdbxSKCJx1UI7nG/E4WF3KBndzmEG
         uJl4sADsnpa2W0D7qlCOcnsuEpvtN0XVQC8u4QRA6klhLLY/fZUe3tOa9yMJqjWPBoWA
         6ZQglwi/e975ui7rpzLX5QUbgJsc0SqzpbjhGwvZgd/OitESFo7U+WKgTKJuIDSTyoay
         Ye1dh4XoT3ZRT0nxZQEhGEa7iJant+VUBsnihTpBNGjxlK4ntEAT0TXs8JIgEXDENlV6
         gCNqNyHPxb5nyKXQ9iG4r33Bu2mnLRB3lLFayH0O0W9cX900Ak+X4uXgTuEM7VtEcdBM
         zN2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7nyJJKBRqvDvGLBaux0uBtTdhziNfFzJW2Ok8rMkyHo=;
        b=krSEUvwt2py+ZBARiZC6Q1UsqD1u10DCpsL0W7v1rZcIdD2HbhwrBaHnXeKuuVJmGO
         JUXMdqaD03W1mYcZ3RloWgh2n86b1EHYlKVwLfHVgQLVN/cnKX9s8XE2ePzK/R//5Eha
         NkfKXPg+ycYg0rI7TwoMheErj9JCLWVYhiMy7XuvM3Dl+jIwV/F4xnZEf7aLhwHxBwIw
         Ww4UZzMdgqSpzERMxQmE8ccRwNXn1hnKJ0O8d6nJDPkCkotkDe/D10iZTXrPa1I7bVpG
         RMnShQuq305SK8ScmPW81F6/yR5UYuh9hJK/J2UOspwaE1VvbQOejlbQbPzKSM86HKVs
         yOlA==
X-Gm-Message-State: AOAM533BgNKlHGvkcQgDYW2P05vn2Ccg9zGBsYJMENnOlExLH6bv0uY1
        mYyBUErsAeSww4+3h2lUKyweq8VMs8X8VQ==
X-Google-Smtp-Source: ABdhPJzEq4hjE6XBapQ03cbuOHtA/SIbvTkk7tZM3x65wwAcMCFhr7gV0ga5SV1dFAXEadqbqAOrcQ==
X-Received: by 2002:a4a:e81d:: with SMTP id b29mr1965137oob.22.1610433786908;
        Mon, 11 Jan 2021 22:43:06 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:ddc5:e91b:d3cf:e2ba])
        by smtp.gmail.com with ESMTPSA id 94sm482271otw.41.2021.01.11.22.43.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 22:43:06 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next 0/7] a set of fixes of coding style
Date:   Tue, 12 Jan 2021 00:42:58 -0600
Message-Id: <20210112064305.31606-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series address several coding style problems.

Lijun Pan (7):
  ibmvnic: prefer 'unsigned long' over 'unsigned long int'
  ibmvnic: fix block comments
  ibmvnic: fix braces
  ibmvnic: avoid multiple line dereference
  ibmvnic: fix miscellaneous checks
  ibmvnic: add comments for spinlock_t definitions
  ibmvnic: remove unused spinlock_t stats_lock definition

 drivers/net/ethernet/ibm/ibmvnic.c | 65 +++++++++++++-----------------
 drivers/net/ethernet/ibm/ibmvnic.h | 11 ++---
 2 files changed, 35 insertions(+), 41 deletions(-)

-- 
2.23.0

