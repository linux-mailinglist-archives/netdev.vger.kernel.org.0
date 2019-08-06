Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36318329C
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732372AbfHFNUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:20:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56535 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726036AbfHFNUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:20:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1AF0421FC3;
        Tue,  6 Aug 2019 09:20:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Aug 2019 09:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=/V6AduhS5OGySHZ0IXPttUadE1/bibpyWuKAPhTnbcI=; b=FBoSHA1+
        BIF+kMtH+RmLoJNNV54F+pXwCCT/wqjE3IcMZCKAc4z72WZgJDkjLwXrud207I5O
        HjBkt/qSvbOmtb2KnpSxtTxgkeMTSsfzHU/irD920BdZazzvMRlUXOiwFEOJdUrR
        sf8USQCMrBq9yRAC9dWZDfXR1ciLokyztlCkYNCKWNXA6irMDhg5BbAsdFSvpiCl
        +uu0GAGZKJwxA5+zFHuJHrvl5ZMk9/SdAbyI5lvb2MJHEWTIsdWlg5ey3h94x2Hi
        KLMJf0jaTy4gJynYPGh58QE1ZX0QpO5PV+mHVCxxQ0bX6Q1M9KvzpVA4BO51Wnxb
        yx2DSx8BCdCdtg==
X-ME-Sender: <xms:sH5JXSIfiXB6oiJLcFQaigm2s7plLq8Qe-9SUn2LtwRKNmTBcS40wQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddutddgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:sH5JXQpDPz0KbI5EmR0FHV0OhwjkVhBXpFFOGm3KGWYJlvl0-wUPgg>
    <xmx:sH5JXV4oX8IOLD26FUYgt225LMfy7JxRXqO1M-8NNlP_gog1Bu-iwQ>
    <xmx:sH5JXRY50Tl4d1qnXjdRbagJ8EpT4jKYTn9QkOKjBjsbVWG_gNbHvA>
    <xmx:sX5JXWO7MOvTRQQUCXWhnFQXnYGErXYFAMxTUseEV1VvFFwQEpuBaA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 632EB80060;
        Tue,  6 Aug 2019 09:20:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, toke@redhat.com,
        jiri@mellanox.com, dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/6] drop_monitor: Avoid multiple blank lines
Date:   Tue,  6 Aug 2019 16:19:54 +0300
Message-Id: <20190806131956.26168-5-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190806131956.26168-1-idosch@idosch.org>
References: <20190806131956.26168-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Remove multiple blank lines which are visually annoying and useless.

This suppresses the "Please don't use multiple blank lines" checkpatch
messages.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/core/drop_monitor.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 35d31b007da4..9080e62245b9 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -300,7 +300,6 @@ static int set_all_monitor_traces(int state)
 	return rc;
 }
 
-
 static int net_dm_cmd_config(struct sk_buff *skb,
 			struct genl_info *info)
 {
@@ -427,7 +426,6 @@ static int __init init_net_drop_monitor(void)
 		reset_per_cpu_data(data);
 	}
 
-
 	goto out;
 
 out_unreg:
-- 
2.21.0

