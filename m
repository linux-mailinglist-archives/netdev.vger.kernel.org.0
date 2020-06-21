Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37055202976
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgFUIAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:00:47 -0400
Received: from smtp45.i.mail.ru ([94.100.177.105]:45758 "EHLO smtp45.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729465AbgFUIAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 04:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From; bh=csAOUL86HSiLSf5Zj+5mkQ3/QUS8nmkxMgwT2xr1QNs=;
        b=fokQdHzfrpje5+WvcStd70CLUsQ9iOGjfkRiFzzOxcfKsteMghuYQbOlBDbwrEqBkEOpHqUGr0ejiqA4wwQjVCumL3AmldSEXyVqnJJ65ZLeSCq4DzdqeyMoQm/oKLcGzRGctj/U0JmKfNWGD11G0RCyqQisnbj7LSdM+4sfo7Q=;
Received: by smtp45.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1jmuuB-0000ou-8M; Sun, 21 Jun 2020 11:00:43 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     Maxim Kochetkov <fido_max@inbox.ru>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/3] Add Marvell 88E1340S, 88E1548P support
Date:   Sun, 21 Jun 2020 10:59:49 +0300
Message-Id: <20200621075952.11970-1-fido_max@inbox.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp45.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9AAC5A87EC32CE31E7E618D9A39B32F604F18773C824D9F38182A05F538085040F836DE010EEBA2B283E69001B37057C0E9E7380992F98E88447C8C5CF9D8A041
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE77E216A0E97507353EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F790063753275FB77F6A31628638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC34C26AE549D86D250785B46C7097FA04A3E976D6DBBFAB77389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C0DEC8C2C8BCD2534D8941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C34964A708C60C975A117882F4460429728AD0CFFFB425014E40A5AABA2AD371193AA81AA40904B5D9A18204E546F3947C188B2BFCDC338A02302FCEF25BFAB3454AD6D5ED66289B52F4A82D016A4342E36136E347CC761E07725E5C173C3A84C352AE7FAEF113C5EABA3038C0950A5D36B5C8C57E37DE458B0B4866841D68ED3567F23339F89546C55F5C1EE8F4F765FCC6A536F79815AD9275ECD9A6C639B01BBD4B6F7A4D31EC0BC0CAF46E325F83A522CA9DD8327EE4930A3850AC1BE2E735444A83B712AC0148C4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F05F538519369F3743B503F486389A921A5CC5B56E945C8DA
X-C8649E89: 8CEAF2896777E911A64208AB62F08C93CD86434D974DBF864CC5BA3F49982455338246270C6E8F71
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojijaCqZVrqPE9A+2MBc/txw==
X-Mailru-Sender: C88E38A2D15C6BD1F5DE00CD289934128EF6D947A40B90BDA7A5DDCEA0BC305B78B0FD82C58F3A8AEE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
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

 drivers/net/phy/marvell.c   | 268 +++++++++++++++++++++---------------
 include/linux/marvell_phy.h |   2 +
 2 files changed, 159 insertions(+), 111 deletions(-)

-- 
2.25.1

