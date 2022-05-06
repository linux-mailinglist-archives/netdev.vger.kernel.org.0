Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01DA51D753
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 14:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390851AbiEFMO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 08:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344601AbiEFMO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 08:14:26 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F123D24F03;
        Fri,  6 May 2022 05:10:42 -0700 (PDT)
Received: from kwepemi100003.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KvqBy0Dl1zhYvJ;
        Fri,  6 May 2022 20:10:18 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100003.china.huawei.com (7.221.188.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 6 May 2022 20:10:40 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 6 May
 2022 20:10:40 +0800
Subject: Re: [PATCH net-next 3/5] net: hns3: add byte order conversion for PF
 to VF mailbox message
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
References: <20220505124444.2233-1-huangguangbin2@huawei.com>
 <20220505124444.2233-4-huangguangbin2@huawei.com>
 <20220505184746.122aea96@kernel.org>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <e504e07c-dff1-8d66-448d-0ccc30c4e87e@huawei.com>
Date:   Fri, 6 May 2022 20:10:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20220505184746.122aea96@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/5/6 9:47, Jakub Kicinski wrote:
> On Thu, 5 May 2022 20:44:42 +0800 Guangbin Huang wrote:
>> From: Jie Wang <wangjie125@huawei.com>
>>
>> Currently, hns3 mailbox processing between PF and VF missed to convert
>> message byte order and use data type u16 instead of __le16 for mailbox
>> data process. These processes may cause problems between different
>> architectures.
>>
>> So this patch uses __le16/__le32 data type to define mailbox data
>> structures. To be compatible with old hns3 driver, these structures use
>> one-byte alignment. Then byte order conversions are added to mailbox
>> messages from PF to VF.
> 
> This adds a few sparse [1] warnings, you must have missed a few
> conversions.
> 
> Please wait at least 24h for additional feedback before reposting.
> 
> [1] https://www.kernel.org/doc/html/latest/dev-tools/sparse.html
> 
> .
> 
Ok, thanks
