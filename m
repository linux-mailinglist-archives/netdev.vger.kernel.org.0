Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 414FE117D68
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 02:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfLJB5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 20:57:51 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39872 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfLJB5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 20:57:50 -0500
Received: by mail-pj1-f66.google.com with SMTP id v93so6699010pjb.6
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 17:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=X0ZaIoyR0nAfoAh+OKYqyipN9nS86d8k81AmmebC5Dc=;
        b=sb87YeZvIf6gK8MxK8th+yPOx87KM8qaPeiKcUwKrOIbUgAb9I5pwdg/HMyYMEDSSx
         UIUHeTq/3n/rBqNZHIglSd1ZJQNnRBMbk3fl2Jm5pL0BAUlr6J6zFW9eqct/2KKka5/+
         rF/C68G6ytDbE9x3eU5OLeWVNKeFrN9mcSo/Vw1Itifv2X0/apYsiYes1MIpbZpxWJ2s
         5LOa/8C2bnf2YXD0bT0S+gAJjfIgQh9JeEWoYt/LoXh45DUXGqJ2cEsH1ffV7gkHSTox
         UD0gocftINsuxU3GYY/IsPowiTQjL9g9wJqSZdBmrIc02mg++MVUodsJqTT1Tc3U1I0V
         43/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=X0ZaIoyR0nAfoAh+OKYqyipN9nS86d8k81AmmebC5Dc=;
        b=r0Lbai6/AxaitvKLpAnbKewA6tbUzvB2VJo6P4u9iFHF9wEmSP6+rzz7OmgLrRKE1u
         m2em5IdWtl6p3BXV0P88We/vHmkreBMP6K+iQ6tPpFyeHPMtoLNSIAMUFsxtGp7Vy+mu
         1JrJ6hf5Pa60J274/H+LIHVX7/KhwUnwFTwNCuTz1xjfRP1bb9Kcp561E6tgxJsdjJJF
         rQDCrelJtDj1ZzsSPnqUWKUYARQAkJbjFlA5ahf/1lBgUuVf9//0aLAEXhAvtul4xmb8
         bYmMBtk9+oMSa4QsLBNmEnUAqV9MttuzqcKuRKGDF7e2WZWpBha+gaHDVPf29lQb2UhL
         eutg==
X-Gm-Message-State: APjAAAVeN8LfKZ8xP/+zrTldHkUQzixOWoNFmkWnA4Lok66sebxiXJZ4
        C9wK1uRAIsaU/BbOXt3pCVMf5Q==
X-Google-Smtp-Source: APXvYqys8ovS57cLyC7J/rp5+/z3FlN6mLZcXsxEwRgLeXUTRjanA6cqMt/mABIv9OcM6hrstcgOXQ==
X-Received: by 2002:a17:90a:28a1:: with SMTP id f30mr2508921pjd.77.1575943069618;
        Mon, 09 Dec 2019 17:57:49 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h11sm775665pgv.38.2019.12.09.17.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 17:57:49 -0800 (PST)
Date:   Mon, 9 Dec 2019 17:57:45 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
Message-ID: <20191209175745.2d96a1f0@cakuba.netronome.com>
In-Reply-To: <20191210011438.4182911-12-andriin@fb.com>
References: <20191210011438.4182911-1-andriin@fb.com>
        <20191210011438.4182911-12-andriin@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Dec 2019 17:14:34 -0800, Andrii Nakryiko wrote:
> struct <object-name> {
> 	/* used by libbpf's skeleton API */
> 	struct bpf_object_skeleton *skeleton;
> 	/* bpf_object for libbpf APIs */
> 	struct bpf_object *obj;
> 	struct {
> 		/* for every defined map in BPF object: */
> 		struct bpf_map *<map-name>;
> 	} maps;
> 	struct {
> 		/* for every program in BPF object: */
> 		struct bpf_program *<program-name>;
> 	} progs;
> 	struct {
> 		/* for every program in BPF object: */
> 		struct bpf_link *<program-name>;
> 	} links;
> 	/* for every present global data section: */
> 	struct <object-name>__<one of bss, data, or rodata> {
> 		/* memory layout of corresponding data section,
> 		 * with every defined variable represented as a struct field
> 		 * with exactly the same type, but without const/volatile
> 		 * modifiers, e.g.:
> 		 */
> 		 int *my_var_1;
> 		 ...
> 	} *<one of bss, data, or rodata>;
> };

I think I understand how this is useful, but perhaps the problem here
is that we're using C for everything, and simple programs for which
loading the ELF is majority of the code would be better of being
written in a dynamic language like python?  Would it perhaps be a
better idea to work on some high-level language bindings than spend
time writing code gens and working around limitations of C?

> This provides great usability improvements:
> - no need to look up maps and programs by name, instead just
>   my_obj->maps.my_map or my_obj->progs.my_prog would give necessary
>   bpf_map/bpf_program pointers, which user can pass to existing libbpf APIs;
> - pre-defined places for bpf_links, which will be automatically populated for
>   program types that libbpf knows how to attach automatically (currently
>   tracepoints, kprobe/kretprobe, raw tracepoint and tracing programs). On
>   tearing down skeleton, all active bpf_links will be destroyed (meaning BPF
>   programs will be detached, if they are attached). For cases in which libbpf
>   doesn't know how to auto-attach BPF program, user can manually create link
>   after loading skeleton and they will be auto-detached on skeleton
>   destruction:
> 
> 	my_obj->links.my_fancy_prog = bpf_program__attach_cgroup_whatever(
> 		my_obj->progs.my_fancy_prog, <whatever extra param);
> 
> - it's extremely easy and convenient to work with global data from userspace
>   now. Both for read-only and read/write variables, it's possible to
>   pre-initialize them before skeleton is loaded:
> 
> 	skel = my_obj__open(raw_embed_data);
> 	my_obj->rodata->my_var = 123;
> 	my_obj__load(skel); /* 123 will be initialization value for my_var */
> 
>   After load, if kernel supports mmap() for BPF arrays, user can still read
>   (and write for .bss and .data) variables values, but at that point it will
>   be directly mmap()-ed to BPF array, backing global variables. This allows to
>   seamlessly exchange data with BPF side. From userspace program's POV, all
>   the pointers and memory contents stay the same, but mapped kernel memory
>   changes to point to created map.
>   If kernel doesn't yet support mmap() for BPF arrays, it's still possible to
>   use those data section structs to pre-initialize .bss, .data, and .rodata,
>   but after load their pointers will be reset to NULL, allowing user code to
>   gracefully handle this condition, if necessary.
> 
> Given a big surface area, skeleton is kept as an experimental non-public
> API for now, until more feedback and real-world experience is collected.

That makes no sense to me. bpftool has the same backward compat
requirements as libbpf. You're just pushing the requirements from
one component to the other. Feedback and real-world use cases have 
to be exercised before code is merged to any project with backward
compatibility requirements :(

Also please run checkpatch on your patches, and fix reverse xmas tree.
This is bpftool, not libbpf. Creating a separate tool for this codegen
stuff is also an option IMHO.
