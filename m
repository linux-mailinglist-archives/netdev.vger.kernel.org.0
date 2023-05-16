Return-Path: <netdev+bounces-2889-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F0857046E0
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:50:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BE13281287
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:50:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B5519518;
	Tue, 16 May 2023 07:50:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787DAC2D3
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:50:02 +0000 (UTC)
X-Greylist: delayed 1218 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 May 2023 00:49:59 PDT
Received: from mail-177132.yeah.net (mail-177132.yeah.net [123.58.177.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 429AF1FCC;
	Tue, 16 May 2023 00:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yeah.net;
	s=s110527; h=Date:From:Subject:Message-ID:MIME-Version:
	Content-Type; bh=mTNDN550SBe+Qmpqj+ZWvWkotJk0mYyhGGjg0XR+pnU=;
	b=Bc0/WzAqwic59gTCEI6dhYTKWdSBU1j0FTkrAmZtIVaJaymYPQe4TMm/qfYJmm
	Ubkdohn/JHcSStbDDRw5D9rqtyh0CgUSRLF6PpcKleHMkSu69RADmU7HiayFv9KL
	9UzQ49w6jJ/m0BRizpHBux5uH7RruvE8PUyUUcjqu7NUk=
Received: from john-VirtualBox (unknown [111.18.136.15])
	by smtp2 (Coremail) with SMTP id C1UQrACXnV19LWNk_3Y6CA--.18933S2;
	Tue, 16 May 2023 15:15:09 +0800 (CST)
Date: Tue, 16 May 2023 15:15:09 +0800
From: Baozhu Ni <nibaozhu@yeah.net>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"moderated list:INTEL ETHERNET DRIVERS" <intel-wired-lan@lists.osuosl.org>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	Outreachy <outreachy@lists.linux.dev>
Subject: [PATCH] e1000e: Add desc after trailing whitespace
Message-ID: <20230516071509.GA3550@john-VirtualBox>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-CM-TRANSID:C1UQrACXnV19LWNk_3Y6CA--.18933S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKryfCry3CF1rWr1UJr13Arb_yoW3XrbE9r
	1Ivwn3GrZ8GFyFyF45CrWxZ34Ykw1DXrykAF93K3s5ZrWUJr48uryv9r1xJFs2gw1fJFyU
	AryaqF1fC3y2kjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUeructUUUUU==
X-Originating-IP: [111.18.136.15]
X-CM-SenderInfo: 5qlet0x2kxq5hhdkh0dhw/1tbiDh1xelszXaj9PAAAsE
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H3,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

./scripts/checkpatch.pl check error, so add description.

Signed-off-by: Baozhu Ni <nibaozhu@yeah.net>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 6f5c16aebcbf..cadeb5bc5e16 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -4198,7 +4198,7 @@ void e1000e_reset(struct e1000_adapter *adapter)
 
 /**
  * e1000e_trigger_lsc - trigger an LSC interrupt
- * @adapter: 
+ * @adapter: board private structure
  *
  * Fire a link status change interrupt to start the watchdog.
  **/
-- 
2.25.1


