Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAF028D9CC
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 08:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgJNGHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 02:07:14 -0400
Received: from twspam01.aspeedtech.com ([211.20.114.71]:40144 "EHLO
        twspam01.aspeedtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728821AbgJNGHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 02:07:14 -0400
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 09E64PNb047725;
        Wed, 14 Oct 2020 14:04:25 +0800 (GMT-8)
        (envelope-from dylan_hung@aspeedtech.com)
Received: from localhost.localdomain (192.168.10.9) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 14 Oct
 2020 14:06:44 +0800
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ratbert@faraday-tech.com>,
        <linux-aspeed@lists.ozlabs.org>, <openbmc@lists.ozlabs.org>
CC:     <BMC-SW@aspeedtech.com>
Subject: [PATCH 0/1] Fix Aspeed ast2600 MAC TX hang
Date:   Wed, 14 Oct 2020 14:06:31 +0800
Message-ID: <20201014060632.16085-1-dylan_hung@aspeedtech.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.10.9]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 09E64PNb047725
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the TX hang issue on Aspeed AST2600.
Two HW arbitration features are added onto ast2600, but these features will
cause MAC TX to hang when handling scatter-gather DMA.  These two
problematic features can be disabled by setting MAC register 0x58 bit28
and bit27.

Dylan Hung (1):
  net: ftgmac100: Fix Aspeed ast2600 TX hang issue

 drivers/net/ethernet/faraday/ftgmac100.c | 5 +++++
 drivers/net/ethernet/faraday/ftgmac100.h | 8 ++++++++
 2 files changed, 13 insertions(+)

-- 
2.17.1

