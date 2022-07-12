Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A45E1571AD3
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbiGLNHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiGLNHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:07:03 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403FBB41BB
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 06:07:01 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y4so10033231edc.4
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 06:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=u8l7HUNbb6T5hd+GJ4MBYUKuc1ALWgwKw98IY+lEVpI=;
        b=x1XIDJ9vm3CAvlnarSpe7uglRwDqmE8M6stiFxOTIdwFxpdKgwHffh1b/dNbDmb249
         hFFj6Sn6Q4HSz+jYD2xDHZDQ1iR9EGYCj7hdmr4ponqVai7IxXBqsy2ujBl9meOsRDmk
         qNxcmAQnAnqRWE64umeVIfzV8RINc/XYuZ/h8ZMcnTlEdyJDlTwpdsIrN+29f5R3bgpv
         G1IRdwuShnscAORDtZSJl9NE5rPA1XTr6KXynOU3Ug3GdFPlV29+7OOYgLPMN2BhOYTq
         Mnm1HTHWj8CaMeH83hHHph26cTlXoOLNg+KpSQrASDwrpn4UHvUJmB/aiJBLJUUzlfP9
         pXVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u8l7HUNbb6T5hd+GJ4MBYUKuc1ALWgwKw98IY+lEVpI=;
        b=xduwoNERdGycOYV27GALx8a9y4tCw4sRhv2npwwGgEQnpV2EH3BLpEQgO3agKfjQDk
         YCPWAB/LH+ZUVtVUmFFjdqAZuieaWSPoQCnPr6zGR4DridJRU6GAMcJtuCR5Nz8jopVB
         0V/ADEde6Jrsi9ughUYjEsHHAQJ7oPZhUcinqJXxsx0R6cbIhVYFLwpIRwLn5HFm5pvo
         92ldD7uYxCbfvnX5daxxmM5ct6t2KgjPn8DWe98Yqi63vQ64HrpHt29NjWghOc58Q3rA
         EfsQbX84M1hRQhjq0U6feVNsHa2tzRcpPm0xj4hAflg2kbMPGN10A0khxgY4JgXU+V2R
         571w==
X-Gm-Message-State: AJIora+YFAOe1CEidCi23bBEydY6K7BGR4B3rWfmvb1gHah6kan2c1h8
        FlyIq+m4DnR2tbYxknzO8OH+Fg==
X-Google-Smtp-Source: AGRyM1t8RW+y6Zxso6IzSZ3nkCgU3iEFhL1cDkcOEW8Kb/4rto+4atb4ox05QRxohqhGkATqzRgT2Q==
X-Received: by 2002:a05:6402:2395:b0:43a:6d91:106c with SMTP id j21-20020a056402239500b0043a6d91106cmr32509494eda.299.1657631219727;
        Tue, 12 Jul 2022 06:06:59 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:ef5d:b12d:ae7c:8d1? ([2a02:578:8593:1200:ef5d:b12d:ae7c:8d1])
        by smtp.gmail.com with ESMTPSA id n4-20020a170906164400b0072af92fa086sm3746055ejd.32.2022.07.12.06.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 06:06:59 -0700 (PDT)
Message-ID: <23fa8509-5b2d-6263-1543-443c9c896348@tessares.net>
Date:   Tue, 12 Jul 2022 15:06:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next] mptcp: Add struct mptcp_sock definition when
 CONFIG_MPTCP is disabled
Content-Language: en-GB
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Geliang Tang <geliang.tang@suse.com>, mptcp@lists.linux.dev
References: <20220711130731.3231188-1-jolsa@kernel.org>
 <6d3b3bf-2e29-d695-87d7-c23497acc81@linux.intel.com>
 <5710e8f7-6c09-538f-a636-2ea1863ab208@tessares.net> <Ys1lKqF1GL/T6mBz@krava>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <Ys1lKqF1GL/T6mBz@krava>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On 12/07/2022 14:12, Jiri Olsa wrote:
> On Tue, Jul 12, 2022 at 11:06:38AM +0200, Matthieu Baerts wrote:
>> Hi Jiri, Mat,
>>
>> On 11/07/2022 23:21, Mat Martineau wrote:
>>> On Mon, 11 Jul 2022, Jiri Olsa wrote:
>>>
>>>> The btf_sock_ids array needs struct mptcp_sock BTF ID for
>>>> the bpf_skc_to_mptcp_sock helper.
>>>>
>>>> When CONFIG_MPTCP is disabled, the 'struct mptcp_sock' is not
>>>> defined and resolve_btfids will complain with:
>>>>
>>>>  BTFIDS  vmlinux
>>>> WARN: resolve_btfids: unresolved symbol mptcp_sock
>>>>
>>>> Adding empty difinition for struct mptcp_sock when CONFIG_MPTCP
>>>> is disabled.
>>>>
>>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>>> ---
>>>> include/net/mptcp.h | 4 ++++
>>>> 1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/include/net/mptcp.h b/include/net/mptcp.h
>>>> index ac9cf7271d46..25741a52c666 100644
>>>> --- a/include/net/mptcp.h
>>>> +++ b/include/net/mptcp.h
>>>> @@ -59,6 +59,10 @@ struct mptcp_addr_info {
>>>>     };
>>>> };
>>>>
>>>> +#if !IS_ENABLED(CONFIG_MPTCP)
>>>> +struct mptcp_sock { };
>>>> +#endif
>>>
>>> The only use of struct mptcp_sock I see with !CONFIG_MPTCP is from this
>>> stub at the end of mptcp.h:
>>>
>>> static inline struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock
>>> *sk) { return NULL; }
>>>
>>> It's normally defined in net/mptcp/protocol.h for the MPTCP subsystem code.
>>>
>>> The conditional could be added on the line before the stub to make it
>>> clear that the empty struct is associated with that inline stub.
>>
>> If this is required only for this specific BPF function, why not
>> modifying this stub (or add a define) to return "void *" instead of
>> "struct mptcp_sock *"?
> 
> so btf_sock_ids array needs BTF ID for 'struct mptcp_sock' and if CONFIG_MPTCP
> is not enabled, then resolve_btfids (which resolves and populate all BTF IDs)
> won't find it and will complain
> 
> btf_sock_ids keeps all socket IDs regardles the state of their CONFIG options,
> and relies that sock structs are defined even if related CONFIG option is disabled

Thank you for the explanation. I didn't know about that.

Then it is fine for me to leave it in mptcp.h. If it is not directly
linked to bpf_mptcp_sock_from_subflow(), I guess it can stay there but
maybe better to wait for Mat's answer about that.

> if that is false assumption then maybe we need to make btf_sock_ids values optional
> somehow

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
