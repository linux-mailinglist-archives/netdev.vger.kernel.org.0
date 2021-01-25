Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E644C304A14
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731034AbhAZFPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:15:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729887AbhAYPfk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 10:35:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2610225AB;
        Mon, 25 Jan 2021 15:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611586982;
        bh=anyjJQn5LMe/z7QdjC1tPEtQH0Fp7Y+ZF9Tn/tpqdWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIATlKNz2IJ+/G3lPuG30rPIgX7EniVgb3H8pwow2UlN0rwXyYArmtrFvVIjtYqY/
         7MnmS2MBu0QXy1jnKPQTvy4gEq5r0MqFZqvhEFg7blRMP/hOnxIJICmL+ufN2mTFvW
         bjYFs1xlWPku7VPuQzo+7GZeW8r4kZBE7K9xwGpleKGWK7NpBOo2hMX9midbGzSNVV
         q0hYkM0GZU5D2eLHPq/vNM8LHhoeitYAMFjMN8axwYxEpBVZ3cd5IlqNYLwDIrxJPC
         dBIjINvTbi15mo/oWrvVLv5Al69ItHMFywxQzrTMFfI48EY0QGm5XiPz/+J74YSk21
         i6TgWmvZ7rqDg==
Received: by pali.im (Postfix)
        id 8E5B8768; Mon, 25 Jan 2021 16:03:00 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] net: sfp: add support for GPON RTL8672/RTL9601C and Ubiquiti U-Fiber
Date:   Mon, 25 Jan 2021 16:02:26 +0100
Message-Id: <20210125150228.8523-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201230154755.14746-1-pali@kernel.org>
References: <20201230154755.14746-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is fourth version of patches which add workarounds for
RTL8672/RTL9601C EEPROMs and Ubiquiti U-Fiber Instant SFP.

The only change since third version is modification of commit messages.

Pali Rohár (2):
  net: sfp: add workaround for Realtek RTL8672 and RTL9601C chips
  net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant

 drivers/net/phy/sfp-bus.c |  15 +++++
 drivers/net/phy/sfp.c     | 117 ++++++++++++++++++++++++++------------
 2 files changed, 97 insertions(+), 35 deletions(-)

-- 
2.20.1

