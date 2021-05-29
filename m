Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A09394D11
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 18:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhE2QAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 12:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhE2QAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 12:00:30 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE3FC061574
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 08:58:53 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so6556649otl.3
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 08:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6YwW01TPCl7Wpklpj/ZN0fUGY6j76x98VhBHECAx2Uc=;
        b=F8E8g6RL2skttk3ZauxlDoahquP3WZ6fO/RtEjgpZen4gwtJ98XyCWs3wKJFnzd2Jn
         3gn/WUD1Y+RNwV3eRyYJYO7jMHKHlL7hrdVx+mGiFaPzFBEv56vsxh8JDc5eWCdnxBYH
         D4DzTkEkbtQZF2w3Rjz+Ub978e0EncA1L5uav4s7HsUT1Rqadpf4nCAqHa6yB1heROcJ
         zSR2hfVeuJtsHsqaXsvKdDyCXWevqqalwhAYPahnIbmhawwCcSNyM5QcOJICUi1wQBGI
         li7Vb7H7jcg9r2O9R1GiSZi+xELozkgIj97Ve10d+/EB1JIoDbmTqvTKS/oLyIBlX+cd
         mqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6YwW01TPCl7Wpklpj/ZN0fUGY6j76x98VhBHECAx2Uc=;
        b=k0HqRPRYawJ9wFE3O1J/cmyM0uJBqG7X4+Z5MMJOhd00dZmYREEh8md3SjpzNLpioC
         EhEsM/+oyUshPDiV6aPlfxdwqh2McnOfFTDds891GuUcRXVqirbD0+xlLgnNpkzdzaza
         W3F/1m1KVuDJ0M7yPvHYyYif9tHQKw7MwMuyk3JnZY2sx8jQQqVUXUTMUZ229jEITc9g
         aAZZioOaEULzWIbSVW7AOodjiILCuK35jrhd16nPogNVRBmWCMgcfFElzZdSgImMZm7t
         5R37iNoX3LFEYgGS46m7h0xc9/FW02qHYXIbVJ4UqsTCSc+H44z+bQxo5gug1GhSVEVi
         VQ2Q==
X-Gm-Message-State: AOAM53040cLU0PEktzZhBcvEkoYbpV0YPpGKc+7H+KZr7aRcOqOkJihZ
        89efJLP6LAMtrFmDh8PAG44=
X-Google-Smtp-Source: ABdhPJyL3f3DI2/dmI6lBi2bCiThRCTTS/j8dAilffKezhYJLkmejBcaMdXzMh0YUl462YUfDgSF+g==
X-Received: by 2002:a05:6830:408f:: with SMTP id x15mr1299414ott.317.1622303932487;
        Sat, 29 May 2021 08:58:52 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id x65sm1870232otb.59.2021.05.29.08.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 May 2021 08:58:52 -0700 (PDT)
Subject: Re: [PATCH net-next v4 0/5] Support for the IOAM Pre-allocated Trace
 with IPv6
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, tom@herbertland.com
References: <20210527151652.16074-1-justin.iurman@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <85a22702-da46-30c2-46c9-66d293d510ff@gmail.com>
Date:   Sat, 29 May 2021 09:58:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210527151652.16074-1-justin.iurman@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/21 9:16 AM, Justin Iurman wrote:
> v4:
>  - Address warnings from checkpatch (ignore errors related to unnamed bitfields
>    in the first patch)
>  - Use of hweight32 (thanks Jakub)
>  - Remove inline keyword from static functions in C files and let the compiler
>    decide what to do (thanks Jakub)
> 
> v3:
>  - Fix warning "unused label 'out_unregister_genl'" by adding conditional macro
>  - Fix lwtunnel output redirect bug: dst cache useless in this case, use
>    orig_output instead
> 
> v2:
>  - Fix warning with static for __ioam6_fill_trace_data
>  - Fix sparse warning with __force when casting __be64 to __be32
>  - Fix unchecked dereference when removing IOAM namespaces or schemas
>  - exthdrs.c: Don't drop by default (now: ignore) to match the act bits "00"
>  - Add control plane support for the inline insertion (lwtunnel)
>  - Provide uapi structures
>  - Use __net_timestamp if skb->tstamp is empty
>  - Add note about the temporary IANA allocation
>  - Remove support for "removable" TLVs
>  - Remove support for virtual/anonymous tunnel decapsulation
> 
> In-situ Operations, Administration, and Maintenance (IOAM) records
> operational and telemetry information in a packet while it traverses
> a path between two points in an IOAM domain. It is defined in
> draft-ietf-ippm-ioam-data [1]. IOAM data fields can be encapsulated
> into a variety of protocols. The IPv6 encapsulation is defined in
> draft-ietf-ippm-ioam-ipv6-options [2], via extension headers. IOAM
> can be used to complement OAM mechanisms based on e.g. ICMP or other
> types of probe packets.
> 
> This patchset implements support for the Pre-allocated Trace, carried
> by a Hop-by-Hop. Therefore, a new IPv6 Hop-by-Hop TLV option is
> introduced, see IANA [3]. The three other IOAM options are not included
> in this patchset (Incremental Trace, Proof-of-Transit and Edge-to-Edge).
> The main idea behind the IOAM Pre-allocated Trace is that a node
> pre-allocates some room in packets for IOAM data. Then, each IOAM node
> on the path will insert its data. There exist several interesting use-
> cases, e.g. Fast failure detection/isolation or Smart service selection.
> Another killer use-case is what we have called Cross-Layer Telemetry,
> see the demo video on its repository [4], that aims to make the entire
> stack (L2/L3 -> L7) visible for distributed tracing tools (e.g. Jaeger),
> instead of the current L5 -> L7 limited view. So, basically, this is a
> nice feature for the Linux Kernel.
> 
> This patchset also provides support for the control plane part, but only for the
> inline insertion (host-to-host use case), through lightweight tunnels. Indeed,
> for in-transit traffic, the solution is to have an IPv6-in-IPv6 encapsulation,
> which brings some difficulties and still requires a little bit of work and
> discussion (ie anonymous tunnel decapsulation and multi egress resolution).
> 
> - Patch 1: IPv6 IOAM headers definition
> - Patch 2: Data plane support for Pre-allocated Trace
> - Patch 3: IOAM Generic Netlink API
> - Patch 4: Support for IOAM injection with lwtunnels
> - Patch 5: Documentation for new IOAM sysctls
> 
>   [1] https://tools.ietf.org/html/draft-ietf-ippm-ioam-data
>   [2] https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options
>   [3] https://www.iana.org/assignments/ipv6-parameters/ipv6-parameters.xhtml#ipv6-parameters-2
>   [4] https://github.com/iurmanj/cross-layer-telemetry
> 

These are draft documents from February 2021. Good to have RFC patches
for others to try the proposed feature, but is really early to be
committing code to Linux. I think we should wait and see how that
proposal develops.

