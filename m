Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932CB614FF9
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 18:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiKARFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 13:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiKARF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 13:05:28 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C321C13E30;
        Tue,  1 Nov 2022 10:05:24 -0700 (PDT)
Message-ID: <0c00ba33-f37b-dfe6-7980-45920ffa273b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667322323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cQa/6U5NTiSVzwW86YvgQYxS/QKgw9kmzN/gFIFxOg0=;
        b=CWGacSkuXsCz33NqB//Bn4xp4PaNCICNI5QVUY+gKslwuIp3OZ2cK7n5KI5fcjRRLWQ7vr
        cGPK/Ic8GU5EnsnFQRk3EXef5GbzN0kT9/U665D1jDF7ef/oOW0qjEg3ow9nAf5EWNWDOM
        JDmTr/DbOjTl7HgT1X3qDODET44CR3c=
Date:   Tue, 1 Nov 2022 10:05:13 -0700
MIME-Version: 1.0
Subject: Re: [xdp-hints] Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     "Bezdeka, Florian" <florian.bezdeka@siemens.com>,
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
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20221027200019.4106375-1-sdf@google.com>
 <635bfc1a7c351_256e2082f@john.notmuch> <20221028110457.0ba53d8b@kernel.org>
 <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch> <20221028181431.05173968@kernel.org>
 <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
 <875yg057x1.fsf@toke.dk>
 <CAKH8qBvQbgE=oSZoH4xiLJmqMSXApH-ufd-qEKGKD8=POfhrWQ@mail.gmail.com>
 <77b115a0-bbba-48eb-89bd-3078b5fb7eeb@linux.dev>
 <CAKH8qBsGB1G60cu91Au816gsB2zF8T0P-yDwxbTEOxX0TN3WgA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAKH8qBsGB1G60cu91Au816gsB2zF8T0P-yDwxbTEOxX0TN3WgA@mail.gmail.com>
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

On 10/31/22 6:59 PM, Stanislav Fomichev wrote:
> On Mon, Oct 31, 2022 at 3:57 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>
>> On 10/31/22 10:00 AM, Stanislav Fomichev wrote:
>>>> 2. AF_XDP programs won't be able to access the metadata without using a
>>>> custom XDP program that calls the kfuncs and puts the data into the
>>>> metadata area. We could solve this with some code in libxdp, though; if
>>>> this code can be made generic enough (so it just dumps the available
>>>> metadata functions from the running kernel at load time), it may be
>>>> possible to make it generic enough that it will be forward-compatible
>>>> with new versions of the kernel that add new fields, which should
>>>> alleviate Florian's concern about keeping things in sync.
>>>
>>> Good point. I had to convert to a custom program to use the kfuncs :-(
>>> But your suggestion sounds good; maybe libxdp can accept some extra
>>> info about at which offset the user would like to place the metadata
>>> and the library can generate the required bytecode?
>>>
>>>> 3. It will make it harder to consume the metadata when building SKBs. I
>>>> think the CPUMAP and veth use cases are also quite important, and that
>>>> we want metadata to be available for building SKBs in this path. Maybe
>>>> this can be resolved by having a convenient kfunc for this that can be
>>>> used for programs doing such redirects. E.g., you could just call
>>>> xdp_copy_metadata_for_skb() before doing the bpf_redirect, and that
>>>> would recursively expand into all the kfunc calls needed to extract the
>>>> metadata supported by the SKB path?
>>>
>>> So this xdp_copy_metadata_for_skb will create a metadata layout that
>>
>> Can the xdp_copy_metadata_for_skb be written as a bpf prog itself?
>> Not sure where is the best point to specify this prog though.  Somehow during
>> bpf_xdp_redirect_map?
>> or this prog belongs to the target cpumap and the xdp prog redirecting to this
>> cpumap has to write the meta layout in a way that the cpumap is expecting?
> 
> We're probably interested in triggering it from the places where xdp
> frames can eventually be converted into skbs?
> So for plain 'return XDP_PASS' and things like bpf_redirect/etc? (IOW,
> anything that's not XDP_DROP / AF_XDP redirect).
> We can probably make it magically work, and can generate
> kernel-digestible metadata whenever data == data_meta, but the
> question - should we?
> (need to make sure we won't regress any existing cases that are not
> relying on the metadata)

Instead of having some kernel-digestible meta data, how about calling another 
bpf prog to initialize the skb fields from the meta area after 
__xdp_build_skb_from_frame() in the cpumap, so 
run_xdp_set_skb_fileds_from_metadata() may be a better name.

The xdp_prog@rx sets the meta data and then redirect.  If the xdp_prog@rx can 
also specify a xdp prog to initialize the skb fields from the meta area, then 
there is no need to have a kfunc to enforce a kernel-digestible layout.  Not 
sure what is a good way to specify this xdp_prog though...

>>> the kernel will be able to understand when converting back to skb?
>>> IIUC, the xdp program will look something like the following:
>>>
>>> if (xdp packet is to be consumed by af_xdp) {
>>>     // do a bunch of bpf_xdp_metadata_<metadata> calls and assemble your
>>> own metadata layout
>>>     return bpf_redirect_map(xsk, ...);
>>> } else {
>>>     // if the packet is to be consumed by the kernel
>>>     xdp_copy_metadata_for_skb(ctx);
>>>     return bpf_redirect(...);
>>> }
>>>
>>> Sounds like a great suggestion! xdp_copy_metadata_for_skb can maybe
>>> put some magic number in the first byte(s) of the metadata so the
>>> kernel can check whether xdp_copy_metadata_for_skb has been called
>>> previously (or maybe xdp_frame can carry this extra signal, idk).

