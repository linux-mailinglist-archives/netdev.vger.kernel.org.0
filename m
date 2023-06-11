Return-Path: <netdev+bounces-9952-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DAD772B495
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 00:25:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B25BD281106
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 22:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1DC156CF;
	Sun, 11 Jun 2023 22:25:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932BD107B4
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 22:25:29 +0000 (UTC)
X-Greylist: delayed 220 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 11 Jun 2023 15:25:26 PDT
Received: from pb-smtp21.pobox.com (pb-smtp21.pobox.com [173.228.157.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E84139;
	Sun, 11 Jun 2023 15:25:26 -0700 (PDT)
Received: from pb-smtp21.pobox.com (unknown [127.0.0.1])
	by pb-smtp21.pobox.com (Postfix) with ESMTP id EB5072C298;
	Sun, 11 Jun 2023 18:21:44 -0400 (EDT)
	(envelope-from tdavies@darkphysics.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=pobox.com; h=date:from
	:to:cc:subject:message-id:mime-version:content-type; s=sasl; bh=
	z+Ge1TsISNeopxsJaxZvRckLuWJjsX/bscizidOYUHY=; b=heK9KiFHa98/9xb4
	Syl79BqHipP7Lfncug0ygiCXtGxjxFZzs/LbKGIRTItHGW6Vdst280cqrA2Y8QcF
	o2xIp1zTreYsYEsmccLEZGou1O+35Kw+cyAxfTaqke52jsj1CSD6UH2i4WYwGc5I
	dH+3B/SUiLhBYcS15Xtb1X3BkPc=
Received: from pb-smtp21.sea.icgroup.com (unknown [127.0.0.1])
	by pb-smtp21.pobox.com (Postfix) with ESMTP id E2BB22C297;
	Sun, 11 Jun 2023 18:21:44 -0400 (EDT)
	(envelope-from tdavies@darkphysics.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=darkphysics.net;
 h=date:from:to:cc:subject:message-id:mime-version:content-type;
 s=2019-09.pbsmtp; bh=z+Ge1TsISNeopxsJaxZvRckLuWJjsX/bscizidOYUHY=;
 b=PwEIP3kNnqBbKve2G14PXwGOp/iZ8K1Iqj4naiQfNCPFmd9UlHLZFnen7JiGog0ylJYgKQLw04J06/i8b5g60IBYwDnwIPLVWBlXvmOlArRKXX+J3cum56pklDaPkHCrkGmTAuJgQjLIXoEIfxD3lrjROKHKvXx4XpLy4hqCFMg=
Received: from oatmeal.darkphysics (unknown [76.146.178.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by pb-smtp21.pobox.com (Postfix) with ESMTPSA id C31E22C295;
	Sun, 11 Jun 2023 18:21:41 -0400 (EDT)
	(envelope-from tdavies@darkphysics.net)
Date: Sun, 11 Jun 2023 15:21:36 -0700
From: Tree Davies <tdavies@darkphysics.net>
To: anthony.l.nguyen@intel.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com
Cc: tdavies@darkphysics.net, intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/e1000: Fix single statement blocks warning
Message-ID: <ZIZI5czU2Qv5KrPA@oatmeal.darkphysics>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="luNyGatCr/pDLYsq"
Content-Disposition: inline
X-Pobox-Relay-ID:
 57659C30-08A6-11EE-AE76-B31D44D1D7AA-45285927!pb-smtp21.pobox.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NO_DNS_FOR_FROM,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--luNyGatCr/pDLYsq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


--luNyGatCr/pDLYsq
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-net-e1000-Fix-single-statement-blocks-warning.patch"

From e92897ab5e93b8827d1654a0171bc53ab478ce49 Mon Sep 17 00:00:00 2001
From: Tree Davies <tdavies@darkphysics.net>
Date: Sun, 11 Jun 2023 14:41:31 -0700
Subject: [PATCH] net/e1000: Fix single statement blocks warning

This patch fixes checkpatch.pl warning of type:
WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Tree Davies <tdavies@darkphysics.net>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index da6e303ad99b..accc2bd7c35c 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -259,9 +259,8 @@ static int e1000_request_irq(struct e1000_adapter *adapter)
 
 	err = request_irq(adapter->pdev->irq, handler, irq_flags, netdev->name,
 			  netdev);
-	if (err) {
+	if (err)
 		e_err(probe, "Unable to allocate interrupt Error: %d\n", err);
-	}
 
 	return err;
 }
-- 
2.30.2


--luNyGatCr/pDLYsq--

