Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A5B224039
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 18:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgGQQKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 12:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgGQQKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 12:10:47 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E37C0619D4;
        Fri, 17 Jul 2020 09:10:46 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id e22so8130124edq.8;
        Fri, 17 Jul 2020 09:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K4sG738MbURXIMMMIi7Zp6H9aMqQB1Y7Bdr3nf17Kdk=;
        b=J5JChlwHPZAM4iIWaf1qXMMQS+Qh/XSGCaDJNUskE0aIw7hlxsSkaggbhpF4IXcpW6
         vTxF0rWXsK5Q8oQKsnvMf0qCgWOewdbUkJ93wO7JIw0qnD76KtxduZqWi0isskpt7Xx6
         cJhzg3bJpfUpEP3jioWZhDe1doATxlA4/TaVudRhdaYSp8CQink+v3zTqtcxd5HYvqNx
         1T/DXPVYJ2kafol29iGG6sVJ7X5ubQzLKB1SEr5u/UBc3qyWZVTU+7iTlXsFf44IaOwv
         yKHKuU/q7uNRHv/mSUKWHTb9D21dhs0erJRAAb2oQjJay7Lgev9gvQUp20jciqPhYWca
         89ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K4sG738MbURXIMMMIi7Zp6H9aMqQB1Y7Bdr3nf17Kdk=;
        b=ccRSlIj3sjY0O9IMD0FPNZG2hmaoMoCEH3GDhNSn2swGCDuVZO+6nIRAQeUmK4K2ZJ
         mFddm5gKyF7ZslVxO82qj1jK+ICINgtXrtTwlGLSXtF02T7lnGnJj2ajydGGH8aU91kt
         23Hs1/9LxP1zk9cv335bSS8DUrk82Wg15y3jhKanQBr7ZeaC8knKFtMAiJgYMOye9fts
         Qf6JkXBl3NV5k83uva/PdcNl8nZ2K/R2tFjyfzpEun/loxaQbqLsEPykt5MeGYkGUWVh
         GZA6cW7oB0LXnqGSsMSmGga1+AcnJoJMnuIDeDFP+m/hMB3g3bTsP6aHybW8jLS4Do3T
         E2kA==
X-Gm-Message-State: AOAM533jD0RCq8qpDzlFeCr6SepW9aStEmN9Gjb4d5tX5kA3ei45l8sb
        QfdLoZRG6y6Ar3IEAsHTeeE=
X-Google-Smtp-Source: ABdhPJwyjyGYXQ8dAmACicqp1imUPUmH4GWUq+zskNgcEvFNHDBMZYxJDzYEnCBRSoVzW1lnU4NaSQ==
X-Received: by 2002:a05:6402:203c:: with SMTP id ay28mr10258244edb.271.1595002245476;
        Fri, 17 Jul 2020 09:10:45 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id bc23sm8578253edb.90.2020.07.17.09.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 09:10:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, sorganov@gmail.com,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next 3/3] docs: networking: timestamping: add a set of frequently asked questions
Date:   Fri, 17 Jul 2020 19:10:27 +0300
Message-Id: <20200717161027.1408240-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200717161027.1408240-1-olteanv@gmail.com>
References: <20200717161027.1408240-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are some questions I had while trying to explain the behavior of
some drivers with respect to software timestamping. Answered with the
help of Richard Cochran.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 Documentation/networking/timestamping.rst | 26 +++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
index 4004c5d2771d..e01ec01179fe 100644
--- a/Documentation/networking/timestamping.rst
+++ b/Documentation/networking/timestamping.rst
@@ -791,3 +791,29 @@ The correct solution to this problem is to implement the PHY timestamping
 requirements in the MAC driver found broken, and submit as a bug fix patch to
 netdev@vger.kernel.org. See :ref:`Documentation/process/stable-kernel-rules.rst
 <stable_kernel_rules>` for more details.
+
+3.4 Frequently asked questions
+------------------------------
+
+Q: When should drivers set SKBTX_IN_PROGRESS?
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+When the interface they represent offers both ``SOF_TIMESTAMPING_TX_HARDWARE``
+and ``SOF_TIMESTAMPING_TX_SOFTWARE``.
+Originally, the network stack could deliver either a hardware or a software
+time stamp, but not both. This flag prevents software timestamp delivery.
+This restriction was eventually lifted via the ``SOF_TIMESTAMPING_OPT_TX_SWHW``
+option, but still the original behavior is preserved as the default.
+
+Q: Should drivers that don't offer SOF_TIMESTAMPING_TX_SOFTWARE call skb_tx_timestamp()?
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+The ``skb_clone_tx_timestamp()`` function from its body helps with propagation
+of TX timestamps from PTP PHYs, and the required placement of this call is the
+same as for software TX timestamping.
+Additionally, since PTP is broken on ports with timestamping PHYs and unmet
+requirements, the consequence is that any driver which may be ever coupled to
+a timestamping-capable PHY in ``netdev->phydev`` should call at least
+``skb_clone_tx_timestamp()``. However, calling the higher-level
+``skb_tx_timestamp()`` instead achieves the same purpose, but also offers
+additional compliance to ``SOF_TIMESTAMPING_TX_SOFTWARE``.
-- 
2.25.1

