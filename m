Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A5C63F919
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 21:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiLAU0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 15:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiLAU0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 15:26:21 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E12BFCDE;
        Thu,  1 Dec 2022 12:26:20 -0800 (PST)
Message-ID: <917db515-072c-31d5-1cd2-b28bc40f7bd4@linux.dev>
Date:   Thu, 1 Dec 2022 12:26:14 -0800
MIME-Version: 1.0
Subject: Re: [PATCH ipsec-next,v2 3/3] selftests/bpf: add xfrm_info tests
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        andrii@kernel.org, daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, shuah@kernel.org
References: <20221129132018.985887-1-eyal.birger@gmail.com>
 <20221129132018.985887-4-eyal.birger@gmail.com>
 <ba1a8717-7d9a-9a78-d80a-ad95bb902085@linux.dev>
 <CAHsH6Gvb94O6ir-emzop1FoDsbHh7QNVFrtDuohzvXpVe0S4Vg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAHsH6Gvb94O6ir-emzop1FoDsbHh7QNVFrtDuohzvXpVe0S4Vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/22 9:34 PM, Eyal Birger wrote:
>>> +
>>> +struct {
>>> +     __uint(type, BPF_MAP_TYPE_ARRAY);
>>> +     __uint(max_entries, 2);
>>> +     __type(key, __u32);
>>> +     __type(value, __u32);
>>> +} dst_if_id_map SEC(".maps");
>>
>> It is easier to use global variables instead of a map.
> 
> Would these be available for read/write from the test application (as the
> map is currently populated/read from userspace)?

Yes, through the skel->bss->...
selftests/bpf/prog_tests/ has examples.


