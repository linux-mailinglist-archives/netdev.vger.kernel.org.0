Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C96343808D
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhJVXX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230086AbhJVXX1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 19:23:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC18060FBF;
        Fri, 22 Oct 2021 23:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634944869;
        bh=euRk4GqnjDNLSwM7i+0QjBXIe1bNYlFDqBWCAA3a9+Y=;
        h=From:To:Cc:Subject:Date:From;
        b=Qf7xQJ0cCvmROuM/2SSjmED3dGOmksDMnAG0b5hrUDuSamlMaYxgRMAKD09WZRcvT
         y1uKLRYwBP1vsaR8JxOq0pYJTyKELFUjhysERFuIib9Z3IIPmNOcceeNf6WKOCx8MR
         G8d2CqHM28NP7spe/zEjLF1v8aYE3gH52mmLJ+j/uMAvm3OFlyWli+K/YOSJuNorMd
         s2x6xXPz4kXd265x6sZDtI7FWLYGE/2ue/UkZ/H1SOwX/964+FZ20anviAoJuS+7X+
         RMuhAdO43Q2vy87aPuC3hlWk4xF2Ml0bhB7vdVrq66ZAOnnDwMwfAVKfkwDq/ZPtNV
         f9wE9hXS73pXg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/8] don't write directly to netdev->dev_addr
Date:   Fri, 22 Oct 2021 16:20:55 -0700
Message-Id: <20211022232103.2715312-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Constify references to netdev->dev_addr and
use appropriate helpers.

v2: s/got/go/

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

