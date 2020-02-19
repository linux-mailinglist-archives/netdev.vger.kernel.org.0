Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F87816518F
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 22:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgBSV0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 16:26:49 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39412 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgBSV0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 16:26:49 -0500
Received: by mail-pj1-f66.google.com with SMTP id e9so609357pjr.4;
        Wed, 19 Feb 2020 13:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=cITU4krOVT1eOCRCwqj4+RqWn0lr9rqwJ4GX0/GfWao=;
        b=eT4JpcUJ+wkyy2YHv+TyX3laOrhH/FEIzRVWWk78OpZLahdhC4GZISvJuPRlTzQwS8
         U2lyFkRCknYC+ad2HPD00oSK+lPUT1Kqww1xNcTQDtFx/7UIq+u2dVDftyevo8AZJWqJ
         IvvWkI1DfMKK2D/UjRC9U+Bm1qgcreP+N9PL8Ok2/Kme28KJs+a+6as2KP7mJFg0qO8d
         i49ZaSW/O3U0JklGjTmPpinFFixZnHeo/H2ixBhx/W6rUz1RfFBIrGwROvh85peADHiJ
         q4F8yS9M5804deK/fYz7Tp2CfBQWRw6zuCobwvHMpzW9QSt0BlGMSlGTZgSGxScn19MQ
         /6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=cITU4krOVT1eOCRCwqj4+RqWn0lr9rqwJ4GX0/GfWao=;
        b=NmQNl1ydEBPFFc2NaHXm6ZS977M6guV1lLI4oQVFZZHk5vRegxLLYBmxtJd7wABkJp
         oCuC0mpbIWrtR6vnEX/QuveZeY57iePtq+mYbsnfNNUf4bBCtBYAqHW0gyacShGY+Cf6
         jobP89nk27WHV+0y7PxIdzGqlCEka/y02vekKhynkv1iPJ0eQoiWTCgqnqUc6r29Gd/R
         xWiFKuOvnk49QLfV1FsKBwS6Vy7rDvVHZwvDQPFJL990k5ekJWS2t5QEnLsPmrD+pbnF
         N/uHb5KSvxoQPsJvZxsa5KdPaUA0+eh7vLbnItyOrnNRS/pnXFxLnXtjzbFCcy4mj3gF
         HZcQ==
X-Gm-Message-State: APjAAAWLpVc4ctZAcpcbnk1hrfwm0jtzZCdKtgguvd64JHQxOUbUKv/u
        uufPiCDZ48BNUmA17GWEDaE=
X-Google-Smtp-Source: APXvYqw1Iw2Off1DunvVinQpLk9rfkJ/vc8phyJbxH2APyw7RzIDzUWH0KgRz/vMXZheJhPlzPFBEg==
X-Received: by 2002:a17:90a:c084:: with SMTP id o4mr10683483pjs.35.1582147608365;
        Wed, 19 Feb 2020 13:26:48 -0800 (PST)
Received: from localhost (198-0-60-179-static.hfc.comcastbusiness.net. [198.0.60.179])
        by smtp.gmail.com with ESMTPSA id p17sm565596pfn.31.2020.02.19.13.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 13:26:47 -0800 (PST)
Date:   Wed, 19 Feb 2020 13:26:46 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Message-ID: <5e4da816bc74b_11742b0a4da1a5b8ca@john-XPS-13-9370.notmuch>
In-Reply-To: <20200219205514.3353788-1-ast@kernel.org>
References: <20200219205514.3353788-1-ast@kernel.org>
Subject: RE: [PATCH bpf-next] selftests/bpf: Fix build of sockmap_ktls.c
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> The selftests fails to build with:
> tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c: In function =E2=80=
=98test_sockmap_ktls_disconnect_after_delete=E2=80=99:
> tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c:72:37: error: =E2=
=80=98TCP_ULP=E2=80=99 undeclared (first use in this function)
>    72 |  err =3D setsockopt(cli, IPPROTO_TCP, TCP_ULP, "tls", strlen("t=
ls"));
>       |                                     ^~~~~~~
> =

> Similar to commit that fixes build of sockmap_basic.c on systems with o=
ld
> /usr/include fix the build of sockmap_ktls.c
> =

> Fixes: d1ba1204f2ee ("selftests/bpf: Test unhashing kTLS socket after r=
emoving from map")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c | 1 +
>  1 file changed, 1 insertion(+)
> =

> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c b/to=
ols/testing/selftests/bpf/prog_tests/sockmap_ktls.c
> index 589b50c91b96..06b86addc181 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
> @@ -7,6 +7,7 @@
>  #include "test_progs.h"
>  =

>  #define MAX_TEST_NAME 80
> +#define TCP_ULP 31
>  =

>  static int tcp_server(int family)
>  {
> -- =

> 2.23.0
> =


Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
