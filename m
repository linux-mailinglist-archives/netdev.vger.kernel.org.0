Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D147219A358
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 03:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731729AbgDABmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 21:42:50 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:43332 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731470AbgDABmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 21:42:50 -0400
Received: by mail-qv1-f65.google.com with SMTP id c28so12033591qvb.10;
        Tue, 31 Mar 2020 18:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WoL8y5mvkcCw5U69p5RjTvYjkILQlxQTzCgdDTVWkJE=;
        b=n02JNsbiyvoLzbo1fAHX/cBHtrKxjvwNNPCrIajCK4tzLsnaw0BEtgsIJ0s4t2NuYd
         K7ae8xkn69Hm/jxVzEX63sYkhVMzv7e4DrHeaJtydTOXkwZ8QfXF/46eY1fsgu9KTCGU
         L/M1YMTkdV3uSYl/w4pcxytbLEepbaFD+FVM/fLKTSNnSUvCgTl8eEkzEN/V4xByw5BX
         djyHF1RImPGKz2yvd55L61gUy2TOXB+g20zHGYSKv9t7+77aODiQAUnT4PUAC1mdSzhD
         dk+0SqzEYw/Jydr+78ZeJHMuSaoBQ5BeQHkpkDSj+ib8bBVB2aAzP1ycRC3F0gV5qM6L
         PPQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WoL8y5mvkcCw5U69p5RjTvYjkILQlxQTzCgdDTVWkJE=;
        b=H/ca0luMCOTwWYLOucEj6UK/jpJCPEhtIhvmeAXSLTxft/A/8O4DM39HzoO2j1LQv8
         vbx7xwjjo4xp8wgs0PkSjxwgtx97AUJ42wGqlElkYSfl5y3Wk+Ez+mjCRBtmUvVmxwpw
         rQGK1S4kOsyqiCN9QSICqTdKuc481p3Rn1QcDrDzkCIssv4WMA3OxlZowMWhCC1M+0rB
         bzgzjF2xUT1xBJAR81h3maXdaL1Sjcsxeqy50ggVfc5mHph6k6en+67xvGjg6RP2GrkP
         YlbNd+ceC0OydUv3I9aGHfNUj9lUQxyr2ZJHQjvJ6VCmNjSQZu3X+/UVkKiupgTbFfZr
         0bgg==
X-Gm-Message-State: ANhLgQ21t/Ht9QRYEwdg9o0tgGF5yRc5qPTTaHfNnc6ZtrIy1Dx23z2a
        7xpN+whFFLdhyiPfL7qXhJM=
X-Google-Smtp-Source: ADFU+vtdcZ+PveQLEMuJHFZr9ozqP8AejD2ZWVQapN0+RagneDE2fI5RNSRYj72knlcEz+6KDtzjeQ==
X-Received: by 2002:a05:6214:b0a:: with SMTP id u10mr17743901qvj.45.1585705368804;
        Tue, 31 Mar 2020 18:42:48 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:8cf:804:d878:6008? ([2601:282:803:7700:8cf:804:d878:6008])
        by smtp.googlemail.com with ESMTPSA id c27sm542328qkk.0.2020.03.31.18.42.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 18:42:48 -0700 (PDT)
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
 <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com>
 <20200331003222.gdc2qb5rmopphdxl@ast-mbp>
 <58cea4c7-e832-2632-7f69-5502b06310b2@gmail.com>
 <20200331011753.qxo3pq6ldqm43bo7@ast-mbp>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <95bfd8e0-86b3-cb87-9f06-68a7c1ba7d7a@gmail.com>
Date:   Tue, 31 Mar 2020 19:42:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200331011753.qxo3pq6ldqm43bo7@ast-mbp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/20 7:17 PM, Alexei Starovoitov wrote:
> On Mon, Mar 30, 2020 at 06:57:44PM -0600, David Ahern wrote:
>> On 3/30/20 6:32 PM, Alexei Starovoitov wrote:
>>>>
>>>> This is not a large feature, and there is no reason for CREATE/UPDATE -
>>>> a mere 4 patch set - to go in without something as essential as the
>>>> QUERY for observability.
>>>
>>> As I said 'bpftool cgroup' covers it. Observability is not reduced in any way.
>>
>> You want a feature where a process can prevent another from installing a
>> program on a cgroup. How do I learn which process is holding the
>> bpf_link reference and preventing me from installing a program? Unless I
>> have missed some recent change that is not currently covered by bpftool
>> cgroup, and there is no way reading kernel code will tell me.
> 
> No. That's not the case at all. You misunderstood the concept.

I don't think so ...

> 
>> That is my point. You are restricting what root can do and people will
>> not want to resort to killing random processes trying to find the one
>> holding a reference. 
> 
> Not true either.
> bpf_link = old attach with allow_multi (but with extra safety for owner)

cgroup programs existed for roughly 1 year before BPF_F_ALLOW_MULTI.
That's a year for tools like 'ip vrf exec' to exist and be relied on.
'ip vrf exec' does not use MULTI.

I have not done a deep dive on systemd code, but on ubuntu 18.04 system:

$ sudo ~/bin/bpftool cgroup tree
CgroupPath
ID       AttachType      AttachFlags     Name
/sys/fs/cgroup/unified/system.slice/systemd-udevd.service
    5        ingress
    4        egress
/sys/fs/cgroup/unified/system.slice/systemd-journald.service
    3        ingress
    2        egress
/sys/fs/cgroup/unified/system.slice/systemd-logind.service
    7        ingress
    6        egress

suggests that multi is not common with systemd either at some point in
its path, so 'ip vrf exec' is not alone in not using the flag. There
most likely are many other tools.


> The only thing bpf_link protects is the owner of the link from other
> processes of nuking that link.
> It does _not_ prevent other processes attaching their own cgroup-bpf progs
> either via old interface or via bpf_link.
> 

It does when that older code does not use the MULTI flag. There is a
history that is going to create conflicts and being able to id which
program holds the bpf_link is essential.

And this is really just one use case. There are many other reasons for
wanting to know what process is holding a reference to something.
