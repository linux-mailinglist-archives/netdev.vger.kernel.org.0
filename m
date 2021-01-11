Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE702F119E
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 12:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729900AbhAKLkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 06:40:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbhAKLkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 06:40:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB8C7224BD;
        Mon, 11 Jan 2021 11:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610365171;
        bh=q29ReHpBql2Zgc+FRSZA+OZfYwG1WIN51qCH8XoCnkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4KQzcjS42XSa9EBnqqVBD4RuLbV8mj/YQ6zGCVw/cIMb4elZC0uDsBsPN/CMdSjd
         zNIud+e8ekiLCUeZRA+MwV7izlCsPAMsql2b7FbNlu2DzjvlVri0d6CCOU/VxF8pKA
         YvkZGpIaTFwqamMkRoq9oPkRpRzK4bbbRrfm1NZPT+Cqy2dQ3jVQQtMKPKNG/hcldP
         5z9Mj2joiMqTGH8FxR+iS+zacMRspSunfKgQVmLoo5Zg4UA8ud1IDODBsxWq/qPyRU
         IC4oGZNTGKnHORoi/DxjIsA4fCQon3SFaDnaK818XeEoCUh55zDRvOBcpDSpB0m01s
         NGYIZwUGHwguw==
Received: by pali.im (Postfix)
        id 2C54F87B; Mon, 11 Jan 2021 12:39:29 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] net: sfp: add support for GPON RTL8672/RTL9601C and Ubiquiti U-Fiber
Date:   Mon, 11 Jan 2021 12:39:07 +0100
Message-Id: <20210111113909.31702-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201230154755.14746-1-pali@kernel.org>
References: <20201230154755.14746-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a third version of patches which add workarounds for
RTL8672/RTL9601C EEPROMs and Ubiquiti U-Fiber Instant SFP.

Russel's PATCH v2 2/3 was dropped from this patch series as
it is being handled separately.

Pali Rohár (2):
  net: sfp: add workaround for Realtek RTL8672 and RTL9601C chips
  net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant

 drivers/net/phy/sfp-bus.c |  15 +++++
 drivers/net/phy/sfp.c     | 117 ++++++++++++++++++++++++++------------
 2 files changed, 97 insertions(+), 35 deletions(-)

-- 
2.20.1

