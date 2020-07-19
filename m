Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C9F225347
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 20:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgGSSIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 14:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgGSSIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 14:08:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB22C0619D2;
        Sun, 19 Jul 2020 11:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=CjAx2ZuJmPVQL3enQstJJutfTYC2ULsxOEx2XpHZ7DY=; b=b2ggWTL6CT/YZWMYsKcldH7BYD
        DnzZWG2QsV6d8PfAGKYfTIh+NMNG204tvNjKACUmb2xf09Rfqk+CamyvRzdpLHyVskwldJXc0OWcA
        BU9fd0PYMecDWz7AtohJho1gZcFOdj4q0Qwsj5W7IvbWllT4X7lry9/mse2UehygNj/r0jnhd4653
        5WbL7YPC/EgeAtVpKtPKO+JEeTD3lDVGgOO9bAdSaMIf0MhfOnvrAQmdW3n+yd1YTpTfGOC5UPB+o
        jdglfqShy7+qoI6iu268WWcceD1JzQQN6If2vo0YOAYDlj6hKok8BXOf3d0RM2dT9vw1x/UlvFTY4
        p8TMLh/Q==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxDjf-0006BA-26; Sun, 19 Jul 2020 18:08:28 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH] net: rds: rdma_transport.h: delete duplicated word
Date:   Sun, 19 Jul 2020 11:08:24 -0700
Message-Id: <20200719180824.12014-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the doubled word "be" in a comment.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
---
 net/rds/rdma_transport.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200717.orig/net/rds/rdma_transport.h
+++ linux-next-20200717/net/rds/rdma_transport.h
@@ -13,7 +13,7 @@
 
 /* Below reject reason is for legacy interoperability issue with non-linux
  * RDS endpoints where older version incompatibility is conveyed via value 1.
- * For future version(s), proper encoded reject reason should be be used.
+ * For future version(s), proper encoded reject reason should be used.
  */
 #define RDS_RDMA_REJ_INCOMPAT		1
 
