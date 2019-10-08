Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82AA2CF183
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 06:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbfJHENt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 00:13:49 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:42409 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfJHENt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 00:13:49 -0400
Received: by mail-yw1-f67.google.com with SMTP id i207so5967886ywc.9;
        Mon, 07 Oct 2019 21:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Auf1dMyhH1zc7fthRanyGrRI3GvJGpCy4rZb6VB9jqk=;
        b=u1IWmErhRMqpzXKg/namxbwwWLivB/Qf4zn/nCbFYD+Vg5WIImu2MrVP4ZWycsB+hc
         ldfi1X0M2Zxhu0puKydzCFgkZiqjhQnEOSbLw5ySF2RBJnO8L5vrhUCIkSsuWgfo1V0V
         9SXCFLpJkA6ztt4ZzHIgI2zuzHsvul5tlUb05KxtCA3Bky79H57F2jMTh1Iimj1U1qml
         KB/YxwlVG24LXpy3gkOoVj50ZSUMmj7IY7wCCwctrIy6A9NNPMrdOTGTbPbDxK4HCjUq
         2tDru4g9eWLvomDSIO3XlpGQ5UU4xQzCG6xq1xjxYdvW1C6NtlvlY3Q7VHHBCXEIgBpG
         0sPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Auf1dMyhH1zc7fthRanyGrRI3GvJGpCy4rZb6VB9jqk=;
        b=uPap5ptUeXcd5CinaDGE8QSKnd0Yu+YISsgGgawMo4QDSogS0jhHpUEZ1OWFCTYuEv
         lsIXCJncTPQyb0bi67G1X7yOvKz65FHcMOFjOvhgbYNyHbvmoEV1b8R1+LVk3w0ZcRHL
         0IncCVV2Mi+ZVnR6QMP3myh3YsPrI38tmDGWlYrlhgmz6DsWLAEqOIzI+GwsdQMKruGh
         YdyDG8yXjXfD+hH2dNhNBwupKCws3sZbtCKrlu9zP2zLTL7/TyLQX4cP2gxzPfDgsGS4
         g4CT8FHkzDHAhtQ6XkxCXkqhOeRIvn9hCkJYDE/TX34ih12n03t7iPLsBLt6YsfrRT4q
         IBog==
X-Gm-Message-State: APjAAAW8KgrJu5+Vh3LajBR57sNiTH8vFR+Y4Se8sgFaQohJNMBcU8lW
        uKsnu0t41tk8AQyMMvghZeACWCsDEIJ0y8a0kw==
X-Google-Smtp-Source: APXvYqxwPLWIdrbf7Exm4VG+eD/AcpKtTeCmsgQiMtlLdNwe51cRLP8ogWfyRKGCRm0FlzlanU0uemeyvmkUck0DfFo=
X-Received: by 2002:a0d:d80a:: with SMTP id a10mr20287095ywe.46.1570508028176;
 Mon, 07 Oct 2019 21:13:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191007172117.3916-1-danieltimlee@gmail.com> <CAADnVQLYuNmVSdq3to2Sjpg3WmZF54A_OPTngMRZwToiDF5PoQ@mail.gmail.com>
In-Reply-To: <CAADnVQLYuNmVSdq3to2Sjpg3WmZF54A_OPTngMRZwToiDF5PoQ@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Tue, 8 Oct 2019 13:13:32 +0900
Message-ID: <CAEKGpzjn=iW7PFkFGTGdtfW87AE=CudGjNax1TL=euaz=gz+Eg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7] samples: bpf: add max_pckt_size option at xdp_adjust_tail
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Song Liu <liu.song.a23@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 8, 2019 at 12:24 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Oct 7, 2019 at 10:21 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
> > to 600. To make this size flexible, static global variable
> > 'max_pcktsz' is added.
> >
> > By updating new packet size from the user space, xdp_adjust_tail_kern.o
> > will use this value as a new max packet size.
> >
> > This static global variable can be accesible from .data section with
> > bpf_object__find_map* from user space, since it is considered as
> > internal map (accessible with .bss/.data/.rodata suffix).
> >
> > If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
> > will be 600 as a default.
> >
> > For clarity, change the helper to fetch map from 'bpf_map__next'
> > to 'bpf_object__find_map_fd_by_name'. Also, changed the way to
> > test prog_fd, map_fd from '!= 0' to '< 0', since fd could be 0
> > when stdin is closed.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> >
> > ---
> > Changes in v6:
> >     - Remove redundant error message
>
> Applied.
> Please keep Acks if you're only doing minor tweaks between versions.

Thank you for your time and effort for the review.

I will keep that in mind for the future.

Thanks,
Daniel
