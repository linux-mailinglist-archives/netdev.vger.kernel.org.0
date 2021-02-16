Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D2131D0E7
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhBPTWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:22:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229916AbhBPTV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 14:21:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 073CA64E65;
        Tue, 16 Feb 2021 19:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613503278;
        bh=FTpgoOlClhQc1+LvIC0BV+fD2T7KSh560wZaT4mPTcA=;
        h=From:To:Cc:Subject:Date:From;
        b=XsDoR+7HKDNg+Xr+m0Z5hjaOsXb2EOYFWJpVRdEPQtO7proJ8jFqFxgVbgnjvHx6r
         vtQKaEHCJ8ZZzfMNJscsiH7T3A7TlYh718cfFG37OkKLaZc1/f7IznJtpuCEtbpQSe
         j6AJ1M4cqzjOm9kmIaW5U0WgYy33sOhNzcuxFV2ar1WFT2XgBgWLLTCfDwN3DfU47+
         81QoRjA6GPZJw6n3giDXaANv+BikaMQtq9qokehsVVA4N/CwY/yMoxHcjWJVdQDBN/
         CfYat8ZUnVE/pmg/eBYY4jqjhkC78RkVVzsfmwzPzS3K5bjxZProsNCMI7L4amiUvv
         Z6P9yTdrWvFrg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        davem@davemloft.net, kuba@kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, lkp@intel.com, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 0/4] Add 5gbase-r PHY interface mode
Date:   Tue, 16 Feb 2021 20:20:51 +0100
Message-Id: <20210216192055.7078-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

there is still some testing needed for Amethyst patches, so I have
split the part adding support for 5gbase-r interface mode and am sending
it alone.

The first two patches are already reviewed.

Changes since last patches (Amethyst v16):
- added phylink 5gbase-r handler
- added SFP support for 5gbase-r mode

Marek

Marek Behún (2):
  net: phylink: Add 5gbase-r support
  sfp: add support for 5gbase-t SFPs

Pavana Sharma (2):
  dt-bindings: net: Add 5GBASER phy interface
  net: phy: Add 5GBASER interface mode

 .../devicetree/bindings/net/ethernet-controller.yaml        | 1 +
 Documentation/networking/phy.rst                            | 6 ++++++
 drivers/net/phy/phylink.c                                   | 4 ++++
 drivers/net/phy/sfp-bus.c                                   | 3 +++
 include/linux/phy.h                                         | 4 ++++
 5 files changed, 18 insertions(+)

-- 
2.26.2

