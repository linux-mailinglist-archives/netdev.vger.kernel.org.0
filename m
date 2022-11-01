Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6C5615424
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 22:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiKAVVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 17:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiKAVV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 17:21:29 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCA71EEDC;
        Tue,  1 Nov 2022 14:19:18 -0700 (PDT)
Message-ID: <ca6e4ce1-abf6-6142-3463-4410181ed0ab@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667337456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bi/oB/qmacK/RH/CAd+QG/wEP2oGK2k8fvNgbwrWZys=;
        b=D3M7dUaGs2WbmaCIGS72lKDr0N3fGeYnI9EN5f4raXNPMVE59479rZvo7g8a/rxAQmMDQr
        Ju0Nf1JIo1uXekI/Ieo7uzG+WtolcOOYCFDzBaGnfJ++KX0ZLPkV1bOwnbMHDq9YsfhS9w
        q6BUfDVqxCNNELAEvefWbuoTpaXHcKY=
Date:   Tue, 1 Nov 2022 14:17:16 -0700
MIME-Version: 1.0
Subject: Re: [xdp-hints] Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Bezdeka, Florian" <florian.bezdeka@siemens.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "alexandr.lobakin@intel.com" <alexandr.lobakin@intel.com>,
        "anatoly.burakov@intel.com" <anatoly.burakov@intel.com>,
        "song@kernel.org" <song@kernel.org>,
        "Deric, Nemanja" <nemanja.deric@siemens.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "willemb@google.com" <willemb@google.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>, "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "mtahhan@redhat.com" <mtahhan@redhat.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "haoluo@google.com" <haoluo@google.com>,
        Yonghong Song <yhs@meta.com>
References: <20221027200019.4106375-1-sdf@google.com>
 <635bfc1a7c351_256e2082f@john.notmuch> <20221028110457.0ba53d8b@kernel.org>
 <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch> <20221028181431.05173968@kernel.org>
 <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
 <875yg057x1.fsf@toke.dk> <663fb4f4-04b7-5c1f-899c-bdac3010f073@meta.com>
 <CAKH8qBt=As5ON+CbH304tRanudvTF27bzeSnjH2GQR2TVx+mXw@mail.gmail.com>
 <752afbbb-1a14-3dad-53d0-35bb32632c91@linux.dev>
 <CAKH8qBsH_bxvH3M8RmSAfgWkuwsgMApU0qpF4H_vJfqN+gdx3A@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAKH8qBsH_bxvH3M8RmSAfgWkuwsgMApU0qpF4H_vJfqN+gdx3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/22 1:12 PM, Stanislav Fomichev wrote:
>>>>> As for the kfunc-based interface, I think it shows some promise.
>>>>> Exposing a list of function names to retrieve individual metadata items
>>>>> instead of a struct layout is sorta comparable in terms of developer UI
>>>>> accessibility etc (IMO).
>>>>
>>>> Looks like there are quite some use cases for hw_timestamp.
>>>> Do you think we could add it to the uapi like struct xdp_md?
>>>>
>>>> The following is the current xdp_md:
>>>> struct xdp_md {
>>>>            __u32 data;
>>>>            __u32 data_end;
>>>>            __u32 data_meta;
>>>>            /* Below access go through struct xdp_rxq_info */
>>>>            __u32 ingress_ifindex; /* rxq->dev->ifindex */
>>>>            __u32 rx_queue_index;  /* rxq->queue_index  */
>>>>
>>>>            __u32 egress_ifindex;  /* txq->dev->ifindex */
>>>> };
>>>>
>>>> We could add  __u64 hw_timestamp to the xdp_md so user
>>>> can just do xdp_md->hw_timestamp to get the value.
>>>> xdp_md->hw_timestamp == 0 means hw_timestamp is not
>>>> available.
>>>>
>>>> Inside the kernel, the ctx rewriter can generate code
>>>> to call driver specific function to retrieve the data.
>>>
>>> If the driver generates the code to retrieve the data, how's that
>>> different from the kfunc approach?
>>> The only difference I see is that it would be a more strong UAPI than
>>> the kfuncs?
>>
>> Another thing may be worth considering, some hints for some HW/driver may be
>> harder (or may not worth) to unroll/inline.  For example, I see driver is doing
>> spin_lock_bh while getting the hwtstamp.  For this case, keep calling a kfunc
>> and avoid the unroll/inline may be the right thing to do.
> 
> Yeah, I'm trying to look at the drivers right now and doing
> spinlocks/seqlocks might complicate the story...
> But it seems like in the worst case, the unrolled bytecode can always
> resort to calling a kernel function?

unroll the common cases and call kernel function for everything else? that 
should be doable.  The bpf prog calling it as kfunc will have more flexibility 
like this here.

> (we might need to have some scratch area to preserve r1-r5 and we
> can't touch r6-r9 because we are not in a real call, but seems doable;
> I'll try to illustrate with a bunch of examples)
> 
> 
>>>> The kfunc approach can be used to *less* common use cases?
>>>
>>> What's the advantage of having two approaches when one can cover
>>> common and uncommon cases?
>>>
>>>>> There are three main drawbacks, AFAICT:
>>>>>
>>>>> 1. It requires driver developers to write and maintain the code that
>>>>> generates the unrolled BPF bytecode to access the metadata fields, which
>>>>> is a non-trivial amount of complexity. Maybe this can be abstracted away
>>>>> with some internal helpers though (like, e.g., a
>>>>> bpf_xdp_metadata_copy_u64(dst, src, offset) helper which would spit out
>>>>> the required JMP/MOV/LDX instructions?
>>>>>
>>>>> 2. AF_XDP programs won't be able to access the metadata without using a
>>>>> custom XDP program that calls the kfuncs and puts the data into the
>>>>> metadata area. We could solve this with some code in libxdp, though; if
>>>>> this code can be made generic enough (so it just dumps the available
>>>>> metadata functions from the running kernel at load time), it may be
>>>>> possible to make it generic enough that it will be forward-compatible
>>>>> with new versions of the kernel that add new fields, which should
>>>>> alleviate Florian's concern about keeping things in sync.
>>>>>
>>>>> 3. It will make it harder to consume the metadata when building SKBs. I
>>>>> think the CPUMAP and veth use cases are also quite important, and that
>>>>> we want metadata to be available for building SKBs in this path. Maybe
>>>>> this can be resolved by having a convenient kfunc for this that can be
>>>>> used for programs doing such redirects. E.g., you could just call
>>>>> xdp_copy_metadata_for_skb() before doing the bpf_redirect, and that
>>>>> would recursively expand into all the kfunc calls needed to extract the
>>>>> metadata supported by the SKB path?
>>>>>
>>>>> -Toke
>>>>>
>>

