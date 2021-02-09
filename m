Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852E0314860
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 06:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhBIFxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 00:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhBIFxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 00:53:19 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11813C061788;
        Mon,  8 Feb 2021 21:52:39 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id b187so17011465ybg.9;
        Mon, 08 Feb 2021 21:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bHk+JF1bvYTk+/3qzL9w8Fao5P5tKzNYOWCvFvqbIrY=;
        b=PykY9irOnLpWserL08/gvwu8oQRBDAUj/XqtE/B6UlQmOUj0IAVpWzs0XDVge5Zzb0
         htqtJuE1lKQiIJwlyEoCzxYSMbOjGxcafQ10p5Bnq6w4CWyyrRA+WMEY+e76R4UlkLu7
         mC14yHBNuVwvnXEWnqmdYjXrWXTtFvKe9p//lMNBgbG5/RmZcRQmddT+6wrOkqu5xl0c
         dCEyY156I1D+Fu6CMyow98V73W/geLLoEwMgYucVCg/2e1g4SG3DQYihDuwFLkuxLBZH
         tqwh6g8iFCfKKVLlW1Da2TbSU6jm13Yo3J9Gz8DodsoiClO7ADeFaw4gaTYpFJV7zJJk
         SaJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bHk+JF1bvYTk+/3qzL9w8Fao5P5tKzNYOWCvFvqbIrY=;
        b=Eiyq9SruKUwfKmPg+kDZ+jJuKzONO9Jk4a33ZcJ654gbNJzWM7KWLfQieA1/Zno3jh
         /EB3qUSOO+Y7AnZd53UBGzCmn6tSlo2mLmba491kThsxAhP6KL6jzs7VQSE99swb5LDf
         rO0eGAFWLxO9OkyPC5FRtgZLcw65whU/ei06XGod1fsGO/wXKZlK4Q0SjpNW70qg2i13
         TCt2fIZJ3ffTs+tRWLfjsUdbo1N92mBQkkn52G0i7MiouNXWcnAvYjrsFyUAQLeOHu6X
         sHoWm04B6rcBCSi3CqlW3i+S5GMeWE2XHvuM34B1y//Ygn/Pb3ymRDY61z2FGRpzdgrU
         rw1g==
X-Gm-Message-State: AOAM53156UskdHpm1p1RLqL/AVX3tgspG3/I5YwMekjrJ29L8gVqOdc4
        E9TaPEE7IErSndhyedlHrLtX69YeCpqfNTRSOzY=
X-Google-Smtp-Source: ABdhPJwRNxpqs5K83gjzBipDdtzkV+2RXjnkdXomzPepukrRz7SLN4wiBDkCZf8lfXO7JxfiSm9A8RSKZ1kJZfboP34=
X-Received: by 2002:a25:3805:: with SMTP id f5mr13327086yba.27.1612849958356;
 Mon, 08 Feb 2021 21:52:38 -0800 (PST)
MIME-Version: 1.0
References: <20210206092654.155239-1-bjorn.topel@gmail.com>
In-Reply-To: <20210206092654.155239-1-bjorn.topel@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Feb 2021 21:52:27 -0800
Message-ID: <CAEf4BzZ4aU26HGxYsOg4ma52bq9ghLDMJD03O1oQaRd8q0=ofA@mail.gmail.com>
Subject: Re: [PATCH bpf v2] selftests/bpf: remove bash feature in test_xdp_redirect.sh
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        u9012063@gmail.com, Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 6, 2021 at 1:29 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com=
> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> The test_xdp_redirect.sh script uses a bash redirect feature,
> '&>/dev/null'. Use '>/dev/null 2>&1' instead.

We have plenty of explicit bash uses in selftest scripts, I'm not sure
it's a good idea to make scripts more verbose.

>
> Also remove the 'set -e' since the script actually relies on that the
> return value can be used to determine pass/fail of the test.

This sounds like a dubious decision. The script checks return results
only of last two commands, for which it's better to write and if
[<first command>] && [<second command>] check and leave set -e intact.

>
> Acked-by: William Tu <u9012063@gmail.com>
> Fixes: 996139e801fd ("selftests: bpf: add a test for XDP redirect")
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
> William, I kept your Acked-by.
>
> v2: Kept /bin/sh and removed bashisms. (Randy)
> ---
>  tools/testing/selftests/bpf/test_xdp_redirect.sh | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_xdp_redirect.sh b/tools/tes=
ting/selftests/bpf/test_xdp_redirect.sh
> index dd80f0c84afb..4d4887da175c 100755
> --- a/tools/testing/selftests/bpf/test_xdp_redirect.sh
> +++ b/tools/testing/selftests/bpf/test_xdp_redirect.sh
> @@ -46,20 +46,20 @@ test_xdp_redirect()
>
>         setup
>
> -       ip link set dev veth1 $xdpmode off &> /dev/null
> +       ip link set dev veth1 $xdpmode off >/dev/null 2>&1
>         if [ $? -ne 0 ];then
>                 echo "selftests: test_xdp_redirect $xdpmode [SKIP]"
>                 return 0
>         fi
>
> -       ip -n ns1 link set veth11 $xdpmode obj xdp_dummy.o sec xdp_dummy =
&> /dev/null
> -       ip -n ns2 link set veth22 $xdpmode obj xdp_dummy.o sec xdp_dummy =
&> /dev/null
> -       ip link set dev veth1 $xdpmode obj test_xdp_redirect.o sec redire=
ct_to_222 &> /dev/null
> -       ip link set dev veth2 $xdpmode obj test_xdp_redirect.o sec redire=
ct_to_111 &> /dev/null
> +       ip -n ns1 link set veth11 $xdpmode obj xdp_dummy.o sec xdp_dummy =
>/dev/null 2>&1
> +       ip -n ns2 link set veth22 $xdpmode obj xdp_dummy.o sec xdp_dummy =
>/dev/null 2>&1
> +       ip link set dev veth1 $xdpmode obj test_xdp_redirect.o sec redire=
ct_to_222 >/dev/null 2>&1
> +       ip link set dev veth2 $xdpmode obj test_xdp_redirect.o sec redire=
ct_to_111 >/dev/null 2>&1
>
> -       ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null
> +       ip netns exec ns1 ping -c 1 10.1.1.22 >/dev/null 2>&1
>         local ret1=3D$?
> -       ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null
> +       ip netns exec ns2 ping -c 1 10.1.1.11 >/dev/null 2>&1
>         local ret2=3D$?
>
>         if [ $ret1 -eq 0 -a $ret2 -eq 0 ]; then
> @@ -72,7 +72,6 @@ test_xdp_redirect()
>         cleanup
>  }
>
> -set -e
>  trap cleanup 2 3 6 9
>
>  test_xdp_redirect xdpgeneric
>
> base-commit: 6183f4d3a0a2ad230511987c6c362ca43ec0055f
> --
> 2.27.0
>
