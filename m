Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10D927F281
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730220AbgI3TUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728031AbgI3TUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:20:10 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5F8C061755;
        Wed, 30 Sep 2020 12:20:08 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id c3so1607473plz.5;
        Wed, 30 Sep 2020 12:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K1KuplXIPM3f9eN8VJrCNwz9WtrGgwBZMt/BFvxKJSI=;
        b=VSs8h9gaBPckrXXgdNNqmG7PTreUHnaHzva+d906fhZMJmmelpw1T+gK3fS69brudR
         /pqUHjCI9clx4e8JNwavN29vP18DUF1Bts+StHuthJKkWGkou6DnZbeP/J2L56vAPQOR
         0JjWEhJ4ZPBEgtpL86oZhMYYQU46t5XmpsRJiu8vIOwx77D+GDY6ueU7O0+uyLEZ0I8y
         U7SePj7Z/CN4c3c7kvRRff+ZLk4mQTRE/W9eDJJXQAztUqDAy4KDVlcZFEW/rqjncEA/
         gu8Fg5GMx7uTfIzrjFkLxcRgBtNGr/uVFm8jwYhRyNmTxyLdGB46Zlf+Hu9a/S38ftNY
         czCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K1KuplXIPM3f9eN8VJrCNwz9WtrGgwBZMt/BFvxKJSI=;
        b=kOSorQ0LcT6ZMVkxsnez9zr0yNdrJIxPZrMVPaopi1pkItMNN/EqJ7UtEzVTzESlmo
         pvB9XRlclklIxQDqyxyHiLYe17OxYvgQ/qJGRyzRvcoDLTw6kFEXzsI5ZDoBa2IDgL/O
         yO1ugjmJZzIQMGC648pOf8CeTAFvJZWxpy9kDqqbFGUHC/qS3ZPSEGuiG5XPBXwsFkG2
         EOunVgV/yEYwSt8DffaruxYg1Hjavyb0rED7n1V2duOueyClx8qxizTjdnwT7AOoyGm5
         lVyCewkcSrUSYXitC6Y0iLI8NVLhcD3Axm2tQqOQA11E/WD1ge/65UseFJTo1bkMDSxg
         aJCw==
X-Gm-Message-State: AOAM532p4wCuo1B2Z9//hXg7WsMMzIcqm/31rAyVsc0EpFXLlg5ZBAGA
        FgGThxTSWNiCdSFSMG6d+7lohznbI+Q=
X-Google-Smtp-Source: ABdhPJwiEBwM5Q/F5KMpdrHnkSeUHCs5kfOIqxTVOrjghKQza8xn7uwJVTzCeIpkpQY+8fuqa0+mmw==
X-Received: by 2002:a17:90b:3004:: with SMTP id hg4mr3771883pjb.7.1601493607620;
        Wed, 30 Sep 2020 12:20:07 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:2a2])
        by smtp.gmail.com with ESMTPSA id bj2sm3119356pjb.20.2020.09.30.12.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 12:20:06 -0700 (PDT)
Date:   Wed, 30 Sep 2020 12:20:04 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 6/6] bpf, selftests: add redirect_neigh
 selftest
Message-ID: <20200930192004.acumndm6xfxwplzl@ast-mbp.dhcp.thefacebook.com>
References: <cover.1601477936.git.daniel@iogearbox.net>
 <0fc7d9c5f9a6cc1c65b0d3be83b44b1ec9889f43.1601477936.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fc7d9c5f9a6cc1c65b0d3be83b44b1ec9889f43.1601477936.git.daniel@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 05:18:20PM +0200, Daniel Borkmann wrote:
> +
> +#ifndef barrier_data
> +# define barrier_data(ptr)	asm volatile("": :"r"(ptr) :"memory")
> +#endif
> +
> +#ifndef ctx_ptr
> +# define ctx_ptr(field)		(void *)(long)(field)
> +#endif

> +static __always_inline bool is_remote_ep_v4(struct __sk_buff *skb,
> +					    __be32 addr)
> +{
> +	void *data_end = ctx_ptr(skb->data_end);
> +	void *data = ctx_ptr(skb->data);

please consider adding:
        __bpf_md_ptr(void *, data);
        __bpf_md_ptr(void *, data_end);
to struct __sk_buff in a followup to avoid this casting headache.

> +SEC("dst_ingress") int tc_dst(struct __sk_buff *skb)
> +{
> +	int idx = dst_to_src_tmp;
> +	__u8 zero[ETH_ALEN * 2];
> +	bool redirect = false;
> +
> +	switch (skb->protocol) {
> +	case __bpf_constant_htons(ETH_P_IP):
> +		redirect = is_remote_ep_v4(skb, __bpf_constant_htonl(ip4_src));
> +		break;
> +	case __bpf_constant_htons(ETH_P_IPV6):
> +		redirect = is_remote_ep_v6(skb, (struct in6_addr)ip6_src);
> +		break;
> +	}
> +
> +	if (!redirect)
> +		return TC_ACT_OK;
> +
> +	barrier_data(&idx);
> +	idx = bpf_ntohl(idx);

I don't follow. Why force that constant into a register and force
actual swap instruction?

> +
> +	__builtin_memset(&zero, 0, sizeof(zero));
> +	if (bpf_skb_store_bytes(skb, 0, &zero, sizeof(zero), 0) < 0)
> +		return TC_ACT_SHOT;
> +
> +	return bpf_redirect_neigh(idx, 0);
> +}

> +xxd -p < test_tc_neigh.o   | sed "s/eeddddee/$veth_src/g" | xxd -r -p > test_tc_neigh.x.o
> +xxd -p < test_tc_neigh.x.o | sed "s/eeffffee/$veth_dst/g" | xxd -r -p > test_tc_neigh.y.o

So the inline asm is because of the above?
So after compiling you're hacking elf binary for this pattern ?
Ouch. Please use global data or something. This is fragile.
This type of hacks should be discouraged and having selftests do them
goes as counter example.
