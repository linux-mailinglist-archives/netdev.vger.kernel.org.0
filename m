Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4DD313B5FB
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 00:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgANXjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 18:39:07 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39827 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728759AbgANXjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 18:39:06 -0500
Received: by mail-pf1-f194.google.com with SMTP id q10so7392112pfs.6
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 15:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xR8mTgaV48+WIV21YK5782FwnOWtuv1Uj/+txm68v10=;
        b=LO3XlhtqpfifunEEK1bsqONa/kV3S9upjFmqWdnBSCoNOvO22EvEIWiABB5P9NIxAg
         +RvMWdXImPxsyvq5bod6HC9kK7FvypVtyMUfnAHuhvCPuhoVUi/nydBXRAQeGgstq2L7
         zNdXAKq53OstQcPqv5nL1hBEWPL5HIH9CWLwlXRxTwbdrQX6s35yltmJvNt916Tx4eyd
         Pb2KCucbPFG58smI+iUUF40MW/WHRUiFMypTAF8wPPux6QRm6l5YKp3qvHesDF/bZMJi
         81aBSJMomGsOyKAH2uqblCmcrTKJY6/nyxUmm7GywwPEcZYIJ4AM4w1Y+zo60sS1XqWC
         rspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xR8mTgaV48+WIV21YK5782FwnOWtuv1Uj/+txm68v10=;
        b=BpEU8iNlMBqmgLjN+rvgoCS36/zS5yOA+iTGC1XHZ9ygCXDqxZTN7nwO5LOiJhsm6I
         f/jv9M25r7NmFZoenS9/rRE3SlV8suNTOC/j4gF1Q+jd47THnIGQvR0bEeqDfRg4Sjgw
         zpDrcnaCIXJZ5vspiNbLbDa1RB3JCsWZAYM7grz7yPa7qHWe3rvJRFp/o0qceNyavfd5
         FCv/IP6Gp6X5gLo3TINLyR/EHRt1cVdjq6F+4p4ltG9XOFAU/0xD9exPhsmtIVKE1hI3
         mMBl6fMkBn+Pgp/BzYw6SfcVA1rKpzYdwa9mNP6UMG7W/YBd5nWi3UHD1GMnxg8r56nd
         KZbg==
X-Gm-Message-State: APjAAAUa+rossRu6OCRLX91DExN9AvmjewbkqDx/wiqSI5mQRwgyoqN/
        WWAQ3+CcgcWyd4Uuo2fx4cX6pw==
X-Google-Smtp-Source: APXvYqw8PrZi2ffB9jcJh0wJXKJeV47ny4I4aSYnR8IGRwXNLnsK4vC2yZi1b1C4yvAMvMcyJpdaSA==
X-Received: by 2002:a63:551a:: with SMTP id j26mr29472006pgb.370.1579045145754;
        Tue, 14 Jan 2020 15:39:05 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id c14sm18191624pjr.24.2020.01.14.15.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 15:39:05 -0800 (PST)
Date:   Tue, 14 Jan 2020 15:39:04 -0800
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 3/6] bpf: Introduce function-by-function
 verification
Message-ID: <20200114233904.GA2308546@mini-arch>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-4-ast@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108072538.3359838-4-ast@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/07, Alexei Starovoitov wrote:
> New llvm and old llvm with libbpf help produce BTF that distinguish global and
> static functions. Unlike arguments of static function the arguments of global
> functions cannot be removed or optimized away by llvm. The compiler has to use
> exactly the arguments specified in a function prototype. The argument type
> information allows the verifier validate each global function independently.
> For now only supported argument types are pointer to context and scalars. In
> the future pointers to structures, sizes, pointer to packet data can be
> supported as well. Consider the following example:
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -2621,8 +2621,8 @@ static s32 btf_func_check_meta(struct btf_verifier_env *env,
>  		return -EINVAL;
>  	}
>  
> -	if (btf_type_vlen(t)) {
> -		btf_verifier_log_type(env, t, "vlen != 0");
> +	if (btf_type_vlen(t) > BTF_FUNC_EXTERN) {
> +		btf_verifier_log_type(env, t, "invalid func linkage");
>  		return -EINVAL;
Sorry for bringing it up after the review:

This effectively teaches kernel about BTF_KIND_FUNC scope argument,
right? Which means, if I take clang from the tip
(https://github.com/llvm/llvm-project/commit/fbb64aa69835c8e3e9efe0afc8a73058b5a0fb3c#diff-f191c05d1eb0a6ca0e89d7e7938d73d4)
and take 5.4 kernel, it will reject BTF because it now has a
BTF_KIND_FUNC with global scope (any 'main' function is global and has
non-zero vlen).

What's the general guidance on the situation where clang starts
spitting out some BTF and released kernels reject it? Is there some list of
flags I can pass to clang to not emit some of the BTF features?
Or am I missing something?
