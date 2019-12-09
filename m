Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 121681172FF
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfLIRmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:42:35 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38192 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfLIRmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:42:35 -0500
Received: by mail-qk1-f194.google.com with SMTP id k6so13827501qki.5;
        Mon, 09 Dec 2019 09:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DlAlEZc0H305aiJasyWlE8NinnS6GUDEys3Ccy9M+LM=;
        b=fWcAr3pPEW/3oxGvUT095JEisSFGMdW1LQD29GFpCt1+P6vUItuK8jw/R3dWd5pY7p
         JkzP3ihVlHwpTQGR2+zJdA3camyuootBTJNlawefR6HQ771GRYqc/huJs1XpF501z7rN
         jvQ5vcA6eraem4EVeL9CV3fRuTh0lwVn/bUerTJ7QtN0Mxq7owtjywFSXAkpkaPod135
         TrAMhITXBpRTzSO8nTYjF3uNVFLA2Qwrr/B5R2jvAAFoAhOlVwn+8ZCbzMU2PaYX2k+9
         feLNx29mbC0hOOZQY7U0FCvcAeu/Qsbni6i10vZS/scASGVfy46Boc2xpT6X/K/dgJwN
         CK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DlAlEZc0H305aiJasyWlE8NinnS6GUDEys3Ccy9M+LM=;
        b=n7MweM3Vc3+kQFbjjVqSP+KIqlyFH7jck5Hozy0NkKzRMmhcOfDzWyY8WInbZwLQsB
         H/+MeYz5VfPIQgfCmoyXrOggdgbeuS5lHNcUxdNLo8QwFJLSnFOu8b05LME44jgK+dPa
         orpWhqzmDFJ5l7Bzi47GS3NcJ54RAWPmTDDu1YKN8A4/MuTDm3+XDay1Qk35RKRku1oq
         HQWlxWFzqaBniRBY0q1X9nBbgxK0VKp/tfz/sLg4GyU9bcThO0JnP3L/rtLbRvMkZ+68
         6epFZhZHqQAok4GIhwVliyCAxSYzVKNqM1D+xCYne9xfzXVQucttRXdnZqx8QUW9MCR0
         vvTg==
X-Gm-Message-State: APjAAAWjfYLupvr2K3sr17lrzC3HWnQqeTDCFWIBxmDbubJwUVrXH7QQ
        /nHhGVQmiUEys2PBz0+ZbgCm3SrEwqSVm5IGTfg=
X-Google-Smtp-Source: APXvYqwYwiTtpVKXund9GsVQS6rtyIblmhcL5g15p9UVk9itaQ7tmMGaz4BhvUiDEV/xWjYh/b6oSM9HjrBSKq/lY6I=
X-Received: by 2002:a37:9c0f:: with SMTP id f15mr28796296qke.297.1575913353977;
 Mon, 09 Dec 2019 09:42:33 -0800 (PST)
MIME-Version: 1.0
References: <20191209135522.16576-1-bjorn.topel@gmail.com> <87h829ilwr.fsf@toke.dk>
In-Reply-To: <87h829ilwr.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 9 Dec 2019 18:42:22 +0100
Message-ID: <CAJ+HfNjZnxrgYtTzbqj2VOP+5A81UW-7OKoReT0dMVBT0fQ1pg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/6] Introduce the BPF dispatcher
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Dec 2019 at 16:00, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.=
com> wrote:
>
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>
[...]
>
> I like the new version where it's integrated into bpf_prog_run_xdp();
> nice! :)
>

Yes, me too! Nice suggestion!

> > The XDP dispatcher is always enabled, if available, because it helps
> > even when retpolines are disabled. Please refer to the "Performance"
> > section below.
>
> Looking at those numbers, I think I would moderate "helps" to "doesn't
> hurt" - a difference of less than 1ns is basically in the noise.
>
> You mentioned in the earlier version that this would impact the time it
> takes to attach an XDP program. Got any numbers for this?
>

Ah, no, I forgot to measure that. I'll get back with that. So, when a
new program is entered or removed from dispatcher, it needs to be
re-jited, but more importantly -- a text poke is needed. I don't know
if this is a concern or not, but let's measure it.


Bj=C3=B6rn

> -Toke
>
