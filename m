Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4FE13FC25
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 23:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389945AbgAPWXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 17:23:21 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:43562 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730215AbgAPWXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 17:23:20 -0500
Received: by mail-qv1-f67.google.com with SMTP id p2so9857194qvo.10;
        Thu, 16 Jan 2020 14:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oCyvl4b908HZ5JJcSmjdgvOBWBhwJ2mkB7jFnC6f1FY=;
        b=Z+2bgoAIiCfuwDfL3sKfHeuQXY/yIYpeyXDqfGvh6AOzAOaFKpxWWH9wfjFh1GxdK2
         l4BX4dg+eJJQsddWhrzjVp+s7L+VpIvk0vNqYU+iM2JI5a96Qgc4B6hKzZlnj75Um48B
         Te2llVFvtQ98wn6p4KTTUMb+35O0ym1bek5benfOLucwfwOJfAQXdKw3can2NprWC+rr
         EjiUDeeMx0RoqXOEbmaevb0IA4ODVDLq3W+dfwnbbixgdxYBkhoPzzOca77hLcUA2n0j
         Cmdy3+L4SPsshEWohMM9PjOIttG1HH4B2FkrOeqD26bqFhrbo/xyMdCzMBcm3m3n11/8
         4+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oCyvl4b908HZ5JJcSmjdgvOBWBhwJ2mkB7jFnC6f1FY=;
        b=toqlj90yKbnUQtWZpMSR3Bv7wSpybsLri0azXT8uKxLl1abp8puhoPgcjhUeGzds7a
         b711ZWi2cPo7/HqZNTmo51F2Nks5PbC8A39jiU7cmL1CWNw3ZhoJiEYwv2vinp5UDI6Z
         itehWhlTK5EO4ShXIHfs7fvIzafgLkdJS02h55GhYaHAOV/y1Sl1sVd8rDrpLFK0RhEA
         MwTvS/VxKmKu1d18aCF9dWlbBriicS7v9qLDZcPdZ/g+hJIf8rMZfaQZz3grp9T3hazi
         AMtWWKQkvaymJc57lJYngzPhs2zGu8EVjUViNus3q6o6nYh7/jOj4urTqc34e7SCXFib
         TE8w==
X-Gm-Message-State: APjAAAWZFTAv4jIh0EMz4WvnDPZoUwG6HXXIxDIlSH5x7ZiPw/2Vryvq
        Vb1jlBEFinXua/BjUY8Nsa3kg/thKmlVYiOCmGI=
X-Google-Smtp-Source: APXvYqzVXQI2o+J0jVqrsglhF5ZDoxbegXW/Aj7QcNicrKmutX3oRkpQKEGNzgM0thXGAVyjLWwI6OSR3Q2H+0TAq9E=
X-Received: by 2002:ad4:4e34:: with SMTP id dm20mr5012047qvb.163.1579213399484;
 Thu, 16 Jan 2020 14:23:19 -0800 (PST)
MIME-Version: 1.0
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk> <157918094065.1357254.8062315384165377618.stgit@toke.dk>
In-Reply-To: <157918094065.1357254.8062315384165377618.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jan 2020 14:23:08 -0800
Message-ID: <CAEf4BzbX282u_DFRUqkzdZ91RhpFRg-dXzsGcTrzdsqc+Tb2HQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 08/11] samples/bpf: Use consistent include
 paths for libbpf
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 5:28 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Fix all files in samples/bpf to include libbpf header files with the bpf/
> prefix, to be consistent with external users of the library. Also ensure
> that all includes of exported libbpf header files (those that are exporte=
d
> on 'make install' of the library) use bracketed includes instead of quote=
d.
>
> To make sure no new files are introduced that doesn't include the bpf/
> prefix in its include, remove tools/lib/bpf from the include path entirel=
y,
> and use tools/lib instead.
>
> Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken f=
rom selftests dir")
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
