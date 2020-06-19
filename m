Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD10200453
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 10:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgFSIty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 04:49:54 -0400
Received: from smtp33.i.mail.ru ([94.100.177.93]:41422 "EHLO smtp33.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbgFSItv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 04:49:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From; bh=m2GKKOMhXUheCkaj5kG/qUXOZLwCXNHH9N+dgvbefMQ=;
        b=GJRej8GoQjrqenNnsnHmoEzb9EN0m/AYVTgNuDeb3BLMq/i1kZD6ScQyz2HiVHPBf5CqyQFKhE8uMC69PWoJuu+LJn3cD1rHSw50DBVAt2pmPwWauflyIyHITYf4RdWgSAWcE1himQtBqTIsc89tO0HTUSFIPKuBc/6fZoOTf7Q=;
Received: by smtp33.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1jmCiZ-0005tu-CX; Fri, 19 Jun 2020 11:49:47 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     Maxim Kochetkov <fido_max@inbox.ru>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/3] Add Marvell 88E1340S, 88E1548P support
Date:   Fri, 19 Jun 2020 11:49:01 +0300
Message-Id: <20200619084904.95432-1-fido_max@inbox.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp33.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9FF4B5D0D517DDB95747F1E434BDA6853FB4F529DC5F605E8182A05F538085040131F907C09D4F5553569ABF88A2940B59A79F903D9FB0FA46ABCA43811A7FB24
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7F8E53417176C7207EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637DD81BB19E5DE3F6B8638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC5347410A10DF4ECDCCECEEE47D29AE401185CC79644456E3389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C0DEC8C2C8BCD2534D8941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C3A12191B5F2BB8629117882F4460429728AD0CFFFB425014E40A5AABA2AD371193AA81AA40904B5D9A18204E546F3947CE3C0F74373B9C9F46E0066C2D8992A164AD6D5ED66289B52F4A82D016A4342E36136E347CC761E07725E5C173C3A84C3FEECBD9D8E7EEAA2BA3038C0950A5D36B5C8C57E37DE458B0B4866841D68ED3567F23339F89546C55F5C1EE8F4F765FCB9CEE4F2B4A90F8475ECD9A6C639B01BBD4B6F7A4D31EC0BC0CAF46E325F83A522CA9DD8327EE4930A3850AC1BE2E735D2D576BCF940C736C4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F9007B117A3693DAE3B503F486389A921A5CC5B56E945C8DA
X-C8649E89: 9872270F787B702DB68A7A8A64A3AC39F39D142E916C29C64CC5BA3F49982455338246270C6E8F71
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj7ZRlLMijxWqAc2pZa3Eh4A==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB2434B50BFEBAE044EC3BC88FDC9ECCE82DD0C8335361DDF715EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add new PHY id support.
Russell King asked to use single style for referencing functions.

Maxim Kochetkov (3):
  net: phy: marvell: use a single style for referencing functions
  net: phy: marvell: Add Marvell 88E1340S support
  net: phy: marvell: Add Marvell 88E1548P support

 drivers/net/phy/marvell.c   | 269 +++++++++++++++++++++---------------
 include/linux/marvell_phy.h |   2 +
 2 files changed, 160 insertions(+), 111 deletions(-)

-- 
2.25.1

