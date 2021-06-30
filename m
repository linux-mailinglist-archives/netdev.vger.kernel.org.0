Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19A13B8A64
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 00:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhF3WZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 18:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232459AbhF3WZF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 18:25:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C00361476;
        Wed, 30 Jun 2021 22:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625091755;
        bh=68tqGUY9CK65gwqSJffEicdTboiJC/8fg8g36aTZZlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYi3PT8WWXts6vb9DoAxxRxpXgGVygmB8vP6O6i2fMXHFrEUAMbOvZF8vzNbPBZ8m
         IV2dGZJDpblaWBwLT8Vg9k3TWbLeGfUnGthiPnalb0h5omNxseBOPKrZ1euSS0hiRa
         +GNQ4Hx76pNwhmLg6uHBeNxwTdJ4YfIgM+MevrhNPHKGK44y58IxFubEbx7p1kiRxf
         de/LCfT5xq64mTG8o+rOtcQml4Oavxeh1UZ5W7HqT89GYaHHh7SZQ6Fvx0bQtBFicr
         V+n+Xwsn+JatpcTSsdFmvmbMyHpje1L806OS8Yon56Mv/teTptpK+/hLGKYKz1Li2h
         92BhF38k/+OOQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net v2 0/6] dsa: mv88e6xxx: Topaz fixes
Date:   Thu,  1 Jul 2021 00:22:25 +0200
Message-Id: <20210630222231.2297-1-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630174308.31831-1-kabel@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

here comes some fixes for the Topaz family (Marvell 88E6141 / 88E6341)
which I found out about when I compared the Topaz' operations
structure with that one of Peridot (6390).

This is v2. In v1, I accidentally sent patches generated from wrong
branch and the 5th patch does not contain a necessary change in
serdes.c.

Changes from v1:
- the fifth patch, "enable SerDes RX stats for Topaz", needs another
  change in serdes.c
- Andrew's Reviewed-by to 1,2,3,4 and 6

Marek Behún (6):
  net: dsa: mv88e6xxx: enable .port_set_policy() on Topaz
  net: dsa: mv88e6xxx: use correct .stats_set_histogram() on Topaz
  net: dsa: mv88e6xxx: enable .rmu_disable() on Topaz
  net: dsa: mv88e6xxx: enable devlink ATU hash param for Topaz
  net: dsa: mv88e6xxx: enable SerDes RX stats for Topaz
  net: dsa: mv88e6xxx: enable SerDes PCS register dump via ethtool -d on
    Topaz

 drivers/net/dsa/mv88e6xxx/chip.c   | 22 ++++++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/serdes.c |  6 +++---
 2 files changed, 23 insertions(+), 5 deletions(-)

-- 
2.31.1

