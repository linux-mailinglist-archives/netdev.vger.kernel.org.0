Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D2E437C4A
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhJVR6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:58:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231472AbhJVR6E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:58:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 691E961246;
        Fri, 22 Oct 2021 17:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634925346;
        bh=x/WuK1pi4PbFytbV5MXjH3vdQjqa5XSDLQ/39WZtOYE=;
        h=From:To:Cc:Subject:Date:From;
        b=BR0vrcNU2pvfhmEvOQA/a50r0NOm+kYTy3G7sitxaI0hZe5E6fK+BWfvE/AuwI0+z
         PT+6U7TRuAGGDUgkCCxF7UE7mIFmF2ZQ7RtNwsvWHzFQ+xrAwcfjHZpplEJOZLqxwq
         tLgd0ss0nlLRIBsmc6VexQ3qX4uqmUgR8h/Hgy7CU3S9R6AO99iV2fUeMNHmFNoWFB
         ARILZJiLPoFdkRrC0m0pHqq/RwvepA04JhKz+O7NJ+1M8Z6/9WCzDjS9dWVq4wY01+
         KyZ62mdMDTi/vIDG8wk1UdupYkkvIaLJyD8eT3X3nF72kA3V4SLWIdOXLqEncmz44x
         I1Y9/lzjZnKVA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/8] don't write directly to netdev->dev_addr
Date:   Fri, 22 Oct 2021 10:55:35 -0700
Message-Id: <20211022175543.2518732-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Constify references to netdev->dev_addr and
use appropriate helpers.

Jakub Kicinski (8):
  net: core: constify mac addrs in selftests
  net: rtnetlink: use __dev_addr_set()
  net: phy: constify netdev->dev_addr references
  net: bonding: constify and use dev_addr_set()
  net: hsr: get ready for const netdev->dev_addr
  net: caif: get ready for const netdev->dev_addr
  net: drivers: get ready for const netdev->dev_addr
  net: atm: use address setting helpers

 drivers/net/bonding/bond_alb.c    | 28 +++++++++++++---------------
 drivers/net/bonding/bond_main.c   |  2 +-
 drivers/net/macsec.c              |  2 +-
 drivers/net/macvlan.c             |  3 ++-
 drivers/net/phy/dp83867.c         |  4 ++--
 drivers/net/phy/dp83869.c         |  4 ++--
 drivers/net/vmxnet3/vmxnet3_drv.c |  4 ++--
 net/atm/br2684.c                  |  4 +++-
 net/atm/lec.c                     |  5 ++---
 net/caif/caif_usb.c               |  2 +-
 net/core/rtnetlink.c              |  4 ++--
 net/core/selftests.c              |  8 ++++----
 net/hsr/hsr_framereg.c            |  4 ++--
 net/hsr/hsr_framereg.h            |  4 ++--
 14 files changed, 39 insertions(+), 39 deletions(-)

-- 
2.31.1

