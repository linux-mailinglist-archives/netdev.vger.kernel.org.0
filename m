Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E0266245F
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 12:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbjAILkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 06:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236907AbjAILjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 06:39:43 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B9B38A9;
        Mon,  9 Jan 2023 03:39:41 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NrBgP5gzTz67lcR;
        Mon,  9 Jan 2023 19:34:41 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 9 Jan 2023 11:39:37 +0000
Message-ID: <0dab9d74-6a41-9cf3-58fb-9fbb265efdd0@huawei.com>
Date:   Mon, 9 Jan 2023 14:39:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 07/12] landlock: Add network rules support
Content-Language: ru
To:     Dan Carpenter <error27@gmail.com>
CC:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        <linux-sparse@vger.kernel.org>, <willemdebruijn.kernel@gmail.com>,
        <gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <artem.kuzin@huawei.com>, Linux API <linux-api@vger.kernel.org>,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-8-konstantin.meskhidze@huawei.com>
 <49391484-7401-e7c7-d909-3bd6bd024731@digikod.net>
 <9a6ea6ac-525d-e058-5867-0794a99b19a3@huawei.com>
 <47fedda8-a13c-b62f-251f-b62508964bb0@digikod.net>
 <4aa29433-e7f9-f225-5bdf-c80638c936e8@huawei.com> <Y7vXSAGHf08p2Zbm@kadam>
 <af0d7337-3a92-5eca-7d7c-cc09d5713589@huawei.com> <Y7vqdgvxQVNvu6AY@kadam>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <Y7vqdgvxQVNvu6AY@kadam>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



1/9/2023 1:20 PM, Dan Carpenter пишет:
> On Mon, Jan 09, 2023 at 12:26:52PM +0300, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 1/9/2023 11:58 AM, Dan Carpenter пишет:
>> > These warnings seem like something I have seen before.  Maybe it was an
>> > issue with _Generic() support?
>> > 
>> > Are you really sure you're running the latest git version of Sparse?
>> > 
>> > I tested this patch with the latest version of Sparse on my system and
>> > it worked fine.
>> 
>>  Hi Dan,
>> 
>>  git is on the master branch now - hash ce1a6720 (dated 27 June 2022)
>> 
>>  Is this correct version?
> 
> Yes, that's correct.  What is your .config?

   What parameters do I need to check in .config?
> 
> regards,
> dan carpenter
> 
> .
