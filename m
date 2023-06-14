Return-Path: <netdev+bounces-10695-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74F2F72FD8C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:55:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E4A92813A5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C51B2883D;
	Wed, 14 Jun 2023 11:55:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97737476
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:55:46 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4671211B
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 04:55:40 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Qh3hj1YWVztQnJ;
	Wed, 14 Jun 2023 19:53:09 +0800 (CST)
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 14 Jun
 2023 19:55:38 +0800
Subject: Re: [PATCH net-next v2 3/4] net: hns3: fix strncpy() not using
 dest-buf length as length issue
To: Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20230612122358.10586-1-lanhao@huawei.com>
 <20230612122358.10586-4-lanhao@huawei.com>
 <8e84a4a13d25ceed6ad2ad2e4137b2fc35a086e4.camel@redhat.com>
CC: <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<richardcochran@gmail.com>, <wangpeiyang1@huawei.com>,
	<shenjian15@huawei.com>, <chenhao418@huawei.com>,
	<simon.horman@corigine.com>, <wangjie125@huawei.com>, <yuanjilin@cdjrlc.com>,
	<cai.huoqing@linux.dev>, <xiujianfeng@huawei.com>
From: Hao Lan <lanhao@huawei.com>
Message-ID: <bcfff02c-d56e-a7b1-d8b7-a1a9c44d052b@huawei.com>
Date: Wed, 14 Jun 2023 19:55:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <8e84a4a13d25ceed6ad2ad2e4137b2fc35a086e4.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.37]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/6/14 18:34, Paolo Abeni wrote:
> On Mon, 2023-06-12 at 20:23 +0800, Hao Lan wrote:
> 
> I think it would be better using 'strscpy' instead of papering over
> more unsecure functions.
> 
> Thanks,
> 
> Paolo
> 
> .
> 
Hi Paolo Abeni,

We accept your suggestion,
thank you.

