Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10BEC198874
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 01:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgC3Xn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 19:43:58 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33829 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728537AbgC3Xn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 19:43:58 -0400
Received: by mail-qk1-f193.google.com with SMTP id i6so21202338qke.1;
        Mon, 30 Mar 2020 16:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GEsMIo837tE32nbS1/vEjsFIUIiXOxXUakGNYbdMpd0=;
        b=L3hJjaAxfXb9n9FyPxd2XiDbZ+CqPjgoEr2fg5fgZBk1Pe9LgMeiuexsjHHdIlGi4X
         6FJtY/TSSX+dLKX+Mac0qUYMTeOVxE8iwk9GkKv79MXQsrTPcEmPm0TXCNnKHZyXhT2W
         bAYrE4wW04mefR0cT1IiX7Tqup8JraVP/uleEVv5XAuA8oKb70EOXMvt8fyknjbwpOOr
         YgFlxHe56wEPvUiRc7vH6IHxLYOUb62/pqs/cYLgSSE9d6qv6EtX+8OSTEhj9DmVLZUj
         WvvUhjn1wEbWx54VKRoJwIDCNhwTn4in0f9IRD71qRqA3nN7UcN18E3fhSqZIaru+c4c
         dy3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GEsMIo837tE32nbS1/vEjsFIUIiXOxXUakGNYbdMpd0=;
        b=tVuleEkD4YJ+EbIawK/Kae/P3iHKEmwHkB/SAJnlGSU0aPW8VZmWSqMwO+Y5vVOnAw
         e6Wo8fgiRX2Lq2HpChTct88qUryAoSZhHZ0b4Ihhj09fjbHPUZf04wGOXHXGiagREP2r
         87SM3cM7a9789RMggMpc/1mOFsfqU9z+pQ+BjEsxeC6ei93/lKi5Tgwd82qTRkL+zvU2
         5aWgzpIe6nEG2NZPDCGiOyqTa9uQpjwrMFZqsHVxUALqXmi0mo6GCv4l5tN8BYZ16T0M
         0BFw2QyopIb7S5QYcnhVa/+TdS9aBIbKnIrjVfkuwSh8d+zGT1Zc4+pf9UEWVMf56Gzr
         DieQ==
X-Gm-Message-State: ANhLgQ3W6ZpZ4NVFRKwRq8nuaCqTvX+NaouExXjZe+DDCMQxppG1zpjb
        s5DqfV3kbAKEGD5Gn/owxqo=
X-Google-Smtp-Source: ADFU+vsXv53R/3NPrlBI0i4bpT+AnryRoMEiamLHgvXwbpCUB5RdBqYAqdMTEqbbYpgHAraWdEkdjw==
X-Received: by 2002:a37:6756:: with SMTP id b83mr2425361qkc.468.1585611835574;
        Mon, 30 Mar 2020 16:43:55 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:38c4:c806:40d0:dc8a? ([2601:282:803:7700:38c4:c806:40d0:dc8a])
        by smtp.googlemail.com with ESMTPSA id d24sm11313167qkl.8.2020.03.30.16.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 16:43:54 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
References: <20200330030001.2312810-1-andriin@fb.com>
 <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
 <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com>
 <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com>
Date:   Mon, 30 Mar 2020 17:43:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/20 4:50 PM, Alexei Starovoitov wrote:
> On Mon, Mar 30, 2020 at 1:46 PM David Ahern <dsahern@gmail.com> wrote:
>> release. As it stands it is a half-baked feature.
> 
> speaking of half-baked.
> I think as it stands (even without link_query) it's already extremely
> useful addition and doesn't take anything away from existing cgroup-bpf
> and doesn't hinder observability. 'bpftool cgroup' works just fine.
> So I've applied the set.
> 
> Even if it was half-baked it would still be applie-able.
> Many features are developed over the course of multiple
> kernel releases. Example: your nexthops, mptcp, bpf-lsm.
> 

nexthops were not - refactoring in 1 release and the entire feature went
in to 5.4. Large features / patch sets often must be spread across
kernel versions because it is not humanly possible to send and review
the patches.

This is not a large feature, and there is no reason for CREATE/UPDATE -
a mere 4 patch set - to go in without something as essential as the
QUERY for observability.
