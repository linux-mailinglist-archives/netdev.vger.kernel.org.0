Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC122EF1B3
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 01:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387456AbfKEANf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 19:13:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48904 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387394AbfKEANf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 19:13:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7sqB/zACQsj5cFVZPc2LFgBxE7/KHzkDaA05R32m/UA=; b=w1wSc6lOxQMr8Kkzxnrkoy/GJ+
        Cq/XtRYqOgE3aCXSuET+Iu3XpLsVjSA1MMn6VgbB245myc+CFzh9sQbpAyOHhr2mxvQF1U8Q7CpNU
        nHL5o07VZA70rfqQ+5+rW3ZsWMWYGgjj62sbv67v9ox0S9gEbXTGvvmLMhLeceKDgkb8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iRmTD-0007Hn-0m; Tue, 05 Nov 2019 01:13:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>, jiri@mellanox.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/5] mv88e6xxx ATU occupancy as devlink resource
Date:   Tue,  5 Nov 2019 01:12:56 +0100
Message-Id: <20191105001301.27966-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset add generic support to DSA for devlink resources. The
Marvell switch Address Translation Unit occupancy is then exported as
a resource. In order to do this, the number of ATU entries is added to
the per switch info structure. Helpers are added, and then the
resource itself is then added.

Andrew Lunn (5):
  net: dsa: Add support for devlink resources
  net: dsa: mv88e6xxx: Add number of MACs in the ATU
  net: dsa: mv88e6xxx: global2: Expose ATU stats register
  net: dsa: mv88e6xxx: global1_atu: Add helper for get next
  net: dsa: mv88e6xxx: Add ATU occupancy via devlink resources

 drivers/net/dsa/mv88e6xxx/chip.c        | 215 +++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h        |   6 +
 drivers/net/dsa/mv88e6xxx/global1.h     |   1 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c |   5 +
 drivers/net/dsa/mv88e6xxx/global2.c     |  13 ++
 drivers/net/dsa/mv88e6xxx/global2.h     |  24 ++-
 include/net/dsa.h                       |  16 ++
 net/dsa/dsa.c                           |  37 ++++
 8 files changed, 312 insertions(+), 5 deletions(-)

-- 
2.23.0

