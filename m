Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2891C61467
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfGGIEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:04:06 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:53075 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGIEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:04:05 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id C8C4F11DC;
        Sun,  7 Jul 2019 04:04:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:04:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=rn7r4S6fTdo+QWjbtGIgGCl3J9+Y7fng1dCo53X9Sm8=; b=SK0R7ypd
        8gc++dLyeUxQjBKNInuHLBz5RlF8UICwDjOaeb9qpsc+WlQV0QW87VLRSQh8QY3m
        DpdC2AGbT8gLqLPjBrUHxmXIT7vcibnMqAEpcpFv6VD/dvkuqnpWT8tn0rmMSdiB
        7Mt4qbVd6vbiUAd6EWNckJpdhs0M48lVwAnZfRrFkZbxSVRPn5avGLAF6putVYBM
        kBE9UNA+hZEckUkMcQhLe8kgF9nUbdHros25WJGpuxmi8Yw0VZcqjvMOdwC9cmXy
        K5IEajAcpbresvqBrJ1BUAG8ZBcC5W5rrZi/Vw4QYWCpHtZLgM+ouz/84OmzgaOI
        K8UXst/Xzr+alg==
X-ME-Sender: <xms:dKchXeE5Oq-DSIk4wJxne5NSoyy2pDTLg4ePwwyfVbagSNkbo0F3lw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:dKchXXD6-5J6kgdw0VRDq6Jzjcea4UWEClQ_VIIHnjCgKyZ94GbmRg>
    <xmx:dKchXd_XKD3BaykzZx6iLqqYzttbMikrB38coOWlqq01DQF8rawcCQ>
    <xmx:dKchXZeGvPr8vXQNF9Ps9IeFDxFmA2yp44nWqf5wllCOvXa96Qi-hA>
    <xmx:dKchXbtoszPALwLwThpwT1XY-w6hzs3pivg0dSiINip1IPI6nceV0A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2CF998005A;
        Sun,  7 Jul 2019 04:04:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 2/5] Documentation: Add a section for devlink-trap testing
Date:   Sun,  7 Jul 2019 11:03:33 +0300
Message-Id: <20190707080336.3794-3-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707080336.3794-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707080336.3794-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 Documentation/networking/devlink-trap.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/networking/devlink-trap.rst b/Documentation/networking/devlink-trap.rst
index 906cdeb0d1f3..b29aac6fe5fd 100644
--- a/Documentation/networking/devlink-trap.rst
+++ b/Documentation/networking/devlink-trap.rst
@@ -188,3 +188,12 @@ following table:
    * - ``buffer_drops``
      - Contains packet traps for packets that were dropped by the device due to
        an enqueue decision
+
+Testing
+=======
+
+See ``tools/testing/selftests/net/devlink_trap.sh`` for a test covering the
+core infrastructure. Test cases should be added for any new functionality.
+
+Device drivers should focus their tests on device-specific functionality, such
+as the triggering of supported packet traps.
-- 
2.20.1

