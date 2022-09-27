Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAA95ECA9B
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 19:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiI0RRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 13:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiI0RRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 13:17:33 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817791CD6B9;
        Tue, 27 Sep 2022 10:17:32 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id r7so16040192wrm.2;
        Tue, 27 Sep 2022 10:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=gFJ/H+N6WAC6t6IyMR0gZxkOzHl2iN3HsUIPG8f/u4I=;
        b=L4/iTXFz7DuL5Uib4WIGjsIg0VrC7CXY9Nc3a6NaRVNsHglXDiLDyualTpBH2xBe4C
         NbHbXeBPxgHCg2zjPKSLOPE0Sx+LhUwzz7pp0Dp9YLLALpGgQYqFsEWeP2nObb9r3A0J
         JN/YeMF4UbQx3cskpQj0nbelj2yYEjpZlCyEanouYFiW5VOoN/SAc4hjNz4N1X/nUq2g
         TRifOA+0L3tNFcxDdUJASxezuirH17L9jRkrcMn1ujmRvAXJRQhZi6ik68pDy9zmmuCL
         fBixtkxBQPhzk0/an7ggX0q/eDguyIMRuNBjlWGO9qW19gRk00YQ540+09bEN/R85APk
         z8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=gFJ/H+N6WAC6t6IyMR0gZxkOzHl2iN3HsUIPG8f/u4I=;
        b=RJLGRf/x+pXCkDgNS8WD/w1lwVkKTtH8a4edM2zESDgrH1Cm9WerR9fPxSJiIqL8js
         OXCX6pujDRPYBCaS46c+/2/VixORNWzi1gLjHi+Butq48r4O9xcJ1dHkwxSBvy494vi+
         eYLTahclZA4re3T1sPHFBfjbJ68jp6Wy7bgxaNJc2WVPByFqpZBKVb76tGblGzuDcDuI
         4asPthDaXu3ECX9iCECfyQ9xjh3J/kLEJjNCTpurJbOdmjcnG1NbErSUxdZeLe3lqaOu
         cF7X++tuI15sswU8FsrKIlnW0G7G+6h8t+KS3eXdtfDMT5nT7yvsw2xO6Llb2EK8ns1Z
         RT3Q==
X-Gm-Message-State: ACrzQf2xg+eSLkAvxKn7MIZyYfPe1Uhg9zHC+BNKiL906atUQN6PgmIS
        l49qeu7JC1rU/dAQ0GFb0s6Ax+vISNc=
X-Google-Smtp-Source: AMsMyM4RKN4LBXcpsUki/a4beJoIwOEKU0REj/xTHR6CD5uBK9Mb1sJXwhpfSrm7yyiPg6HtYG8mfw==
X-Received: by 2002:adf:fa08:0:b0:228:c246:2a4b with SMTP id m8-20020adffa08000000b00228c2462a4bmr16991498wrr.630.1664299050980;
        Tue, 27 Sep 2022 10:17:30 -0700 (PDT)
Received: from [192.168.8.100] (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id b5-20020a05600c4e0500b003b339438733sm2507299wmq.19.2022.09.27.10.17.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 10:17:30 -0700 (PDT)
Message-ID: <bbb212f6-0165-0747-d99d-b49acbb02a80@gmail.com>
Date:   Tue, 27 Sep 2022 18:16:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 0/4] shrink struct ubuf_info
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
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
In-Reply-To: <021d8ea4-891c-237d-686e-64cecc2cc842@gmail.com>
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

On 9/27/22 15:28, Pavel Begunkov wrote:
> Hello Paolo,
> 
> On 9/27/22 14:49, Paolo Abeni wrote:
>> Hello,
>>
>> On Fri, 2022-09-23 at 17:39 +0100, Pavel Begunkov wrote:
>>> struct ubuf_info is large but not all fields are needed for all
>>> cases. We have limited space in io_uring for it and large ubuf_info
>>> prevents some struct embedding, even though we use only a subset
>>> of the fields. It's also not very clean trying to use this typeless
>>> extra space.
>>>
>>> Shrink struct ubuf_info to only necessary fields used in generic paths,
>>> namely ->callback, ->refcnt and ->flags, which take only 16 bytes. And
>>> make MSG_ZEROCOPY and some other users to embed it into a larger struct
>>> ubuf_info_msgzc mimicking the former ubuf_info.
>>>
>>> Note, xen/vhost may also have some cleaning on top by creating
>>> new structs containing ubuf_info but with proper types.
>>
>> That sounds a bit scaring to me. If I read correctly, every uarg user
>> should check 'uarg->callback == msg_zerocopy_callback' before accessing
>> any 'extend' fields.
> 
> Providers of ubuf_info access those fields via callbacks and so already
> know the actual structure used. The net core, on the opposite, should
> keep it encapsulated and not touch them at all.
> 
> The series lists all places where we use extended fields just on the
> merit of stripping the structure of those fields and successfully
> building it. The only user in net/ipv{4,6}/* is MSG_ZEROCOPY, which
> again uses callbacks.
> 
> Sounds like the right direction for me. There is a couple of
> places where it might get type safer, i.e. adding types instead
> of void* in for struct tun_msg_ctl and getting rid of one macro
> hiding types in xen. But seems more like TODO for later.
> 
>> AFAICS the current code sometimes don't do the
>> explicit test because the condition is somewhat implied, which in turn
>> is quite hard to track.
>>
>> clearing uarg->zerocopy for the 'wrong' uarg was armless and undetected
>> before this series, and after will trigger an oops..
> 
> And now we don't have this field at all to access, considering that
> nobody blindly casts it.
> 
>> There is some noise due to uarg -> uarg_zc renaming which make the
>> series harder to review. Have you considered instead keeping the old
>> name and introducing a smaller 'struct ubuf_info_common'? the overall
>> code should be mostly the same, but it will avoid the above mentioned
>> noise.
> 
> I don't think there will be less noise this way, but let me try
> and see if I can get rid of some churn.

It doesn't look any better for me

TL;DR; This series converts only 3 users: tap, xen and MSG_ZEROCOPY
and doesn't touch core code. If we do ubuf_info_common though I'd need
to convert lots of places in skbuff.c and multiple places across
tcp/udp, which is much worse. And then I'd still need to touch all
users to do ubuf_info -> ubuf_info_common conversion and all in a
single commit to not break build.

If it's about naming, I can add a tree-wide renaming patch on top.

Paolo, I'd appreciate if you let know whether you're fine with it
or not, I don't want the series to get stuck. For bug concerns,
all places touching those optional fields are converted to
ubuf_info_msgzc, and I wouldn't say 4/4 is so bad.

-- 
Pavel Begunkov
