Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39AC32F4A
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 14:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfFCMN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 08:13:58 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39805 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727443AbfFCMN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 08:13:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1692622220;
        Mon,  3 Jun 2019 08:13:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 03 Jun 2019 08:13:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=9rMnshMfDv2wQAgs/9rNKxPutZBgYVLAoUSQk/HwrLs=; b=S4Xtknwu
        YXnvb9BNx6rQPbb5cBQNP+GkwGNeHEn4SyOhDlmHpCA76ay1H9P8HukASDevW6Du
        5+JKJZYenJDyRtnHVTgqtglPgzoYLvebd48vrTXE+Yc9jCbZWYxEOqRmDJLLOwv2
        sZF6Ty39XUHLxBSHSIzZEzrcuGbBEzMajtHRX+CHtEhtvtvQZpViv0SIxc04lzhT
        O9Go/nIAJ1jyag+5k21MKDbeYZ9H7Qf0HWIU2kU7m8Cn8pLtlgVHD+6tt2JlB37M
        SzhvNq/giBr/VuCzPOByX+z7iGmUXhUOHRfuh1oaiN3GCxDc/Tt2fn1V/IssEs7r
        da6ne6SGirTSSg==
X-ME-Sender: <xms:Aw_1XJ3eK8Z0nq0egU0oZy45BvHTwTwJxs6N1hoFYwfyxaCPKZGb2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefjedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedv
X-ME-Proxy: <xmx:Aw_1XI9IzvTaIKSViSrMNd1sC3NhwNB3vQSzne34UPXr9rHYGCOwUQ>
    <xmx:Aw_1XI0PJjNrppkSlAfaamB4ejWCXGFfR_cPEKaH2wytsNw5MfMbiQ>
    <xmx:Aw_1XA4BfsnrlauWSEmB-8Jfk7gMORMwftvi9-SQ2ZUJ33-2zlEOaA>
    <xmx:BA_1XDsONl6qHiD4-RNqttsom5vb7x-kB8M2Rx9ZAGaGX3fT1HJ4Jw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 76BD638008E;
        Mon,  3 Jun 2019 08:13:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        shalomt@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/9] ptp: ptp_clock: Publish scaled_ppm_to_ppb
Date:   Mon,  3 Jun 2019 15:12:41 +0300
Message-Id: <20190603121244.3398-7-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190603121244.3398-1-idosch@idosch.org>
References: <20190603121244.3398-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Publish scaled_ppm_to_ppb to allow drivers to use it.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/ptp/ptp_clock.c          | 5 +++--
 include/linux/ptp_clock_kernel.h | 8 ++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index e189fa1be21e..f0893953b503 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -63,7 +63,7 @@ static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
 	spin_unlock_irqrestore(&queue->lock, flags);
 }
 
-static s32 scaled_ppm_to_ppb(long ppm)
+s32 ptp_clock_scaled_ppm_to_ppb(long ppm)
 {
 	/*
 	 * The 'freq' field in the 'struct timex' is in parts per
@@ -82,6 +82,7 @@ static s32 scaled_ppm_to_ppb(long ppm)
 	ppb >>= 13;
 	return (s32) ppb;
 }
+EXPORT_SYMBOL(ptp_clock_scaled_ppm_to_ppb);
 
 /* posix clock implementation */
 
@@ -137,7 +138,7 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 		delta = ktime_to_ns(kt);
 		err = ops->adjtime(ops, delta);
 	} else if (tx->modes & ADJ_FREQUENCY) {
-		s32 ppb = scaled_ppm_to_ppb(tx->freq);
+		s32 ppb = ptp_clock_scaled_ppm_to_ppb(tx->freq);
 		if (ppb > ops->max_adj || ppb < -ops->max_adj)
 			return -ERANGE;
 		if (ops->adjfine)
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 28eb9c792522..fc59d57640a5 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -212,6 +212,14 @@ extern void ptp_clock_event(struct ptp_clock *ptp,
 
 extern int ptp_clock_index(struct ptp_clock *ptp);
 
+/**
+ * ptp_clock_scaled_ppm_to_ppb() - convert scaled ppm to ppb
+ *
+ * @ppm:    Parts per million, but with a 16 bit binary fractional field
+ */
+
+extern s32 ptp_clock_scaled_ppm_to_ppb(long ppm);
+
 /**
  * ptp_find_pin() - obtain the pin index of a given auxiliary function
  *
-- 
2.20.1

