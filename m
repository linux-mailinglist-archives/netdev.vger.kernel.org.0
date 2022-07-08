Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2833856BA27
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 14:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbiGHM4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 08:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiGHM4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 08:56:13 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67EC1CFEC;
        Fri,  8 Jul 2022 05:56:12 -0700 (PDT)
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LfY7v25m5z6H8Wx;
        Fri,  8 Jul 2022 20:51:55 +0800 (CST)
Received: from lhreml745-chm.china.huawei.com (10.201.108.195) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Fri, 8 Jul 2022 14:56:10 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhreml745-chm.china.huawei.com (10.201.108.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 8 Jul 2022 13:56:09 +0100
Message-ID: <b4275c2a-6e10-7c81-248e-abc84bc3c6cb@huawei.com>
Date:   Fri, 8 Jul 2022 15:56:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v6 01/17] landlock: renames access mask
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
 <20220621082313.3330667-2-konstantin.meskhidze@huawei.com>
 <09f25976-e1a6-02af-e8ca-6feef0cdebec@digikod.net>
 <a211ec4b-9004-2503-d419-217d18505271@huawei.com>
 <99f4ac6eb9ede955af7426f3989e57a4@mail.infomaniak.com>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <99f4ac6eb9ede955af7426f3989e57a4@mail.infomaniak.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 lhreml745-chm.china.huawei.com (10.201.108.195)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



7/5/2022 4:26 PM, Mickaël Salaün пишет:
> On 2022-07-05T13:29:04.000+02:00, Konstantin Meskhidze (A) <konstantin.meskhidze@huawei.com> wrote:
>>  7/1/2022 8:08 PM, Mickaël Salaün пишет:
>> 
>> >    
>> >  On 21/06/2022 10:22, Konstantin Meskhidze wrote:
>> > 
>> > >    To support network type rules,
>> > >  this modification extends and renames
>> > >  ruleset's access masks.
>> > >  This patch adds filesystem helper functions
>> > >  to set and get filesystem mask. Also the
>> > >  modification adds a helper structure
>> > >  landlock_access_mask to support managing
>> > >  multiple access mask.
>> >   
>> >  Please use a text-width of 72 columns for all commit messages. You can
>> >  also split them into paragraphs.
>> >  
>>     By the way, are you going to review the rest patches?
> 
> Yes, of course, I'm busy right now but I'll send more reviews by the end of the week.

   Thanks. Take your time.
> .
