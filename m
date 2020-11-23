Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF01E2C0236
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 10:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgKWJUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 04:20:35 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:48103 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727978AbgKWJUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 04:20:35 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 23 Nov 2020 11:20:30 +0200
Received: from vnc1.mtl.labs.mlnx (vnc1.mtl.labs.mlnx [10.7.2.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AN9KUCA000611;
        Mon, 23 Nov 2020 11:20:30 +0200
Received: from vnc1.mtl.labs.mlnx (localhost [127.0.0.1])
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4) with ESMTP id 0AN9KUNk006503;
        Mon, 23 Nov 2020 11:20:30 +0200
Received: (from moshe@localhost)
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4/Submit) id 0AN9KChj006326;
        Mon, 23 Nov 2020 11:20:12 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next v2 0/2] Add support for DSFP transceiver type
Date:   Mon, 23 Nov 2020 11:19:56 +0200
Message-Id: <1606123198-6230-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for new cable module type DSFP (Dual Small Form-Factor Pluggable
transceiver). DSFP EEPROM memory layout is compatible with CMIS 4.0 spec. Add
CMIS 4.0 module type to UAPI and implement DSFP EEPROM dump in mlx5.

Change log:
v1 -> v2
- Added comments on accessing only the mandatory part of passive and
  active cables.

Vladyslav Tarasiuk (2):
  ethtool: Add CMIS 4.0 module type to UAPI
  net/mlx5e: Add DSFP EEPROM dump support to ethtool

 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 12 ++++-
 .../net/ethernet/mellanox/mlx5/core/port.c    | 52 ++++++++++++++++---
 include/linux/mlx5/port.h                     |  1 +
 include/uapi/linux/ethtool.h                  |  3 ++
 4 files changed, 60 insertions(+), 8 deletions(-)

-- 
2.18.2

