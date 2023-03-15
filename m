Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD35E6BAA68
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjCOIFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231691AbjCOIFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:05:39 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2BF19F06
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 01:05:36 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pcM8Y-0000P3-BO; Wed, 15 Mar 2023 09:05:30 +0100
Message-ID: <1f37c8d4-8a1d-bc06-5b65-9357a7766ad7@leemhuis.info>
Date:   Wed, 15 Mar 2023 09:05:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v1 net 1/2] tcp: Fix bind() conflict check for dual-stack
 wildcard address.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux regressions mailing list <regressions@lists.linux.dev>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        Paul Holzinger <pholzing@redhat.com>,
        Martin KaFai Lau <martin.lau@kernel.org>
References: <20230312031904.4674-1-kuniyu@amazon.com>
 <20230312031904.4674-2-kuniyu@amazon.com>
 <533d3c1a-db7e-6ff2-1fdf-fb8bbbb7a14c@leemhuis.info>
 <20230315002625.49bac132@kernel.org>
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20230315002625.49bac132@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1678867537;712e79df;
X-HE-SMSGID: 1pcM8Y-0000P3-BO
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.03.23 08:26, Jakub Kicinski wrote:
> On Sun, 12 Mar 2023 12:42:48 +0100 Linux regression tracking (Thorsten
> Leemhuis) wrote:
>> Link:
>> https://lore.kernel.org/netdev/CAG_fn=Ud3zSW7AZWXc+asfMhZVL5ETnvuY44Pmyv4NPv-ijN-A@mail.gmail.com/
>> [1]
>> Fixes: 5456262d2baa ("net: Fix incorrect address comparison when
>> searching for a bind2 bucket")
>> Reported-by: Paul Holzinger <pholzing@redhat.com>
>> Link:
>> https://lore.kernel.org/netdev/e21bf153-80b0-9ec0-15ba-e04a4ad42c34@redhat.com/
>> [0]
> 
> I tried to fix this manually when applying but:
>  - your email client wraps your replies
>  - please don't reply to patches with tags which will look to scripts
>    and patchwork like tags it should pull into the submission
>    (Reported-by in particular, here)

Sorry for the mixup and thx for letting me know, will simply quote my
suggestion next time, that should avoid both problems.

Ciao, Thorsten
