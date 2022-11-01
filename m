Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F26C6150BA
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 18:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiKARbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 13:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiKARba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 13:31:30 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF41C1C421;
        Tue,  1 Nov 2022 10:31:28 -0700 (PDT)
Message-ID: <752afbbb-1a14-3dad-53d0-35bb32632c91@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667323885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ol7d/SLJ6X6mg36SiC0ZeRFUpUzT12EE9bBK6pbc9MQ=;
        b=rXflmn5Oiq9pgFgx3WqwuPIIxh8sIrA/eqYpZc4X4RsOVgcstXbLvd9qGoxOTPFJ0SJZnd
        uP4NVFaaqFtrkDSRNyoNaVD1McC3Z+eHSfhXc79pDHufoUpf3ZXYVprgM6VLkqfiPiGzv5
        JDWiN0jaoxl0OlVi0AZs0dUpOhc4qXE=
Date:   Tue, 1 Nov 2022 10:31:19 -0700
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAKH8qBt=As5ON+CbH304tRanudvTF27bzeSnjH2GQR2TVx+mXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/22 3:09 PM, Stanislav Fomichev wrote:
> On Mon, Oct 31, 2022 at 12:36 PM Yonghong Song <yhs@meta.com> wrote:
>>
>>
>>
>> On 10/31/22 8:28 AM, Toke Høiland-Jørgensen wrote:
>>> "Bezdeka, Florian" <florian.bezdeka@siemens.com> writes:
>>>
>>>> Hi all,
>>>>
>>>> I was closely following this discussion for some time now. Seems we
>>>> reached the point where it's getting interesting for me.
>>>>
>>>> On Fri, 2022-10-28 at 18:14 -0700, Jakub Kicinski wrote:
>>>>> On Fri, 28 Oct 2022 16:16:17 -0700 John Fastabend wrote:
>>>>>>>> And it's actually harder to abstract away inter HW generation
>>>>>>>> differences if the user space code has to handle all of it.
>>>>>>
>>>>>> I don't see how its any harder in practice though?
>>>>>
>>>>> You need to find out what HW/FW/config you're running, right?
>>>>> And all you have is a pointer to a blob of unknown type.
>>>>>
>>>>> Take timestamps for example, some NICs support adjusting the PHC
>>>>> or doing SW corrections (with different versions of hw/fw/server
>>>>> platforms being capable of both/one/neither).
>>>>>
>>>>> Sure you can extract all this info with tracing and careful
>>>>> inspection via uAPI. But I don't think that's _easier_.
>>>>> And the vendors can't run the results thru their validation
>>>>> (for whatever that's worth).
>>>>>
>>>>>>> I've had the same concern:
>>>>>>>
>>>>>>> Until we have some userspace library that abstracts all these details,
>>>>>>> it's not really convenient to use. IIUC, with a kptr, I'd get a blob
>>>>>>> of data and I need to go through the code and see what particular type
>>>>>>> it represents for my particular device and how the data I need is
>>>>>>> represented there. There are also these "if this is device v1 -> use
>>>>>>> v1 descriptor format; if it's a v2->use this another struct; etc"
>>>>>>> complexities that we'll be pushing onto the users. With kfuncs, we put
>>>>>>> this burden on the driver developers, but I agree that the drawback
>>>>>>> here is that we actually have to wait for the implementations to catch
>>>>>>> up.
>>>>>>
>>>>>> I agree with everything there, you will get a blob of data and then
>>>>>> will need to know what field you want to read using BTF. But, we
>>>>>> already do this for BPF programs all over the place so its not a big
>>>>>> lift for us. All other BPF tracing/observability requires the same
>>>>>> logic. I think users of BPF in general perhaps XDP/tc are the only
>>>>>> place left to write BPF programs without thinking about BTF and
>>>>>> kernel data structures.
>>>>>>
>>>>>> But, with proposed kptr the complexity lives in userspace and can be
>>>>>> fixed, added, updated without having to bother with kernel updates, etc.
>>>>>>   From my point of view of supporting Cilium its a win and much preferred
>>>>>> to having to deal with driver owners on all cloud vendors, distributions,
>>>>>> and so on.
>>>>>>
>>>>>> If vendor updates firmware with new fields I get those immediately.
>>>>>
>>>>> Conversely it's a valid concern that those who *do* actually update
>>>>> their kernel regularly will have more things to worry about.
>>>>>
>>>>>>> Jakub mentions FW and I haven't even thought about that; so yeah, bpf
>>>>>>> programs might have to take a lot of other state into consideration
>>>>>>> when parsing the descriptors; all those details do seem like they
>>>>>>> belong to the driver code.
>>>>>>
>>>>>> I would prefer to avoid being stuck on requiring driver writers to
>>>>>> be involved. With just a kptr I can support the device and any
>>>>>> firwmare versions without requiring help.
>>>>>
>>>>> 1) where are you getting all those HW / FW specs :S
>>>>> 2) maybe *you* can but you're not exactly not an ex-driver developer :S
>>>>>
>>>>>>> Feel free to send it early with just a handful of drivers implemented;
>>>>>>> I'm more interested about bpf/af_xdp/user api story; if we have some
>>>>>>> nice sample/test case that shows how the metadata can be used, that
>>>>>>> might push us closer to the agreement on the best way to proceed.
>>>>>>
>>>>>> I'll try to do a intel and mlx implementation to get a cross section.
>>>>>> I have a good collection of nics here so should be able to show a
>>>>>> couple firmware versions. It could be fine I think to have the raw
>>>>>> kptr access and then also kfuncs for some things perhaps.
>>>>>>
>>>>>>>> I'd prefer if we left the door open for new vendors. Punting descriptor
>>>>>>>> parsing to user space will indeed result in what you just said - major
>>>>>>>> vendors are supported and that's it.
>>>>>>
>>>>>> I'm not sure about why it would make it harder for new vendors? I think
>>>>>> the opposite,
>>>>>
>>>>> TBH I'm only replying to the email because of the above part :)
>>>>> I thought this would be self evident, but I guess our perspectives
>>>>> are different.
>>>>>
>>>>> Perhaps you look at it from the perspective of SW running on someone
>>>>> else's cloud, an being able to move to another cloud, without having
>>>>> to worry if feature X is available in xdp or just skb.
>>>>>
>>>>> I look at it from the perspective of maintaining a cloud, with people
>>>>> writing random XDP applications. If I swap a NIC from an incumbent to a
>>>>> (superior) startup, and cloud users are messing with raw descriptor -
>>>>> I'd need to go find every XDP program out there and make sure it
>>>>> understands the new descriptors.
>>>>
>>>> Here is another perspective:
>>>>
>>>> As AF_XDP application developer I don't wan't to deal with the
>>>> underlying hardware in detail. I like to request a feature from the OS
>>>> (in this case rx/tx timestamping). If the feature is available I will
>>>> simply use it, if not I might have to work around it - maybe by falling
>>>> back to SW timestamping.
>>>>
>>>> All parts of my application (BPF program included) should not be
>>>> optimized/adjusted for all the different HW variants out there.
>>>
>>> Yes, absolutely agreed. Abstracting away those kinds of hardware
>>> differences is the whole *point* of having an OS/driver model. I.e.,
>>> it's what the kernel is there for! If people want to bypass that and get
>>> direct access to the hardware, they can already do that by using DPDK.
>>>
>>> So in other words, 100% agreed that we should not expect the BPF
>>> developers to deal with hardware details as would be required with a
>>> kptr-based interface.
>>>
>>> As for the kfunc-based interface, I think it shows some promise.
>>> Exposing a list of function names to retrieve individual metadata items
>>> instead of a struct layout is sorta comparable in terms of developer UI
>>> accessibility etc (IMO).
>>
>> Looks like there are quite some use cases for hw_timestamp.
>> Do you think we could add it to the uapi like struct xdp_md?
>>
>> The following is the current xdp_md:
>> struct xdp_md {
>>           __u32 data;
>>           __u32 data_end;
>>           __u32 data_meta;
>>           /* Below access go through struct xdp_rxq_info */
>>           __u32 ingress_ifindex; /* rxq->dev->ifindex */
>>           __u32 rx_queue_index;  /* rxq->queue_index  */
>>
>>           __u32 egress_ifindex;  /* txq->dev->ifindex */
>> };
>>
>> We could add  __u64 hw_timestamp to the xdp_md so user
>> can just do xdp_md->hw_timestamp to get the value.
>> xdp_md->hw_timestamp == 0 means hw_timestamp is not
>> available.
>>
>> Inside the kernel, the ctx rewriter can generate code
>> to call driver specific function to retrieve the data.
> 
> If the driver generates the code to retrieve the data, how's that
> different from the kfunc approach?
> The only difference I see is that it would be a more strong UAPI than
> the kfuncs?

Another thing may be worth considering, some hints for some HW/driver may be 
harder (or may not worth) to unroll/inline.  For example, I see driver is doing 
spin_lock_bh while getting the hwtstamp.  For this case, keep calling a kfunc 
and avoid the unroll/inline may be the right thing to do.

> 
>> The kfunc approach can be used to *less* common use cases?
> 
> What's the advantage of having two approaches when one can cover
> common and uncommon cases?
> 
>>> There are three main drawbacks, AFAICT:
>>>
>>> 1. It requires driver developers to write and maintain the code that
>>> generates the unrolled BPF bytecode to access the metadata fields, which
>>> is a non-trivial amount of complexity. Maybe this can be abstracted away
>>> with some internal helpers though (like, e.g., a
>>> bpf_xdp_metadata_copy_u64(dst, src, offset) helper which would spit out
>>> the required JMP/MOV/LDX instructions?
>>>
>>> 2. AF_XDP programs won't be able to access the metadata without using a
>>> custom XDP program that calls the kfuncs and puts the data into the
>>> metadata area. We could solve this with some code in libxdp, though; if
>>> this code can be made generic enough (so it just dumps the available
>>> metadata functions from the running kernel at load time), it may be
>>> possible to make it generic enough that it will be forward-compatible
>>> with new versions of the kernel that add new fields, which should
>>> alleviate Florian's concern about keeping things in sync.
>>>
>>> 3. It will make it harder to consume the metadata when building SKBs. I
>>> think the CPUMAP and veth use cases are also quite important, and that
>>> we want metadata to be available for building SKBs in this path. Maybe
>>> this can be resolved by having a convenient kfunc for this that can be
>>> used for programs doing such redirects. E.g., you could just call
>>> xdp_copy_metadata_for_skb() before doing the bpf_redirect, and that
>>> would recursively expand into all the kfunc calls needed to extract the
>>> metadata supported by the SKB path?
>>>
>>> -Toke
>>>

