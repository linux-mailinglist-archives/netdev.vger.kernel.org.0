Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441FC36CB42
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 20:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236651AbhD0SqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 14:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbhD0SqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 14:46:21 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77873C061574;
        Tue, 27 Apr 2021 11:45:38 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id s16so55352377iog.9;
        Tue, 27 Apr 2021 11:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=HzyOy8LijzMkJ5J9Z6292MrXQk0yVZu20NjKaizDw80=;
        b=Py6tjmldu4Scr2JRp9CbKzduQmYzqdfdWDrzEczBD1VRK6YMWa1nf/6wO3wyXWT7mv
         v84BzlSAAazgoT8O0tJb1bJaGsbPjSipcwWvvRYU2OCbQBTntEH8DBYe37EslGaCLHFs
         sv/LdU0tVcAiXPyERN+wYiKELM/nznWXfm7Ht/jFJ4Ci2pDiGJC80h7uEjuGvLwH97N9
         x6Ze7lAQsnj7PqHWmsXhcWf0BRLm1okrAXu1CSgGnCjfAxtNcwYzduf7kfPaQk63D82z
         blcMWuPaE4or4FVKkYOjLoStKI3gJn6jLYLAVXU3hfTP9eDDoT6QYSXE1WKxtYd5eLqf
         po/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=HzyOy8LijzMkJ5J9Z6292MrXQk0yVZu20NjKaizDw80=;
        b=EF6hlaZ8gdbxmigPZ2p9oTU93GMwpqvo7kCmNyMMbmuq572Qc/1c5IGCc0ky1cPcXf
         k8BDugVqqeWq2JZpgLU+6RtfQWshf3uhaobP9MIRseeXwH0/37abGQJSj9LoxIL8rWsr
         b6RCAFOQven26LnfjSlL+ESs/hjYlkp6SZc+4zpaOEbJ3xRikduUhw2yCfcoX/xD7oDC
         OObTbNmZAx1kF7mT30SGtmPOsLiv8dUgzdNHTcRvfHs9WbivYpWWTd2ZafrGRHl48Wa1
         h58Ems9xYgbnvy4SWl77b/lUIVXEmIBviE/UxZSTMs0XrXz21nElGy9jojPhzHyziLVP
         R5Lw==
X-Gm-Message-State: AOAM531XsFup4U9FBlmLOFUvSjUlIg83cBHBBa7SSmnsieatBUXiwmif
        d7U/NRFXwfhNAPOHuoSPVAw=
X-Google-Smtp-Source: ABdhPJzLVDpFZ10Z6H2IxQWgaj+iEDyqMBr1vI7n8cKbW2SJ42ZVfxCovIhhiW54rPe+/PKzyNXc6Q==
X-Received: by 2002:a02:6d66:: with SMTP id e38mr23035717jaf.69.1619549137855;
        Tue, 27 Apr 2021 11:45:37 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id b6sm1694896ilh.82.2021.04.27.11.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 11:45:37 -0700 (PDT)
Date:   Tue, 27 Apr 2021 11:45:29 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Message-ID: <60885bc933b91_1231920826@john-XPS-13-9370.notmuch>
In-Reply-To: <20210423002646.35043-2-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-2-alexei.starovoitov@gmail.com>
Subject: RE: [PATCH v2 bpf-next 01/16] bpf: Introduce bpf_sys_bpf() helper and
 program type.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Add placeholders for bpf_sys_bpf() helper and new program type.
> 
> v1->v2:
> - check that expected_attach_type is zero
> - allow more helper functions to be used in this program type, since they will
>   only execute from user context via bpf_prog_test_run.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>

> +int bpf_prog_test_run_syscall(struct bpf_prog *prog,
> +			      const union bpf_attr *kattr,
> +			      union bpf_attr __user *uattr)
> +{
> +	void __user *ctx_in = u64_to_user_ptr(kattr->test.ctx_in);
> +	__u32 ctx_size_in = kattr->test.ctx_size_in;
> +	void *ctx = NULL;
> +	u32 retval;
> +	int err = 0;
> +
> +	/* doesn't support data_in/out, ctx_out, duration, or repeat or flags */
> +	if (kattr->test.data_in || kattr->test.data_out ||
> +	    kattr->test.ctx_out || kattr->test.duration ||
> +	    kattr->test.repeat || kattr->test.flags)
> +		return -EINVAL;
> +
> +	if (ctx_size_in < prog->aux->max_ctx_offset ||
> +	    ctx_size_in > U16_MAX)
> +		return -EINVAL;
> +
> +	if (ctx_size_in) {
> +		ctx = kzalloc(ctx_size_in, GFP_USER);
> +		if (!ctx)
> +			return -ENOMEM;
> +		if (copy_from_user(ctx, ctx_in, ctx_size_in)) {
> +			err = -EFAULT;
> +			goto out;
> +		}
> +	}
> +	retval = bpf_prog_run_pin_on_cpu(prog, ctx);
> +
> +	if (copy_to_user(&uattr->test.retval, &retval, sizeof(u32)))
> +		err = -EFAULT;
> +	if (ctx_size_in)
> +		if (copy_to_user(ctx_in, ctx, ctx_size_in)) {
> +			err = -EFAULT;
> +			goto out;
> +		}

stupid nit, the last goto there is not needed.

> +out:
> +	kfree(ctx);
> +	return err;
> +}
