Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B473170F6
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhBJUOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhBJUOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 15:14:46 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1945CC061574;
        Wed, 10 Feb 2021 12:14:06 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id k4so3302078ybp.6;
        Wed, 10 Feb 2021 12:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2gKnQEd4HhiRL2RshJ9tRa37DqmZChxhAvo3d0G1OA0=;
        b=jSUfH62mg/cqznsAOKxv5K7LDIr7701cR+zNM/esjovn9VDmyT9sKoSIUMRe/hi9TQ
         kyuUFfUOJP1mv4hZrvEPh4KgrEnyGM0t0LWPTRdvrkJxL7DTEYCQF0uhDi36kvHKlfVu
         0fFtQLB69dCmcSI/KzgxZ/oH5V4Mxz+iENfsm635n6NNpwj5zP1SuNbL0I9I5u2IcRRP
         94BxNIv+TA6avXpoTlQVtXsy/WJM81GdLIz7BWlcw6hkHawkp952mQTm5IFd4ZQ2AQ8l
         YdQ8aH+pcLH8T+C9DAyiGHZ2C2vLNgkRCwrZPFGOBsM4k+hQlVhU4H7a84/YDHYBvlh0
         zy7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2gKnQEd4HhiRL2RshJ9tRa37DqmZChxhAvo3d0G1OA0=;
        b=pftF0rr0v4kjJFa9lpC6xA4qrCjeXiTj9A5wQ2bov0NDIANlkeBWGdWPpcYagqeXi/
         ZhiOAoILzWMpu9UIr7a+vodNqtr7JIe1scYVZf4nDcO88gVx0vUU6Rl7D7ey9luXRKLK
         GlKLBzEK4IGCpZDuCyUL49NFotMpgQ2nxe0qIsHLZpM1UMqcE5U7vqV3/l8goyDcm+oT
         EqYu9669VXX40n8Wjtdr8MR4P3Waa+XypZ6h8uwbYGxSfIE/FDDWLvhMVyXBrKsPUW8P
         M4mqRCqqTxNzBSoz6uI18RnJ++f9vpzjlM0gHOgluolvFtOQ7nsWyCSy4XdgXNe/Nye9
         zqww==
X-Gm-Message-State: AOAM532hUbio6Cn1YFc6FRUQKyaV61GB5fYVFJvr02endbpFiAqQk81e
        h1MU11ca09wZVlA5Fntjkw0VhEvWueZ3DLwy7g0=
X-Google-Smtp-Source: ABdhPJwbS35LJ3n1W2/tgtjiwIMm3bcACJio1nc822N7BiBd+X1pNsKFFOiTWV3lklZV0pRUS2QSMijxYVQMvmg8TCE=
X-Received: by 2002:a25:37c4:: with SMTP id e187mr6772002yba.347.1612988045433;
 Wed, 10 Feb 2021 12:14:05 -0800 (PST)
MIME-Version: 1.0
References: <20210209074518.849999-1-bjorn.topel@gmail.com>
In-Reply-To: <20210209074518.849999-1-bjorn.topel@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Feb 2021 12:13:54 -0800
Message-ID: <CAEf4Bza7aJTnquXhJXiQR=rtNGVug-Sc_bsiBm9Op9QUOszkdw@mail.gmail.com>
Subject: Re: [PATCH bpf v3] selftests/bpf: convert test_xdp_redirect.sh to bash
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

On Mon, Feb 8, 2021 at 11:45 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> The test_xdp_redirect.sh script uses a bash feature, '&>'. On systems,
> e.g. Debian, where '/bin/sh' is dash, this will not work as
> expected. Use bash in the shebang to get the expected behavior.
>
> Further, using 'set -e' means that the error of a command cannot be
> captured without the command being executed with '&&' or '||'. Let us
> use '||' to capture the return value of a failed command.
>
> v3: Reintroduced /bin/bash, and kept 'set -e'. (Andrii)
> v2: Kept /bin/sh and removed bashisms. (Randy)
>
> Acked-by: William Tu <u9012063@gmail.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---

Not exactly what I had in mind (see below), but it's ok like this as well, =
so:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

Does it have to go through the bpf tree or bpf-next is fine? And what
about Fixes: tag?


>  tools/testing/selftests/bpf/test_xdp_redirect.sh | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_xdp_redirect.sh b/tools/tes=
ting/selftests/bpf/test_xdp_redirect.sh
> index dd80f0c84afb..3f85a82f1c89 100755
> --- a/tools/testing/selftests/bpf/test_xdp_redirect.sh
> +++ b/tools/testing/selftests/bpf/test_xdp_redirect.sh
> @@ -1,4 +1,4 @@
> -#!/bin/sh
> +#!/bin/bash
>  # Create 2 namespaces with two veth peers, and
>  # forward packets in-between using generic XDP
>  #
> @@ -43,6 +43,8 @@ cleanup()
>  test_xdp_redirect()
>  {
>         local xdpmode=3D$1
> +       local ret1=3D0
> +       local ret2=3D0
>
>         setup
>
> @@ -57,10 +59,8 @@ test_xdp_redirect()
>         ip link set dev veth1 $xdpmode obj test_xdp_redirect.o sec redire=
ct_to_222 &> /dev/null
>         ip link set dev veth2 $xdpmode obj test_xdp_redirect.o sec redire=
ct_to_111 &> /dev/null
>
> -       ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null
> -       local ret1=3D$?
> -       ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null
> -       local ret2=3D$?
> +       ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null || ret1=3D$?
> +       ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null || ret2=3D$?

You didn't like

if ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null &&
   ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null; then
        echo "selftests: test_xdp_redirect $xdpmode [PASS]"
...

?

>
>         if [ $ret1 -eq 0 -a $ret2 -eq 0 ]; then
>                 echo "selftests: test_xdp_redirect $xdpmode [PASS]";
>
> base-commit: 6183f4d3a0a2ad230511987c6c362ca43ec0055f
> --
> 2.27.0
>
