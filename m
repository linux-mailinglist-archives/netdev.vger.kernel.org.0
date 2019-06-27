Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DD858D6B
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfF0V6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:58:22 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:49797 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0V6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:58:21 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45ZYgH2PtPz1s28f;
        Thu, 27 Jun 2019 23:58:19 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45ZYgH1sqLz1qqkH;
        Thu, 27 Jun 2019 23:58:19 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id RQlIl7F6OoRl; Thu, 27 Jun 2019 23:58:17 +0200 (CEST)
X-Auth-Info: YW6Vl+vNwvajhw6ZyAL8rfz8g6uZhJtmjs/vVtTyLz8=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 27 Jun 2019 23:58:16 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH 0/5] net: dsa: microchip: Further regmap cleanups
Date:   Thu, 27 Jun 2019 23:55:51 +0200
Message-Id: <20190627215556.23768-1-marex@denx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset cleans up KSZ9477 switch driver by replacing various
ad-hoc polling implementations and register RMW with regmap functions.

Each polling function is replaced separately to make it easier to review
and possibly bisect, but maybe the patches can be squashed.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <Woojung.Huh@microchip.com>

Marek Vasut (5):
  net: dsa: microchip: Replace ad-hoc polling with regmap
  net: dsa: microchip: Replace ksz9477_wait_vlan_ctrl_ready polling with
    regmap
  net: dsa: microchip: Replace ksz9477_wait_alu_ready polling with
    regmap
  net: dsa: microchip: Replace ksz9477_wait_alu_sta_ready polling with
    regmap
  net: dsa: microchip: Replace bit RMW with regmap

 drivers/net/dsa/microchip/ksz9477.c    | 128 +++++++++----------------
 drivers/net/dsa/microchip/ksz_common.h |  14 ---
 2 files changed, 47 insertions(+), 95 deletions(-)

-- 
2.20.1

