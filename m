Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5B752CBC0
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 08:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbiESGHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 02:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbiESGHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 02:07:20 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B34C814BB
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 23:07:18 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nrZJb-00009g-Nz; Thu, 19 May 2022 08:07:15 +0200
Message-ID: <763a84db-d544-6468-cbaa-5c88f9bb3512@leemhuis.info>
Date:   Thu, 19 May 2022 08:07:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [regression] dpaa2: TSO offload on lx2160a causes fatal exception
 in interrupt
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7ca81e6b-85fd-beff-1c2b-62c86c9352e9@leemhuis.info>
 <20220504080646.ypkpj7xc3rcgoocu@skbuf> <20220512094323.3a89915f@kernel.org>
 <20220518221226.3712626c@kernel.org>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220518221226.3712626c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1652940438;9c45c552;
X-HE-SMSGID: 1nrZJb-00009g-Nz
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19.05.22 07:12, Jakub Kicinski wrote:
> On Thu, 12 May 2022 09:43:23 -0700 Jakub Kicinski wrote:
>> On Wed, 4 May 2022 08:06:47 +0000 Ioana Ciornei wrote:
>>>>> Mitigation:
>>>>> ethtool -K ethX tso off
>>>>>
>>>>> [reply] [−] Comment 1 kernelbugs@63bit.net 2022-05-02 01:37:06 UTC
>>>>>
>>>>> I believe this is related to commit 3dc709e0cd47c602a8d1a6747f1a91e9737eeed3
>>>>>     
>>>>
>>>> That commit is "dpaa2-eth: add support for software TSO".
>>>>
>>>> Could somebody take a look into this? Or was this discussed somewhere
>>>> else already? Or even fixed?    
>>>
>>> I will take a look at it, it wasn't discussed already.  
>>
>> Hi! Any progress on this one? AFAICT this is a new bug in 5.18, would
>> be great if we can close it in the next week or so, otherwise perhaps
>> consider disabling TSO by default. maybe?
> 
> ping?

ICYMI: There was some activity in bugzilla nearly ten days ago and Ioana
provided a patch, but seems that didn't help. I asked for a status
update yesterday, but no reply yet:
https://bugzilla.kernel.org/show_bug.cgi?id=215886

Ciao, Thorsten
