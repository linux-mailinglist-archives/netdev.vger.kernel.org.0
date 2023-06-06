Return-Path: <netdev+bounces-8532-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E551372478D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:23:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A055F280FC8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E96002DBCE;
	Tue,  6 Jun 2023 15:23:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEBF37B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:23:05 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD5110C6
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:23:04 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QbDd25ShJz18M42;
	Tue,  6 Jun 2023 23:18:14 +0800 (CST)
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 6 Jun
 2023 23:23:01 +0800
Subject: Re: [PATCH net-next 6/6] sfc: generate encap headers for TC offload
To: Edward Cree <ecree.xilinx@gmail.com>, <edward.cree@amd.com>,
	<linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
 <672e66e6a4cf0f54917eddbca7c27a6f0d2823bf.1685992503.git.ecree.xilinx@gmail.com>
 <dd491618-6a36-ee7a-0581-c533fa245ce9@huawei.com>
 <5a26664a-56a4-5424-f2a9-a429633607c3@gmail.com>
CC: <netdev@vger.kernel.org>, <habetsm.xilinx@gmail.com>
From: Hao Lan <lanhao@huawei.com>
Message-ID: <d488a307-bbb1-78be-5831-658f3dd2ab8b@huawei.com>
Date: Tue, 6 Jun 2023 23:23:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <5a26664a-56a4-5424-f2a9-a429633607c3@gmail.com>
Content-Type: text/plain; charset="windows-1252"
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



On 2023/6/6 23:03, Edward Cree wrote:
> On 06/06/2023 04:52, Hao Lan wrote:
>> Why do you need to refactor the efx_gen_encap_header function in the same series?
>> I saw that patch 5 defined this function, and patch 6 refactored it,
>> instead of writing it all at once?
> Patch 5 introduces it only as a stub, because the calling code needs
>  it to exist.  Patch 6 then provides the implementation; this is not
>  a refactoring.
> They're in separate patches to split things up logically for review
>  and to assist future bisection.  Patch 5 is already big and complex
>  without this part.
> 
> (Also, please trim your quotes when replying to patches: you only
>  need to quote the part you're commenting on.)
> 
> -ed
> .
> 

This is a great idea for committing complex code,
thank you.

Reviewed-by: Hao Lan <lanhao@huawei.com>

