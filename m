Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F9049CECD
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 16:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243045AbiAZPnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 10:43:16 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:56722 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243021AbiAZPnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 10:43:15 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V2vg.fT_1643211792;
Received: from 30.225.24.71(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V2vg.fT_1643211792)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 Jan 2022 23:43:12 +0800
Message-ID: <6b740b0c-791b-cc5f-0082-1ff1a519f16f@linux.alibaba.com>
Date:   Wed, 26 Jan 2022 23:43:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net] net/smc: Forward wakeup to smc socket waitqueue after
 fallback
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1643211184-53645-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1643211184-53645-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/1/26 11:33 pm, Wen Gu wrote:

> 
> Fixes: 2153bd1e3d3d ("net/smc: Transfer remaining wait queue entries during fallback")
> Suggested-by: Karsten Graul <kgraul@linux.ibm.com>
> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
> ---

Hi Karsten,

This patch uses the idea you mentioned in a very earlier discussion, it may be difficult to recall:
https://lore.kernel.org/netdev/f51d3e86-0044-bc92-cdac-52bd978b056b@linux.ibm.com/

So I add the 'Suggested-by:' tag.

Thank you.
