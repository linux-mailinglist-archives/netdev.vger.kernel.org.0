Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4293AFD63
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFVGyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:54:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36225 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230290AbhFVGyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 02:54:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id D46E35C00AA;
        Tue, 22 Jun 2021 02:52:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 22 Jun 2021 02:52:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=B/8Jw1D9tsc6BagOi3t8zMHgiBpP6zzjghJ22Z+tMvc=; b=lHF1P40D
        aRwSCrDTfs6BJwUh5ApwaL6nUIwa08eFmY9F+TdgLv0hwySRgaF96WgvyybuYOEz
        EZ0qyyhcGDFG6eFvm9ex3MKidGscZA1wdMTx/7O1G4mRWWLrT+zhiT32yFotYsyL
        X5eZOqv4FIaYmrzjPEg+UBFR/YzPkkiOxQw6nNgI1d3HXmL5SrIHwjwG2OM74bDP
        IZzQF1koSZ7ZDAgRpxs/zfrfUOZ6briyFIHZLyqJ/FyxeTCYvJv9KIZUtlJ/zkOQ
        qkdkSYCucYcwuTMYUCNSJsPUxpBRHLT59HseMr+zg3Cw0JbjfAGrGMO45v/xEeX7
        oieBCuRIYDjGEQ==
X-ME-Sender: <xms:kYjRYEaxqeVqarOqRfnFDAVvoTDBmX_WSR8zNiyCyKmWlHPGXj63XA>
    <xme:kYjRYPZ6A6eIabR-ubqxBW2tVx_m0S-PeQd18QXqkvtp3xxm9JrRMP_6Wq6DQWY4c
    aWVhCLbUzPs9Vw>
X-ME-Received: <xmr:kYjRYO-2HOP83Iuyp2Lw-1N4u4iGQ881dQh2aPklmTAGEq71CN_d5K0c4wmvPBlVxAKU0NqpGUVMelMRvfgopekVj-8laVDaikYJ3miycx302w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegtddguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:kYjRYOoJzKrs1D4JI3Y6VQdLrYL50xz1gZAYUX-XQjIAdCPKKxFFWg>
    <xmx:kYjRYPo4xFV-aI2vyk02x1OPfHw2TdB6ucAzA7r9jnPFQP91AJFqaQ>
    <xmx:kYjRYMR6G6MJbdcj73nEjexjVvSgUF-9SfQYf_a2G7YBVFNcgdj_ZQ>
    <xmx:kYjRYAf0neKCf49nWAWUNsyQUY9qrqMDUSvsQykg_BZ8nYwTyAvnhg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Jun 2021 02:51:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vladyslavt@nvidia.com, mkubecek@suse.cz, moshe@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/7] ethtool: Document behavior when module EEPROM bank attribute is omitted
Date:   Tue, 22 Jun 2021 09:50:49 +0300
Message-Id: <20210622065052.2545107-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622065052.2545107-1-idosch@idosch.org>
References: <20210622065052.2545107-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The kernel assumes bank 0 when 'ETHTOOL_MSG_MODULE_EEPROM_GET' is sent
without 'ETHTOOL_A_MODULE_EEPROM_BANK'.

Document it as part of the interface documentation.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 8ae644f800f0..6ea91e41593f 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1383,6 +1383,8 @@ Request contents:
   ``ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS``  u8      page I2C address
   =======================================  ======  ==========================
 
+If ``ETHTOOL_A_MODULE_EEPROM_BANK`` is not specified, bank 0 is assumed.
+
 Kernel response contents:
 
  +---------------------------------------------+--------+---------------------+
-- 
2.31.1

