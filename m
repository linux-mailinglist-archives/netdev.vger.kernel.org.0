Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548D429240E
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 10:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgJSI5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 04:57:49 -0400
Received: from twspam01.aspeedtech.com ([211.20.114.71]:65337 "EHLO
        twspam01.aspeedtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729831AbgJSI5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 04:57:48 -0400
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 09J8soVf046771;
        Mon, 19 Oct 2020 16:54:50 +0800 (GMT-8)
        (envelope-from dylan_hung@aspeedtech.com)
Received: from localhost.localdomain (192.168.10.9) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 19 Oct
 2020 16:57:27 +0800
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ratbert@faraday-tech.com>,
        <linux-aspeed@lists.ozlabs.org>, <openbmc@lists.ozlabs.org>
CC:     <BMC-SW@aspeedtech.com>
Subject: [PATCH 0/4] fix ftgmac100 issues on aspeed soc
Date:   Mon, 19 Oct 2020 16:57:13 +0800
Message-ID: <20201019085717.32413-1-dylan_hung@aspeedtech.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.10.9]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 09J8soVf046771
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes the ftgmac100 mac hw issues on aspeed soc.

Fixes: 52c0cae ("ftgmac100: Remove tx descriptor accessors")
Fixes: 39bfab8 ("net: ftgmac100: Add support for DT phy-handle property")
Fixes: 10cbd64 ("ftgmac100: Rework NAPI & interrupts handling")


Dylan Hung (4):
  ftgmac100: Fix race issue on TX descriptor[0]
  ftgmac100: Fix missing-poll issue
  ftgmac100: Add a dummy read to ensure running sequence
  ftgmac100: Restart MAC HW once

 drivers/net/ethernet/faraday/ftgmac100.c | 53 ++++++++++++++----------
 1 file changed, 32 insertions(+), 21 deletions(-)

-- 
2.17.1

