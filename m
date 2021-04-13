Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F8E35E8F2
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347257AbhDMWSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbhDMWSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 18:18:41 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917E4C061574;
        Tue, 13 Apr 2021 15:18:21 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id c195so19882543ybf.9;
        Tue, 13 Apr 2021 15:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bd7fqYh5LO3bEok4xPNV0VnP9oPXB8+3qeiCw3rycvA=;
        b=NQv+fC4YU97VEE09EwZmiFaWbjmZuWSfPJzeJjLWNlLOX+OpU1RaeKcr8wDaNmcZXY
         63YEqgmc1527mdYd0g1j0ueTSEtlypS/prFx345wdlhhzP4rBuXAMku8E1J/cmlIvzVE
         Mo1VKAKfXSUC0jmd2KYUUtZglz4BnI6EW2mbXFUDpgXz9t0ZccGBUs73BawjNgwXB79a
         xBMQoLHS0Q0u1iUQhnPjjAdQ7wgjTj/w8MnrTGRNlfuNyWrFUOGL0M8ZWvuSDxxbxkr8
         +pqN4yzli20q5hBScR068k/gprfr/p8/+6G8y9C6pT8kJR7aJwueIia/0N87qdrZbXqI
         5dpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bd7fqYh5LO3bEok4xPNV0VnP9oPXB8+3qeiCw3rycvA=;
        b=d5LPfSxUNo2FAEKWBdNZ65zJTuSrN/Cvy9D5rZPkQ7RiMl2WFafnEjgUXICchhsRnK
         FmLlmaFsgN7QHT1b5Jc80d7ACD+nAmawytIfmRZ8c8YBoSC3C1U+r4wWU+y8ihgMzpED
         eZXq5zjncMjhTrzAg1YavNxSYYMb6S6LfqwgXrTa3uWBlmtkyK49pdbOHGq8ukgOW2Lj
         A+UBodGhTqCZR40PYNmxNKHUyhfaYh+m7rK/jDrVX9prc/YPlaIWPh9Blew+ozhJKjo/
         Qyl9yFNAJezI0JV2BhdL4boCSu9uBEjq6uCeL6dMCDWsvZp0MrlIOe2F/+UpLGH2V+cE
         6Diw==
X-Gm-Message-State: AOAM530ewOnVC9zZGoEifepkb1bsSx2IcLUd+Ky6zM6hLc4hGTArFncT
        gzAEOowB7072ULRi61TcbsSXwYutmznRk9mgfDc=
X-Google-Smtp-Source: ABdhPJyk67mnwYw+qePAAL4jHTp0oNni6Ua5ZFeVs93cD9K1ZOtNYqJ7Bz1Rp2ICBBl8rb4c03KHO2E66m29aI6EcIQ=
X-Received: by 2002:a25:3357:: with SMTP id z84mr39122289ybz.260.1618352300905;
 Tue, 13 Apr 2021 15:18:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210412034813.EK9k9%akpm@linux-foundation.org> <7208c4e4-8ff1-7e0d-50ad-6b0aae872a6d@infradead.org>
In-Reply-To: <7208c4e4-8ff1-7e0d-50ad-6b0aae872a6d@infradead.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Apr 2021 15:18:10 -0700
Message-ID: <CAEf4BzZBHUX=8=FYwq0bp6GFkOTxCbtiJN31SSoWCsMyh7_hMg@mail.gmail.com>
Subject: Re: mmotm 2021-04-11-20-47 uploaded (bpf: xsk.c)
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, broonie@kernel.org,
        mhocko@suse.cz, Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>,
        mm-commits@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 9:38 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 4/11/21 8:48 PM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2021-04-11-20-47 has been uploaded to
> >
> >    https://www.ozlabs.org/~akpm/mmotm/
> >
> > mmotm-readme.txt says
> >
> > README for mm-of-the-moment:
> >
> > https://www.ozlabs.org/~akpm/mmotm/
> >
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> >
> > You will need quilt to apply these patches to the latest Linus release =
(5.x
> > or 5.x-rcY).  The series file is in broken-out.tar.gz and is duplicated=
 in
> > https://ozlabs.org/~akpm/mmotm/series
> >
> > The file broken-out.tar.gz contains two datestamp files: .DATE and
> > .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss=
,
> > followed by the base kernel version against which this patch series is =
to
> > be applied.
> >
> > This tree is partially included in linux-next.  To see which patches ar=
e
> > included in linux-next, consult the `series' file.  Only the patches
> > within the #NEXT_PATCHES_START/#NEXT_PATCHES_END markers are included i=
n
> > linux-next.
> >
> >
> > A full copy of the full kernel tree with the linux-next and mmotm patch=
es
> > already applied is available through git within an hour of the mmotm
> > release.  Individual mmotm releases are tagged.  The master branch alwa=
ys
> > points to the latest release, so it's constantly rebasing.
> >
> >       https://github.com/hnaz/linux-mm
> >
> > The directory https://www.ozlabs.org/~akpm/mmots/ (mm-of-the-second)
> > contains daily snapshots of the -mm tree.  It is updated more frequentl=
y
> > than mmotm, and is untested.
> >
> > A git copy of this tree is also available at
> >
> >       https://github.com/hnaz/linux-mm
>
> on x86_64:
>
> xsk.c: In function =E2=80=98xsk_socket__create_shared=E2=80=99:
> xsk.c:1027:7: error: redeclaration of =E2=80=98unmap=E2=80=99 with no lin=
kage
>   bool unmap =3D umem->fill_save !=3D fill;
>        ^~~~~
> xsk.c:1020:7: note: previous declaration of =E2=80=98unmap=E2=80=99 was h=
ere
>   bool unmap, rx_setup_done =3D false, tx_setup_done =3D false;
>        ^~~~~
> xsk.c:1028:7: error: redefinition of =E2=80=98rx_setup_done=E2=80=99
>   bool rx_setup_done =3D false, tx_setup_done =3D false;
>        ^~~~~~~~~~~~~
> xsk.c:1020:14: note: previous definition of =E2=80=98rx_setup_done=E2=80=
=99 was here
>   bool unmap, rx_setup_done =3D false, tx_setup_done =3D false;
>               ^~~~~~~~~~~~~
> xsk.c:1028:30: error: redefinition of =E2=80=98tx_setup_done=E2=80=99
>   bool rx_setup_done =3D false, tx_setup_done =3D false;
>                               ^~~~~~~~~~~~~
> xsk.c:1020:37: note: previous definition of =E2=80=98tx_setup_done=E2=80=
=99 was here
>   bool unmap, rx_setup_done =3D false, tx_setup_done =3D false;
>                                      ^~~~~~~~~~~~~
>
>
> Full randconfig file is attached.

What SHA are you on? I checked that github tree, the source code there
doesn't correspond to the errors here (i.e., there is no unmap
redefinition on lines 1020 and 1027). Could it be some local merge
conflict?

>
> --
> ~Randy
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
