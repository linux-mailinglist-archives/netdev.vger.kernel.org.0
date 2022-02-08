Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14304ACFE9
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 04:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346570AbiBHDyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 22:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346487AbiBHDxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 22:53:51 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F473C0401DC;
        Mon,  7 Feb 2022 19:53:50 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jt8CX24PZz67ZkT;
        Tue,  8 Feb 2022 11:49:44 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Tue, 8 Feb 2022 04:53:47 +0100
Message-ID: <8356b0fe-5665-96c1-c09b-bb74f97cc7ca@huawei.com>
Date:   Tue, 8 Feb 2022 06:53:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH 0/2] landlock network implementation cover letter
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
 <85450679-51fd-e5ae-b994-74bda3041739@digikod.net>
 <51967ba5-519a-8af2-76ce-eafa8c1dea33@huawei.com>
 <26cae763-3540-8e1b-f25b-68ac3df481a6@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <26cae763-3540-8e1b-f25b-68ac3df481a6@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



2/7/2022 4:35 PM, Mickaël Salaün пишет:
> 
> On 07/02/2022 14:18, Konstantin Meskhidze wrote:
>>
>>
>> 2/1/2022 8:53 PM, Mickaël Salaün пишет:
>>>
>>> On 24/01/2022 09:02, Konstantin Meskhidze wrote:
>>>> Hi, all!
>>>>
>>>> This is a new bunch of RFC patches related to Landlock LSM network 
>>>> confinement.
>>>> Here are previous discussions:
>>>> 1. 
>>>> https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/ 
>>>>
>>>> 2. 
>>>> https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/ 
>>>>
>>>>
>>>> As in previous RFCs, 2 hooks are supported:
>>>>    - hook_socket_bind()
>>>>    - hook_socket_connect()
>>>>
>>>> Selftest are provided in 
>>>> tools/testing/selftests/landlock/network_test.c;
>>>> Implementation was tested in QEMU invironment with 5.13 kernel version:
>>>
>>> Again, you need to base your work on the latest kernel version.
>>>
>>    Is it because there are new Landlock features in a latest kernel
>>    version?
>>    I thought 5.13 kernel version and the latest one have the same
>>    Landlock functionality and there will not be rebasing problems in
>>    future. But anyway I will base the work on the latest kernel.
>>    Which kernel version do you work on now?
> 
> 
> For now, the security/landlock/ files didn't changed yet, but that will 
> come. All other kernel APIs (and semantic) may change over time (e.g. 
> LSM API, network types…). I'm working on Linus's master branch (when it 
> becomes stable enough) or the linux-rolling-stable branch (from the 
> stable repository). When it will be ready for a merge, we need to base 
> our work on linux-next.

   Ok. I got it. I will rebase to the latest version.
   Thanks.
> .

