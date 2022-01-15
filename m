Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D1D48F662
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 11:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiAOK0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 05:26:03 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:51350 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229530AbiAOK0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 05:26:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V1si0dd_1642242360;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V1si0dd_1642242360)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 15 Jan 2022 18:26:00 +0800
Date:   Sat, 15 Jan 2022 18:25:59 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/smc: Remove unused function declaration
Message-ID: <20220115102559.GA13341@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <1642167345-77338-1-git-send-email-guwen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1642167345-77338-1-git-send-email-guwen@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 09:35:45PM +0800, Wen Gu wrote:
>The declaration of smc_wr_tx_dismiss_slots() is unused.
>So remove it.

Sorry, I missed to remove this

>
>Fixes: 349d43127dac ("net/smc: fix kernel panic caused by race of smc_sock")
>Signed-off-by: Wen Gu <guwen@linux.alibaba.com>

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

>---
> net/smc/smc_wr.h | 4 ----
> 1 file changed, 4 deletions(-)
>
>diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
>index 47512cc..a54e90a 100644
>--- a/net/smc/smc_wr.h
>+++ b/net/smc/smc_wr.h
>@@ -125,10 +125,6 @@ int smc_wr_tx_v2_send(struct smc_link *link,
> int smc_wr_tx_send_wait(struct smc_link *link, struct smc_wr_tx_pend_priv *priv,
> 			unsigned long timeout);
> void smc_wr_tx_cq_handler(struct ib_cq *ib_cq, void *cq_context);
>-void smc_wr_tx_dismiss_slots(struct smc_link *lnk, u8 wr_rx_hdr_type,
>-			     smc_wr_tx_filter filter,
>-			     smc_wr_tx_dismisser dismisser,
>-			     unsigned long data);
> void smc_wr_tx_wait_no_pending_sends(struct smc_link *link);
> 
> int smc_wr_rx_register_handler(struct smc_wr_rx_handler *handler);
>-- 
>1.8.3.1
