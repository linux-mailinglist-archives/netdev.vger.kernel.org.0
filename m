Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BED6474E9B
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 00:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238261AbhLNXek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 18:34:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43666 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238257AbhLNXej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 18:34:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA44E6174D;
        Tue, 14 Dec 2021 23:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F0FC34600;
        Tue, 14 Dec 2021 23:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639524878;
        bh=wI9nmY3mEtt26cxtE+Zt3H6P52A5LLMVvJbx7VbsnPo=;
        h=From:To:Cc:Subject:Date:From;
        b=tUzNWvSqH6XSpWLgLz+ds+tDyoHkNSO4Cnza27m6c4bDkNKxDYgO5b4/pLA7dTFFr
         ZOlOSseIte9DuIiK/thRGiTmtwrW8dlDKxUqN3X5fcmx7YuGSLOdUh8FFWqjKhT+6C
         BMlwwVhdRj/DmvnsK9CONsSitqtlWHE7mmD8GRz70YXbl+YPUcI1w2AWmMF+YE48Pd
         sc17FfVdLFUm8WjtTfpr6SvbExOXdUNhujjMxjCZ7I2jP08VB5Je1faSfljR+ATklU
         /pE4ZakE0O+GpzyhZKlztOO0mrvpwT1RBbSBoOzkcS5K+FdSUKzYda31MAkSSrMeyy
         dN9vYMAbF9shA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH devicetree 0/2] Common PHY to YAML + tx-amplitude property
Date:   Wed, 15 Dec 2021 00:34:30 +0100
Message-Id: <20211214233432.22580-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts common PHY binding to YAML and adds property for
specifying PHY transmit amplitude.

Marek Behún (2):
  dt-bindings: phy: Convert generic PHY provider binding to YAML
  dt-bindings: phy: Add `tx-amplitude-microvolt` property binding

 .../devicetree/bindings/phy/phy-bindings.txt  | 73 +----------------
 .../devicetree/bindings/phy/phy.yaml          | 81 +++++++++++++++++++
 2 files changed, 82 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/phy.yaml

-- 
2.32.0

