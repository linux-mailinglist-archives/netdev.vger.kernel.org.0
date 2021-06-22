Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB353AFD5F
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhFVGyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:54:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56955 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229702AbhFVGyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 02:54:07 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id AA9A05C00D4;
        Tue, 22 Jun 2021 02:51:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 22 Jun 2021 02:51:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=W0jyNhFGrOKczHs3n
        21PjzEKzK+Hh6gog/RjsIxyP1E=; b=GBC2YMzH1tYgtUkUd4Jubw3+8ki3SJKGV
        MmXNJ6Gf3L8g1PEtPLF73ty4RJhiZ+5juudVamYtnLX7bPol/mXLj6sT5TfPHDPk
        biML1rftVEOvn39fP1GkqlK978MQsdY5C0JBshSDsh2y3QSQ0mWRT5dpvt1G5aIn
        Sp5enY90LVBCaIlPX1ZRrw0k7XdnYjv2boyaaDKvA9xYqv2GbMSyTkUhNDQJA3Fu
        N96SdJGOGpbF0z1qpwdHcdsqCVDe9EUe18yTR4XAdyYtExZJ6QhH0SMzKACXzqPS
        6deNM4A9Vq0PR+sqx3yWQSDWj2O3k3SqAZQWpBgXkmiB97CZLVWFw==
X-ME-Sender: <xms:h4jRYDSGp7WNT-aJbgxSYAteJrONv-VYlDdNEJ2yVvwJ4HjvXn4LfQ>
    <xme:h4jRYEz4zPIRYXVWRkmXxGDTjWlPzzqO3UCrtLurvgglNwGQo86pddK2MpajH8IOs
    mgIOecKpUg3XoY>
X-ME-Received: <xmr:h4jRYI1Yyk2ndMcbJnPnuj-_0NJ4pBd0EdrlrzHb5EZTBosXcCbJCO04gyI2bfrCW7eCc85VKrFDKJS3twXqcaPwCom1sqdsc70wUsDUEm5sXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegtddguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:h4jRYDDOlRfi3qkHPiSYP9imEjq68mBj_l3lkBYoLHY3XgrxQfTknQ>
    <xmx:h4jRYMiui5LGYZwXEIKrdHxo0Y2wOnNxJGag_QkaDcS7UvJTcn5Vug>
    <xmx:h4jRYHq3x_UcBPUoYSjAfli5nhjdyYHKvYyuoy__cguujg2TtjLwjg>
    <xmx:h4jRYHXgkmmm87NXrRQWFBRJbMdvmAHfhlUJXOxcE_iEG-H5w69n3w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Jun 2021 02:51:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vladyslavt@nvidia.com, mkubecek@suse.cz, moshe@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/7] ethtool: Module EEPROM API improvements
Date:   Tue, 22 Jun 2021 09:50:45 +0300
Message-Id: <20210622065052.2545107-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset contains various improvements to recently introduced
module EEPROM netlink API. Noticed these while adding module EEPROM
write support.

Ido Schimmel (7):
  ethtool: Use correct command name in title
  ethtool: Document correct attribute type
  ethtool: Decrease size of module EEPROM get policy array
  ethtool: Document behavior when module EEPROM bank attribute is
    omitted
  ethtool: Use kernel data types for internal EEPROM struct
  ethtool: Validate module EEPROM length as part of policy
  ethtool: Validate module EEPROM offset as part of policy

 Documentation/networking/ethtool-netlink.rst |  8 +++++---
 include/linux/ethtool.h                      | 12 ++++++------
 include/uapi/linux/ethtool_netlink.h         |  2 +-
 net/ethtool/eeprom.c                         | 13 ++++---------
 net/ethtool/netlink.h                        |  2 +-
 5 files changed, 17 insertions(+), 20 deletions(-)

-- 
2.31.1

