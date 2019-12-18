Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D07B1244FC
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfLRKsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:48:02 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44649 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfLRKsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:48:02 -0500
Received: by mail-lj1-f193.google.com with SMTP id u71so1569541lje.11
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 02:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y8I/adrDsHbrQ6DaD2YmiInq83JS4UeecTD+gcoH/1s=;
        b=u6OlLBMH8JFVpb4s+j4q3R9ucjYTDTNA55XeSgxhvd4IO4swKM57Egy7WDHHqGMXRH
         4AMBa2JWXte+r0GBXYAngi/Vgx9p8sZuwo+MAbFvvVn2p0BJpQsHGt8RvXmrpx/bM6aS
         ypzv1xRX/3PkAiWzJGQro/TSLwZiLpuowsNe+ZKzKxvNbda91CFDjJvCrseUcy/Fge4A
         qndu80X6gWE2aGbKPgyGlTmxny+fOPpL9GgIDhAPfuiEycKD+KEBYW2oNo0VjG3wMMSF
         HygZn+aI53tigr7+FrZtV0b1n8qwa+afu/AVOTPdWKaBQwmrKsvC2BjeWH6r57FjYDCT
         1EUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y8I/adrDsHbrQ6DaD2YmiInq83JS4UeecTD+gcoH/1s=;
        b=X/z8XGglNo+Tx+j8hXCjZ5XjeD0EusNZ21BlinzfsWaEiwEP5l6BLbc55RxTer+x92
         kYp1U/boamt3eXmo1UQ8H+K+eFw6FXN9vpdnn0TOc0OK7anSVjN+Eo5a6rvjKylMG0UA
         eLJPYyuNvaofpJJmH8SH/DPfM2heMYH+t7QVbb1Q0aX36OzaDARpZ1otFjTiNJU9+jH8
         2SBUBqqzMwsBEvM6hm5AbAc4nScVmzlHcz/dMf60Kk1pg2ydwYsLv43tqCin3W0ZiDKE
         k47bREyx7EIWgxaw7X8xci0cYJoXOPEjAcbtT9WOtEFo+RAw51n41ztW+pqwfBCrsipg
         I6bA==
X-Gm-Message-State: APjAAAXyiqABwOGAkdPkXf0+/wS2gQ/XJpG7kRBtBhco5KfRQOpy1B8A
        wPtrRcPIBSOrCBezu338CZiO4ZI4wwllAEG3ewn+Bw==
X-Google-Smtp-Source: APXvYqz2BHIUBhMYQ8Mw1QMdzuxRcwCcNi/RIyF8IXY1rtWdbBB23cfR7RMW9crqnoNVMHhCcmaiyWuuTuXhN468yBg=
X-Received: by 2002:a2e:868c:: with SMTP id l12mr1125967lji.194.1576666078690;
 Wed, 18 Dec 2019 02:47:58 -0800 (PST)
MIME-Version: 1.0
References: <20191216181204.724953-1-toke@redhat.com>
In-Reply-To: <20191216181204.724953-1-toke@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Dec 2019 16:17:46 +0530
Message-ID: <CA+G9fYssgDcBkiNGSV7BmjE4Tj1j1_fa4VTJFv3N=2FHzewQLg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: Print hint about ulimit when getting
 permission denied error
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Yonghong Song <yhs@fb.com>, lkft-triage@lists.linaro.org,
        Leo Yan <leo.yan@linaro.org>,
        Daniel Diaz <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Dec 2019 at 00:00, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index a2cc7313763a..3fe42d6b0c2f 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -41,6 +41,7 @@
>  #include <sys/types.h>
>  #include <sys/vfs.h>
>  #include <sys/utsname.h>
> +#include <sys/resource.h>
>  #include <tools/libc_compat.h>
>  #include <libelf.h>
>  #include <gelf.h>
> @@ -100,6 +101,32 @@ void libbpf_print(enum libbpf_print_level level, con=
st char *format, ...)
>         va_end(args);
>  }
>
> +static void pr_perm_msg(int err)
> +{
> +       struct rlimit limit;
> +       char buf[100];
> +
> +       if (err !=3D -EPERM || geteuid() !=3D 0)
> +               return;
> +
> +       err =3D getrlimit(RLIMIT_MEMLOCK, &limit);
> +       if (err)
> +               return;
> +
> +       if (limit.rlim_cur =3D=3D RLIM_INFINITY)
> +               return;
> +
> +       if (limit.rlim_cur < 1024)
> +               snprintf(buf, sizeof(buf), "%lu bytes", limit.rlim_cur);

 libbpf.c: In function 'pr_perm_msg':
 libbpf.c:120:33: error: format '%lu' expects argument of type 'long
unsigned int', but argument 4 has type 'rlim_t {aka long long unsigned
int}' [-Werror=3Dformat=3D]
    snprintf(buf, sizeof(buf), "%lu bytes", limit.rlim_cur);
                                ~~^         ~~~~~~~~~~~~~~
                                %llu

Linux next i386 and arm builds failed due to this error.

Full build log link,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-next/DISTRO=3Dl=
kft,MACHINE=3Dintel-core2-32,label=3Ddocker-lkft/672/consoleText
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-next/DISTRO=3Dl=
kft,MACHINE=3Dam57xx-evm,label=3Ddocker-lkft/672/consoleText


--=20
Linaro LKFT
https://lkft.linaro.org
