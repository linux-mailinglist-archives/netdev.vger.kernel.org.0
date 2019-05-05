Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D831426D
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 23:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbfEEVP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 17:15:57 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:29086 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbfEEVPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 17:15:53 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id B1E6DA018C;
        Sun,  5 May 2019 23:15:51 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id OzY1807eyhP2; Sun,  5 May 2019 23:15:37 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 0/5] net: dsa: lantiq: Add bridge offloading
Date:   Sun,  5 May 2019 23:15:12 +0200
Message-Id: <20190505211517.25237-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds bridge offloading for the Intel / Lantiq GSWIP 2.1 switch.

Changes since:
v1:
 - fix typo signle -> single

Hauke Mehrtens (5):
  net: dsa: lantiq: Allow special tags only on CPU port
  net: dsa: lantiq: Add VLAN unaware bridge offloading
  net: dsa: lantiq: Add VLAN aware bridge offloading
  net: dsa: lantiq: Add fast age function
  net: dsa: lantiq: Add Forwarding Database access

 drivers/net/dsa/lantiq_gswip.c | 811 ++++++++++++++++++++++++++++++++-
 1 file changed, 802 insertions(+), 9 deletions(-)

-- 
2.20.1

