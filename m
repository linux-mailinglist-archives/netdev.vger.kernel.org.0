Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C602F0C84
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbhAKF3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:29:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbhAKF3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 00:29:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EA9522A83;
        Mon, 11 Jan 2021 05:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610342885;
        bh=+PgYJSdZLWU1lW6H1U/Yz+sOq9dLLOXqLYWdB9rBy7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+XunlfzG6chT31SqfjgMdHpaf9MfeSnjiOTFqMWJj2j5UqUp7AZOi3AMIWbHXbeq
         RcQTWfvZxJXPZyAfIkoMPPBKqMHE1n0HwIlx/DVdFwarPF5M3yWykneaSOJvxTJe/5
         WI3aoN655LW9Z/xrTYMhn6JfxBbMjZ8IHeAoTwGjXIcR8awxZ/ABt+DZQbOU/AkDks
         mH5gpV66TmeglnGFnGR9Pj2YAcssaK7LOTU8ivm0RhScldPDqqudwWrLInfcSZX54M
         qXhxEQ+jS0G4mhWQGYF2sIz05o/mIAHW9On5BiWNd6pWel0s9g+PYW/o7y+HyIspbR
         pb7XYDYKKssIQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
Subject: [PATCH net 6/9] MAINTAINERS: mtk-eth: remove Felix
Date:   Sun, 10 Jan 2021 21:27:56 -0800
Message-Id: <20210111052759.2144758-7-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210111052759.2144758-1-kuba@kernel.org>
References: <20210111052759.2144758-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop Felix from Mediatek Ethernet driver maintainers.
We haven't seen any tags since the initial submission.

Not adding a CREDITS entry because summarizing Felix's
contributions as "initial Mediatek MT7623 driver" is
really selling it short. And Felix is not gone, so he
can write his own description :P

Subsystem MEDIATEK ETHERNET DRIVER
  Changes 39 / 196 (19%)
  Last activity: 2020-04-07
  Felix Fietkau <nbd@nbd.name>:
  John Crispin <john@phrozen.org>:
    Author 6427dc1da51d 2017-08-09 00:00:00 28
    Tags 6427dc1da51d 2017-08-09 00:00:00 38
  Sean Wang <sean.wang@mediatek.com>:
    Author 880c2d4b2fdf 2019-06-03 00:00:00 50
    Tags a5d75538295b 2020-04-07 00:00:00 55
  Mark Lee <Mark-MC.Lee@mediatek.com>:
    Author 8d66a8183d0c 2019-11-14 00:00:00 4
    Tags 8d66a8183d0c 2019-11-14 00:00:00 4
  Top reviewers:
    [8]: andrew@lunn.ch
    [7]: f.fainelli@gmail.com
  INACTIVE MAINTAINER Felix Fietkau <nbd@nbd.name>

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Felix Fietkau <nbd@nbd.name>
CC: John Crispin <john@phrozen.org>
CC: Sean Wang <sean.wang@mediatek.com>
CC: Mark Lee <Mark-MC.Lee@mediatek.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 92fdc134ca14..b3e88594808a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11165,7 +11165,6 @@ F:	Documentation/devicetree/bindings/dma/mtk-*
 F:	drivers/dma/mediatek/
 
 MEDIATEK ETHERNET DRIVER
-M:	Felix Fietkau <nbd@nbd.name>
 M:	John Crispin <john@phrozen.org>
 M:	Sean Wang <sean.wang@mediatek.com>
 M:	Mark Lee <Mark-MC.Lee@mediatek.com>
-- 
2.26.2

