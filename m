Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE9C4ABFD9
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiBGNqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387268AbiBGNe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 08:34:28 -0500
Received: from smtp-8fae.mail.infomaniak.ch (smtp-8fae.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fae])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FB7C043188
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 05:34:27 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JsnDc38wnzMpw6f;
        Mon,  7 Feb 2022 14:34:24 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4JsnDc08TczlhMCD;
        Mon,  7 Feb 2022 14:34:23 +0100 (CET)
Message-ID: <26cae763-3540-8e1b-f25b-68ac3df481a6@digikod.net>
Date:   Mon, 7 Feb 2022 14:35:03 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
 <85450679-51fd-e5ae-b994-74bda3041739@digikod.net>
 <51967ba5-519a-8af2-76ce-eafa8c1dea33@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH 0/2] landlock network implementation cover letter
In-Reply-To: <51967ba5-519a-8af2-76ce-eafa8c1dea33@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 07/02/2022 14:18, Konstantin Meskhidze wrote:
> 
> 
> 2/1/2022 8:53 PM, Mickaël Salaün пишет:
>>
>> On 24/01/2022 09:02, Konstantin Meskhidze wrote:
>>> Hi, all!
>>>
>>> This is a new bunch of RFC patches related to Landlock LSM network 
>>> confinement.
>>> Here are previous discussions:
>>> 1. 
>>> https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/ 
>>>
>>> 2. 
>>> https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/ 
>>>
>>>
>>> As in previous RFCs, 2 hooks are supported:
>>>    - hook_socket_bind()
>>>    - hook_socket_connect()
>>>
>>> Selftest are provided in 
>>> tools/testing/selftests/landlock/network_test.c;
>>> Implementation was tested in QEMU invironment with 5.13 kernel version:
>>
>> Again, you need to base your work on the latest kernel version.
>>
>    Is it because there are new Landlock features in a latest kernel
>    version?
>    I thought 5.13 kernel version and the latest one have the same
>    Landlock functionality and there will not be rebasing problems in
>    future. But anyway I will base the work on the latest kernel.
>    Which kernel version do you work on now?


For now, the security/landlock/ files didn't changed yet, but that will 
come. All other kernel APIs (and semantic) may change over time (e.g. 
LSM API, network types…). I'm working on Linus's master branch (when it 
becomes stable enough) or the linux-rolling-stable branch (from the 
stable repository). When it will be ready for a merge, we need to base 
our work on linux-next.
