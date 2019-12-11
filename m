Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A3911AB12
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 13:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbfLKMiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 07:38:14 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:40557 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbfLKMiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 07:38:13 -0500
Received: by mail-qv1-f65.google.com with SMTP id k10so4039777qve.7;
        Wed, 11 Dec 2019 04:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CQk2Nxee7Zcdm3hAjI/D3a7hGTTJ2wRYtO1TPkIIDNE=;
        b=s1eHc2P9bJ0iukevCS2MaStDALxCIAv4P96FLoGxy4DU/iP3kPjJTmvJQ7Omts9ju/
         Bj/fkkxl1N1y6cmWBHI3bV1Bd8aZJcBdwYjc1v8CN858o0AwXFZD5oRsTCOA0bBEzp15
         we3GQYYIWsrLR3OOfW+9277PPzliN5e6cY7kStnybXaAs2cLJkE7kYylHpKWZgEa70mY
         g7yR6X0HqJ09lKEuqLplrdZ6yuq8Qut306y/KR+uKAaBZBfL0tK6PQugU8Vhlgv2YPaE
         vgeRStx3pocBjtyciRHFxfiXg6Hp0LtmqTpMWtGs/LfyOvR926oNo24Wu1JLYGvMPzr3
         9pag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CQk2Nxee7Zcdm3hAjI/D3a7hGTTJ2wRYtO1TPkIIDNE=;
        b=Ld/M1M5hq9T/yfM25lLcgDGOyrz2Y4FhEwlteqpVRRyhpRgbGlRZ82dXSz+NIrzxKX
         eQfyb+GLXtViW9tX2KkJGTyRfQJ+ww0GtBMA/qf6x3tlpnAN7ZZuED+B1CqJiDzJcuFQ
         pBCh0HUdKBRcAr/gTIxtxxhKhIudtat96eiVNQNb4o24n8RrqZbtB/ou4J4HTONYh7Aq
         DFLJCHRxFMvf4kyRRabIRdwNgpzHQiq/kLhGCO/W7oH2BnBBmOAhSLSwuDOS2pzQguMB
         1RtLnCgUWv/NstPCYnJRx2BPTYGCKR9N+9es9L2RXOkKzQla61wfiin4iskjoubEW7eY
         wg0w==
X-Gm-Message-State: APjAAAXggCVzbKpQXi1mpYtCq9G4v7g8h6Ze/Rz0EJtd+4DiP4DapJq5
        SGfKq6wmyK5xkSUx+uXvuG7WcJkelVYUdBnfHq0GXqj+c9k=
X-Google-Smtp-Source: APXvYqwo5EhzUFagCmi0bIUTak2sLbw+HZcUN5372PbiQwN2QnctG/hRYwrl6H2HTnzBxXjEfThKaFcSHHLJyUeLb0A=
X-Received: by 2002:a05:6214:448:: with SMTP id cc8mr2756750qvb.10.1576067892709;
 Wed, 11 Dec 2019 04:38:12 -0800 (PST)
MIME-Version: 1.0
References: <20191209135522.16576-1-bjorn.topel@gmail.com> <87h829ilwr.fsf@toke.dk>
 <CAJ+HfNjZnxrgYtTzbqj2VOP+5A81UW-7OKoReT0dMVBT0fQ1pg@mail.gmail.com>
In-Reply-To: <CAJ+HfNjZnxrgYtTzbqj2VOP+5A81UW-7OKoReT0dMVBT0fQ1pg@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 11 Dec 2019 13:38:01 +0100
Message-ID: <CAJ+HfNiH4KUO-MXm3L8pka3dECC1S6rHUJ9NoMfyrhPD+9s9nw@mail.gmail.com>
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

On Mon, 9 Dec 2019 at 18:42, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> =
wrote:
>
[...]
> > You mentioned in the earlier version that this would impact the time it
> > takes to attach an XDP program. Got any numbers for this?
> >
>
> Ah, no, I forgot to measure that. I'll get back with that. So, when a
> new program is entered or removed from dispatcher, it needs to be
> re-jited, but more importantly -- a text poke is needed. I don't know
> if this is a concern or not, but let's measure it.
>

Toke, I tried to measure the impact, but didn't really get anything
useful out. :-(

My concern was mainly that text-poking is a point of contention, and
it messes with the icache. As for contention, we're already
synchronized around the rtnl-lock. As for the icache-flush effects...
well... I'm open to suggestions how to measure the impact in a useful
way.

>
> Bj=C3=B6rn
>
> > -Toke
> >
