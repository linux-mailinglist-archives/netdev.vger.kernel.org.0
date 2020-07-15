Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E9D2212D8
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgGOQnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgGOQmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:42:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490DBC061755;
        Wed, 15 Jul 2020 09:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=J/Nj7cakMWC9zRzrNKsSvW3BAo+rPjXjpVsN8Iiqtp4=; b=k+zcfuYkUPeXtfLFXqYwbw7ptD
        9FQm277+V3gwzLMV7wZdJzRX5a7t6yavZSeDUneCwlxaaQDxaNggWJPj5ir6dqJWuAe8j36b4GNaV
        OpOT3YZxaicF2DEgYwq/K9Xn1cikr9Wt/1hcohGL10i6rLlBNC/R3uaXQ+rzXRmyRVMVBu6x9Pofc
        crAGSzS6aS7ktqta5ZvGBnygp+fdzl51HcDJnXgSe9ca2yK+9VlgqVXAqAD17InyaTca1l//Xc41g
        /NJfCqoBzqFPZ7axn5y1desYShbz8j+H7SYbt3Cg82dwSmQToPULODr232A4dCH1bojS3PYtx9Gse
        bvrbezAg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvkUc-0000Bh-Tj; Wed, 15 Jul 2020 16:42:51 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 1/9 v2 net-next] net: qed: drop duplicate words in comments
Date:   Wed, 15 Jul 2020 09:42:38 -0700
Message-Id: <20200715164246.9054-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled word "the" in two comments.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
v2: move wireless patches to a separate patch series.

 include/linux/qed/qed_chain.h |    2 +-
 include/linux/qed/qed_if.h    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200714.orig/include/linux/qed/qed_chain.h
+++ linux-next-20200714/include/linux/qed/qed_chain.h
@@ -130,7 +130,7 @@ struct qed_chain {
 	} pbl_sp;
 
 	/* Address of first page of the chain - the address is required
-	 * for fastpath operation [consume/produce] but only for the the SINGLE
+	 * for fastpath operation [consume/produce] but only for the SINGLE
 	 * flavour which isn't considered fastpath [== SPQ].
 	 */
 	void *p_virt_addr;
--- linux-next-20200714.orig/include/linux/qed/qed_if.h
+++ linux-next-20200714/include/linux/qed/qed_if.h
@@ -498,7 +498,7 @@ struct qed_fcoe_pf_params {
 	u8 bdq_pbl_num_entries[2];
 };
 
-/* Most of the the parameters below are described in the FW iSCSI / TCP HSI */
+/* Most of the parameters below are described in the FW iSCSI / TCP HSI */
 struct qed_iscsi_pf_params {
 	u64 glbl_q_params_addr;
 	u64 bdq_pbl_base_addr[3];
