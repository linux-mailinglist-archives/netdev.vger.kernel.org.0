Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC121023B
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 00:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbfD3WK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 18:10:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50589 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfD3WK0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 18:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version
        :Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ip0LkpiHkEBmRbnU3+MNXc8IWx8LWS+9g1FUR1vCJGM=; b=B1ocB7gCBiO1+T3uNuYnrxvAAD
        il+XInf1FVJ6jeKNnRx8NGjPoBwzngv5w/hUjyqlHGkoJarUuPTdVV68B6RlkleGeVe4ZdmpYHZ/w
        qrIvfs6PZzazYZYPCglIQJ6fxyuSttcQWWMGmGRivVSE6owUcfJWV9XfQ8MXmUIJDFBI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLavX-00055I-9P; Wed, 01 May 2019 00:08:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/2] mv88e6xxx: Disable ports to save power
Date:   Wed,  1 May 2019 00:08:29 +0200
Message-Id: <20190430220831.19505-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Save some power by disabling ports. The first patch fully disables a
port when it is runtime disabled. The second disables any ports which
are not used at all.

Depending on configuration strapping, this can lower the temperature
of an idle switch a few degrees.

Andrew Lunn (2):
  net: dsa: mv88e6xxx: Set STP disable state in port_disable
  net: dsa :mv88e6xxx: Disable unused ports

 drivers/net/dsa/mv88e6xxx/chip.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

-- 
2.20.1

