Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF95A10E38
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfEAUpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:45:36 -0400
Received: from mx1.mailbox.org ([80.241.60.212]:62750 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfEAUpg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 16:45:36 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx1.mailbox.org (Postfix) with ESMTPS id 478164C668;
        Wed,  1 May 2019 22:45:34 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id zDz39ELpx5RF; Wed,  1 May 2019 22:45:31 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/5] net: dsa: lantiq: Add bridge offloading
Date:   Wed,  1 May 2019 22:45:01 +0200
Message-Id: <20190501204506.21579-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds bridge offloading for the Intel / Lantiq GSWIP 2.1 switch.

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

