Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D976BA997
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjCOHnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjCOHnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:43:22 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BA7126C4;
        Wed, 15 Mar 2023 00:43:00 -0700 (PDT)
Received: from dggpemm500012.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Pc2Nd1f8sz17L1Z;
        Wed, 15 Mar 2023 15:40:01 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 dggpemm500012.china.huawei.com (7.185.36.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 15:42:57 +0800
From:   gaoxingwang <gaoxingwang1@huawei.com>
To:     <idosch@idosch.org>
CC:     <davem@davemloft.net>, <gaoxingwang1@huawei.com>,
        <kuba@kernel.org>, <liaichun@huawei.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <shuah@kernel.org>, <yanan@huawei.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: ipv4:the same route is added repeatedly
Date:   Wed, 15 Mar 2023 15:43:10 +0800
Message-ID: <20230315074310.2957080-1-gaoxingwang1@huawei.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <ZBCq+KXtxWXLPFNF@shredder>
References: <ZBCq+KXtxWXLPFNF@shredder>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500012.china.huawei.com (7.185.36.89)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index b5736ef16ed2..390f4be7f7be 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -576,6 +576,9 @@ static int rtentry_to_fib_config(struct net *net, int cmd, struct rtentry *rt,
>  			cfg->fc_scope = RT_SCOPE_UNIVERSE;
>  	}
>  
> +	if (!cfg->fc_table)
> +		cfg->fc_table = RT_TABLE_MAIN;
> +
>  	if (cmd == SIOCDELRT)
>  		return 0;
Thanks for you reply.This patch works for me.
Can you submit a patch? Hope the problem will be fixed as soon as possible. 
