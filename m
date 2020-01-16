Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0715513FC19
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 23:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388299AbgAPWVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 17:21:23 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36377 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730287AbgAPWVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 17:21:22 -0500
Received: by mail-qk1-f193.google.com with SMTP id a203so20846246qkc.3;
        Thu, 16 Jan 2020 14:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vpbQOrapjlYcWs3bkrcm05Gp66rOZ9x8yOYklUO+LHY=;
        b=YrLfshsTZMEaoaurtJbcwzSaoRcapaMk5aQ6Vcf1sdNXNja9QAeeNF8VJykNeVUgZo
         xlwzKaZakSt5Y9bZy4IKR7MGJ/wOLaZ3+2QmM0lNILTzox9tYpZfca9fg0+M+HlevJFX
         xzgPEils0QPrNad+MFBheww0mG7T12Yqk0h4nTkLYPtMRRRDQjXS0mJVrw3a9j43ReCZ
         L92rwv39vWk3qhIze8qmfWjrg5jwEWQuAIftG3eCuafKT9/GgqAiwkQBO0GVo8PkMwVZ
         NTU9QcrL4KkQEUIYYs960+BeIsImrg+fed1Srq8py9vwMf2x3KljpdXshqJdeSZ7aMYN
         haTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vpbQOrapjlYcWs3bkrcm05Gp66rOZ9x8yOYklUO+LHY=;
        b=BD6WgfC4q0UKEpuPlbiSSR6XRBH4sW833wWLL5jdACUtHXh2B3aZZWtnf1xNTGbAw6
         /qbT8wNCFZbti0CTf5RYGLjNiSPUyvjzZXo/shRRZnaeHGa/gc4hdJin6OThcn9m8yaG
         aIr3YWg+nWt++JncIfIO+0KzcdHhwxnujezKjvX716mbeC2WZzA9sE/abgVVO6yCIMJA
         y+0o03rBxPobhwndrfPuk3795WRoeSgtezlxF/R8Z0g6cKy1o7M3nGKLyIsCapwveW/J
         6/6+HOQNczCDNhC7U2ku26XrU13nYj6xvRJefkJGYLEyjj7cbnJFpguc5r5NKWvyXpvg
         wqmA==
X-Gm-Message-State: APjAAAV/CpXdbkZGZc8SkYIHHVHsGwJzaGtCT79JfHHE7pShRvnxxFdY
        J3JBxx8RmyiL6+0+P/vHL2PV7WK7NjoVCshdzT8=
X-Google-Smtp-Source: APXvYqz1i/WEP6x/rLAeNoVBbsK0G1LZrffElunve4gOl5pxTl+wMdcs1VSidF8QuuZXFAgkfUU7ExMVAZrIPvhsrL8=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr31315590qkq.437.1579213281433;
 Thu, 16 Jan 2020 14:21:21 -0800 (PST)
MIME-Version: 1.0
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk> <157918093839.1357254.16574794899249700991.stgit@toke.dk>
In-Reply-To: <157918093839.1357254.16574794899249700991.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jan 2020 14:21:10 -0800
Message-ID: <CAEf4BzZep26Y50ER5x9FLsxu0_yW-sG5abxE2RZLBT-JhRnqbg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 06/11] bpftool: Use consistent include paths
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
> Fix bpftool to include libbpf header files with the bpf/ prefix, to be
> consistent with external users of the library. Also ensure that all
> includes of exported libbpf header files (those that are exported on 'mak=
e
> install' of the library) use bracketed includes instead of quoted.
>
> To make sure no new files are introduced that doesn't include the bpf/
> prefix in its include, remove tools/lib/bpf from the include path entirel=
y,
> and use tools/lib instead.
>
> Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken f=
rom selftests dir")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
