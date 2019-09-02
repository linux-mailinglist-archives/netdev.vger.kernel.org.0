Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EACD1A56F1
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 15:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbfIBNCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 09:02:37 -0400
Received: from mx.0dd.nl ([5.2.79.48]:35062 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729770AbfIBNCh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 09:02:37 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 6B3175FA49;
        Mon,  2 Sep 2019 15:02:35 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="sO1B5De6";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.232])
        by mail.vdorst.com (Postfix) with ESMTPA id 288291DB4019;
        Mon,  2 Sep 2019 15:02:35 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 288291DB4019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1567429355;
        bh=Cu2l4plbvHJDGjWeI5n0FmhZk+4i5/ZcSrC/B/TwPy0=;
        h=From:To:Cc:Subject:Date:From;
        b=sO1B5De6OkKQ2VqYZrXXypkJiyHV2jaXuU3g7M3IMb6ld+qgE+TAPmi2B4J79VXC4
         fMvzQdmYIpRQVtLfeXMD/59J10Tins4qCU9iaZ8xW6BAShu0IbxzCa8PNa9aZVAZoa
         C1zR/i/Wb7lMQXkxZaRJdeBrZkjwHxfqwwFl/iB11D/KQ6ow1+sGf9RqHAdxqb3jWB
         NyynqM+nsbLdPvxXIqD+IutcliAI4JlbR+qfRzer5GyiMlCedGB09tn97pFowvv3r0
         fkOAtBEcQLy//FYVD6BaI3B35moxtglmtXwmk4cdOst2bHGso+U7tAzHjaMghfaHiH
         FD78PYuLlYWJw==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, linux-mips@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next v3 0/3] net: dsa: mt7530: Convert to PHYLINK and add support for port 5
Date:   Mon,  2 Sep 2019 15:02:23 +0200
Message-Id: <20190902130226.26845-1-opensource@vdorst.com>
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

v2->v3:
 * Removed 'status = "okay"' lines in patch #2
 * Change a port 5 setup message in a debug message in patch #3
 * Added ack-by and tested-by tags
v1->v2:
 * Mostly phylink improvements after review.
rfc -> v1:
 * Mostly phylink improvements after review.
 * Drop phy isolation patches. Adds no value for now.

René van Dorst (3):
  net: dsa: mt7530: Convert to PHYLINK API
  dt-bindings: net: dsa: mt7530: Add support for port 5
  net: dsa: mt7530: Add support for port 5

 .../devicetree/bindings/net/dsa/mt7530.txt    | 214 ++++++++++
 drivers/net/dsa/mt7530.c                      | 371 +++++++++++++++---
 drivers/net/dsa/mt7530.h                      |  61 ++-
 3 files changed, 573 insertions(+), 73 deletions(-)

-- 
2.20.1

