Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF71736899
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 02:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfFFAHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 20:07:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42924 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFFAHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 20:07:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5CE11136E16AB;
        Wed,  5 Jun 2019 17:07:21 -0700 (PDT)
Date:   Wed, 05 Jun 2019 17:07:20 -0700 (PDT)
Message-Id: <20190605.170720.1054035351724704869.davem@davemloft.net>
To:     yanjun.zhu@oracle.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [PATCHv2 1/1] net: rds: add per rds connection cache statistics
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559536081-25401-1-git-send-email-yanjun.zhu@oracle.com>
References: <1559536081-25401-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 17:07:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Mon,  3 Jun 2019 00:28:01 -0400

> The variable cache_allocs is to indicate how many frags (KiB) are in one
> rds connection frag cache.
> The command "rds-info -Iv" will output the rds connection cache
> statistics as below:
> "
> RDS IB Connections:
>       LocalAddr RemoteAddr Tos SL  LocalDev            RemoteDev
>       1.1.1.14 1.1.1.14   58 255  fe80::2:c903:a:7a31 fe80::2:c903:a:7a31
>       send_wr=256, recv_wr=1024, send_sge=8, rdma_mr_max=4096,
>       rdma_mr_size=257, cache_allocs=12
> "
> This means that there are about 12KiB frag in this rds connection frag
> cache. 
> Since rds.h in rds-tools is not related with the kernel rds.h, the change
> in kernel rds.h does not affect rds-tools.
> rds-info in rds-tools 2.0.5 and 2.0.6 is tested with this commit. It works
> well.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
> V1->V2: RDS CI is removed. 

Applied to net-next.
