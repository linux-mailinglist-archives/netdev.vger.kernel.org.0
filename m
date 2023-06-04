Return-Path: <netdev+bounces-7729-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6031372142F
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 04:49:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCFF6281699
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 02:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E961F15D1;
	Sun,  4 Jun 2023 02:49:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE74315A5
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 02:49:22 +0000 (UTC)
X-Greylist: delayed 147 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 03 Jun 2023 19:49:17 PDT
Received: from pb-smtp2.pobox.com (pb-smtp2.pobox.com [64.147.108.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7EF3F2;
	Sat,  3 Jun 2023 19:49:17 -0700 (PDT)
Received: from pb-smtp2.pobox.com (unknown [127.0.0.1])
	by pb-smtp2.pobox.com (Postfix) with ESMTP id 56FF718FCCE;
	Sat,  3 Jun 2023 22:46:48 -0400 (EDT)
	(envelope-from tdavies@darkphysics.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=pobox.com; h=date:from
	:to:cc:subject:message-id:mime-version:content-type; s=sasl; bh=
	dqDBRzC7tcn7+DMkBVjjohLM8iy8N4hgg2tVjJuNb/4=; b=yhGJ8/xEZG7kopHr
	kdZBOQwNVvbFb4XSF9hvBLKevM/nZFg0X4K6TNE9d5DBQSlhqMOs049rhjr3TuoJ
	VRGFfzgNAh9wbckxGccfzEMV+MbJGQjIot+Hl9utM/SIkmtI+ftQwwl8qEDyseOG
	wq+yCSbZhCs6X4X4G8XFV/3ji8M=
Received: from pb-smtp2.nyi.icgroup.com (unknown [127.0.0.1])
	by pb-smtp2.pobox.com (Postfix) with ESMTP id 4D04D18FCCD;
	Sat,  3 Jun 2023 22:46:48 -0400 (EDT)
	(envelope-from tdavies@darkphysics.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=darkphysics.net;
 h=date:from:to:cc:subject:message-id:mime-version:content-type;
 s=2019-09.pbsmtp; bh=dqDBRzC7tcn7+DMkBVjjohLM8iy8N4hgg2tVjJuNb/4=;
 b=ZZypp/ISH1Lee9Io0GliZs/9oNn9OO4oO1KaewKaKbWb1t5snNrbEc0neN/Z3xCYsFFCXefpYcG7X+qkNyYhyZxPbAKdz9IYuIKcQhg+EtuCBalXExvj38XOJTyeH8NcT3FvcLT+t63wnUbPm0zIc2Atjya9YxEc5/Z92FnBZY8=
Received: from oatmeal.darkphysics (unknown [76.146.178.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by pb-smtp2.pobox.com (Postfix) with ESMTPSA id 020BD18FCCC;
	Sat,  3 Jun 2023 22:46:46 -0400 (EDT)
	(envelope-from tdavies@darkphysics.net)
Date: Sat, 3 Jun 2023 19:46:40 -0700
From: Tree Davies <tdavies@darkphysics.net>
To: anthony.l.nguyen@intel.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com
Cc: tdavies@darkphysics.net, intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Patch] net/e1000: Fix extern warnings
Message-ID: <ZHv7EDzikZPikoRh@oatmeal.darkphysics>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ELWD20BX7LFhUz03"
Content-Disposition: inline
X-Pobox-Relay-ID:
 0CB3580A-0282-11EE-BF0C-307A8E0A682E-45285927!pb-smtp2.pobox.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NO_DNS_FOR_FROM,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--ELWD20BX7LFhUz03
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


--ELWD20BX7LFhUz03
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-net-e1000-Fix-extern-warnings.patch"

From 407d0e4641d67118c954d36cc829c35300669fc8 Mon Sep 17 00:00:00 2001
From: Tree Davies <tdavies@darkphysics.net>
Date: Sat, 3 Jun 2023 19:02:06 -0700
Subject: [PATCH] net/e1000: Fix extern warnings

This patch fixes 11 checkpatch.pl warnings of type:
WARNING: externs should be avoided in .c files

Signed-off-by: Tree Davies <tdavies@darkphysics.net>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index da6e303ad99b..44f1bfba8a1a 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -63,14 +63,6 @@ static const struct pci_device_id e1000_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, e1000_pci_tbl);
 
-int e1000_up(struct e1000_adapter *adapter);
-void e1000_down(struct e1000_adapter *adapter);
-void e1000_reinit_locked(struct e1000_adapter *adapter);
-void e1000_reset(struct e1000_adapter *adapter);
-int e1000_setup_all_tx_resources(struct e1000_adapter *adapter);
-int e1000_setup_all_rx_resources(struct e1000_adapter *adapter);
-void e1000_free_all_tx_resources(struct e1000_adapter *adapter);
-void e1000_free_all_rx_resources(struct e1000_adapter *adapter);
 static int e1000_setup_tx_resources(struct e1000_adapter *adapter,
 				    struct e1000_tx_ring *txdr);
 static int e1000_setup_rx_resources(struct e1000_adapter *adapter,
@@ -79,7 +71,6 @@ static void e1000_free_tx_resources(struct e1000_adapter *adapter,
 				    struct e1000_tx_ring *tx_ring);
 static void e1000_free_rx_resources(struct e1000_adapter *adapter,
 				    struct e1000_rx_ring *rx_ring);
-void e1000_update_stats(struct e1000_adapter *adapter);
 
 static int e1000_init_module(void);
 static void e1000_exit_module(void);
@@ -87,8 +78,6 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
 static void e1000_remove(struct pci_dev *pdev);
 static int e1000_alloc_queues(struct e1000_adapter *adapter);
 static int e1000_sw_init(struct e1000_adapter *adapter);
-int e1000_open(struct net_device *netdev);
-int e1000_close(struct net_device *netdev);
 static void e1000_configure_tx(struct e1000_adapter *adapter);
 static void e1000_configure_rx(struct e1000_adapter *adapter);
 static void e1000_setup_rctl(struct e1000_adapter *adapter);
-- 
2.30.2


--ELWD20BX7LFhUz03--

