Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D626713CA
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 10:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfGWITj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 04:19:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38141 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727892AbfGWITi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 04:19:38 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 15DCD220CF;
        Tue, 23 Jul 2019 04:19:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 23 Jul 2019 04:19:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=4Iv6pNmZHxcjlOU/TXn6z2UBFLEO/Z83rZADeGSLgKc=; b=xzeAY50T
        YycQY2mcimeL9AGKOfrg0wqAv+q0yoSNMDm7pDZ+z0C9HObd+9XIWzR2rG4m5w4W
        RiVj8WqkJj4u4bWVHAlb0WkiLSt+GpJtsljouI6Oqr8CYWJbFjyrxYCMPFZw+9fQ
        cJ9gsQCPfmk3Bdx8Nz0NFQ45CewaWItMfQJ9eEpUfs6zmz2/PhCUfNcxv566YP64
        qHH9tUwAbTQH3WfgSsmggs+XS8MM17J53tZCT2y/1f4hWwwroBCnB/uP36ed8DAG
        /4U2hFqVaqnqEYeZuc7lAwQBpbkav0uZKGFo9jfm9Y65nwdgpoKQKs26QOFTYXAe
        zZZmOrCQsTl1lg==
X-ME-Sender: <xms:GMM2XfK87yt7Kgj21TaPPeyDJ0oM85FvYcaaUsRiIVdYTtIwBFShuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:GMM2XT6uYopZ2CxBFczA1dR4KwblU9yGnOXqvS0j6NFhEcxh_I_zgQ>
    <xmx:GMM2XT0D6IhywZLlSC6RyuETq7FnPQU_phuks8RJ22sPJXBIPgIbVw>
    <xmx:GMM2XZel9q3DXcPnMX20N3YGr2OiSG8NkLK2UmN4inWtrx3KzqkPzg>
    <xmx:GcM2XWxjemTisVSYk0rY7pDy2UWMya7GLDcOzGUzf_Banhc6PtwA4A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D48E6380087;
        Tue, 23 Jul 2019 04:19:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, ssuryaextr@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 1/2] selftests: forwarding: gre_multipath: Enable IPv4 forwarding
Date:   Tue, 23 Jul 2019 11:19:25 +0300
Message-Id: <20190723081926.30647-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723081926.30647-1-idosch@idosch.org>
References: <20190723081926.30647-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The test did not enable IPv4 forwarding during its setup phase, which
causes the test to fail on machines where IPv4 forwarding is disabled.

Fixes: 54818c4c4b93 ("selftests: forwarding: Test multipath tunneling")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Tested-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 tools/testing/selftests/net/forwarding/gre_multipath.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/gre_multipath.sh b/tools/testing/selftests/net/forwarding/gre_multipath.sh
index cca2baa03fb8..37d7297e1cf8 100755
--- a/tools/testing/selftests/net/forwarding/gre_multipath.sh
+++ b/tools/testing/selftests/net/forwarding/gre_multipath.sh
@@ -187,12 +187,16 @@ setup_prepare()
 	sw1_create
 	sw2_create
 	h2_create
+
+	forwarding_enable
 }
 
 cleanup()
 {
 	pre_cleanup
 
+	forwarding_restore
+
 	h2_destroy
 	sw2_destroy
 	sw1_destroy
-- 
2.21.0

