Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDC0173234
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 08:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgB1H4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 02:56:49 -0500
Received: from first.geanix.com ([116.203.34.67]:36146 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbgB1H4s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 02:56:48 -0500
Received: from localhost (87-49-45-242-mobile.dk.customer.tdc.net [87.49.45.242])
        by first.geanix.com (Postfix) with ESMTPSA id 44148C109A;
        Fri, 28 Feb 2020 07:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582876606; bh=jhkGkspXY/1ypb8uBTCek0CWi0k0+SYxXRM0eW/BSDU=;
        h=From:To:Cc:Subject:Date;
        b=gtMDZjMClPasPLH/9/vtBniF2hko1IM6RWOJLYJlxunbZAhakbwYL4ud2gS7/8xvg
         orPn8pDwomOuOntaOpWYqckAKC+w5Fa04mjstyEerV0+5yqJvPMQsT1CqOfGWRPbh7
         8PGqoHcuXKIEECrWy1Xwo4TdkhN3vlErYv9WB2NzTDCRMbsB28hH0wuN1Lzs07L9NW
         MZH8XaRJD/f4q+iMdvw9McFQYdtwCY3OP82oeW7HvncYW4s7GUc7Ij+PJtyhWM1meW
         t2KDcqo9CWb8FEfihqXtS9iZJjuByruzzXPv/HxHkd49JZ+3d9QlUUX9HdrK5N4lys
         LgKzpmVAE+RuQ==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH net-next 0/4] net: ll_temac: RX/TX ring size and coalesce ethtool parameters
Date:   Fri, 28 Feb 2020 08:56:42 +0100
Message-Id: <cover.1582875715.git.esben@geanix.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=4.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 05ff821c8cf1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for RX/TX ring size and irq coalesce ethtool
parameters to ll_temac driver.

Esben Haabendal (4):
  net: ll_temac: Remove unused tx_bd_next struct field
  net: ll_temac: Remove unused start_p variable
  net: ll_temac: Make RX/TX ring sizes configurable
  net: ll_temac: Add ethtool support for coalesce parameters

 drivers/net/ethernet/xilinx/ll_temac.h      |   8 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c | 198 +++++++++++++++-----
 2 files changed, 154 insertions(+), 52 deletions(-)

-- 
2.25.1

