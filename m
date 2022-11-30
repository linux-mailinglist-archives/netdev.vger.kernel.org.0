Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6EF63E072
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiK3TK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiK3TKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:10:23 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C7254460;
        Wed, 30 Nov 2022 11:10:20 -0800 (PST)
Message-ID: <953fb82c-0871-748e-e0f0-6ecca6ec80ee@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669835418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cpYTRvMJdbirKiTMceU5QudTQHf/OZVy3iDsQKagpcc=;
        b=MbBHoiG3ypuLon1XvmHnqfAFhYvpJHUUxDB47JsIJrgGF+tAzFEuhoXhnDuGEZ2pTv+PA6
        kRDR96StL8CFtRq0vcWProtUzhj6Hd2iCeQHH7SJ5Lq9pJCA46usYhvEh+zE6d7MFMPGEX
        4pHBdDjgBWPkCy0Bzx7EAMuTr2t6yjM=
Date:   Wed, 30 Nov 2022 11:10:13 -0800
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
Subject: Re: [PATCH ipsec-next 2/3] xfrm: interface: Add unstable helpers for
 setting/getting XFRM metadata from TC-BPF
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eyal Birger <eyal.birger@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, shuah@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
References: <20221128160501.769892-1-eyal.birger@gmail.com>
 <20221128160501.769892-3-eyal.birger@gmail.com>
 <c8a2d940-ff85-c952-74d0-25ad2c33c1af@linux.dev>
 <20221129095001.GV704954@gauss3.secunet.de>
 <20221129081510.56b1025e@kernel.org>
Content-Language: en-US
In-Reply-To: <20221129081510.56b1025e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/22 8:15 AM, Jakub Kicinski wrote:
> On Tue, 29 Nov 2022 10:50:01 +0100 Steffen Klassert wrote:
>>> Please tag for bpf-next
>>
>> This is a change to xfrm ipsec, so it should go
>> through the ipsec-next tree, unless there is
>> a good reason for handling that different.

The set is mostly depending on the bpf features.  Patch 2 is mostly depending on 
bpf and patch 3 is also a bpf selftest.  I assume the set should have been 
developed based on the bpf-next tree instead.  It is also good to have the test 
run in bpf CI sooner than later to bar on-going bpf changes that may break it. 
It is the reason I think bpf-next makes more sense.

If it is preferred to go through ipsec-next, the set should at least be tested 
against the bpf-next before posting.

https://patchwork.kernel.org/project/netdevbpf/patch/20221129132018.985887-4-eyal.birger@gmail.com/
