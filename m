Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91DFDCB314
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 03:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730861AbfJDBf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 21:35:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60352 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728954AbfJDBf5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 21:35:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=U8UijmsryQF2pwAybuzwWVksqBSOZAexKzR4fWd7vMo=; b=lDKHOqVsNTpwYCGGGscbSA51Gd
        PphpYCZJuD2JEKr+2oj4zl4L/J5jveaWPFkMbfjKaJjKo/PsbzTnPO6Ym+xJl55lJxCx946bTm/Ha
        CMG+wCwWdBOillao7mfcrnWNU2EVdHnZETbT28UmNYCDHBGfppKdNU9OFqHZnrvrtV2I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iGCVM-0007NI-Pm; Fri, 04 Oct 2019 03:35:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/2] mv88e6xxx: Allow config of ATU hash algorithm
Date:   Fri,  4 Oct 2019 03:35:21 +0200
Message-Id: <20191004013523.28306-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Marvell switches allow the hash algorithm for MAC addresses in the
address translation unit to be configured. Add support to the DSA core
to allow DSA drivers to make use of devlink parameters, and allow the
ATU hash to be get/set via such a parameter.

Andrew Lunn (2):
  net: dsa: Add support for devlink device parameters
  net: dsa: mv88e6xxx: Add devlink param for ATU hash algorithm.

 drivers/net/dsa/mv88e6xxx/chip.c        | 136 +++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h        |   4 +
 drivers/net/dsa/mv88e6xxx/global1.h     |   3 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c |  30 ++++++
 include/net/dsa.h                       |  23 ++++
 net/dsa/dsa.c                           |  48 +++++++++
 net/dsa/dsa2.c                          |   7 +-
 7 files changed, 249 insertions(+), 2 deletions(-)

-- 
2.23.0

