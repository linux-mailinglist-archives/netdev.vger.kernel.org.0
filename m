Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F086052D6D3
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240438AbiESPF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240440AbiESPE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:04:56 -0400
Received: from smtp-42ab.mail.infomaniak.ch (smtp-42ab.mail.infomaniak.ch [IPv6:2001:1600:3:17::42ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039514BBA6;
        Thu, 19 May 2022 08:04:33 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L3tRz4cVnzMr6Z4;
        Thu, 19 May 2022 17:04:31 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4L3tRy4vTLzlj4cQ;
        Thu, 19 May 2022 17:04:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1652972671;
        bh=Iu2hekakHuh12yGJ6SUOfbZ+vrKKheTFjv1jLZqAce8=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=t3Qwxl9EzBWg0IWuUrBqegCUcmc1BxNvSjw4QMEbHPFZ+SzCilA2faLJZWcm0KnNq
         FVJpxS5tcU5CEven7Pt8e1y2S8+KYgKMynyAUp3vG/uhkfv6Az3aPUjTiOJZhSJc+S
         aaNCLbbXeDNmoa33fDyV+u/Nc6IqeyRea2Xpbwuw=
Message-ID: <0958567e-cc91-f63f-402a-a6324a576da2@digikod.net>
Date:   Thu, 19 May 2022 17:04:30 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-13-konstantin.meskhidze@huawei.com>
 <4806f5ed-41c0-f9f2-d7a1-2173c8494399@digikod.net>
 <09ab37e1-eba5-80be-8fb3-df2bde698fc6@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v5 12/15] seltests/landlock: rules overlapping test
In-Reply-To: <09ab37e1-eba5-80be-8fb3-df2bde698fc6@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/05/2022 14:24, Konstantin Meskhidze wrote:
> 
> 
> 5/16/2022 8:41 PM, Mickaël Salaün пишет:

[...]

>>> +
>>> +    /* Makes connection to socket with port[0] */
>>> +    ASSERT_EQ(0, connect(sockfd, (struct sockaddr *)&self->addr4[0],
>>
>> Can you please get rid of this (struct sockaddr *) type casting please 
>> (without compiler warning)?
>>
>    Do you have a warning here? Cause I don't.

There is no warning but this kind of cast is useless.
