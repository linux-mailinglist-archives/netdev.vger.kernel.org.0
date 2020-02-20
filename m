Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89FAF1664DA
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 18:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgBTR37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 12:29:59 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:32778 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728115AbgBTR37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 12:29:59 -0500
Received: by mail-qt1-f194.google.com with SMTP id d5so3451021qto.0;
        Thu, 20 Feb 2020 09:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Cr2F/agim5KEWq0/zdOgrWhvT2lVWIUKBrK1sJFAva8=;
        b=EmMHhuAvBf2lyMKPswBWcyufSx/yvOR+vPYVbSoU5rVuamI3sd58w5lYvpZ27mpwHx
         tiDDIsaBJOU+WkHycLpE256RYnOjD+jWthyp3eGjsF9o2W+AD/W8SR5wAS0rPzIa3TQm
         K5GRn1H1JYQOouxUeALhoZM/ozwGg/pz9PujxpM18OVIQEa/RqorLOQUldCtISSmRV+h
         eUU7NqEX2bWZX3DwvFeT9uI+rjbAnEq4kAVxpVpFQ8RqV1IRw8KV7GOFN986M0OJmlYd
         A4c8c8h1En5ryiqTLPJtf5uSEpPNwqSQDDou204+L3YzJLv2PYvMiGQ/jYWUEgxqdtT3
         dRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Cr2F/agim5KEWq0/zdOgrWhvT2lVWIUKBrK1sJFAva8=;
        b=lk+96UCl1dl1riqsldp6WVt8o+gxW/xaiwByBWsAWrIPzJkOI36eSOPoCT/FjOgk9m
         FPGQ6pid0EYRI08zqfHuqt7qhyd0bfpxuf99h9BOgWFeLFN8fC1qWWukbDYOx37X7vjk
         1Zhbdr4yrlgrFFIdbG5tki7S7m+GWoAbNAke9LQqZNKDUWy8qb2GJ1klUOueeP0YgFUa
         ads5dJuRUdPcyS4fRo7IevKHAkXOI3iwRVBYWs/2k1I9zYM2RID940L5uMgupHvd33B2
         xV54EZcXeu2HRRHcBJMLWCQoIJFb17H/I/Rl5PIKR8b4RrBj/I4deafMgN1C/IPRzta5
         heyQ==
X-Gm-Message-State: APjAAAU2VGbMdS5a7rvHmJLWH3lwiTqGZsKdyS/4hAqfHaUaLXOFEJEX
        /RdoaSw6Gyf3QLvzL+6qrwI9sMo6FK6zHg1bSDZIaenE
X-Google-Smtp-Source: APXvYqwJt+EyJ9VGD3Wo1/qQUCfCNhmyJEWhhAE1TEVNH+zOAfq8orDmQW15vmyFLIDOTf3ArGAJBMn53Ar/iey7zG8=
X-Received: by 2002:ac8:1385:: with SMTP id h5mr26911373qtj.59.1582219798003;
 Thu, 20 Feb 2020 09:29:58 -0800 (PST)
MIME-Version: 1.0
References: <158220517358.127661.1514720920408191215.stgit@xdp-tutorial> <158220520562.127661.14289388017034825841.stgit@xdp-tutorial>
In-Reply-To: <158220520562.127661.14289388017034825841.stgit@xdp-tutorial>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Feb 2020 09:29:47 -0800
Message-ID: <CAEf4BzaPOug4aNPZ1=c4TknfMkZ9_kUdJHQRYdqBGJLriSxQRw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 3/3] selftests/bpf: update xdp_bpf2bpf test to
 use new set_attach_target API
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 5:28 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> Use the new bpf_program__set_attach_target() API in the xdp_bpf2bpf
> selftest so it can be referenced as an example on how to use it.
>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---

Looks great, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   16 +++++++++++++-=
--
>  .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |    4 ++--
>  2 files changed, 15 insertions(+), 5 deletions(-)
>

[...]
