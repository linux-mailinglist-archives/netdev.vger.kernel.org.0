Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A62C2CD603
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbgLCMu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 07:50:57 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:47161 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389085AbgLCMu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:50:56 -0500
Received: from orion.localdomain ([95.118.71.13]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1Mf3yk-1kEByE4Ahe-00gYhv; Thu, 03 Dec 2020 13:48:09 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     rspringer@google.com, toddpoynor@google.com, benchan@chromium.org,
        rcy@google.com, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenzjulienne@suse.de, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 06/11] drivers: staging: qlge: remove unneeded MODULE_VERSION() call
Date:   Thu,  3 Dec 2020 13:47:58 +0100
Message-Id: <20201203124803.23390-6-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201203124803.23390-1-info@metux.net>
References: <20201203124803.23390-1-info@metux.net>
X-Provags-ID: V03:K1:cBKaZXJn0PaO0gZjofotydy/u2LaN3ERY88o9bVP8f6rx4XXaTI
 WNfMxy04qka7pvujlGMnyGN4k3gWrCIj+1tp/HAc0X5WtqDCkYOioxTM2jEtf3ZIZncfChC
 qVUNKyyblO8oHre+e56Df11V+LodaYmXLj15Hi2b4j7d3mwWPciFUer7y+08UuCW4t38T2D
 ehsmN5FRRh8FZ5gmOBLAw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9PodaIjvxg8=:sJqOJCZz20RQK7DfZp31Sx
 Fu8zC/Zz1DVKeTF9Z9Iq86wT8tM72zBpuOPSLnYnFaKvkkdQTVGgD7OJ5E1yVT30E2kn8HE7a
 Kixrw5wCxoVAAsm1w26VSqqnpY/AbYvOTougsTyzyWPneHe79j1KECVCp+j7AGoqQIJBb5B0y
 RGkqz0CP+jTm1NlPjE/yrQIwRA6wyzWjsmq7B9ia3rfKmaKvI3JIglTZQ8t+jBxAgMynVtzMZ
 amRn0XJumtPoO/YZ0hJFyvPkQndhvsejctWcCbKM1Svanm89Xw/lJ7Xgz+FFeY1QSBtMKNHw5
 vwaLuT39R0pzqAcS7ALtso8s3N/9kC0M55nCSarj/qIWKQnP30b1kuzcTUmEGSwJWtM0bPDNR
 mfvVorZbflQDLwMAw31/SmIH+veC3bVhOTVvz3Rnrem6IeFYGOyNSkjtGaDO+
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it doesn't seem to serve any practical purpose.
For in-tree drivers, the kernel version really matters. The module version
doesn't seem to be maintained and having much practical meaning anymore.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/staging/qlge/qlge_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 27da386f9d87..a98ee325ff32 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -49,7 +49,6 @@ const char qlge_driver_version[] = DRV_VERSION;
 MODULE_AUTHOR("Ron Mercer <ron.mercer@qlogic.com>");
 MODULE_DESCRIPTION(DRV_STRING " ");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
 
 static const u32 default_msg =
 	NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK |
-- 
2.11.0

