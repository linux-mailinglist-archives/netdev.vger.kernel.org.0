Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 526F7142CE
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 00:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbfEEWZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 18:25:30 -0400
Received: from mx1.mailbox.org ([80.241.60.212]:20214 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbfEEWZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 18:25:30 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx1.mailbox.org (Postfix) with ESMTPS id 946E64BD83;
        Mon,  6 May 2019 00:25:28 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id wZRGeZd3w4k0; Mon,  6 May 2019 00:25:24 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v3 0/5] net: dsa: lantiq: Add bridge offloading
Date:   Mon,  6 May 2019 00:25:05 +0200
Message-Id: <20190505222510.14619-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds bridge offloading for the Intel / Lantiq GSWIP 2.1 switch.

Changes since:
v2:
 - Added Fixes tag to patch 1
 - Fixed typo
 - added GSWIP_TABLE_MAC_BRIDGE_STATIC and made use of it
 - used GSWIP_TABLE_MAC_BRIDGE in more places

v1:
 - fix typo signle -> single

Hauke Mehrtens (5):
  net: dsa: lantiq: Allow special tags only on CPU port
  net: dsa: lantiq: Add VLAN unaware bridge offloading
  net: dsa: lantiq: Add VLAN aware bridge offloading
  net: dsa: lantiq: Add fast age function
  net: dsa: lantiq: Add Forwarding Database access

 drivers/net/dsa/lantiq_gswip.c | 812 ++++++++++++++++++++++++++++++++-
 1 file changed, 803 insertions(+), 9 deletions(-)

-- 
2.20.1

