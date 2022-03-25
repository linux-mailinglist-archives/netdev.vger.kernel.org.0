Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA464E6CCC
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 04:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358177AbiCYDPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 23:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbiCYDPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 23:15:30 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88955C358
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 20:13:57 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KPnBs6Ml9zBrjH;
        Fri, 25 Mar 2022 11:09:57 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 25 Mar
 2022 11:13:55 +0800
Subject: Re: [RFCv5 PATCH net-next 01/20] net: rename net_device->features to
 net_device->active_features
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <ecree.xilinx@gmail.com>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>, <lipeng321@huawei.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
 <20220324154932.17557-2-shenjian15@huawei.com>
 <20220324175832.70a7de9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220324180331.77a818c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2c493855-4084-8b5d-fed8-6faf8255faae@huawei.com>
 <20220324183549.10ba1260@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <f90cb41d-da3b-3a7d-e9df-0382ba22b465@huawei.com>
Date:   Fri, 25 Mar 2022 11:13:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20220324183549.10ba1260@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/3/25 9:35, Jakub Kicinski 写道:
> On Fri, 25 Mar 2022 09:29:51 +0800 shenjian (K) wrote:
>> 在 2022/3/25 9:03, Jakub Kicinski 写道:
>>> I see you mention that the work is not complete in the cover letter.
>>> Either way this patch seems unnecessary, you can call the helpers
>>> for "active" features like you do, but don't start by renaming the
>>> existing field. The patch will be enormous.
>>> .
>> I agree that this patch will be enormous,  I made this patch from suggestion
>> from Andrew Lunn in RFCv3.[1]   Willit make people confused
>> for help name inconsistent with feature name ?
>>
>> [1]https://www.spinics.net/lists/netdev/msg777767.html
> Thanks, not sure if I see a suggestion there from Andrew or just
> a question. Maybe you can add a comment instead to avoid surprising
> people?
> .
ok, will drop this patch


