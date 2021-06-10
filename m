Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD70C3A2D38
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 15:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhFJNj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 09:39:58 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:44865 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhFJNj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 09:39:57 -0400
Received: by mail-wr1-f52.google.com with SMTP id f2so2347951wri.11
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 06:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0sj7tSYkdDY6cg0JGPEaS057smMW6C6/SG3QI1zQncQ=;
        b=I2cXkmM0iGW8TFdbsdBJvf49KrZW/ecFaWyjKG3wJIFVFqGfX29/LzGf1rAGfXXr9C
         UoEgUAWaEMwelWi1bJslwkHRdnYQZT9EnOMRQopWHTlTDtQUspw/TULExB3uVjJjz1kX
         4qMBbmaqpbXzUAnAR0FOr19eGcOLK7L6q2K3qZBwd9hopMVJKhoAKwG2hOuTnS8Mxxys
         ed5TOyLEW7f5g1aWdw4vYEm7zMoJ9pMfyT0u3qeX+mQGdabfi6G7XlRFxrqNlk//Y0un
         yPMEzV62srxY0OBalW/+u75Abx6FpsIPOzOZek5MIYHBli04jrbrqZIoe3fnAjxmQjhL
         yNPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0sj7tSYkdDY6cg0JGPEaS057smMW6C6/SG3QI1zQncQ=;
        b=EpjDXsXJYz9zYS0uOLAhUtCFZeyZQfLLdBZ2Th0nY5SuNjD2qUjyOIQIJjyF+iUkSN
         bOxmamoXe7HZL8cRACy96/KDnM3terdyfGug0G3Df3yTEPtrM3qnS5bmirg0psSSJNhn
         D9hmVfnfg3qWs+KTP6fvJihu3yKmkJpWismBEslsaeY0JCHN4VLRAFgeB3YdFKHmgKBI
         m/lt7zKnMtjzbLqf3Dd5pQGz2+AdP8/bbChdSSwZaGpIslu/uoO61ycMTgHogxEZaZpJ
         nAcDiR6uTel3G4QpxRO7V7dFxQTQpsd71vHE4mQiuxEJ3wZj99nm+QpcvQZIaXpKffyT
         y7hA==
X-Gm-Message-State: AOAM533ES4LNcltFxNBiE4o4+0qZK/xBeVJSbo/kDNoD8iBmbOXx4Z/e
        mCnJIjohYUqZBxEpkhfX9Tu6Mw==
X-Google-Smtp-Source: ABdhPJw2lJ/LhEbUnzzq7jGGuxZ7BJLNMX7N0aLXBpzRnYkJcuMxtv1bvHdKI3tDJhcgwiRI3kWTOA==
X-Received: by 2002:a5d:6e92:: with SMTP id k18mr5592603wrz.94.1623332220947;
        Thu, 10 Jun 2021 06:37:00 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id f184sm2078294wmf.38.2021.06.10.06.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 06:37:00 -0700 (PDT)
Date:   Thu, 10 Jun 2021 17:36:55 +0400
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, davem@davemloft.net,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, rdna@fb.com
Subject: Re: [PATCH bpf-next v1 00/10] bpfilter
Message-ID: <20210610133655.d25say2ialzhtdhq@amnesia>
References: <20210603101425.560384-1-me@ubique.spb.ru>
 <4dd3feeb-8b4a-0bdb-683e-c5c5643b1195@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dd3feeb-8b4a-0bdb-683e-c5c5643b1195@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 05:50:13PM -0700, Yonghong Song wrote:
> 
> 
> On 6/3/21 3:14 AM, Dmitrii Banshchikov wrote:
> > The patchset is based on the patches from David S. Miller [1] and
> > Daniel Borkmann [2].
> > 
> > The main goal of the patchset is to prepare bpfilter for
> > iptables' configuration blob parsing and code generation.
> > 
> > The patchset introduces data structures and code for matches,
> > targets, rules and tables.
> > 
> > The current version misses handling of counters. Postpone its
> > implementation until the code generation phase as it's not clear
> > yet how to better handle them.
> > 
> > Beside that there is no support of net namespaces at all.
> > 
> > In the next iteration basic code generation shall be introduced.
> > 
> > The rough plan for the code generation.
> > 
> > It seems reasonable to assume that the first rules should cover
> > most of the packet flow.  This is why they are critical from the
> > performance point of view.  At the same time number of user
> > defined rules might be pretty large. Also there is a limit on
> > size and complexity of a BPF program introduced by the verifier.
> > 
> > There are two approaches how to handle iptables' rules in
> > generated BPF programs.
> > 
> > The first approach is to generate a BPF program that is an
> > equivalent to a set of rules on a rule by rule basis. This
> > approach should give the best performance. The drawback is the
> > limitation from the verifier on size and complexity of BPF
> > program.
> > 
> > The second approach is to use an internal representation of rules
> > stored in a BPF map and use bpf_for_each_map_elem() helper to
> > iterate over them. In this case the helper's callback is a BPF
> > function that is able to process any valid rule.
> > 
> > Combination of the two approaches should give most of the
> > benefits - a heuristic should help to select a small subset of
> > the rules for code generation on a rule by rule basis. All other
> > rules are cold and it should be possible to store them in an
> > internal form in a BPF map. The rules will be handled by
> > bpf_for_each_map_elem().  This should remove the limit on the
> > number of supported rules.
> 
> Agree. A bpf program inlines some hot rule handling and put
> the rest in for_each_map_elem() sounds reasonable to me.
> 
> > 
> > During development it was useful to use statically linked
> > sanitizers in bpfilter usermode helper. Also it is possible to
> > use fuzzers but it's not clear if it is worth adding them to the
> > test infrastructure - because there are no other fuzzers under
> > tools/testing/selftests currently.
> > 
> > Patch 1 adds definitions of the used types.
> > Patch 2 adds logging to bpfilter.
> > Patch 3 adds bpfilter header to tools
> > Patch 4 adds an associative map.
> > Patches 5/6/7/8 add code for matches, targets, rules and table.
> > Patch 9 handles hooked setsockopt(2) calls.
> > Patch 10 uses prepared code in main().
> > 
> > Here is an example:
> > % dmesg  | tail -n 2
> > [   23.636102] bpfilter: Loaded bpfilter_umh pid 181
> > [   23.658529] bpfilter: started
> > % /usr/sbin/iptables-legacy -L -n
> 
> So this /usr/sbin/iptables-legacy is your iptables variant to
> translate iptable command lines to BPFILTER_IPT_SO_*,
> right? It could be good to provide a pointer to the source
> or binary so people can give a try.
> 
> I am not an expert in iptables. Reading codes, I kind of
> can grasp the high-level ideas of the patch, but probably
> Alexei or Daniel can review some details whether the
> design is sufficient to be an iptable replacement.
> 

The goal of a complete iptables replacement is too ambigious for
the moment - because existings hooks and helpers don't cover all
required functionality.

A more achievable goal is to have something simple that could
replace a significant part of use cases for filter table.

Having something simple that would work as a stateless firewall
and provide some performance benefits is a good start. For more
complex scenarios there is a safe fallback to the existing
implementation.


> 
> > Chain INPUT (policy ACCEPT)
> > target     prot opt source               destination
> > 
> > Chain FORWARD (policy ACCEPT)
> > target     prot opt source               destination
> > 
> [...]

-- 

Dmitrii Banshchikov
