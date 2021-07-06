Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1339B3BD019
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbhGFLcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234045AbhGFL24 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:28:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6954361D5E;
        Tue,  6 Jul 2021 11:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570426;
        bh=9FgXrg546LF12QfPPvKq2AJJdYzvM69rjMX+fXMsaG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLu0u/BAJtr0LxqWL3FmV+34aEVHQ88ZQ2L/rVU5suHsVA01VaFcSHOf6nK/QHWC0
         UPW9m4S+lZ7FWT1itbXhjFdRRNoFmCdg3xEgJCUGprBdUDyTigATWIGuZAdDqf0iSn
         1O1+5xj+Fhf31VlxIPivP1/DxyeE3aA/RpybEqyOil5Xb0Fq0JqdFMQPDNGMVnV9HM
         JSRfC0SqM5qFo0eg/L5AlMJerMzVeIVW28jiQwYywsrFSThunFpoH3fk4RPEBmgdA2
         etX9DKYa498DtAK3IojZ2SFRmJgVXM0AQlf1jVIlCAXs5mj0rc4Zhh/zOqnt81ntvj
         lOZyhBJSg9XMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 089/160] ibmvnic: fix kernel build warnings in build_hdr_descs_arr
Date:   Tue,  6 Jul 2021 07:17:15 -0400
Message-Id: <20210706111827.2060499-89-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index ffb2a91750c7..a0d30ece6c04 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1476,7 +1476,8 @@ static int create_hdr_descs(u8 hdr_field, u8 *hdr_data, int len, int *hdr_len,
 
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

