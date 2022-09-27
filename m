Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709FF5ECE48
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbiI0UTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbiI0USz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:18:55 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F919F7B;
        Tue, 27 Sep 2022 13:18:54 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id cc5so16680255wrb.6;
        Tue, 27 Sep 2022 13:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=VYiQC0+hw/YN0HXUIX2ZHIj06ZGTMESETEb91ek6mio=;
        b=b+d1TFFX1HXrnCaj7FfV0JH6lWEvDi7u3jNGbto0NjhdTpD6ERgE7IZlMeUVVKagS3
         tAsXx4Z6ZmRtpNFpwpxDVJPUF7h5h/m+dvjMfh69N0kHhjdsGOlPbcdGFjPe3dIamT8v
         q7TwybO/csHrDvvde2hc5jWTaSOMBDxPgCFs4rJEcVW2Wza3nWPY1r7D8Q6xQaRVfGVO
         x6hQERoCR+sQon+7K602PQLtOTJI4fdHVnOIBlQyCQKkl8kKxYNVRzBpgHiZR8VozqwO
         dhDUyaw7//V8D4F1HfY5TRpbllYVg9mn6ql2NwHov4/vATDDt8Oa8QIsfUomFfI1owfC
         8IZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=VYiQC0+hw/YN0HXUIX2ZHIj06ZGTMESETEb91ek6mio=;
        b=vA5/uerW8DcNZj2140wQdU7YkI1DiN8+lAktK2KMIzxHAObcUVm4129GxoKNR+zc+m
         StbsmDuLrGkS9thd39vt6V/XgBZxBo5CjVdcQm0OVCKkjC2Q/JMRv6mXON3+M/9QEUhT
         dHQaLxQUWlf7VXSt2ezvDZw1K8EPqVNmtqVVhIJL9tFKEtuFFMV9es1eqbL4+1+vEd5A
         FOVO1fQqENDuzcnWj8yB0nNrF7kC8fxMlFHoHXO94WcxvsMSqLgutJ1TY7y4Y+qVqOaJ
         2sjkjrYPnocPXjEAeJgQl+sws+KlD76OezKxR6x2vl3lsF5kYxiSCI04lK0IWbT1X++h
         XQGw==
X-Gm-Message-State: ACrzQf3R8XB2BauifgRn+gKmHI79HABv9+qWwTohsA5sYlFBo50Cg0wX
        Xk8lyl3ITH04BqNNG43nyeI=
X-Google-Smtp-Source: AMsMyM72QF1jZuXSKJAZ2BYNMNBdePc6il3Rd6JK8twIGapZblKS+cSGVMGc37PNt4I9uTYnAXgKHg==
X-Received: by 2002:a05:6000:186e:b0:22a:e3b1:9c7d with SMTP id d14-20020a056000186e00b0022ae3b19c7dmr19019256wri.113.1664309932648;
        Tue, 27 Sep 2022 13:18:52 -0700 (PDT)
Received: from [192.168.8.100] (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id h6-20020a05600c2ca600b003b4c40378casm15913221wmc.39.2022.09.27.13.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 13:18:52 -0700 (PDT)
Message-ID: <eb543907-190f-c661-b5d6-b4d67b6184e6@gmail.com>
Date:   Tue, 27 Sep 2022 21:17:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 0/4] shrink struct ubuf_info
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <cover.1663892211.git.asml.silence@gmail.com>
 <7fef56880d40b9d83cc99317df9060c4e7cdf919.camel@redhat.com>
 <021d8ea4-891c-237d-686e-64cecc2cc842@gmail.com>
 <bbb212f6-0165-0747-d99d-b49acbb02a80@gmail.com>
 <85cccb780608e830024fc82a8e4f703031646f4e.camel@redhat.com>
 <c06897d4-4883-2756-87f9-9b10ab495c43@gmail.com>
 <6502e1a45526f97a1e6d7d27bbe07e3bb3623de3.camel@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6502e1a45526f97a1e6d7d27bbe07e3bb3623de3.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/22 20:59, Paolo Abeni wrote:
> On Tue, 2022-09-27 at 19:48 +0100, Pavel Begunkov wrote:
>> On 9/27/22 18:56, Paolo Abeni wrote:
>>> On Tue, 2022-09-27 at 18:16 +0100, Pavel Begunkov wrote:
>>>> On 9/27/22 15:28, Pavel Begunkov wrote:
>>>>> Hello Paolo,
>>>>>
>>>>> On 9/27/22 14:49, Paolo Abeni wrote:
>>>>>> Hello,
>>>>>>
>>>>>> On Fri, 2022-09-23 at 17:39 +0100, Pavel Begunkov wrote:
>>>>>>> struct ubuf_info is large but not all fields are needed for all
>>>>>>> cases. We have limited space in io_uring for it and large ubuf_info
>>>>>>> prevents some struct embedding, even though we use only a subset
>>>>>>> of the fields. It's also not very clean trying to use this typeless
>>>>>>> extra space.
>>>>>>>
>>>>>>> Shrink struct ubuf_info to only necessary fields used in generic paths,
>>>>>>> namely ->callback, ->refcnt and ->flags, which take only 16 bytes. And
>>>>>>> make MSG_ZEROCOPY and some other users to embed it into a larger struct
>>>>>>> ubuf_info_msgzc mimicking the former ubuf_info.
>>>>>>>
>>>>>>> Note, xen/vhost may also have some cleaning on top by creating
>>>>>>> new structs containing ubuf_info but with proper types.
>>>>>>
>>>>>> That sounds a bit scaring to me. If I read correctly, every uarg user
>>>>>> should check 'uarg->callback == msg_zerocopy_callback' before accessing
>>>>>> any 'extend' fields.
>>>>>
>>>>> Providers of ubuf_info access those fields via callbacks and so already
>>>>> know the actual structure used. The net core, on the opposite, should
>>>>> keep it encapsulated and not touch them at all.
>>>>>
>>>>> The series lists all places where we use extended fields just on the
>>>>> merit of stripping the structure of those fields and successfully
>>>>> building it. The only user in net/ipv{4,6}/* is MSG_ZEROCOPY, which
>>>>> again uses callbacks.
>>>>>
>>>>> Sounds like the right direction for me. There is a couple of
>>>>> places where it might get type safer, i.e. adding types instead
>>>>> of void* in for struct tun_msg_ctl and getting rid of one macro
>>>>> hiding types in xen. But seems more like TODO for later.
>>>>>
>>>>>> AFAICS the current code sometimes don't do the
>>>>>> explicit test because the condition is somewhat implied, which in turn
>>>>>> is quite hard to track.
>>>>>>
>>>>>> clearing uarg->zerocopy for the 'wrong' uarg was armless and undetected
>>>>>> before this series, and after will trigger an oops..
>>>>>
>>>>> And now we don't have this field at all to access, considering that
>>>>> nobody blindly casts it.
>>>>>
>>>>>> There is some noise due to uarg -> uarg_zc renaming which make the
>>>>>> series harder to review. Have you considered instead keeping the old
>>>>>> name and introducing a smaller 'struct ubuf_info_common'? the overall
>>>>>> code should be mostly the same, but it will avoid the above mentioned
>>>>>> noise.
>>>>>
>>>>> I don't think there will be less noise this way, but let me try
>>>>> and see if I can get rid of some churn.
>>>>
>>>> It doesn't look any better for me
>>>>
>>>> TL;DR; This series converts only 3 users: tap, xen and MSG_ZEROCOPY
>>>> and doesn't touch core code. If we do ubuf_info_common though I'd need
>>>> to convert lots of places in skbuff.c and multiple places across
>>>> tcp/udp, which is much worse.
>>>
>>> Uhmm... I underlook the fact we must preserve the current accessors for
>>> the common fields.
>>>
>>> I guess something like the following could do (completely untested,
>>> hopefully should illustrate the idea):
>>>
>>> struct ubuf_info {
>>> 	struct_group_tagged(ubuf_info_common, common,
>>> 		void (*callback)(struct sk_buff *, struct ubuf_info *,
>>>                            bool zerocopy_success);
>>> 		refcount_t refcnt;
>>> 	        u8 flags;
>>> 	);
>>>
>>> 	union {
>>>                   struct {
>>>                           unsigned long desc;
>>>                           void *ctx;
>>>                   };
>>>                   struct {
>>>                           u32 id;
>>>                           u16 len;
>>>                           u16 zerocopy:1;
>>>                           u32 bytelen;
>>>                   };
>>>           };
>>>
>>>           struct mmpin {
>>>                   struct user_struct *user;
>>>                   unsigned int num_pg;
>>>           } mmp;
>>> };
>>>
>>> Then you should be able to:
>>> - access ubuf_info->callback,
>>> - access the same field via ubuf_info->common.callback
>>> - declare variables as 'struct ubuf_info_commom' with appropriate
>>> contents.
>>>
>>> WDYT?
>>
>> Interesting, I didn't think about struct_group, this would
>> let to split patches better and would limit non-core changes.
>> But if the plan is to convert the core helpers to
>> ubuf_info_common, than I think it's still messier than changing
>> ubuf providers only.
>>
>> I can do the exercise, but I don't really see what is the goal.
>> Let me ask this, if we forget for a second how diffs look,
>> do you care about which pair is going to be in the end?
> 
> Uhm... I proposed this initially with the goal of remove non fuctional
> changes from a patch that was hard to digest for me (4/4). So it's
> about diffstat to me ;)

Ah, got it

> On the flip side the change suggested would probably not be as
> straighforward as I would hope for.
> 
>> ubuf_info_common/ubuf_info vs ubuf_info/ubuf_info_msgzc?
> 
> The specific names used are not much relevant.
> 
>> Are there you concerned about naming or is there more to it?
> 
> I feel like this series is potentially dangerous, but I could not spot
> bugs into the code. I would have felt more relaxed eariler in the devel
> cycle.

union {
	struct {
		unsigned long desc;
		void *ctx;
	};
	struct {
		u32 id;
		u16 len;
		u16 zerocopy:1;
		u32 bytelen;
	};
};


btw, nobody would frivolously change ->zerocopy anyway as it's
in a union. Even without the series we're absolutely screwed
if someone does that. If anything it adds a way to get rid of it:

1) Make vhost and xen use their own structures with right types.
2) kill unused struct {ctx, desc} for MSG_ZEROCOPY

-- 
Pavel Begunkov
