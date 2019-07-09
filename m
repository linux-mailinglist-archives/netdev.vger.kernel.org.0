Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4977C63D6B
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 23:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbfGIVkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 17:40:09 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35709 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGIVkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 17:40:09 -0400
Received: by mail-qt1-f196.google.com with SMTP id d23so231307qto.2;
        Tue, 09 Jul 2019 14:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lJh45MwiMC9N1tuyLAbuw8kfrp+3H6r/0ozeqeFn+r0=;
        b=eLrUIheCO4lohY9L+34S3vsuIbyu7P9eyRJYkKfdqg8AMDjPXeKGAEWNcsTJkN1BCk
         OaigVyjPz2BAnF+cp+sT08/UqJO0sMfqeG/iI4gIuCvjG7ZB3zEQZxmkwohWVW1bCgIK
         ya1P7MMGbiv2qRe9upjonDLY0Oim1u7A3mNrt1p2G8HJL5V6nLbTwT/pif9RdlrwAH4b
         PubLOzDVBslnjDOTBBWjRxDo7OD3zkBN8CBoAeIKuGMEGV8oxbLzp1Mq1s8nPsAjSWt0
         M5TqmYXQ52dFzSk1ZQc5dBxImR2Wlzu/2FgPZPxC0GNPTz1BAd5jsLhX3oAhXtVKPwAs
         XplA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lJh45MwiMC9N1tuyLAbuw8kfrp+3H6r/0ozeqeFn+r0=;
        b=BVMr4W8nfN6RbfBBmRjy4iWoECCaUdMQzCVE5a+Oc36heCUzENicTFSLCRM69qnhAA
         AS6EfZom3bBhf1pHdNsDNzl22mYQ3aKV+vSlg55wbEtJdN4GlPfqXXNyWVAs4Y+ex1N6
         r0vWf5KqDcSeH+tFHPkxnWDz0XFdxv5F6Eww2bN+GSjOewpQ07Gv9lHoGpMQ2EWDhIr8
         CjfmqMmZDOKi9tosRTJ3CrMyjS+bBzwWC2AMpQCBjgRsFqZLh5JO2g2ZIUWrMn3q6hPy
         BMz/XumbRa8vmlSW8Uuw9T1EbNkV7RvP7wuIKGYYKpfNfEcphl/pWpesSKMC8hKYMvPD
         S8Tw==
X-Gm-Message-State: APjAAAUV+jT7ecyrlD9iavJGSotrgQWSwe8pVUu3d7rGTInPI9EFDa6O
        a058B8gzlp/GfhMdWZ0ELg/Fr484jv5yC3RNUz4=
X-Google-Smtp-Source: APXvYqzK0ReF8Oh7k2Vxfx3PDUUQA9iiUosAAplZrJQfekSu7b0xqDERqw3IaxQVZKjPT4SGrsPW3z8DbInOPOpUhuE=
X-Received: by 2002:a0c:c107:: with SMTP id f7mr21341958qvh.150.1562708408142;
 Tue, 09 Jul 2019 14:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190705155012.3539722-1-andriin@fb.com> <86f8f511-655c-bf9e-8d78-f2e3f65efdb9@iogearbox.net>
 <0366eaff-b617-b88a-ade4-b9ee8c671e18@solarflare.com>
In-Reply-To: <0366eaff-b617-b88a-ade4-b9ee8c671e18@solarflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 9 Jul 2019 14:39:57 -0700
Message-ID: <CAEf4BzY5g-2R4ZYT5veH4TydyB=iMTmqMk2fx3gSS2SOi=QaqA@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/4] capture integers in BTF type info for map defs
To:     Edward Cree <ecree@solarflare.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 9, 2019 at 1:27 PM Edward Cree <ecree@solarflare.com> wrote:
>
> On 05/07/2019 22:15, Daniel Borkmann wrote:
> > On 07/05/2019 05:50 PM, Andrii Nakryiko wrote:
> >> This patch set implements an update to how BTF-defined maps are specified. The
> >> change is in how integer attributes, e.g., type, max_entries, map_flags, are
> >> specified: now they are captured as part of map definition struct's BTF type
> >> information (using array dimension), eliminating the need for compile-time
> >> data initialization and keeping all the metadata in one place.
> >>
> >> All existing selftests that were using BTF-defined maps are updated, along
> >> with some other selftests, that were switched to new syntax.
> BTW is this changing the BTF format spec, and if so why isn't it accompanied by
>  a patch to Documentation/bpf/btf.rst?  It looks like that doc still talks about
>  BPF_ANNOTATE_KV_PAIR, which seems to be long gone.

It didn't remove BPF_ANNOTATE_KV_PAIR and you can still use it and
libbpf will continue supporting it for the time being. But I'll update
the doc with new syntax, thanks for reminding!


>
> -Ed
