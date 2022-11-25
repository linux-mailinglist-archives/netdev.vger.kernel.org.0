Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CB76387BE
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 11:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiKYKnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 05:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiKYKni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 05:43:38 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F44F1F9E9;
        Fri, 25 Nov 2022 02:43:36 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NJWfY1fYNz15MsX;
        Fri, 25 Nov 2022 18:43:01 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 18:43:33 +0800
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
To:     Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <patches@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, <shuah@kernel.org>,
        <patches@kernelci.org>, <lkft-triage@lists.linaro.org>,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        <srw@sladewatkins.net>, <rwarsow@gmx.de>,
        Netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
References: <20221123084557.945845710@linuxfoundation.org>
 <CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com>
 <CA+G9fYvgaNKbr_EhWsh9hjnzCeVXGJoXX4to72ytdvZi8W0svA@mail.gmail.com>
 <Y4BuUU5yMI6PqCbb@kroah.com>
 <CA+G9fYsXomPXcecPDzDydO3=i2qHDM2RTtGxr0p2YOS6=YcWng@mail.gmail.com>
 <a1652617-9da5-4a29-9711-9d3b3cf66597@app.fastmail.com>
 <23b0fa9c-d041-8c56-ec4b-04991fa340d4@huawei.com>
 <78fc17ac-bdce-4835-953d-d50d0a467146@app.fastmail.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <a6b5e0f5-815c-6fd0-9195-80cfd0819912@huawei.com>
Date:   Fri, 25 Nov 2022 18:43:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <78fc17ac-bdce-4835-953d-d50d0a467146@app.fastmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/25 18:32, Arnd Bergmann wrote:
> On Fri, Nov 25, 2022, at 11:25, YueHaibing wrote:
>> On 2022/11/25 18:02, Arnd Bergmann wrote:
>>> On Fri, Nov 25, 2022, at 09:05, Naresh Kamboju wrote:
>>>> On Fri, 25 Nov 2022 at 12:57, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>>>> On Thu, Nov 24, 2022 at 09:17:36PM +0530, Naresh Kamboju wrote:
>>>>>>
>>>>>> Daniel bisected this reported problem and found the first bad commit,
>>>>>>
>>>>>> YueHaibing <yuehaibing@huawei.com>
>>>>>>     net: broadcom: Fix BCMGENET Kconfig
>>>>>
>>>>> But that is in 5.10.155, 5.15.79, 6.0.9, and 6.1-rc5.  It is not new to
>>>>> this -rc release.
>>>>
>>>> It started from 5.10.155 and this is only seen on 5.10 and other
>>>> branches 5.15, 6.0 and mainline are looking good.
>>>
>>> I think the original patch is wrong and should be fixed upstream.
>>> The backported patch in question is a one-line Kconfig change doing
>>
>> It seems lts 5.10 do not contain commit e5f31552674e ("ethernet: fix 
>> PTP_1588_CLOCK dependencies"),
>> there is not PTP_1588_CLOCK_OPTIONAL option.
> 
> Ok, so there is a second problem then.
> 
> Greg, please just revert fbb4e8e6dc7b ("net: broadcom: Fix BCMGENET Kconfig")
> in stable/linux-5.10.y: it depends on e5f31552674e ("ethernet: fix
> PTP_1588_CLOCK dependencies"), which we probably don't want backported
> from 5.15 to 5.10.
> 
> YueHaibing, do you agree with my suggestion for improving the
> upstream 8d820bc9d12b ("net: broadcom: Fix BCMGENET Kconfig")
> commit? Can you send a follow-up fix, or should I?

Ok, I will take care this.

> 
>       Arnd
> .
> 
