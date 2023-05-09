Return-Path: <netdev+bounces-1105-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EDC06FC368
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:04:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C9CD281191
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C82C2D1;
	Tue,  9 May 2023 10:04:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B668A53B2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102B2C433D2;
	Tue,  9 May 2023 10:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683626670;
	bh=478tQNtd0bYwq0TBSEOC3ofnei1ThTQcsDZ0NkuIvwQ=;
	h=From:To:Cc:Subject:Date:From;
	b=ZcRsqRbmqX45semrAv+8Zi+zdyK/evTHP7peNB9Msqpi75O/PUuhuzK66l7RO8yKI
	 HBrF0jkIbrr+GwU+KV/YBHRI5dT1qVnu5Vx0LW4I/tzqr19X6tUqT4c7t/1JuHnXAe
	 yKd3iEs0M3UeI8RTdEJFf1es8wGwGYjC6SrfHv2DfyuipqiX/mcRfV3o1TDC61g8/H
	 frMRq/t+wLhoaA0fGERSRkOteC7OhaGdMiZ/kvYGr5k0P5EGoXgAnyElXkPMhS//Go
	 K8KCN+WoyDxnbrNTItKp/ytL9HFdeZs+Hzmxb+T8R2TRNL30pSocfZGQklZ8BfOGTu
	 fKpzzZvvvy3Ug==
From: matthias.bgg@kernel.org
To: Arend van Spriel <aspriel@gmail.com>,
	Franky Lin <franky.lin@broadcom.com>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: brcm80211-dev-list.pdl@broadcom.com,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hans de Goede <hdegoede@redhat.com>,
	SHA-cyfmac-dev-list@infineon.com,
	Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
	Matthias Brugger <mbrugger@suse.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] wifi: brcmfmac: wcc: Add debug messages
Date: Tue,  9 May 2023 12:04:20 +0200
Message-Id: <20230509100420.26094-1-matthias.bgg@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Matthias Brugger <mbrugger@suse.com>

The message is attach and detach function are merly for debugging,
change them from pr_err to pr_debug.

Signed-off-by: Matthias Brugger <mbrugger@suse.com>

---

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c
index 02de99818efa..5573a47766ad 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c
@@ -12,13 +12,13 @@
 
 static int brcmf_wcc_attach(struct brcmf_pub *drvr)
 {
-	pr_err("%s: executing\n", __func__);
+	pr_debug("%s: executing\n", __func__);
 	return 0;
 }
 
 static void brcmf_wcc_detach(struct brcmf_pub *drvr)
 {
-	pr_err("%s: executing\n", __func__);
+	pr_debug("%s: executing\n", __func__);
 }
 
 const struct brcmf_fwvid_ops brcmf_wcc_ops = {
-- 
2.40.1


