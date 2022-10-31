Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0E26139A8
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiJaPFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiJaPFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:05:08 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8CAD1117F;
        Mon, 31 Oct 2022 08:05:07 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 3FACE21BA0;
        Mon, 31 Oct 2022 17:05:07 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 20DCC21B9F;
        Mon, 31 Oct 2022 17:05:06 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id E692D3C0437;
        Mon, 31 Oct 2022 17:05:03 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 29VF52rh159370;
        Mon, 31 Oct 2022 17:05:03 +0200
Date:   Mon, 31 Oct 2022 17:05:02 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Simon Horman <horms@verge.net.au>, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH net,v2 0/2] fix WARNING when removing file in ipvs
In-Reply-To: <20221031120705.230059-1-shaozhengchao@huawei.com>
Message-ID: <9dfd739c-f7b-e758-9b46-f79ba9cec82@ssi.bg>
References: <20221031120705.230059-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Mon, 31 Oct 2022, Zhengchao Shao wrote:

> When using strace for fault injection, some warnings are trigged when
> files are removed. This is because the file fails to be created during
> the initialization, but the initialization continues normally. Therefore,
> a WARNING is reported when the file is removed during the exit.
> 
> ---
> v2: add macro isolation
> ---
> Zhengchao Shao (2):
>   ipvs: fix WARNING in __ip_vs_cleanup_batch()
>   ipvs: fix WARNING in ip_vs_app_net_cleanup()

	Both patches in v2 look good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

>  net/netfilter/ipvs/ip_vs_app.c  | 10 ++++++++--
>  net/netfilter/ipvs/ip_vs_conn.c | 26 +++++++++++++++++++++-----
>  2 files changed, 29 insertions(+), 7 deletions(-)
> 
> -- 
> 2.17.1

Regards

--
Julian Anastasov <ja@ssi.bg>

