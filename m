Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 607FB47052
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfFOOJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:37 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34901 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:36 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B61AE21EAE;
        Sat, 15 Jun 2019 10:09:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=27sQkn6yoAvtsuzVC551sy8YfyGENAmGXrhU+IuKqt4=; b=wUJCRACE
        4Yuov0DTQJXzdhG4qFNAXqeJtYVr9h6vktgSNDQY5lOmVoj3m1dw+Gsx/aFQv8vp
        RgaGxIC9x7wwrIrEmtha1yxlbI/phEJagqdyWS+P5VGo5XPagndNfqS1NiZDR7zB
        a+cwNLZMIXIau/AmoNuQn8JNEkRxVgkfHvHic18ZaCPkYwziypE9sq0arC2vNDyB
        bZZUOhZDSOUgRSnV0T5Gbl5KfVqVs8rH58tqtrzrtR+1BD8S3hDTqqvKEznN+bEw
        VSZ9Ph5nLnngMhDumlu9lkftwDpdcHlluoWl/doapFbc63IsUVYl6l7mzYKewHe9
        vDiy+nHqkmQkTQ==
X-ME-Sender: <xms:H_wEXX89i7CUkv4ks46SFkr05o8DqerO1xsSk1zKWvAuVAb1tk5oRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepje
X-ME-Proxy: <xmx:H_wEXaiuvbu0On0bsxQfGNsKfluqGz9YHhTXTEDKM_QB2rawTnngNQ>
    <xmx:H_wEXd_jG-tAmgVG5hWZfUAGg2_sZiEP4sGgUUjlddeqKkJ_Xxmelw>
    <xmx:H_wEXWQrMLWcwA_ikhRORqV3sOmOztRtcMJtTi5OzDPd1XlscOzpDA>
    <xmx:H_wEXf-gw_XNPtoqZJMm8epkebcyN6ycywiStV-ckMepv9uPBujx7A>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id B74CA380085;
        Sat, 15 Jun 2019 10:09:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/17] mlxsw: spectrum_router: Remove processing of IPv6 append notifications
Date:   Sat, 15 Jun 2019 17:07:43 +0300
Message-Id: <20190615140751.17661-10-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190615140751.17661-1-idosch@idosch.org>
References: <20190615140751.17661-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

No such notifications are sent by the IPv6 code, so remove them.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 99a2caccd0fe..b7e839a88449 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5898,7 +5898,6 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 
 	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_APPEND: /* fall through */
 	case FIB_EVENT_ENTRY_ADD:
 		replace = fib_work->event == FIB_EVENT_ENTRY_REPLACE;
 		err = mlxsw_sp_router_fib6_add(mlxsw_sp,
@@ -6005,7 +6004,6 @@ static void mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
 
 	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_APPEND: /* fall through */
 	case FIB_EVENT_ENTRY_ADD: /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
 		fen6_info = container_of(info, struct fib6_entry_notifier_info,
-- 
2.20.1

