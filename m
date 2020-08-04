Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2880C23B8DB
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 12:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbgHDKfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 06:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729385AbgHDKfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 06:35:21 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3417DC06174A;
        Tue,  4 Aug 2020 03:35:21 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id o1so22612452plk.1;
        Tue, 04 Aug 2020 03:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=2ca/QrowQ6tGL3YlTY/zRzYbbmOdjci7HQ5UaZxrd7U=;
        b=uhLd9SNImtAJuG345pumkWc7FFAQzZbxGRfbrVJwZOpFi4CFPdRWTGdoq2H3T0vOIf
         MaMUXqtaXYbapCXrNGKUHCPvOvPbH48p3S+Lh/MiWYGV70NumnYN01whEEXCcC74VfSJ
         O+pReSH2YR+ZeXiNNx+NYXjlSQwbhY19LtlSyzYFXKPo4O7Om7yX5vj574VhSms6uEu6
         ijHHACvc1QRuoqvMh/oNutsSd8CJAsXocXVTOQRMMuGbtKpzTcsUbMKndywIf6YmdZV8
         cDsbV5FXHNaBwFpLZF9sHJ8u/+LIDFjL7JU4YIg25KyMSCRnpW5U24qhJfGEVDtRBOpV
         0oBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=2ca/QrowQ6tGL3YlTY/zRzYbbmOdjci7HQ5UaZxrd7U=;
        b=m9VJIWVfrnzKdlxLxDoDEdJURni2iwTrxhbNdrFmCnjUNBb/fLc3CrRhaIhzvATFuA
         /FDai88bBV0sUTqTdAWgVVtl2Ok4Y8bbO7sYVbkoNyZoNHEf1pWt1ZTTo6B8YRDXG0F3
         aayyYQSN9GGa09dlX5eyuE5qYXdJ7bYsPhfINAzH2vGi6Qc7GEwKP4XZ/6zFwD7i8zwi
         qYlCSZ6qV41a8vO54PDK/b/G+bc6jpZaKoQF3Tc0/SdVeqBwHI2AnQkGAz2FH7dezQ58
         mNG/MpJ1IcZBV1SI4KshLPrEJUddizRSXyCbEscI+hS0IH/R0uREmkj1qj8DM3wAYCJm
         NbWw==
X-Gm-Message-State: AOAM533VeDEJtzCQ3tD4eFvTsRHc6I5ZxtOpvSE6p46JDN/xmuF/ZzG4
        Da6owVrPwU91PxDqn4sJnzg=
X-Google-Smtp-Source: ABdhPJwjcEZYdFXpZlVncxXwOGmBxS40h8pb5EBVuCCmMlX4rkSI/BzBmx2fZnLM03kW9tha0ACSQw==
X-Received: by 2002:a17:90a:6787:: with SMTP id o7mr3674376pjj.76.1596537320665;
        Tue, 04 Aug 2020 03:35:20 -0700 (PDT)
Received: from [192.168.97.34] (p7925058-ipngn38401marunouchi.tokyo.ocn.ne.jp. [122.16.223.58])
        by smtp.gmail.com with ESMTPSA id z62sm22004085pfb.47.2020.08.04.03.35.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Aug 2020 03:35:20 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.15\))
Subject: Re: [RFC PATCH bpf-next 3/3] samples/bpf: Add a simple bridge example
 accelerated with XDP
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
In-Reply-To: <CAEf4BzaRKhJqFmXJEQy5LOjKx9nkPgAKHa3cesvywy2qqg93YA@mail.gmail.com>
Date:   Tue, 4 Aug 2020 19:35:08 +0900
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org, bpf <bpf@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1BA4E035-5045-4D62-BA39-F3990CA4EF1E@gmail.com>
References: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
 <1596170660-5582-4-git-send-email-komachi.yoshiki@gmail.com>
 <CAEf4BzaRKhJqFmXJEQy5LOjKx9nkPgAKHa3cesvywy2qqg93YA@mail.gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
X-Mailer: Apple Mail (2.3445.104.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> 2020/08/01 2:48=E3=80=81Andrii Nakryiko =
<andrii.nakryiko@gmail.com>=E3=81=AE=E3=83=A1=E3=83=BC=E3=83=AB:
>=20
> On Thu, Jul 30, 2020 at 9:45 PM Yoshiki Komachi
> <komachi.yoshiki@gmail.com> wrote:
>>=20
>> This patch adds a simple example of XDP-based bridge with the new
>> bpf_fdb_lookup helper. This program simply forwards packets based
>> on the destination port given by FDB in the kernel. Note that both
>> vlan filtering and learning features are currently unsupported in
>> this example.
>>=20
>> There is another plan to recreate a userspace application
>> (xdp_bridge_user.c) as a daemon process, which helps to automate
>> not only detection of status changes in bridge port but also
>> handling vlan protocol updates.
>>=20
>> Note: David Ahern suggested a new bpf helper [1] to get master
>> vlan/bonding devices in XDP programs attached to their slaves
>> when the master vlan/bonding devices are bridge ports. If this
>> idea is accepted and the helper is introduced in the future, we
>> can handle interfaces slaved to vlan/bonding devices in this
>> sample by calling the suggested bpf helper (I guess it can get
>> vlan/bonding ifindex from their slave ifindex). Notice that we
>> don't need to change bpf_fdb_lookup() API to use such a feature,
>> but we just need to modify bpf programs like this sample.
>>=20
>> [1]: http://vger.kernel.org/lpc-networking2018.html#session-1
>>=20
>> Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
>> ---
>=20
> Have you tried using a BPF skeleton for this? It could have saved a
> bunch of mechanical code for your example. Also libbpf supports map
> pinning out of the box now, I wonder if it would just work in your
> case. Also it would be nice if you tried using BPF link-based approach
> for this example, to show how it can be used. Thanks!
>=20

It is still under consideration, but these features seems to be useful =
for
this example.

I would try to apply them in the next version.

Thank you for giving me good advice.

Best regards,

>=20
>> samples/bpf/Makefile          |   3 +
>> samples/bpf/xdp_bridge_kern.c | 129 ++++++++++++++++++
>> samples/bpf/xdp_bridge_user.c | 239 =
++++++++++++++++++++++++++++++++++
>> 3 files changed, 371 insertions(+)
>> create mode 100644 samples/bpf/xdp_bridge_kern.c
>> create mode 100644 samples/bpf/xdp_bridge_user.c
>>=20
>=20
> [...]

=E2=80=94
Yoshiki Komachi
komachi.yoshiki@gmail.com

