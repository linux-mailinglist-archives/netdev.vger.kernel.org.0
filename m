Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACBB2D0BE
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 22:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfE1U54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 16:57:56 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36210 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfE1U54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 16:57:56 -0400
Received: by mail-qt1-f196.google.com with SMTP id u12so27061qth.3;
        Tue, 28 May 2019 13:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o1ydLImzsmpkS5F7PlvU5sVhBXF/PklEQqQZqMpZmxE=;
        b=pUUFYFdhSOjFKlE4+4l7DO7lFTfWN1aoCbBGKyUVb1zddz/d94F+w8Swz99yR7Z+yi
         JMuV5TFhMLdvWJuUEBwYbuKUJTLJiQBweh9i1EOl3KSECbPvROcAD92Nzu8+lk+4Wj1H
         Veg8w/g/mxEO9ooewq3DrgMWdw1+Vr35vdmu3em+cXEpVTUNhk7O82mGNdigmcgJZ6xY
         DTOA1uWJRMCxYnoS7J/BuACvvS81cDojuRxFtxwWjzvUX0+IX7TNR+/C4RdSRQ3xJr6r
         Hykh8DQekErFOps4eAllmh+qoou+mRcNzmo99/e49QV53zWeNCkSlIchshLsny5H1/NG
         MpsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o1ydLImzsmpkS5F7PlvU5sVhBXF/PklEQqQZqMpZmxE=;
        b=V1q2fKJ1tDgYDCATvHUtyniHmgOM9Z8OnGZxnXk9lRCFOpnS/9nzmKN/PeTGA8SulB
         cDHGX4Fhf3RmE2OWfYWYcXaFr5rAqb2Eans8GX/FkolfnnGBGNyUJrL8XHXsKXCIpkYC
         sOPK1rhkA80nZJjMGKwhAECDP8mDwVn9VYgLjnZm6Qwjgr3OnDdIOFPFOSQqri79NDMP
         jnrQ/FeNDekTBqNdE2vhNhhvNBlZZLksxcHzihn4ML3xgXV7Drf4B7ljzt2vSVhowA9k
         4J8X3+6MmfEtMTMIsBEZNeLZ7zajWDWGhuBKZF/a0QNUQv8zPRKI716ZD9EbEAWbAKJ3
         192w==
X-Gm-Message-State: APjAAAUydww0kRlInx5cKAeflE6pBv/sA2ax0yZ8TXwvJPONL7AlYClY
        RejlbgbLs73uDGjlBE9hrZwfgh9QuRkWn2MJGzg=
X-Google-Smtp-Source: APXvYqyVyzhSWxFPxx1Q7S/1xkEQOPxvA+Ddzkuz4KVntMBUsTlXhD9T29/yxzB2jQa3duROW2pyJYlgJS46nAlO7dk=
X-Received: by 2002:a0c:d4ee:: with SMTP id y43mr95878708qvh.26.1559077075184;
 Tue, 28 May 2019 13:57:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190528190218.GA6950@ip-172-31-44-144.us-west-2.compute.internal>
In-Reply-To: <20190528190218.GA6950@ip-172-31-44-144.us-west-2.compute.internal>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Tue, 28 May 2019 13:57:44 -0700
Message-ID: <CAPhsuW5uVgqVEfpJsCNmQKYgmAksJ+jVTkU7QG2Fz8ofg6Puxg@mail.gmail.com>
Subject: Re: [PATCH bpf v2] selftests: bpf: fix compiler warning
To:     Alakesh Haloi <alakesh.haloi@gmail.com>
Cc:     linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 12:35 PM Alakesh Haloi <alakesh.haloi@gmail.com> wr=
ote:
>
> Add missing header file following compiler warning
>
> prog_tests/flow_dissector.c: In function =E2=80=98tx_tap=E2=80=99:
> prog_tests/flow_dissector.c:175:9: warning: implicit declaration of funct=
ion =E2=80=98writev=E2=80=99; did you mean =E2=80=98write=E2=80=99? [-Wimpl=
icit-function-declaration]
>   return writev(fd, iov, ARRAY_SIZE(iov));
>          ^~~~~~
>          write
>
> Fixes: 0905beec9f52 ("selftests/bpf: run flow dissector tests in skb-less=
 mode")
> Signed-off-by: Alakesh Haloi <alakesh.haloi@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>

Thanks for the fix!

> ---
>  tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/to=
ols/testing/selftests/bpf/prog_tests/flow_dissector.c
> index fbd1d88a6095..c938283ac232 100644
> --- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> +++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> @@ -3,6 +3,7 @@
>  #include <error.h>
>  #include <linux/if.h>
>  #include <linux/if_tun.h>
> +#include <sys/uio.h>
>
>  #define CHECK_FLOW_KEYS(desc, got, expected)                           \
>         CHECK_ATTR(memcmp(&got, &expected, sizeof(got)) !=3D 0,          =
 \
> --
> 2.17.1
>
