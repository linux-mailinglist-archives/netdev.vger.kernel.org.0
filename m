Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA683459DEA
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 09:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhKWI2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:28:45 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:33795 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231240AbhKWI2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 03:28:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UxtNBJi_1637655934;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UxtNBJi_1637655934)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Nov 2021 16:25:35 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH net 0/2] Fixes for closing process and minor cleanup
Date:   Tue, 23 Nov 2021 16:25:14 +0800
Message-Id: <20211123082515.65956-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 is a minor cleanup for local struct sock variables.

Patch 2 ensures the active closing side enters TIME_WAIT.

Tony Lu (2):
  net/smc: Clean up local struct sock variables
  net/smc: Ensure the active closing peer first closes clcsock

 net/smc/smc_close.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

-- 
2.32.0.3.g01195cf9f

