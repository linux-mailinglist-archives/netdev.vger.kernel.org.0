Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4832CC5F
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfE1Qp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:45:26 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44519 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfE1Qp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 12:45:26 -0400
Received: by mail-qk1-f196.google.com with SMTP id w187so13375278qkb.11;
        Tue, 28 May 2019 09:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PFmaYpz+7586n8fgFzVofvO6konpWOrSa5dCBt2QReQ=;
        b=anrNjBRsknHzWPik+xWHWpC52AhNn4Rm17SGUku1No9v1MdLTVVQff/jGHtbgyaFcZ
         podY2XyhqOCFaXvyIYt3b9GidZFmCrUWmr9z2iT82xm/riYk4C9Lsn7cOw6C7MLcc354
         /Qou5L1D8DfnkaxFOPD84RioSEwIVubPgBerMzl7MWT8fMYGAjtPA0HoSo6znBDp1U47
         CkqxVrMob3azCegSEjZo5HjErJXQslG7YY/GvYs64/lAks8pKiupHqFYUAVOXA+NQmge
         g+8FFc6Eu0MS7B9DkClx73FNHQvCy6Afv9WPQN1EckuEi9WLX9gs9WtTFcjXKZi65eeM
         UZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PFmaYpz+7586n8fgFzVofvO6konpWOrSa5dCBt2QReQ=;
        b=mEmcCUAnQrndJYj9gucHbhjPDMaTyD43pQ+CUTh3vkLv26s0sc9Q6p7EiTDkYBzxPB
         udqIibC7qtEFumNSeNOYydX4VFqGAnBafB9oxsJY46ll8npCL+BVRLXnFhV9H4eDtrgH
         lCv/zpLyLlD+AdaVmfTOnubglqGO0DKcnwl4vjqgQYPm6Z/btl14ZK8hRvS5gkPDkRLy
         wtNH/O4zsg/oxd6ynszRBGYS1ic8hVpPYsu754sP55F3WOWO564QYDlUZLqN09LxsDB8
         gZRwWUBKSobf2bH6zlbm/Ir7T2zaaPYotTM8qSiB5bj0cdPl00GfRFg2tjoe6MH/dCD1
         IYDA==
X-Gm-Message-State: APjAAAVQG6Fon+70dRiEQeQmF4yaH5etpfm1hleX8CmLB9FEiTqvJBM3
        9/lkHD1hTmrcwqYqhSX9Ln/6GvurzqKGtrOBAOw=
X-Google-Smtp-Source: APXvYqwxnAJXnfzy3oJ7sLlXZqQixsfQ+YZO+6KnyeoazRF9rZ1t5e8A0gFtHjIbg3A1bXf4IjD1rHcMcfCt89SykjQ=
X-Received: by 2002:ae9:ee0b:: with SMTP id i11mr12264495qkg.96.1559061925163;
 Tue, 28 May 2019 09:45:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190524003038.GA69487@ip-172-31-44-144.us-west-2.compute.internal>
In-Reply-To: <20190524003038.GA69487@ip-172-31-44-144.us-west-2.compute.internal>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Tue, 28 May 2019 09:45:14 -0700
Message-ID: <CAPhsuW7H=w_UMyu5Q5p5+MGogkQ7+7X7sS=vJTiR=+JJy0KuTg@mail.gmail.com>
Subject: Re: [PATCH] selftests: bpf: fix compiler warning
To:     Alakesh Haloi <alakesh.haloi@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 5:31 PM Alakesh Haloi <alakesh.haloi@gmail.com> wro=
te:
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
> Signed-off-by: Alakesh Haloi <alakesh.haloi@gmail.com>

The patch looks good. Please add a "Fixes" tag, so the fix
can be back ported properly.

Also, please specify which tree the patch should be applied
with [PATCH bpf] or [PATCH bpf-next].

Thanks,
Song




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
