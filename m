Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 254DD86AF8
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390259AbfHHT5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:57:42 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46897 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732704AbfHHT5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:57:42 -0400
Received: by mail-ot1-f66.google.com with SMTP id z17so5103386otk.13
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 12:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LI+HiWab3COKRaiLaXikF8QtEjNaA+Orh5U902IfyAw=;
        b=ilEWIHwrOUcfW+iALCTaj+3hiHJe3W1qJTRc16uu3PmvuguT0ykxtQue+ZI1sv11YS
         T4vnHi7Rv1uKEls77XDkUqgEpMxHlooVKuBu8qJN6XDVEjn6OVjZ+I/6DKhtFbEAYqfT
         ziWQcfcQAkKDNC357pGhoYyU9PErF+OL5TOcVcxMnZRiyuCmbq/tH+XxL9DD/7P5qqp9
         oVwnUmLaLy4T3HxwTL4EvNgEXV/1yHih4nEh4hRY+fKGn7byJ+kZ2jE4N0CDOTBpwKxR
         VX0kNyqojmHUh681WsTVHVdv/yTmuM1tppWl93oCafHPKyjVNKyatKvbV2nK9OZGN4eB
         Q0dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LI+HiWab3COKRaiLaXikF8QtEjNaA+Orh5U902IfyAw=;
        b=L3vsUAbH8Noa0sd5VoC11cZUzzLO3somk5eO3S9ug/dA2Xe62w0hCplrjqEBpLW1nl
         vqT9rBhoJ1FXHgifKanExH5H+j8+1Izt/a0dzEXczK0PWnT5gzQVVwb0s2jyHPvirGu2
         4HMiYh6hqc8sk2FmvvcHuad+XXK4H5FqUGli6bLSrPdLhHD4+lfMlPsh5StV5/T5A8bs
         HN/VUYC9jYkWcuPFWgusCUmkVIJ4jvjjB8lhcOuS6msVSHeBOJ9mLT7liDbRa1JYQ1if
         ZexroF60FNdePW3afUo8knizLqLyZNwPv9iailgGhotXDQyaA3m2G4MtSpXQxXnEnyT0
         z4Aw==
X-Gm-Message-State: APjAAAVDJKfPeP/QVnnzkM8RPJhuj7s392dH8WfUEglwptAStC6+0Mnu
        J5v6ey2DIKs29/ahHjnzIkcAXQOXdSQ2633lgPg=
X-Google-Smtp-Source: APXvYqySx4s9HU3FDe8xgikUFnWuxwoppVSftTnLzpb5HzKBL61Yg5cW5+eDy97RgH0vDDHb4rNuZb+GuNcypuVGMgs=
X-Received: by 2002:a5d:9d58:: with SMTP id k24mr16441688iok.116.1565294261191;
 Thu, 08 Aug 2019 12:57:41 -0700 (PDT)
MIME-Version: 1.0
References: <156415721066.13581.737309854787645225.stgit@alrua-x1>
 <CAADnVQJpYeQ68V5BE2r3BhbraBh7G8dSd8zknFUJxtW4GwNkuA@mail.gmail.com> <87k1bnsbds.fsf@toke.dk>
In-Reply-To: <87k1bnsbds.fsf@toke.dk>
From:   Y Song <ys114321@gmail.com>
Date:   Thu, 8 Aug 2019 12:57:05 -0700
Message-ID: <CAH3MdRWk_bZVpBUZ8=xsMNw2hUwnQ3Yv-otu9M+7f1Cwr-t1UA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/6] xdp: Add devmap_hash map type
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 8, 2019 at 12:43 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Fri, Jul 26, 2019 at 9:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> This series adds a new map type, devmap_hash, that works like the exis=
ting
> >> devmap type, but using a hash-based indexing scheme. This is useful fo=
r the use
> >> case where a devmap is indexed by ifindex (for instance for use with t=
he routing
> >> table lookup helper). For this use case, the regular devmap needs to b=
e sized
> >> after the maximum ifindex number, not the number of devices in it. A h=
ash-based
> >> indexing scheme makes it possible to size the map after the number of =
devices it
> >> should contain instead.
> >>
> >> This was previously part of my patch series that also turned the regul=
ar
> >> bpf_redirect() helper into a map-based one; for this series I just pul=
led out
> >> the patches that introduced the new map type.
> >>
> >> Changelog:
> >>
> >> v5:
> >>
> >> - Dynamically set the number of hash buckets by rounding up max_entrie=
s to the
> >>   nearest power of two (mirroring the regular hashmap), as suggested b=
y Jesper.
> >
> > fyi I'm waiting for Jesper to review this new version.
>
> Ping Jesper? :)

Toke, the patch set has been merged to net-next.
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=
=3Dd3406913561c322323ec2898cc58f55e79786be7

>
> -Toke
