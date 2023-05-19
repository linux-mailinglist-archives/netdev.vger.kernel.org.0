Return-Path: <netdev+bounces-3830-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85D0D70904A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:19:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 253371C20B86
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 07:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 119D780A;
	Fri, 19 May 2023 07:19:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057367F3
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 07:19:14 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D52E58;
	Fri, 19 May 2023 00:19:13 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QMylY0HLTz18KJl;
	Fri, 19 May 2023 15:14:49 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 19 May
 2023 15:19:11 +0800
Subject: Re: [PATCH net-next v3] octeontx2-pf: Add support for page pool
To: Ratheesh Kannoth <rkannoth@marvell.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <sgoutham@marvell.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <sbhatta@marvell.com>,
	<gakula@marvell.com>, <schalla@marvell.com>, <hkelam@marvell.com>
References: <20230519071352.3967986-1-rkannoth@marvell.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <4e89de93-3b82-a448-0c31-871ad09e40a0@huawei.com>
Date: Fri, 19 May 2023 15:19:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230519071352.3967986-1-rkannoth@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/19 15:13, Ratheesh Kannoth wrote:
> Page pool for each rx queue enhance rx side performance
> by reclaiming buffers back to each queue specific pool. DMA
> mapping is done only for first allocation of buffers.
> As subsequent buffers allocation avoid DMA mapping,
> it results in performance improvement.
> 
> Image        |  Performance
> ------------ | ------------
> Vannila      |   3Mpps
>              |
> with this    |   42Mpps
> change	     |
> ---------------------------

LGTM.
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>

> 
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> ---


