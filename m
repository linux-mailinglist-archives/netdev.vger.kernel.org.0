Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0EE13AAB0
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 14:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgANNWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 08:22:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38283 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725994AbgANNWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 08:22:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579008136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BMr4t19r9FDBxMiNqZ17ABTwdjTXfkzRestAINYUs2o=;
        b=c6g2lrQb2OTVNGtmEkC2+8lxH+Me3josDccx8Zih97WL9WgRv953/ezl0nIU/bvO/xtkph
        ycT/7PLjT9h3P5qo1UmuYw1yRH4/ltoPItup8+Nza4VD+hVGtwIbRc1Ckofry5PTgup+mg
        keK0mgSHKdqkKcJHb8vJ+QkE32ne84k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-hY50GWhqMJyc0ARApPk7RQ-1; Tue, 14 Jan 2020 08:22:14 -0500
X-MC-Unique: hY50GWhqMJyc0ARApPk7RQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59D0F8DC401;
        Tue, 14 Jan 2020 13:22:12 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B18E350A8F;
        Tue, 14 Jan 2020 13:22:10 +0000 (UTC)
Date:   Tue, 14 Jan 2020 14:22:08 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 5/6] tools/bpf: add runqslower tool to
 tools/bpf
Message-ID: <20200114132208.GC170376@krava>
References: <20200113073143.1779940-1-andriin@fb.com>
 <20200113073143.1779940-6-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113073143.1779940-6-andriin@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 12, 2020 at 11:31:42PM -0800, Andrii Nakryiko wrote:

SNIP

> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
> new file mode 100644
> index 000000000000..f1363ae8e473
> --- /dev/null
> +++ b/tools/bpf/runqslower/Makefile
> @@ -0,0 +1,80 @@
> +# SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> +OUTPUT := .output
> +CLANG := clang
> +LLC := llc
> +LLVM_STRIP := llvm-strip
> +DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
> +BPFTOOL ?= $(DEFAULT_BPFTOOL)
> +LIBBPF_SRC := $(abspath ../../lib/bpf)
> +CFLAGS := -g -Wall
> +
> +# Try to detect best kernel BTF source
> +KERNEL_REL := $(shell uname -r)
> +ifneq ("$(wildcard /sys/kenerl/btf/vmlinux)","")

s/kenerl/kernel/

jirka

