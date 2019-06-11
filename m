Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9902D3D13C
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405318AbfFKPpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:45:54 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57871 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404136AbfFKPpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:45:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 64BA6222CE;
        Tue, 11 Jun 2019 11:45:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 11:45:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Id1FsuWfuMLuDXQTFtG4cXkmKUewAjCCXjTGdBhK0AI=; b=o5GEogjn
        GgSGYHlYK3r8P2BGj9NoNKPIeSabW8QFdBD8CYuJ4MrXQoe4j53hWAjLe21kEygB
        UhbFm4uvDxy42lvoM1tzZdH9kggvZRPL4MdoUJVqZ6ZJcPs0KBN0Ko9G1WdDP94x
        qZi+3qqZSr+RkjtmsR/DnyMchAaxiSbinz68z9lFH5tksFInZsDnpxrf3o+hYTQT
        ETFB649+mXPWibUkAHR6lJNootyq/SY69NAPEVqPSwCNQ8rgCoMSjBk/jicDR9oe
        4nSRBlUEOsbDLi3Uwxmc7gjCoJjQ4v4OZKLG5Kj9StfweSOyDkO8um8AmPaLD2Q1
        s3tgeResVTPCDg==
X-ME-Sender: <xms:r8z_XPGLLK2vhwMCB5GQaikywjjoI7WrlIutEE3zt1KC4-sjqdPDIg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehhedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:r8z_XAUMcQQ6IpTkhoMhHbsUW5HDTQ6yd8czFRp7RkJkSIIb7qG-gg>
    <xmx:r8z_XBzROrPaKkRd-vg3VU1xslS3_Rn3NKYzTZnap8r22yK35mbHWg>
    <xmx:r8z_XM9-vcrNzBMW03w-EKDuPqaRZT_JW5zN_EOAhVU1E-JDJ-lb3w>
    <xmx:r8z_XCpNiZXiNMc0eB22kV9ZUPPtrzxDvxcmkQIYs-BWlBG62LCtxw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A024C380085;
        Tue, 11 Jun 2019 11:45:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        petrm@mellanox.com, richardcochran@gmail.com, olteanv@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 6/9] ptp: ptp_clock: Publish scaled_ppm_to_ppb
Date:   Tue, 11 Jun 2019 18:45:09 +0300
Message-Id: <20190611154512.17650-7-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611154512.17650-1-idosch@idosch.org>
References: <20190611154512.17650-1-idosch@idosch.org>
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
 drivers/ptp/ptp_clock.c          | 3 ++-
 include/linux/ptp_clock_kernel.h | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index e189fa1be21e..e60eab7f8a61 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -63,7 +63,7 @@ static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
 	spin_unlock_irqrestore(&queue->lock, flags);
 }
 
-static s32 scaled_ppm_to_ppb(long ppm)
+s32 scaled_ppm_to_ppb(long ppm)
 {
 	/*
 	 * The 'freq' field in the 'struct timex' is in parts per
@@ -82,6 +82,7 @@ static s32 scaled_ppm_to_ppb(long ppm)
 	ppb >>= 13;
 	return (s32) ppb;
 }
+EXPORT_SYMBOL(scaled_ppm_to_ppb);
 
 /* posix clock implementation */
 
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 28eb9c792522..93cc4f1d444a 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -212,6 +212,14 @@ extern void ptp_clock_event(struct ptp_clock *ptp,
 
 extern int ptp_clock_index(struct ptp_clock *ptp);
 
+/**
+ * scaled_ppm_to_ppb() - convert scaled ppm to ppb
+ *
+ * @ppm:    Parts per million, but with a 16 bit binary fractional field
+ */
+
+extern s32 scaled_ppm_to_ppb(long ppm);
+
 /**
  * ptp_find_pin() - obtain the pin index of a given auxiliary function
  *
-- 
2.20.1

