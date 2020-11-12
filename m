Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2582AFF7C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgKLFu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:50:56 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:48259 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725976AbgKLFu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 00:50:56 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 12 Nov 2020 07:50:53 +0200
Received: from vnc1.mtl.labs.mlnx (vnc1.mtl.labs.mlnx [10.7.2.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AC5orkr030685;
        Thu, 12 Nov 2020 07:50:53 +0200
Received: from vnc1.mtl.labs.mlnx (localhost [127.0.0.1])
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4) with ESMTP id 0AC5orlC008536;
        Thu, 12 Nov 2020 07:50:53 +0200
Received: (from moshe@localhost)
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4/Submit) id 0AC5ogLs008505;
        Thu, 12 Nov 2020 07:50:42 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next 0/2] Add support for DSFP transceiver type
Date:   Thu, 12 Nov 2020 07:49:39 +0200
Message-Id: <1605160181-8137-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for new cable module type DSFP (Dual Small Form-Factor Pluggable
transceiver). DSFP EEPROM memory layout is compatible with CMIS 4.0 spec. Add
CMIS 4.0 module type to UAPI and implement DSFP EEPROM dump in mlx5.

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

