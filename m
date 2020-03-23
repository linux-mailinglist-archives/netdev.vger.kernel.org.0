Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 324EE1900A8
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgCWVti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:49:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgCWVti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 17:49:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RPoz6ukbcDFtUp6PfyFx5W3V7zEHhiIU4+Tw9b+JNjk=; b=lDRqHWOoJcHBgo2QUMXvELy0gs
        quffs7zu+nk0NyvWzWjqZlvzQyxY2mkHkoSp3HA245uTCA100JsuPwGlTq1KYMFOl1CJX3FPcqnwI
        c04p6rnopbi2qkLbzaOtFYtu7unXxWdfd6NBCEMbWjImumQjFZIZZdV4MD1K6ULxUEes=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGUwh-0003fy-4E; Mon, 23 Mar 2020 22:49:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/2] mv88e6xxx fixed link fixes
Date:   Mon, 23 Mar 2020 22:48:58 +0100
Message-Id: <20200323214900.14083-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent changes for how the MAC is configured broke fixed links, as
used by CPU/DSA ports, and for SFPs when phylink cannot be used.

Andrew Lunn (2):
  net: dsa: mv88e6xxx: Configure MAC when using fixed link
  net: dsa: mv88e6xxx: Set link down when changing speed

 drivers/net/dsa/mv88e6xxx/chip.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

-- 
2.26.0.rc2

