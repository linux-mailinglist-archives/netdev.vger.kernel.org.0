Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B7C73FBC
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388254AbfGXUe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 16:34:57 -0400
Received: from mx.0dd.nl ([5.2.79.48]:52898 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728607AbfGXT0V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 15:26:21 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 345015FD5A;
        Wed, 24 Jul 2019 21:26:19 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="U0yugvGO";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id D6A5F1D25D39;
        Wed, 24 Jul 2019 21:26:18 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com D6A5F1D25D39
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1563996378;
        bh=Ss2HrGE2MdzKsLVFFLyyU08QQHMn+fv1AywMDR+R/BI=;
        h=From:To:Cc:Subject:Date:From;
        b=U0yugvGOBpC/vwUsUt5j2uKo+4qbU0pt18CO55nVYlCdCJZFqSNi0wcdD4hzYwjLJ
         wmnLPMBObKAB12n9ktvAjwldO4vC2d7hyIpO+qGlWgcoeQHGt1+NXMn/f2ZzRSbd8w
         QvZUmcMil7TBJqs6M+6Q2fcOVdOcgChz1JJZT0O3QUF6QomaH17M5YFnhmbmpGC7rM
         8IINX3n+/U69akQcVWrCcpriuJ9B5H1HTvBbWdGcP/ZMbIN/qJbshs/Ff2jtWJ7E8E
         3sLfa9WW/iNe8Azd+um+HHOSYJOD9a3G4RdHkOmC+mM4ZvbN80RfwxHGnJ70hy/fEi
         jnOkZ/l27B2qg==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     netdev@vger.kernel.org
Cc:     frank-w@public-files.de, sean.wang@mediatek.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        matthias.bgg@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        john@phrozen.org, linux-mediatek@lists.infradead.org,
        linux-mips@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next 0/3] net: dsa: MT7530: Convert to PHYLINK and add support for port 5
Date:   Wed, 24 Jul 2019 21:25:46 +0200
Message-Id: <20190724192549.24615-1-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. net: dsa: mt7530: Convert to PHYLINK API
   This patch converts mt7530 to PHYLINK API.
2. dt-bindings: net: dsa: mt7530: Add support for port 5
3. net: dsa: mt7530: Add support for port 5
   These 2 patches adding support for port 5 of the switch.

rfc -> v1:
 * Mostly phylink improvements after review.
 * Drop phy isolation patches. Adds no value for now.

René van Dorst (3):
  net: dsa: mt7530: Convert to PHYLINK API
  dt-bindings: net: dsa: mt7530: Add support for port 5
  net: dsa: mt7530: Add support for port 5

 .../devicetree/bindings/net/dsa/mt7530.txt    | 215 +++++++++++
 drivers/net/dsa/mt7530.c                      | 356 +++++++++++++++---
 drivers/net/dsa/mt7530.h                      |  60 ++-
 3 files changed, 561 insertions(+), 70 deletions(-)

To: <netdev@vger.kernel.org>
Cc: Sean Wang <sean.wang@mediatek.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Cc: Frank Wunderlich <frank-w@public-files.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-mediatek@lists.infradead.org
Cc: linux-mips@vger.kernel.org
Cc: John Crispin <john@phrozen.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>

-- 
2.20.1

