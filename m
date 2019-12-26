Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C5B12A98B
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 02:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfLZBrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 20:47:23 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:54286 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfLZBrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 20:47:23 -0500
Received: from [192.168.1.4] (unknown [124.77.217.174])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 456725C172E;
        Thu, 26 Dec 2019 09:47:20 +0800 (CST)
Subject: Re: [PATCH net-next 0/5] netfilter: add indr block setup in
 nf_flow_table_offload
From:   wenxu <wenxu@ucloud.cn>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <6ed792a4-6f64-fe57-4e1e-215bfa701ccf@ucloud.cn>
Date:   Thu, 26 Dec 2019 09:46:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVS0tCS0tLSEtKSE1KS0NZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PSo6Nio5HTg#SEI3CEMpMgo0
        AwNPFE5VSlVKTkxMSElPQ09LT0pJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJT1VM
        TFVJSkxVSkxPWVdZCAFZQUlIQk03Bg++
X-HM-Tid: 0a6f3fe3059b2087kuqy456725c172e
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2019/12/25 17:48, wenxu@ucloud.cn 写道:
> From: wenxu <wenxu@ucloud.cn>
>
> This patch provide tunnel offload in nf_flow_table_offload based on
> route lwtunnel. 
> The first patch add TC_SETP_FT type in flow_indr_block_call.
> The next two patches add support indr callback setup in flowtable offload.
> The last two patches add tunnel match and action offload.

Hi  David,

This series modify the net/core/flow_offload.c and net/sched/cls_api.c files.

This series maybe be suit for net-next tree but not nf-next tree?


BR

wenxu

>
>
> wenxu (5):
>   flow_offload: add TC_SETP_FT type in flow_indr_block_call
>   netfilter: nf_flow_table_offload: refactor nf_flow_table_offload_setup
>     to support indir setup
>   netfilter: nf_flow_table_offload: add indr block setup support
>   netfilter: nf_flow_table_offload: add tunnel match offload support
>   netfilter: nf_flow_table_offload: add tunnel encap/decap action
>     offload support
>
>  include/net/flow_offload.h            |   3 +-
>  net/core/flow_offload.c               |   6 +-
>  net/netfilter/nf_flow_table_offload.c | 253 +++++++++++++++++++++++++++++++---
>  net/netfilter/nf_tables_offload.c     |   2 +-
>  net/sched/cls_api.c                   |   2 +-
>  5 files changed, 243 insertions(+), 23 deletions(-)
>
