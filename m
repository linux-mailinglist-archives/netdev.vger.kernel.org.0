Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C71177BE3
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbgCCQ16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:27:58 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38067 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729598AbgCCQ16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 11:27:58 -0500
Received: by mail-lj1-f195.google.com with SMTP id w1so4211939ljh.5;
        Tue, 03 Mar 2020 08:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6NizXeEgQtj7OHhrUvzWf+RxeVKw/MJ7E7M98rZwZHs=;
        b=TCvbfOWaHFL5PVcFhg/r11H9lRIUO8AsKlizzW42uIt5o25qkU+WaujtaCqOh5gJhp
         UTHhGUEFxjI44knsQlP/JDv4oNDhuJeUiFsEZeT1rIzo2QL0uqXKzWk4657jgj1DYpqj
         mHh+CjpUo39eMGoVtpcY0olZmbR0cejpAFQw8n1ydX/JP48bS2Vf403nVv2App1kXXMv
         sgQTj6V17qgpaZ0HuooNtvs6fUgZIHu2BJuqmttKr6/r8zFzXC5je8JhyokvR2FPQicV
         KwKBs6kwh+JUT+xrLOYjXTUsQ3spxvXJ0kSsuTDinUUMumFaOnw05gZwxFg7zawdl9H8
         44nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6NizXeEgQtj7OHhrUvzWf+RxeVKw/MJ7E7M98rZwZHs=;
        b=OALELv/PFkSODB5pWb8dZWbLmS1kAeYitiB39rnv/DV0fTYEGvBCfZCf5jVqabNA59
         aGNHGKJDJhRMaF0fKnM540o9QxMn1hYPH+IEiiPHp2qrH7NTTxW5OrybhB1FL63h1h8K
         0vpR13M816kf7ZGjiv64g/Rr9ZG9Vd9XQFZrvnDW/ZtIDe9e6FdDO0CxNICNn2AU0Thp
         KETW3gGIr+COgsjIuO7xx0D1EzAiptQjgQLS6ZoAxELtSaPMV0ULq4FBpc1TcHQzMvrP
         GT5F6DjMpCUQTH34Irpm2DJBIsahRjNLtM9vdJ5jzL5ifTindRAXOctZD2HoTjcRje8F
         +5Dg==
X-Gm-Message-State: ANhLgQ0KVPs0cynkjryT9q4Y9+5Xf3g8kc2+wjnRN7GITYMU0olz0LBl
        TFnGTg7CLqIgvC/KFYt6K91J9w42KyeR2r41PbXFOw==
X-Google-Smtp-Source: ADFU+vtIuyG1I0sIW/QxxXIzpv7RjBRoe1+fMP6EsFfrW42qEGO8uAlBouyWB2w5F2eRgESa0j2fiXC4tbgKa1AszRo=
X-Received: by 2002:a2e:b80b:: with SMTP id u11mr3005972ljo.143.1583252875902;
 Tue, 03 Mar 2020 08:27:55 -0800 (PST)
MIME-Version: 1.0
References: <20200302145348.559177-1-toke@redhat.com> <20200303010311.bg6hh4ah5thu5q2c@ast-mbp>
 <87d09tsvu1.fsf@toke.dk>
In-Reply-To: <87d09tsvu1.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 3 Mar 2020 08:27:44 -0800
Message-ID: <CAADnVQKKBpSGZ3vQWy_Y5vLqJsyY3cCnwmeW9hU1Xu0L_9zqiQ@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: Declare bpf_log_buf variables as static
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 3, 2020 at 12:10 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Mon, Mar 02, 2020 at 03:53:48PM +0100, Toke H=C3=83=C2=B8iland-J=C3=
=83=C2=B8rgensen wrote:
> >> The cgroup selftests did not declare the bpf_log_buf variable as stati=
c, leading
> >> to a linker error with GCC 10 (which defaults to -fno-common). Fix thi=
s by
> >> adding the missing static declarations.
> >>
> >> Fixes: 257c88559f36 ("selftests/bpf: Convert test_cgroup_attach to pro=
g_tests")
> >> Signed-off-by: Toke H=C3=83=C2=B8iland-J=C3=83=C2=B8rgensen <toke@redh=
at.com>
> >
> > Applied to bpf-next.
> > It's hardly a fix. Fixes tag doesn't make it a fix in my mind.
>
> It fixes a compile error of selftests with GCC 10; how is that not a
> fix? We found it while setting up a CI test compiling Linus' tree on
> Fedora rawhide, so it does happen in the wild.
>
> > I really see no point rushing it into bpf->net->Linus's tree at this po=
int.
>
> Well if you're not pushing any other fixes then OK, sure, no reason to
> go through the whole process just for this. But if you end up pushing
> another round of fixes anyway, please include this as well. If not, I
> guess we can wait :)

CI stands for Continuous Integration =3D=3D development.
stable tree is not for development.
If you want to develop anything or accommodate the tree
for external development you need to use development tree.
Which is bpf-next.
