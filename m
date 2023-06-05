Return-Path: <netdev+bounces-7937-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B9B87222B3
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:55:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 881601C20B9D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:55:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3345A154A6;
	Mon,  5 Jun 2023 09:55:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256AC134D6
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:55:51 +0000 (UTC)
Received: from smtpbg154.qq.com (smtpbg154.qq.com [15.184.224.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221A0B8
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:55:48 -0700 (PDT)
X-QQ-mid: bizesmtp86t1685958940til2nehg
Received: from localhost.localdomain ( [60.177.99.31])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 05 Jun 2023 17:55:30 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: fp7GbACbaw5YkLigfuXaoRjCkPL5d++OJE7zLv/1wMDlxJYceeDK053MmKywI
	haLrvOCvly8CCFTT7izazKEd3wVJGrTKM5EbVkFGkzE0wLAyDHBU/4PdllHf+TcB2FEBHfX
	W3Mz0S906KjtbfxE9aY+UD9e0+2yK5kGF0K1KnH9iHLxYPYfl7lgGFK3/TsSvZKMXFqWoyn
	ucjtEuH/lYa2ytkJ5SUVSkdKgyTTekaaB8ER+tGO+bKI4cFdu3+lLHhVNCv/4o0d8hQYdnb
	GkiQBdGc8nYwseR4+vw2Cu2rn+Vva2C3W5XnMIVTCBsUwsoUz0xgpaSw4ozBIxMf4linCn6
	cDG/h3tiM8GZwYFipt1eT9yjplylI/HdusxvGmYNSJCy2osYaiGB286yMPRbg==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 2970531670337835324
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [RFC,PATCH net-next 0/3] wangxun nics add wol ncsi support
Date: Mon,  5 Jun 2023 17:52:49 +0800
Message-ID: <6B6FE1F43BAECDA0+20230605095527.57898-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.41.0
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
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for wangxun nics support WOL or NCSI, which phy should
not to supsend.

Mengyuan Lou (3):
  net: ngbe: add Wake on Lan support
  net: core: add member ncsi_enabled to net_device
  net: ngbe: add support for ncsi nics

 drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c | 10 ++++++++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c    |  2 ++
 drivers/net/phy/phy_device.c                     |  4 +++-
 include/linux/netdevice.h                        |  3 +++
 4 files changed, 18 insertions(+), 1 deletion(-)

-- 
2.41.0


