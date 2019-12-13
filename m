Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFDBA11EED7
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfLMXuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 18:50:04 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40233 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMXuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 18:50:03 -0500
Received: by mail-pf1-f196.google.com with SMTP id q8so2289823pfh.7;
        Fri, 13 Dec 2019 15:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J87jfdzcYKYTCbIj29bsALQjPAoMzqA2blYQq9TuL+c=;
        b=B9MzsY1JhzPO/HE6kzgxO5DhQRPdxeU73BXoi99E5K4pGSA1Ea2wtfilwCGtcSS1Pz
         WPYsl7TyyRmEtVBbkLZxhcmE3ELC+0+a7phM9GlU7nQH+y4IwQVrKu1upJYIk/0SJFlK
         9bAt9TsFw6zkI6h7vJE+5kbTgkWI9mGA4MkRc8eqhiuS5upBV4bZ8HEjXCDDW0KlOQAV
         gJNZUc7vB43aT9eLpGlpi+RZyeAS3SeDehry82H484JCqBKEKuWPZJXhT5tl+hf5ud9h
         Zu5rSeAd4DyI6tUK3UnFZIrTQNlxeNILusdoNahlFQRc8Lm6PKcWE0wvUucqHu+Gy+we
         ZZKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J87jfdzcYKYTCbIj29bsALQjPAoMzqA2blYQq9TuL+c=;
        b=GvJ54dQtotoCHpe8ZRpUCwJSVvX5FawyrLjibHrMRKzMksFxe7uJK/gDNM6LSTgtqs
         xYwGIV2s2cBAb6J26XT2ae+zfge7jWx8qELmZJH6M5sWKiBxyqr/YuBDbnlbLD0ywI67
         rMwr86138FE8sgd3wAitDtrxgOqhubJZTDhHw/w7QuocnwWo7es+GNbpurs4fxKQtqTH
         QvB3xEi2bQWaPPvNplWupLj8udN8KmTNFwaSNB4SsKb67W+b47Kc1U5bFC58vj1lQypD
         1em+IzjfeGL+lQ9sg6so08/tDtBoVpsaLWLJJtlaMNQxrG4Ak6LbQOvYfwSixnGmVoII
         d9Lw==
X-Gm-Message-State: APjAAAVX14kMumVYQPPExZRMDXHv4HoJ5g7FkwgMiPAlNGLWQVQFkheT
        Ds70yzipsSdb7OlZU/5xr2w=
X-Google-Smtp-Source: APXvYqzkjvSFBRHJBdTW3kikjsDrENn7/fNDOjAUbqSb6MruK/Xw1OrTJUYg85geSUbTixmD6dmqSg==
X-Received: by 2002:a63:1101:: with SMTP id g1mr2297480pgl.435.1576281002962;
        Fri, 13 Dec 2019 15:50:02 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::de66])
        by smtp.gmail.com with ESMTPSA id k60sm11340968pjh.22.2019.12.13.15.50.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 15:50:02 -0800 (PST)
Date:   Fri, 13 Dec 2019 15:50:00 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 07/17] libbpf: expose BTF-to-C type
 declaration emitting API
Message-ID: <20191213234959.7qrvp5n3habe34pp@ast-mbp.dhcp.thefacebook.com>
References: <20191213223214.2791885-1-andriin@fb.com>
 <20191213223214.2791885-8-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213223214.2791885-8-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 02:32:04PM -0800, Andrii Nakryiko wrote:
> Expose API that allows to emit type declaration and field/variable definition
> (if optional field name is specified) in valid C syntax for any provided BTF
> type. This is going to be used by bpftool when emitting data section layout as
> a struct. As part of making this API useful in a stand-alone fashion, move
> initialization of some of the internal btf_dump state to earlier phase.
> 
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/btf.h      | 22 ++++++++++++++
>  tools/lib/bpf/btf_dump.c | 62 +++++++++++++++++++++++-----------------
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 59 insertions(+), 26 deletions(-)
> 
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index a114c8ef4f08..1f9625946ead 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -126,6 +126,28 @@ LIBBPF_API void btf_dump__free(struct btf_dump *d);
>  
>  LIBBPF_API int btf_dump__dump_type(struct btf_dump *d, __u32 id);
>  
> +struct btf_dump_emit_type_decl_opts {
> +	/* size of this struct, for forward/backward compatiblity */
> +	size_t sz;
> +	/* optional field name for type declaration, e.g.:
> +	 * - struct my_struct <FNAME>
> +	 * - void (*<FNAME>)(int)
> +	 * - char (*<FNAME>)[123]
> +	 */
> +	const char *field_name;
> +	/* extra indentation level (in number of tabs) to emit for multi-line
> +	 * type declarations (e.g., anonymous struct); applies for lines
> +	 * starting from the second one (first line is assumed to have
> +	 * necessary indentation already
> +	 */
> +	int indent_level;
> +};
> +#define btf_dump_emit_type_decl_opts__last_field attach_prog_fd

OPTS_VALID() is missing in btf_dump__emit_type_decl() ?
Otherwise it would have caught above typo.


>  	d->ident_names = hashmap__new(str_hash_fn, str_equal_fn, NULL);
>  	if (IS_ERR(d->ident_names)) {
>  		err = PTR_ERR(d->ident_names);
>  		d->ident_names = NULL;
> -		btf_dump__free(d);
> -		return ERR_PTR(err);
> +		goto err;
> +	}
> +	d->type_states = calloc(1 + btf__get_nr_types(d->btf),
> +				sizeof(d->type_states[0]));
> +	if (!d->type_states) {
> +		err = -ENOMEM;
> +		goto err;
> +	}
> +	d->cached_names = calloc(1 + btf__get_nr_types(d->btf),
> +				 sizeof(d->cached_names[0]));
> +	if (!d->cached_names) {
> +		err = -ENOMEM;
> +		goto err;
>  	}
>  
> +	/* VOID is special */
> +	d->type_states[0].order_state = ORDERED;
> +	d->type_states[0].emit_state = EMITTED;

Not following the logic with 1 + btf__get_nr_types(d->btf) and
above init...
type_states[0] is void. true.
But btf__get_nr_types() includes that type_id=0 == void.
So what this 1+ is for?
I know it's just a move of old code. I just noticed.
Would be great to add a comment.

