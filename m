Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F2697D79
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbfHUOp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:45:57 -0400
Received: from mx.0dd.nl ([5.2.79.48]:54136 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729234AbfHUOp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 10:45:56 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 8F4CD5FB50;
        Wed, 21 Aug 2019 16:45:55 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="E9uTpccz";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id 5C1FA1D8290C;
        Wed, 21 Aug 2019 16:45:55 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 5C1FA1D8290C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566398755;
        bh=0kUa5Ungc7V6E1VFo+fYEYf+NT1SqygGndKdc6r86I4=;
        h=From:To:Cc:Subject:Date:From;
        b=E9uTpcczXg7cXVtzCEz8w79LhJCZuxEZSeYDhgxEZG+UKATbL1KNKHo9D4Qb7IR1k
         fNQHFH9OLGJMRp/z+DXzHLmxP+hZBGEfVgq5Xk2vtOnPhxeaNEqlirnMi2S8RhGqkw
         G2ig+n6Omaxn6l6x35EQcxNVlUTl7+Kx3kTBLuwjqBqP+gMvwFFGnUuZkYiq4+nxa9
         klgKKAX9LEjaqDQHqoilX6HDQRKcNklHzHOwnWiN57uloC1MsGarJ8wYaxEGmjDayU
         0lukPqULmqZRaHM7x6byj1vGiB7FJBT2V4wndidMQVfC5ZPWQ4M97pwuc4SLcbIr8b
         /CyhDaoa+uVKw==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>, linux-mips@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next v2 0/3] net: dsa: mt7530: Convert to PHYLINK and add support for port 5
Date:   Wed, 21 Aug 2019 16:45:44 +0200
Message-Id: <20190821144547.15113-1-opensource@vdorst.com>
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

v1->v2:
 * Mostly phylink improvements after review.
rfc -> v1:
 * Mostly phylink improvements after review.
 * Drop phy isolation patches. Adds no value for now.
René van Dorst (3):
  net: dsa: mt7530: Convert to PHYLINK API
  dt-bindings: net: dsa: mt7530: Add support for port 5
  net: dsa: mt7530: Add support for port 5

 .../devicetree/bindings/net/dsa/mt7530.txt    | 218 ++++++++++
 drivers/net/dsa/mt7530.c                      | 371 +++++++++++++++---
 drivers/net/dsa/mt7530.h                      |  61 ++-
 3 files changed, 577 insertions(+), 73 deletions(-)

-- 
2.20.1

