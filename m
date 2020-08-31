Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE5825807B
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 20:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgHaSMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 14:12:50 -0400
Received: from inva020.nxp.com ([92.121.34.13]:41050 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728360AbgHaSMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 14:12:49 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id EAB091A0A93;
        Mon, 31 Aug 2020 20:12:47 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DE04B1A0A7C;
        Mon, 31 Aug 2020 20:12:47 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A89D120304;
        Mon, 31 Aug 2020 20:12:47 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/3] dpaa2-eth: add a dpaa2_eth_ prefix to all functions
Date:   Mon, 31 Aug 2020 21:12:37 +0300
Message-Id: <20200831181240.21527-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is just a quick cleanup that aims at adding a dpaa2_eth_ prefix to
all functions within the dpaa2-eth driver even if those are static and
private to the driver. The main reason for doing this is that looking a
perf top, for example, is becoming an inconvenience because one cannot
easily determine which entries are dpaa2-eth related or not.

Ioana Ciornei (3):
  dpaa2-eth: add a dpaa2_eth_ prefix to all functions in dpaa2-ethtool.c
  dpaa2-eth: add a dpaa2_eth_ prefix to all functions in dpaa2-eth.c
  dpaa2-eth: add a dpaa2_eth_ prefix to all functions in dpaa2-eth-dcb.c

 .../ethernet/freescale/dpaa2/dpaa2-eth-dcb.c  |   8 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 400 +++++++++---------
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  89 ++--
 3 files changed, 249 insertions(+), 248 deletions(-)

-- 
2.25.1

