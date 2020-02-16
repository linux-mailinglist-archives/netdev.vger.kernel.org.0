Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1FB16052C
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 18:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgBPRyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 12:54:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48500 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbgBPRyh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 12:54:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=peAo8rrTD/wYQnBuwilusp2obepk2vfBfItGvcerrBM=; b=W9hjN6ElN2mCf8Bu6hAuOJxDYc
        EyxV9sW8W/sUVybPjt6hoKT00mnAOLv5ZMp/sEP8bJrq5X5KCd+6BNveUyq67uycyAlUFDDDDgeh4
        Y3XmrOKaP8giTm0Wg1YR3UtjWan0ZEQ7GqBoKzv4qXy2hScKoVMkcAzH2NHVm3QA+EZY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j3O7d-0008T0-Qp; Sun, 16 Feb 2020 18:54:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/3] mv88e6xxx: Add SERDES/PCS registers to ethtool -d
Date:   Sun, 16 Feb 2020 18:54:12 +0100
Message-Id: <20200216175415.32505-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool -d will dump the registers of an interface. For mv88e6xxx
switch ports, this dump covers the port specific registers. Extend
this with the SERDES/PCS registers, if a port has a SERDES.

Andrew Lunn (3):
  net: dsa: mv88e6xxx: Allow PCS registers to be retrieved via ethtool
  net: dsa: mv88e6xxx: Add 6352 family PCS registers to ethtool -d
  net: dsa: mv88e6xxx: Add 6390 family PCS registers to ethtool -d

 drivers/net/dsa/mv88e6xxx/chip.c   | 32 ++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h   |  5 ++
 drivers/net/dsa/mv88e6xxx/serdes.c | 77 ++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |  5 ++
 4 files changed, 118 insertions(+), 1 deletion(-)

-- 
2.25.0

