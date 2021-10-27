Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27B143C58D
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241046AbhJ0IzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:55:00 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:60377 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235961AbhJ0Iy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:54:57 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Uts5tlX_1635324749;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Uts5tlX_1635324749)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 16:52:30 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        ubraun@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: [PATCH net 0/4] Fixes for SMC
Date:   Wed, 27 Oct 2021 16:52:05 +0800
Message-Id: <20211027085208.16048-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Lu <tony.ly@linux.alibaba.com>

We are using SMC to replace TCP, and find some issues when running TCP's
test cases.

Tony Lu (2):
  Revert "net/smc: don't wait for send buffer space when data was
    already sent"
  net/smc: Fix smc_link->llc_testlink_time overflow

Wen Gu (2):
  net/smc: Correct spelling mistake to TCPF_SYN_RECV
  net/smc: Fix wq mismatch issue caused by smc fallback

 net/smc/af_smc.c  | 17 ++++++++++++++++-
 net/smc/smc_llc.c |  2 +-
 net/smc/smc_tx.c  |  7 ++++---
 3 files changed, 21 insertions(+), 5 deletions(-)

-- 
2.19.1.6.gb485710b

