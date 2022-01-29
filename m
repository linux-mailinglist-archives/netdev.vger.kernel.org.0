Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D67E4A2E6F
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 12:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240838AbiA2Lzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 06:55:35 -0500
Received: from mxout02.lancloud.ru ([45.84.86.82]:39864 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240720AbiA2LzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 06:55:24 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 9CF2722F7EB7
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
Subject: [PATCH v2 0/2] Remove some dead code in the Renesas Ethernet drivers
Date:   Sat, 29 Jan 2022 14:55:15 +0300
Message-ID: <20220129115517.11891-1-s.shtylyov@omp.ru>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are 2 patches against DaveM's 'net-next.git' repo. The Renesas drivers
call their ndo_stop() methods directly and they always return 0, making the
result checks pointless, hence remove them...

Sergey Shtylyov (2):
  ravb: ravb_close() always returns 0
  sh_eth: sh_eth_close() always returns 0

 drivers/net/ethernet/renesas/ravb_main.c | 5 +----
 drivers/net/ethernet/renesas/sh_eth.c    | 4 +---
 2 files changed, 2 insertions(+), 7 deletions(-)

-- 
2.26.3

