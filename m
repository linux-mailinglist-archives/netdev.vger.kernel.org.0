Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACF729C15A
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 18:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1776608AbgJ0Oxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 10:53:36 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:34571 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1773543AbgJ0OwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 10:52:00 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 27E5416C2;
        Tue, 27 Oct 2020 10:51:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 27 Oct 2020 10:51:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=FbuojxYDFgKVoY7YEZ6pLG4DyUlV4My59IhjfH7MEp8=; b=Xj+W0mrW
        mWrFRomhtZW0EePxZpcm4vZHi3kl6H+mqSpABO1kyyx0t0CYCNqoPwXDFAdyub4i
        aybmewE/32NDAXqe40XUBzc4g0VlvpZ+USRVzB9Qb6VmnFokAFmWoqikeHYewoRQ
        hrDH9Ku9uPq3CH2v/lAk2PikVTg1NPldXPD9qeNh3L3pIRfc/LUFPKc1PkaYFgpu
        J4d7DtQ922Wfvkb9BFbhet3nz4zXijqjrMBLwUhXg+rExLBKFdTfQcurC9K/oyMo
        HMBbLa+HTMJzeY7yndM/yUt5hhwOg5TosT1mWIm4cRUN3spjEqqugBGWnqib5PCC
        gQt7tMY91tDNsQ==
X-ME-Sender: <xms:DjSYX2je7Dy2DTbVdDHMNAotnsiQsavSmOvGXXefHmm5IvVgb7S8vA>
    <xme:DjSYX3A-gkCewII5V_HXnwRZ5kw_n1KG1trUu60QOqPo7gKorPl2bNhRVMnEfTPkR
    9wPeL1pAoJkITY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkeelgdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdelnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:DjSYX-GNLSI6znMDgQFV-j3Rpx8Y1JgxDKqO-ApPvO0SQ_SGie_OEg>
    <xmx:DjSYX_T6LKn9PapjWp0xJUpt0zZkxXTuGxaNhFF1ZPthmcI51Mb06Q>
    <xmx:DjSYXzzW0Z7KbZomY7xcNH4zX1NNgzDZq0lD68aCgXL3Gwurg7LWIQ>
    <xmx:DjSYX-q5eSxhvZ-mDHZQLIx4kgqlKtg6b4trM78B7qotcGJmqj3LJw>
Received: from shredder.mtl.com (igld-84-229-153-9.inter.net.il [84.229.153.9])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A39A328006A;
        Tue, 27 Oct 2020 10:51:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        f.fainelli@gmail.com, andrew@lunn.ch, David.Laight@aculab.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool 1/2] update UAPI header copies
Date:   Tue, 27 Oct 2020 16:51:46 +0200
Message-Id: <20201027145147.227053-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201027145147.227053-1-idosch@idosch.org>
References: <20201027145147.227053-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Update to kernel commit XXX.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 uapi/linux/ethtool_netlink.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index c022883cdb22..030f95d2ccdf 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -94,10 +94,13 @@ enum {
 #define ETHTOOL_FLAG_OMIT_REPLY	(1 << 1)
 /* request statistics, if supported by the driver */
 #define ETHTOOL_FLAG_STATS		(1 << 2)
+/* be compatible with legacy ioctl interface */
+#define ETHTOOL_FLAG_LEGACY		(1 << 3)
 
 #define ETHTOOL_FLAG_ALL (ETHTOOL_FLAG_COMPACT_BITSETS | \
 			  ETHTOOL_FLAG_OMIT_REPLY | \
-			  ETHTOOL_FLAG_STATS)
+			  ETHTOOL_FLAG_STATS | \
+			  ETHTOOL_FLAG_LEGACY)
 
 enum {
 	ETHTOOL_A_HEADER_UNSPEC,
-- 
2.26.2

