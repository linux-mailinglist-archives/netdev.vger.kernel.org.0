Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF34275B38
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 01:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfGYX0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 19:26:37 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38291 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfGYX0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 19:26:36 -0400
Received: by mail-pf1-f193.google.com with SMTP id y15so23508602pfn.5;
        Thu, 25 Jul 2019 16:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ifdr0wujq0BFaqVnl9iBUQtaNfiD39a2UoD51NeCSco=;
        b=MHjcIKgwnZGHcA5kp2vSn5MccAM8jv0wyZZP+eWQNNDzzf3NUKzfoL/JhHK7Vgvwzc
         6mXVeXeuVDXOULvktYzAb9Lj8ghZkm2Z3AIeBzw+74812LJfHYoDR8xGkg4n2YEDZo0K
         nhTLYaYVCUBe8luLRbNGf6kOYX70bJ8gGx5qLHL7LJjA3CP0Ypgq0BY0iUBbgl2gYC2N
         w6eyHfwbAf3rOBHMajP1Kb5NDwudDcRjyawyFaZKUu3OiMNNLDiFfyuLm9SZbOmwc50k
         V5VOpwI7rNXv1kfSc0y5HcPdJNJ4ZasdA9wbp0JdmdCpSGqrkt0nbuiuWOIHXxvv0MwT
         QEBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ifdr0wujq0BFaqVnl9iBUQtaNfiD39a2UoD51NeCSco=;
        b=N0mDv5eS5nsYyypeNpsd45hzAI5eHevOsgkPQuJ5hI/9Ozku2tUxu+vrgafvLfj1E3
         X3HJSl0Ubud2X4d2D2/IcI7gpGf+iu0H7Clrs1TaV8Ufe3QHwrhH+SLOTgRHt9LfFtxT
         C+YokGTEjZSPmy8IyHq7UHShABWSwGXSE1nAaUCFO3f0JgFkj6P9ycJjdNHQGXkBckkZ
         00CiGxs/8LKj0fTaeFzrr7KS3fE7L4gv/mrSf9dtf/B0tNFo2b5j2fbm6bO6h/DQAQkI
         WP4dSIQHOF0nIiZbn+0d8EmvCh0CVQUPgDQ5heB+TtS9Uw0pryMer0Op4ovgZstKvFr0
         2teg==
X-Gm-Message-State: APjAAAUm3K5XN300dlIIHjHV2iKbGulA5+tsZZt3yYv/cTH5B3zyFylo
        XFW1pvWIN2r7n5gCRBeRZ6g=
X-Google-Smtp-Source: APXvYqw4MeNmMa46N0eojLsOb00SiS1B7QtrAKajQkTx8t8jXi521K8wJOp/DSeG1HzTmlAiTY0WRQ==
X-Received: by 2002:a17:90a:d817:: with SMTP id a23mr86445308pjv.54.1564097195823;
        Thu, 25 Jul 2019 16:26:35 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::1:85f9])
        by smtp.gmail.com with ESMTPSA id d2sm44598671pgo.0.2019.07.25.16.26.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 16:26:35 -0700 (PDT)
Date:   Thu, 25 Jul 2019 16:26:34 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, yhs@fb.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 06/10] selftests/bpf: add CO-RE relocs array
 tests
Message-ID: <20190725232633.zt6fxixq72xqwwmz@ast-mbp>
References: <20190724192742.1419254-1-andriin@fb.com>
 <20190724192742.1419254-7-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724192742.1419254-7-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 12:27:38PM -0700, Andrii Nakryiko wrote:
> Add tests for various array handling/relocation scenarios.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
...
> +
> +#define CORE_READ(dst, src) \
> +	bpf_probe_read(dst, sizeof(*src), __builtin_preserve_access_index(src))

This is the key accessor that all progs will use.
Please split just this single macro into individual commit and add
detailed comment about its purpose and
what __builtin_preserve_access_index() does underneath.

> +SEC("raw_tracepoint/sys_enter")
> +int test_core_nesting(void *ctx)
> +{
> +	struct core_reloc_arrays *in = (void *)&data.in;
> +	struct core_reloc_arrays_output *out = (void *)&data.out;
> +
> +	/* in->a[2] */
> +	if (CORE_READ(&out->a2, &in->a[2]))
> +		return 1;
> +	/* in->b[1][2][3] */
> +	if (CORE_READ(&out->b123, &in->b[1][2][3]))
> +		return 1;
