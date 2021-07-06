Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635F23BCC9A
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhGFLTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:19:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232803AbhGFLTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 071E861C52;
        Tue,  6 Jul 2021 11:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570189;
        bh=cVUpZ974XxVYD/7Fwp5542TVuNMT77tbrLYVujDkoW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dP+e42/TE9lkNTvaBl4kpp4na/HtYPQW5WbQ2X0tpF9SKltfyITrbTi0QKD9S9b6n
         4MISFoMgK8s4pC48IuC20zv61GESWTJfGLgYb00g0kSntQZAelPWkkSeyIVjszIkbU
         mqsVX1FUjZV+X+i7YfIv4T5dgmzOpmogl+lTgQ+KDpr6As4f0m1RzPolvcOGtAIpDn
         viQ4QeF0hAIe9rHgzK3hiavQqqp0fo+2TklDpcKw6Hq/FtFnlSxObCn98HEg3osE8/
         ePNdeps4nhozcQ3Rk2jtRf9v3spaCYCycccjP9Q+2404x00i1Ti7qeC36qLi5qJdHQ
         juD2G+Ltg3pWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 104/189] ibmvnic: fix kernel build warnings in build_hdr_descs_arr
Date:   Tue,  6 Jul 2021 07:12:44 -0400
Message-Id: <20210706111409.2058071-104-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lijun Pan <lijunp213@gmail.com>

[ Upstream commit 73214a690c50a134bd364e1a4430e0e7ac81a8d8 ]

Fix the following kernel build warnings:
drivers/net/ethernet/ibm/ibmvnic.c:1516: warning: Function parameter or member 'skb' not described in 'build_hdr_descs_arr'
drivers/net/ethernet/ibm/ibmvnic.c:1516: warning: Function parameter or member 'indir_arr' not described in 'build_hdr_descs_arr'
drivers/net/ethernet/ibm/ibmvnic.c:1516: warning: Excess function parameter 'txbuff' description in 'build_hdr_descs_arr'

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5788bb956d73..a764a5e615fa 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1502,7 +1502,8 @@ static int create_hdr_descs(u8 hdr_field, u8 *hdr_data, int len, int *hdr_len,
 
 /**
  * build_hdr_descs_arr - build a header descriptor array
- * @txbuff: tx buffer
+ * @skb: tx socket buffer
+ * @indir_arr: indirect array
  * @num_entries: number of descriptors to be sent
  * @hdr_field: bit field determining which headers will be sent
  *
-- 
2.30.2

