Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A761448444D
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbiADPLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:11:49 -0500
Received: from mx3.wp.pl ([212.77.101.10]:15687 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230321AbiADPLt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 10:11:49 -0500
Received: (wp-smtpd smtp.wp.pl 17746 invoked from network); 4 Jan 2022 16:11:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1641309107; bh=6559S1Oozzg/Tq1L9l+CRBqLHF2kUBPocLFtQDFiJok=;
          h=From:To:Subject;
          b=komFoGi9vghEvKdz2h2kvZEzltKbdkzHIr8VuO8sT10p+5x2+KegoO2Jxy7zWYgqU
           hy0GpdeKgCNUjZsSw6g4iwtgDtvwDgG4+1PSaF+8lB/FcBa7tniQu5YArdyieznaNM
           tvYDFn4WAi6aTVcfInCCx5Y0804NZU5+TLTR+Lmc=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <tsbogend@alpha.franken.de>; 4 Jan 2022 16:11:46 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     tsbogend@alpha.franken.de, olek2@wp.pl, hauke@hauke-m.de,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] net: lantiq_xrx200: improve ethernet performance
Date:   Tue,  4 Jan 2022 16:11:41 +0100
Message-Id: <20220104151144.181736-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 1f5ef74a7ab2fe835c7dbb3e013c64db
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [kfNU]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset improves Ethernet performance by 15%.

NAT Performance results on BT Home Hub 5A (kernel 5.10.89, mtu 1500):

	Down		Up
Before	539 Mbps	599 Mbps
After	624 Mbps	695 Mbps

Aleksander Jan Bajkowski (3):
  MIPS: lantiq: dma: increase descritor count
  net: lantiq_xrx200: increase napi poll weigth
  net: lantiq_xrx200: convert to build_skb

 .../include/asm/mach-lantiq/xway/xway_dma.h   |  2 +-
 drivers/net/ethernet/lantiq_xrx200.c          | 62 ++++++++++++-------
 2 files changed, 41 insertions(+), 23 deletions(-)

-- 
2.30.2

