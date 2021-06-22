Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEEA3AFD61
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhFVGyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:54:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48071 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230175AbhFVGyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 02:54:12 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 25C665C00AA;
        Tue, 22 Jun 2021 02:51:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 22 Jun 2021 02:51:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=r1FREHzWQS3p5+Gpjg1By6sPhPtQlXtrJNNIgev7YCM=; b=EByIR3Re
        EAx8Vnp8x79lf5zlYjrbT2Vk7tuDpAvrjhYK79N1b1yMJAo2c/WzW+LVgkC3HCGG
        0uFIGi/H/NbRncvD3CeuFNgYguQA7dfuPWk67I+yAxXNzJEumKNXWmUGivX0gLZb
        UVihalysVn03jz/FJuAY4cgHjVXmIPg8DIMS+UrJcAXLDYAMBOKf38Xn//DlLcx4
        6Xltf6olNcwoNm3jzuv0pw9ubWxaxt9KnIHfeo5DFV1t+yAPuZcYMVgwr2U1/CHI
        kDNLNsfsIaaYHVPos/EOnD9bYF5DoBkKFviKXy5CMZhyUo7+ix7nlMd74MmrtAqT
        ri6Vu623CNDGTg==
X-ME-Sender: <xms:jYjRYMVDAdObT3nhlyYaPBhCJwaLxCCPwSFg5l7v25EgenbhwP2qZQ>
    <xme:jYjRYAn1_pHVaThszOFgK5vUmW4oDkizSSumlXwupZ9tgsxpcApEE28tLqaF4Wdfx
    t08UXcNXl1CUFM>
X-ME-Received: <xmr:jYjRYAbDYOOZaZEHa2s8LnQAZY3j6lK-cdvpM84nPmVvPJbkzyf68mmeQTV1syq3odFdusjxnLL9IDIWu2XYLREhMa2z3PjErxEvI2lQXLTY8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegtddguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:jYjRYLXZ1QFzBktysLkZY15bruTbzVGWbpXVNL5xsfb922FaOQ_9Hw>
    <xmx:jYjRYGkUxs74IrjVKji2liduWJDy_mKLKG8NSDTKN6-vtmMf0Nofag>
    <xmx:jYjRYAejX2CXrShOfp7AZIJAOx6nsm0yxl0rqluykvS2E8yizm7mpw>
    <xmx:jYjRYEYki9aCNdt0iqsdDgT1EFnBNgOghyCAxP6ooQaBGHzDWMitog>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Jun 2021 02:51:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vladyslavt@nvidia.com, mkubecek@suse.cz, moshe@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/7] ethtool: Document correct attribute type
Date:   Tue, 22 Jun 2021 09:50:47 +0300
Message-Id: <20210622065052.2545107-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622065052.2545107-1-idosch@idosch.org>
References: <20210622065052.2545107-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

'ETHTOOL_A_MODULE_EEPROM_DATA' is a binary attribute, not a nested one.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst | 2 +-
 include/uapi/linux/ethtool_netlink.h         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index c3600f9c8988..8ae644f800f0 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1388,7 +1388,7 @@ Kernel response contents:
  +---------------------------------------------+--------+---------------------+
  | ``ETHTOOL_A_MODULE_EEPROM_HEADER``          | nested | reply header        |
  +---------------------------------------------+--------+---------------------+
- | ``ETHTOOL_A_MODULE_EEPROM_DATA``            | nested | array of bytes from |
+ | ``ETHTOOL_A_MODULE_EEPROM_DATA``            | binary | array of bytes from |
  |                                             |        | module EEPROM       |
  +---------------------------------------------+--------+---------------------+
 
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 825cfda1c5d5..c7135c9c37a5 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -675,7 +675,7 @@ enum {
 	ETHTOOL_A_MODULE_EEPROM_PAGE,			/* u8 */
 	ETHTOOL_A_MODULE_EEPROM_BANK,			/* u8 */
 	ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS,		/* u8 */
-	ETHTOOL_A_MODULE_EEPROM_DATA,			/* nested */
+	ETHTOOL_A_MODULE_EEPROM_DATA,			/* binary */
 
 	__ETHTOOL_A_MODULE_EEPROM_CNT,
 	ETHTOOL_A_MODULE_EEPROM_MAX = (__ETHTOOL_A_MODULE_EEPROM_CNT - 1)
-- 
2.31.1

