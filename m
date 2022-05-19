Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F3852D6C5
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240290AbiESPEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240361AbiESPDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:03:49 -0400
Received: from smtp-8fa8.mail.infomaniak.ch (smtp-8fa8.mail.infomaniak.ch [83.166.143.168])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F94ED721
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 08:02:43 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L3tPt2kqmzMqFYP;
        Thu, 19 May 2022 17:02:42 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4L3tPs69HLzlhZwG;
        Thu, 19 May 2022 17:02:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1652972562;
        bh=X0N1rSNWG+5gZCVjSi27t21NEkxFWDf7hCWQX+cM6eM=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=bGrqlgVv4BZTXoeItlITlIleC/3eusnE6Q2Y9f31Dw9CVUwnjVoIDGsG1dZhlHZc3
         E//V5ExUtVgaXhuJD5yqCABK2jyhts2iLM3i4jfxFBuMU3r6lhj4NAI553+Dv7zjKj
         DADrPGZJ2sEbJLd0bima7T05lvX87zo6ruB9Ep/M=
Message-ID: <4bac347d-93b0-049a-2c02-f3b66746e2e7@digikod.net>
Date:   Thu, 19 May 2022 17:02:40 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-12-konstantin.meskhidze@huawei.com>
 <e2c67180-3ec5-f710-710a-0c2644bfa54e@digikod.net>
 <1297f02f-5c2c-bebd-da58-eed9b8ee97cc@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v5 11/15] seltests/landlock: connect() with AF_UNSPEC
 tests
In-Reply-To: <1297f02f-5c2c-bebd-da58-eed9b8ee97cc@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 19/05/2022 14:31, Konstantin Meskhidze wrote:
> 
> 
> 5/17/2022 11:55 AM, Mickaël Salaün пишет:
>> I guess these tests would also work with IPv6. You can then use the 
>> "alternative" tests I explained.
>>
>    Do you mean adding new helpers such as bind_variant() and 
> connect_variant()??

Yes, reusing bind_variant() and adding connect_variant().
