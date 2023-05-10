Return-Path: <netdev+bounces-1396-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3EBD6FDAF2
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:41:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 945802812BD
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE7866127;
	Wed, 10 May 2023 09:40:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24A463E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:40:12 +0000 (UTC)
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE0C4207
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:40:10 -0700 (PDT)
X-QQ-mid: bizesmtp73t1683711537th8fhncj
Received: from localhost.localdomain ( [125.119.253.217])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 10 May 2023 17:38:48 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: +ynUkgUhZJkG6vLgv0WMg025aFA0dJFX8yuwTJvsxoqNLBhtKX1arAvaHl65S
	vZ/ywYQrw9GJCBAmQUZadeLFoz+wMit+vFbU79QcuA1Z+SpLvRCtI4UZfmmtXyak67jWd5z
	wabVVnTwWMegjvjVn9dprcbClurGN8XZEyotfg0ie2A90tm9mx40UuJiBXoOaH5nnYQcPTq
	O2qMiP0y2hXBymZJxoF3KBfjcCAQ+htkiE54lnbMcEUx8/091N5TEz8TmZodHISwr4ICQQI
	hZD/VNIgL+EWNIxIrPOgyGmPd1wuUIMSb5bWAlj2FyoBnzsv7lSW6DOXtuJSlKOtDvfJjiP
	+bQrc1L0gDFSnJYLBgvnOyyX245i3PYycxvf+0VS2gAh/zGvfd1GlQqzpMHwC6yNgRbPrxE
	WI/4f2Zhqgg=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 7172970205468190982
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v4 0/7] Wangxun netdev features support
Date: Wed, 10 May 2023 17:38:38 +0800
Message-Id: <20230510093845.47446-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz5a-3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement tx_csum and rx_csum to support hardware checksum offload.
Implement ndo_vlan_rx_add_vid and ndo_vlan_rx_kill_vid.
Enable macros in netdev features which wangxun can support.

changes v4:
- Yunsheng Lin:
https://lore.kernel.org/netdev/c4b9765d-7213-2718-5de3-5e8231753b95@huawei.com/
changes v3:
- Yunsheng Lin: Tidy up logic for wx_encode_tx_desc_ptype.
changes v2:
- Andrew Lunn:
Add ETH_P_CNM Congestion Notification Message to if_ether.h.
Remove lro support.
- Yunsheng Lin:
https://lore.kernel.org/netdev/eb75ae23-8c19-bbc5-e99a-9b853511affa@huawei.com/

Mengyuan Lou (7):
  net: wangxun: libwx add tx offload functions
  net: wangxun: libwx add rx offload functions
  net: wangxun: Implement vlan add and kill functions
  net: ngbe add netdev features support
  net: ngbe: Implement vlan add and remove ops
  net: txgbe add netdev features support
  net: txgbe: Implement vlan add and remove ops

 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 275 +++++++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   3 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   | 600 +++++++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  | 362 ++++++++++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  19 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  24 +-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   1 +
 8 files changed, 1265 insertions(+), 20 deletions(-)

-- 
2.40.0


