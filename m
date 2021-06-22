Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D028F3AFD60
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhFVGyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:54:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59763 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230004AbhFVGyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 02:54:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6EE495C00D5;
        Tue, 22 Jun 2021 02:51:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 22 Jun 2021 02:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=xQUpF9hi3K6wMYHzQrvvqSccP9/y+SFlSWlei2yokVE=; b=dGA0VOjC
        eeGIwTX9+zakq79tqLJiD1iG+CGkRTPvSISePttTJ1DSuOGtopAdoGXjzv7b8DeL
        l4h58pC451l9u1DTUwtETno32NiiROLJoIRwE3eQ8tQKhJFTwPFmKpXy4pFl1FZa
        7HpkAqBicwYl6hE6Bq1foqP08KzDDklCNLT4sYr7f1k6SSpVOGCpxKnbgj8Ikgx5
        y1aFOp0vbNJJgoviQTeTFq2ZrKC8Mui59mEZgiTZopoZ+5Oe09+UijxrO+VFWVfC
        ZyfwuY+ibIzCi8+lHpjxuZ8ja3Mfr9z3px9gCmT/pvrZrhLOwoJov8rL1M9L0PF5
        6c1hyKn71XCfCg==
X-ME-Sender: <xms:iojRYDvZKJ2gfiyKbo0Havz0P0LwtRQ6-MZBtYkqREdBhINwfPgkEg>
    <xme:iojRYEec6VEdgCrAbBcwlrMm4R4pElTdrW8iUL-xXZ08RC4jYDmKWbOdK5yR-_gi_
    RqrErurEHCQb6g>
X-ME-Received: <xmr:iojRYGyss10r_LIYBxBPCIXy1eMsojNl08NKEIzti34dk-_jnBsSMyfLLL562G4b-ScmjdfbPZJWE4yQckhuWIwy8PfNfQYK8yOwzo931Hl1mQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegtddguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:iojRYCPe3DI5bL5jNhM225ydYy_A1eu5r03pcjjKiIhAsmO8XzaSmQ>
    <xmx:iojRYD_LJXYo8yciycPZ44H403PchViDGYjZeJVbxUIRISUk2JgEkw>
    <xmx:iojRYCXArMPzCy8bqoK81BXIhMRW-X-MmwJRpR0QNcV7mSOCW3niIQ>
    <xmx:iojRYDwDO3OMLAGv8-rlAFyc8cTHqew-HL1nZMNCABdvl1cKqUYD8g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Jun 2021 02:51:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vladyslavt@nvidia.com, mkubecek@suse.cz, moshe@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/7] ethtool: Use correct command name in title
Date:   Tue, 22 Jun 2021 09:50:46 +0300
Message-Id: <20210622065052.2545107-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622065052.2545107-1-idosch@idosch.org>
References: <20210622065052.2545107-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The command is called 'ETHTOOL_MSG_MODULE_EEPROM_GET', not
'ETHTOOL_MSG_MODULE_EEPROM'.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 25131df3c2bd..c3600f9c8988 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1363,8 +1363,8 @@ in an implementation specific way.
 ``ETHTOOL_A_FEC_AUTO`` requests the driver to choose FEC mode based on SFP
 module parameters. This does not mean autonegotiation.
 
-MODULE_EEPROM
-=============
+MODULE_EEPROM_GET
+=================
 
 Fetch module EEPROM data dump.
 This interface is designed to allow dumps of at most 1/2 page at once. This
-- 
2.31.1

