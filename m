Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC8A482260
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 07:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbhLaGAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 01:00:43 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:47434 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230479AbhLaGAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 01:00:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V0Og.qp_1640930439;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V0Og.qp_1640930439)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 31 Dec 2021 14:00:40 +0800
Date:   Fri, 31 Dec 2021 14:00:39 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Karsten Graul <kgraul@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/smc: remove redundant re-assignment of pointer link
Message-ID: <Yc6ch2hVWwb6coa4@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211230153900.274049-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211230153900.274049-1-colin.i.king@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 03:39:00PM +0000, Colin Ian King wrote:
> The pointer link is being re-assigned the same value that it was
> initialized with in the previous declaration statement. The
> re-assignment is redundant and can be removed.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

It would be better to add Fixes statement in the end of message.

  Fixes: 387707fdf486 ("net/smc: convert static link ID to dynamic references")

And [PATCH net ...] is fine to point out the target. The patch itself
looks good to me, thanks.

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

Thanks,
Tony Lu
