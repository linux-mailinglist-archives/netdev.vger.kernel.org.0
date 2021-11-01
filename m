Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6D0441442
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 08:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhKAHmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 03:42:49 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:60617 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229933AbhKAHmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 03:42:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UuW7YUr_1635752412;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UuW7YUr_1635752412)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Nov 2021 15:40:12 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 0/3] Tracepoints for SMC
Date:   Mon,  1 Nov 2021 15:39:10 +0800
Message-Id: <20211101073912.60410-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set introduces tracepoints for SMC, including the tracepoints
basic code. The tracepoitns would help us to track SMC's behaviors by
automatic tools, or other BPF tools, and zero overhead if not enabled.

Compared with kprobe and other dymatic tools, the tracepoints are
considered as stable API, and less overhead for tracing with easy-to-use
API.

Tony Lu (3):
  net/smc: Introduce tracepoint for fallback
  net/smc: Introduce tracepoints for tx and rx msg
  net/smc: Introduce tracepoint for smcr link down

 net/smc/Makefile         |   2 +
 net/smc/af_smc.c         |   2 +
 net/smc/smc_core.c       |   9 ++-
 net/smc/smc_rx.c         |   3 +
 net/smc/smc_tracepoint.c |   9 +++
 net/smc/smc_tracepoint.h | 116 +++++++++++++++++++++++++++++++++++++++
 net/smc/smc_tx.c         |   3 +
 7 files changed, 142 insertions(+), 2 deletions(-)
 create mode 100644 net/smc/smc_tracepoint.c
 create mode 100644 net/smc/smc_tracepoint.h

-- 
2.19.1.6.gb485710b

