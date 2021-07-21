Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A613D0696
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 04:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhGUBXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 21:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbhGUBXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 21:23:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAB5C061574;
        Tue, 20 Jul 2021 19:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=9ZdDeoeJBVHasYACD/U9e1/n6aWpbckywvGfg+hXFTo=; b=tocW9ftMAovoUtTPs67DWlJ+PE
        +O6opCRNAC0OR23uJBWO+H/gDeaD/PNJ5C2A0VRAUQsUmcE/sO5goUAhXzDFVQ9UenoM9AV6Nkdtb
        SiXsIidoLpmRluQE4U3LnLAPThQd4jEbsnVzHpSMAOQiFUZll4tP6Z6Gi7sm56Zcrf2DMaUIl3EE8
        QX2rIo0wnN3HJveksaPBa1X6AY5ZSqqfnZTP28Wl4JHrUiLrDrhRvx2lWXjh9OhiV65qAkNUmYpE7
        eL7rPpFbNAK7qPJiReQsdrdu9pNjNT4JVjNZIUAcDCr8MRSd6AuRLuSUyj+78WaeCocXE1bwLEm1N
        9nzQ+GOA==;
Received: from [2601:1c0:6280:3f0::a22f] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m61aG-008hYY-ML; Wed, 21 Jul 2021 02:03:49 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Aditya Srivastava <yashsri421@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH] bluetooth: btrsi: use non-kernel-doc comment for copyright
Date:   Tue, 20 Jul 2021 19:03:34 -0700
Message-Id: <20210721020334.3129-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel-doc complains about a non-kernel-doc comment that uses "/**"
to begin the comment, so change it to just "/*".

drivers/bluetooth/btrsi.c:2: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * Copyright (c) 2017 Redpine Signals Inc.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Aditya Srivastava <yashsri421@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: linux-bluetooth@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
Cc: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/bluetooth/btrsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20210720.orig/drivers/bluetooth/btrsi.c
+++ linux-next-20210720/drivers/bluetooth/btrsi.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2017 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
