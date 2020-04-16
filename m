Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D751AB5D5
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 04:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732848AbgDPCXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 22:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731975AbgDPCXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 22:23:15 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB763C061A0C;
        Wed, 15 Apr 2020 19:23:14 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id b10so15233112qtt.9;
        Wed, 15 Apr 2020 19:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=68SisVJeJftxR6PZLb2+8eImWJh6KX3/okXNBoBxO+k=;
        b=I8bDqssMPWc6BEIPMGKJbBoVWLdDCf9FpqcfHytpaE1iAgkz3eAioLFZB9uu8n1asf
         btoQPciG5qblSXZITPp3cXtV0MBko5n8ihRJ4JaYdZxM/+mehC3guXuxU2Qfou4aodzm
         rAoBwt0nimItZiiB0Etf4/UMSY3qLyhC0lPwolUED8jc+pYTb8Y5aBrn8+bxtjaFdryd
         E58nFldpTJB5a7CWpBgJTMaf/det9YnUhuPq/aSIjcm6/2KhU7Vp1bIeSm6wGE8Umq3P
         AMWERfrvVtjqeCAlx6NRIf4d/onqsiNAXPxGNtPopqZXBozn3NIdpFcptTz7muS5roEc
         CX5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=68SisVJeJftxR6PZLb2+8eImWJh6KX3/okXNBoBxO+k=;
        b=RZsH+L/Qm/EzgWOCePRDrYBHTas3CA4AqKutFQrfih58i1PJgGeeSM4TdfPtOXlBxq
         SQmRhRiFzBqe+V6CnFlrZuBi1wg4tt2PHiVl0etuHcEwJdkG2RTKaH+Jz0KCLipUywFL
         Vg7bGFcVSVl6brQN1nplYgGKiZa2iV/9M2Y8ghpSN2ZeSBwAPffnB55H2/4zC88z4rBe
         qNHROiIWoMaemYcmrnfuoF7nbRPrgGWnxplw2cxAu7BK06VJ/m/rzg+RFO1iOvMI5HGV
         iSB5U90DUy/E8Y53gjrwEonIVk9v2ElKOmKNlekwnDoUAg/l4UPx9k/VXKSr9F3FBYvn
         ZUlQ==
X-Gm-Message-State: AGi0PuaWLw573RNOrYcG//+nM8/XuuMAd/2PQLVZBjZb7LafFJ++qmI3
        5SFnDsdlaD0+KGWjfeCOELo=
X-Google-Smtp-Source: APiQypI7QumN3HbKbUgmPU41yDwh5zZ2zqmcnIp7R3QHRaG3ihMmQ0NGuAkwGLb+Xh+MeGv5VDYj2Q==
X-Received: by 2002:aed:3b86:: with SMTP id r6mr18583098qte.178.1587003794087;
        Wed, 15 Apr 2020 19:23:14 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b4ef:508c:423e:3e6a? ([2601:282:803:7700:b4ef:508c:423e:3e6a])
        by smtp.googlemail.com with ESMTPSA id z2sm1734732qkc.28.2020.04.15.19.23.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 19:23:13 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next v2 00/17] bpf: implement bpf based dumping of
 kernel data structures
To:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
References: <20200415192740.4082659-1-yhs@fb.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <40e427e2-5b15-e9aa-e2cb-42dc1b53d047@gmail.com>
Date:   Wed, 15 Apr 2020 20:23:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/20 1:27 PM, Yonghong Song wrote:
> 
> As there are some discussions regarding to the kernel interface/steps to
> create file/anonymous dumpers, I think it will be beneficial for
> discussion with this work in progress.
> 
> Motivation:
>   The current way to dump kernel data structures mostly:
>     1. /proc system
>     2. various specific tools like "ss" which requires kernel support.
>     3. drgn
>   The dropback for the first two is that whenever you want to dump more, you
>   need change the kernel. For example, Martin wants to dump socket local

If kernel support is needed for bpfdump of kernel data structures, you
are not really solving the kernel support problem. i.e., to dump
ipv4_route's you need to modify the relevant proc show function.


>   storage with "ss". Kernel change is needed for it to work ([1]).
>   This is also the direct motivation for this work.
> 
>   drgn ([2]) solves this proble nicely and no kernel change is not needed.
>   But since drgn is not able to verify the validity of a particular pointer value,
>   it might present the wrong results in rare cases.
> 
>   In this patch set, we introduce bpf based dumping. Initial kernel changes are
>   still needed, but a data structure change will not require kernel changes
>   any more. bpf program itself is used to adapt to new data structure
>   changes. This will give certain flexibility with guaranteed correctness.
> 
>   Here, kernel seq_ops is used to facilitate dumping, similar to current
>   /proc and many other lossless kernel dumping facilities.
> 
> User Interfaces:
>   1. A new mount file system, bpfdump at /sys/kernel/bpfdump is introduced.
>      Different from /sys/fs/bpf, this is a single user mount. Mount command
>      can be:
>         mount -t bpfdump bpfdump /sys/kernel/bpfdump
>   2. Kernel bpf dumpable data structures are represented as directories
>      under /sys/kernel/bpfdump, e.g.,
>        /sys/kernel/bpfdump/ipv6_route/
>        /sys/kernel/bpfdump/netlink/

The names of bpfdump fs entries do not match actual data structure names
- e.g., there is no ipv6_route struct. On the one hand that is a good
thing since structure names can change, but that also means a mapping is
needed between the dumper filesystem entries and what you get for context.

Further, what is the expectation in terms of stable API for these fs
entries? Entries in the context can change. Data structure names can
change. Entries in the structs can change. All of that breaks the idea
of stable programs that are compiled once and run for all future
releases. When structs change, those programs will break - and
structures will change.

What does bpfdumper provide that you can not do with a tracepoint on a
relevant function and then putting a program on the tracepoint? ie., why
not just put a tracepoint in the relevant dump functions.
