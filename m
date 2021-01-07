Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57DD2ED37A
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 16:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbhAGPZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 10:25:06 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:50721 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727912AbhAGPZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 10:25:05 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id DFCC415E0;
        Thu,  7 Jan 2021 10:23:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Jan 2021 10:23:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=2/ZuYU7mv7wM+SDXOjdBeDem2k6bStbMYKThaNATVRc=; b=jFZ5WUZ9
        qVh7b1xU2uFqxkppYSH+TqwgWHTamPLRBFo0RkL62aGMOxIaxqJzu56w6IHVJQbx
        hVA/fwyGaDX/E2P21Rr8CuoPUIplfOJRXBzhpzKDdh7W/BYgoWRwhmYWvR0/axkj
        wRMho5IG3rBX4qnUOwChkxyZMhkra7JrFur5Tl89am5+wXf/gPwluvSg0lRnXRuj
        oHjvQoyJV8gdUJUPL+EKJoJ0JJdUKu+YFzn+l2mEAKGQ9ckA6FhPnNpCg312cTd+
        A1r14Nu7m0So+rDqX3I5m+l+c/cgpd1oLfbL8i0dlldgRYZCOVACsl5FWWSj/YQ3
        7azFqSYqeJMcRw==
X-ME-Sender: <xms:jif3X-5YglnvqserSwmrqg6pGP6c-PuSzdWUY1RySkGsuL5CDxcIVQ>
    <xme:jif3X37Nw9_79vk6dub-xlStaDcPWmCshACezGo8dPR19lNOARORhDeX_VdzklWXu
    97A5Expqa9lS5I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegvddgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:jif3X9cKhtwYvbCuy3_IFpdfaxsa3nZUuSsc-gfcGZX7flxahfl17A>
    <xmx:jif3X7Iz5weBAzJ5Uu7nRiL1SNL0yUZ4UNbgzmlXJj4Q7ClAumKGtg>
    <xmx:jif3XyKzPlYWa5CZkUw7mllX3FF4L9TP-sO4lr-FrqWaL12o7lsORw>
    <xmx:jif3X5VCDM7VfH4yvcEKe0cW4ZkS32Gh7IBQ5z-6VVG3m5ISBHnKnA>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id E4978240066;
        Thu,  7 Jan 2021 10:23:56 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2 2/2] ipmonitor: Mention "nexthop" object in help and man page
Date:   Thu,  7 Jan 2021 17:23:27 +0200
Message-Id: <20210107152327.1141060-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107152327.1141060-1-idosch@idosch.org>
References: <20210107152327.1141060-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Before:

 # ip monitor help
 Usage: ip monitor [ all | LISTofOBJECTS ] [ FILE ] [ label ] [all-nsid] [dev DEVICE]
 LISTofOBJECTS := link | address | route | mroute | prefix |
                  neigh | netconf | rule | nsid
 FILE := file FILENAME

After:

 # ip monitor help
 Usage: ip monitor [ all | LISTofOBJECTS ] [ FILE ] [ label ] [all-nsid] [dev DEVICE]
 LISTofOBJECTS := link | address | route | mroute | prefix |
                  neigh | netconf | rule | nsid | nexthop
 FILE := file FILENAME

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ipmonitor.c        | 2 +-
 man/man8/ip-monitor.8 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index 685be52cfe64..99f5fda8ba1f 100644
--- a/ip/ipmonitor.c
+++ b/ip/ipmonitor.c
@@ -32,7 +32,7 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage: ip monitor [ all | LISTofOBJECTS ] [ FILE ] [ label ] [all-nsid] [dev DEVICE]\n"
 		"LISTofOBJECTS := link | address | route | mroute | prefix |\n"
-		"		 neigh | netconf | rule | nsid\n"
+		"		 neigh | netconf | rule | nsid | nexthop\n"
 		"FILE := file FILENAME\n");
 	exit(-1);
 }
diff --git a/man/man8/ip-monitor.8 b/man/man8/ip-monitor.8
index 86f8f9885fef..f886d31b8013 100644
--- a/man/man8/ip-monitor.8
+++ b/man/man8/ip-monitor.8
@@ -55,7 +55,7 @@ command is the first in the command line and then the object list follows:
 is the list of object types that we want to monitor.
 It may contain
 .BR link ", " address ", " route ", " mroute ", " prefix ", "
-.BR neigh ", " netconf ", "  rule " and " nsid "."
+.BR neigh ", " netconf ", "  rule ", " nsid " and " nexthop "."
 If no
 .B file
 argument is given,
-- 
2.29.2

