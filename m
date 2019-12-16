Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4B7120946
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 16:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbfLPPEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 10:04:55 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34374 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbfLPPEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 10:04:55 -0500
Received: by mail-lf1-f66.google.com with SMTP id l18so4494031lfc.1;
        Mon, 16 Dec 2019 07:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hqMxtYK86E/dK/JkCXWfrBWfWCnClygQ3fiSuT/+OCk=;
        b=E+1PIwoPOoOCmQl+gN9b3UwDF7ZjcZJvSsMZuO+gWnjX9h2Fswrfi4WL7l6UBzSREh
         0ObA1dNI1oP1RjZE2x0RvJgKYICIXRYamNRp6YOPKStHsQJOcHtkmXljlPWfwofoNHuX
         8k110n6t4Ol5Sxb9CAn6eaygq1w6QKX0LGRONDLAVrwrIgnunNnUPn24Jh2tyjT86S0b
         LZ2qpEtrkgcd2Z0OQJaTxxBrGsm/a3beEyBt4eqV2CuS6JjJZlht8Z55e8t84bN4r9vS
         U7lzgcotKgPQaZb/mHOkSzryD7ZltZWJxlIxkwez2A0zADOQ/9ETIenshtM48sC/Pndi
         ymxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hqMxtYK86E/dK/JkCXWfrBWfWCnClygQ3fiSuT/+OCk=;
        b=BXuUlUSurzZlhp7v5H7M2XnA+N6xAeS/N5exws03I9xKe/0wDurrT6FuNte5Iz01WF
         TLqKpz9/4yF0P309CcWhOoUR8A0nwiTUQPbsIBOfu/7b/D16zBo2jWb3VvLwmFGAAEhw
         b6MEZsgARaaWCwvR98JfmBL3XJHHofT4pNQo9WK0SxNPAACwOwOyBklbqvMrXemWWbgr
         x4p/YC0eB81Oam2qZxduK0oPQtis4LqCD78BQd+//wAwvlR2kjXyQApeXEWGVBXGC0kM
         C8fHtddG+VMAtWGZ2cdFu9SFhiWYwILG+21bnRv60riKKBe7Y4bhiHD0OIFvp0htLv3F
         Mz2g==
X-Gm-Message-State: APjAAAUSFXsLiKLvLbbA98+bLmMrEcDBD0NbG9lj+2FkpFkGaVIxsdIB
        ayfQEbB1ipTT9TKLuDiHuu1YUhS3T0g/El+6fqI=
X-Google-Smtp-Source: APXvYqyoUwpnNeJu6ovp67D7t/iHvbG/t29Oy+2vD8gSnZbRUa+UmmGr/4Kp7RAwr7cQvtZAMxl1ZyiD36rNErwKdeo=
X-Received: by 2002:a19:888:: with SMTP id 130mr17125559lfi.167.1576508692892;
 Mon, 16 Dec 2019 07:04:52 -0800 (PST)
MIME-Version: 1.0
References: <20191216103819.359535-1-toke@redhat.com>
In-Reply-To: <20191216103819.359535-1-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 16 Dec 2019 07:04:40 -0800
Message-ID: <CAADnVQJYJ5XakE2cGDvzi4fX2zpoiwkjFMxWn05=44NWhDTpGw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples/bpf: Set -fno-stack-protector when
 building BPF programs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 2:38 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> It seems Clang can in some cases turn on stack protection by default, whi=
ch
> doesn't work with BPF. This was reported once before[0], but it seems the
> flag to explicitly turn off the stack protector wasn't added to the
> Makefile, so do that now.
>
> The symptom of this is compile errors like the following:
>
> error: <unknown>:0:0: in function bpf_prog1 i32 (%struct.__sk_buff*): A c=
all to built-in function '__stack_chk_fail' is not supported.
>
> [0] https://www.spinics.net/lists/netdev/msg556400.html
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Applied. Thanks
