Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C806F43DBB9
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhJ1HQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:16:27 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:44067 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhJ1HQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 03:16:27 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Utz5HHV_1635405238;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Utz5HHV_1635405238)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Oct 2021 15:13:59 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: [PATCH net v2 0/2] Fixes for SMC
Date:   Thu, 28 Oct 2021 15:13:43 +0800
Message-Id: <20211028071344.11168-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some fixes for SMC.

v1->v2:
- fix wrong email address.

Tony Lu (1):
  net/smc: Fix smc_link->llc_testlink_time overflow

Wen Gu (1):
  net/smc: Correct spelling mistake to TCPF_SYN_RECV

 net/smc/af_smc.c  | 2 +-
 net/smc/smc_llc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.19.1.6.gb485710b

