Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B918A51FBEE
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbiEIMCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbiEIMCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:02:41 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915FF27FE2;
        Mon,  9 May 2022 04:58:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VClEqzf_1652097524;
Received: from localhost.localdomain(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0VClEqzf_1652097524)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 09 May 2022 19:58:45 +0800
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] net/smc: two fixes for using smc with io_uring
Date:   Mon,  9 May 2022 19:58:35 +0800
Message-Id: <20220509115837.94911-1-guangguan.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set includes two fixes for using smc with io_uring.

Guangguan Wang (2):
  net/smc: non blocking recvmsg() return -EAGAIN when no data and
    signal_pending
  net/smc: align the connect behaviour with TCP

 net/smc/af_smc.c | 53 ++++++++++++++++++++++++++++++++++++++++++++----
 net/smc/smc_rx.c |  4 ++--
 2 files changed, 51 insertions(+), 6 deletions(-)

-- 
2.24.3 (Apple Git-128)

