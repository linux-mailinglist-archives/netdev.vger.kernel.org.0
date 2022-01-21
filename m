Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007CB4962E0
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348667AbiAUQgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:36:25 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:58245 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234718AbiAUQgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:36:24 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V2SImAL_1642782981;
Received: from 30.39.181.79(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0V2SImAL_1642782981)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 22 Jan 2022 00:36:22 +0800
Message-ID: <b21d51b2-5480-4550-7cd6-c16060261970@linux.alibaba.com>
Date:   Sat, 22 Jan 2022 00:36:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next] net/smc: Introduce receive queue flow
 control support
Content-Language: en-US
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
 <20da5fa9-6158-d04c-6f44-29e550ed97d0@linux.ibm.com>
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
In-Reply-To: <20da5fa9-6158-d04c-6f44-29e550ed97d0@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/1/20 19:03, Karsten Graul wrote:> 
> I really appreciate your effort to improve the performance and solve existing bottle necks,
> but please keep in mind that the SMC module implements the IBM SMC protocol that is
> described here: https://www.ibm.com/support/pages/node/6326337
> (you can find these links in the source code, too).
> 
> Your patch makes changes that are not described in this design paper and may lead to
> future incompatibilities with other platforms that support the IBM SMC protocol.
> 
> For example:
> - you start using one of the reserved bytes in struct smc_cdc_msg
> - you define a new smc_llc message type 0x0A
> - you change the maximum number of connections per link group from 255 to 32
> 
> We need to start a discussion about your (good!) ideas with the owners of the protocol.

Thanks for your affirmation of my effort and looking forward
to the conclusion of the protocol discussion.
