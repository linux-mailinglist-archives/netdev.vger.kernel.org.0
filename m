Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30874EFF89
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 10:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239083AbiDBIMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 04:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiDBIMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 04:12:12 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C070DCABB
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 01:10:21 -0700 (PDT)
Received: from kwepemi100017.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KVqP039G1zBrwk;
        Sat,  2 Apr 2022 16:06:12 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100017.china.huawei.com (7.221.188.163) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 2 Apr 2022 16:10:18 +0800
Received: from [127.0.0.1] (10.67.101.149) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Sat, 2 Apr
 2022 16:10:18 +0800
Subject: Re: [RFCv4 PATCH net-next 3/3] net-next: hn3: add tx push support in
 hns3 ring param process
To:     Jakub Kicinski <kuba@kernel.org>
References: <20220331084342.27043-1-wangjie125@huawei.com>
 <20220331084342.27043-4-wangjie125@huawei.com>
 <20220331202316.6f78748e@kernel.org>
CC:     <mkubecek@suse.cz>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <3105ca3f-a4c4-938c-9d7c-402c9a23aa39@huawei.com>
Date:   Sat, 2 Apr 2022 16:10:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20220331202316.6f78748e@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/4/1 11:23, Jakub Kicinski wrote:
> On Thu, 31 Mar 2022 16:43:42 +0800 Jie Wang wrote:
>> Subject: [RFCv4 PATCH net-next 3/3] net-next: hn3: add tx push support in hns3 ring param process
>
> BTW this patch is missing an s in hns3 in the subject ;)
>
good catch, thx.
> .
>

