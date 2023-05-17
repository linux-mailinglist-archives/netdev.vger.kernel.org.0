Return-Path: <netdev+bounces-3144-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47F70705C6B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:28:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 428031C20C43
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D78817CD;
	Wed, 17 May 2023 01:28:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6336F17C8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:28:17 +0000 (UTC)
Received: from mail-177132.yeah.net (mail-177132.yeah.net [123.58.177.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id A199E3A90;
	Tue, 16 May 2023 18:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yeah.net;
	s=s110527; h=Date:From:Subject:Message-ID:MIME-Version:
	Content-Type; bh=FMRYP780oGsC/V150FLH6SQ7V5SyK3kirmT0MA+o3jQ=;
	b=nyWd2aKVJRk1LmAs2nu7eLkLXg4knrgjmR1HWQ/2YkWMjk7fgm9Iee+4tMiZNe
	k0a7oAb0iCtEfIgmeWGpgMrs2KCvS/43HGuSetgP0v0LVj/Uht/IXS+cHid2GQ5i
	IgHL7+pyuQrPliYzw5kuNgOCudnxPlA/9xB4KUS6/BJOo=
Received: from john-VirtualBox (unknown [111.18.136.15])
	by smtp2 (Coremail) with SMTP id C1UQrACHj19+LWRkaM5rCA--.15260S2;
	Wed, 17 May 2023 09:27:28 +0800 (CST)
Date: Wed, 17 May 2023 09:27:26 +0800
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
Subject: [PATCH v2 net-next] e1000e: Add @adapter description to kdoc
Message-ID: <20230517012726.GA1785@john-VirtualBox>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-CM-TRANSID:C1UQrACHj19+LWRkaM5rCA--.15260S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF18GFW8KFWDJFW7JF4xZwb_yoWfWwbE9r
	4Iv3Z7KrZ8GF1Fkr45ArWxZ342kw1qqryvkFyfK3savryDZr4rWryv9r17GFsI9w4fJa4D
	AryaqF1fC3y29jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnk-BtUUUUU==
X-Originating-IP: [111.18.136.15]
X-CM-SenderInfo: 5qlet0x2kxq5hhdkh0dhw/1tbiBQByelsVBYuNKgAAsq
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H3,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Provide a description for the kernel doc of the @adapter
of e1000e_trigger_lsc()

Signed-off-by: Baozhu Ni <nibaozhu@yeah.net>
---
v2:
  - let the subject and description clearer
v1: https://lore.kernel.org/lkml/ZGNl8yHEko7LpCBr@corigine.com/

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


