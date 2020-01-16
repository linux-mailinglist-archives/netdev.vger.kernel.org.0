Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8C313FBCF
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 22:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388007AbgAPV5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 16:57:48 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37576 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729153AbgAPV5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 16:57:47 -0500
Received: by mail-qt1-f194.google.com with SMTP id w47so20219877qtk.4;
        Thu, 16 Jan 2020 13:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BKup+mN+yNw5E+RKZ+Bk6trS4fw29oa/jBU1SsMkNjo=;
        b=rpyy3YyC3pc4ZrmsAjEayWTY6S5fFW2TfftXYZ9zA9d0TT+4oeNbZxyRWO7jd3qmqV
         lAt0czVSnh36YxNThoGHWF2iAql/35TiHCv2iP6EJBeK1TrbRGU4rpH69mZsD05z4Z1d
         dlFJDBgbbuQS6Cu6d8S8eCrtQ4UrFd3IXvEEFk83ElJTcQcjeUfr9+KT8o5nl0+dUuUt
         P6D6IOLXb3m4P0jLT0OMi2S+EFsOQq0K5B6ELOgQVk8AxoysQv/LW9noMMP71kb5icEM
         F3yct2QlOrcAuUM8yGI33B5Vzu/+4UKugaTww0OrhRh4f+owRPKpt/Os7T0PnnI06jeg
         5z7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BKup+mN+yNw5E+RKZ+Bk6trS4fw29oa/jBU1SsMkNjo=;
        b=LL3MAg8qOpuj41z6Cf0TImjeXYYUFrQDC2Ww79zilC+c/SCa2Ebiyxc+61CyGZ2IwD
         ltAeT/uj3wmtX1TiCEQl9VWZ3JWCdbkmeUO3cwLrxftmKTbzlUUVMR5U2m8J9mU3846h
         QUO8NPALQ5GLxMUr6CPZ8X+hbz3/N2WhQwfHiqUctlP5lepOKmuC6HethQmKGeBYHCUl
         ehvdibtKCVRjqIADTQYlzboWOVEBOTNSJT+1DN+C3yaEJEY8lfIskbtwKc257IA7ugxU
         JFfkiHcU1fmZ5yS/9QS1EsTmpRtGFNV8g8KWj0crKOyU4ZyjQ0iWKTWGf/N35JYgv/Tz
         u1eQ==
X-Gm-Message-State: APjAAAXeYoxFqikVDH05iHELuEehHGapMYAOo8IVRvFfQAFzX2owTG1r
        +6bGXBkH3cJTURGH0qe+iw/BD9r4FTXOAfIKqJk=
X-Google-Smtp-Source: APXvYqz6W4hGwAmtkVgT6A+/5UfZjE9EHGHzPkk6ExiU4zKRnlOidUa4twJjkynIyaiQT4AhpX3h1OBlBvadSgKQco8=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr4515795qtl.171.1579211866008;
 Thu, 16 Jan 2020 13:57:46 -0800 (PST)
MIME-Version: 1.0
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk> <157918093723.1357254.4296174077488807255.stgit@toke.dk>
In-Reply-To: <157918093723.1357254.4296174077488807255.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jan 2020 13:57:34 -0800
Message-ID: <CAEf4BzbA6TZHvQ-7YoHbf1wNn3OcpTEgUMh6uzwJnGOX0yDSDg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 05/11] selftests: Use consistent include paths
 for libbpf
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

On Thu, Jan 16, 2020 at 5:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Fix all selftests to include libbpf header files with the bpf/ prefix, to
> be consistent with external users of the library. Also ensure that all
> includes of exported libbpf header files (those that are exported on 'mak=
e
> install' of the library) use bracketed includes instead of quoted.
>
> To not break the build, keep the old include path until everything has be=
en
> changed to the new one; a subsequent patch will remove that.
>
> Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken f=
rom selftests dir")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
