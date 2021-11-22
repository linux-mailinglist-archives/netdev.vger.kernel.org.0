Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A2745964B
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 21:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhKVUyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 15:54:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229836AbhKVUyW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 15:54:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7E8060200;
        Mon, 22 Nov 2021 20:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637614276;
        bh=0VBRwg+eCoKEZUn0RV4wwoyboHPii0YHcHjfSqPkz8c=;
        h=From:To:Cc:Subject:Date:From;
        b=QCOXRIRSLBrElYF2u1BcrafqiS9QHoShqWKkK9SzmuL9rw/3kdhUChW47DzWPdXoR
         GrC5PCztWoSOtXt+t29+8tA1pIKvcsy0p4nci7Ro5As3qVKvd6DZ8h8GuVnC8iZzEe
         OMDyhfAF9uoHuFCt1DykPKgTh2X6pETOFYdnpq7slfuwry7IOfM4uY9AyQIgWmTlvJ
         3DdT2KCq2RW+LYZouPDkaHauAUcVkyz+rsiVAozqXQ5YlYdMMJNc9jyadsXsfltoxe
         YjeRwkisqF2xzxTbTibK9JswhUpEpXjHEchtNd/9odHHpf+NGZk2h837jKFLLbLVS7
         24f3TpsFhJ4DQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 0/2] Add 5gbase-r support for mvpp2
Date:   Mon, 22 Nov 2021 21:51:09 +0100
Message-Id: <20211122205111.10156-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this adds support for 5gbase-r for mvpp2 driver. Current versions of
TF-A firmware support changing the PHY to 5gbase-r via SMC calls, at
least on Macchiatobin.

Tested on Macchiatobin.

Marek Behún (2):
  phy: marvell: phy-mvebu-cp110-comphy: add support for 5gbase-r
  net: marvell: mvpp2: Add support for 5gbase-r

 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 44 ++++++++++++++++---
 drivers/phy/marvell/phy-mvebu-cp110-comphy.c  |  9 ++++
 2 files changed, 46 insertions(+), 7 deletions(-)

-- 
2.32.0

