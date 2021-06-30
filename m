Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D1A3B87DE
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhF3Rpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:45:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231986AbhF3Rpl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 13:45:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2539F6147E;
        Wed, 30 Jun 2021 17:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625074992;
        bh=O0HjQFq/6Ag/X+lwHZm/U/Uf/5DKzAzKWOyghrrHKXI=;
        h=From:To:Cc:Subject:Date:From;
        b=s254rmZofBqf+U+fA1yCAMYQISch6cBW5NuU4RzQOLa+JKEJ75h5xKRy6hBillkmM
         EaW99Ju4OMv9ZxlDLoJGDZ69McryrQjs/Ghkow0F5aGbEqN+KNh4u6n6UkHQzsAcsE
         x/rQyOBsQ7GhSCZbJYkpUEyd+zFTQulpjsUk3D50ivL/JIaoazZa4O6c+clmi4Wuv4
         eJAjbuTgx8vz4QsD0C69s2l1xCZ3eHX5pEQXDQgcsLm3pHVFlNdnDDsXXpiXrQHnxz
         WOtmK3qIOCV0aKKhm+gO2MasFLV5wj3kui+pLk2g38Twe3B18CsewnhOe7AybXiyvI
         3NceMd5NF9JFA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 0/6] dsa: mv88e6xxx: Topaz fixes
Date:   Wed, 30 Jun 2021 19:43:02 +0200
Message-Id: <20210630174308.31831-1-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
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

Marek Behún (6):
  net: dsa: mv88e6xxx: enable .port_set_policy() on Topaz
  net: dsa: mv88e6xxx: use correct .stats_set_histogram() on Topaz
  net: dsa: mv88e6xxx: enable .rmu_disable() on Topaz
  net: dsa: mv88e6xxx: enable devlink ATU hash param for Topaz
  net: dsa: mv88e6xxx: enable SerDes RX stats for Topaz
  net: dsa: mv88e6xxx: enable SerDes PCS register dump via ethtool -d on
    Topaz

 drivers/net/dsa/mv88e6xxx/chip.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

-- 
2.31.1

