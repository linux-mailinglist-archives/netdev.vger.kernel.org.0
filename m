Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647F24AE028
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 19:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353076AbiBHR6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiBHR6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:58:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403A3C061576;
        Tue,  8 Feb 2022 09:58:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD5EB61766;
        Tue,  8 Feb 2022 17:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357B7C004E1;
        Tue,  8 Feb 2022 17:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644343110;
        bh=YThmeioGVlRtQGh5OkQwpRe54M5yvmgR9ZY/n50LRIY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rG+oCYxFv8HGDE6JoDSt9jBuo5VXMBl9ZD21V1pI8Ly2ATbN0U6AihbWH7ZKUxVYg
         6tqqHIQBN1GXuL1sNGr6qjbG8LiyUCQXR8oyQZNAJRM1tn8EU4h3TglYrk7TwojFOK
         4ddzUKPQ9CioZw1ibmDZKbSA1qZR/lHo+SPhfnULmYYPeJsvPcplPA8plYyCoPVGir
         Imi5JWQdKPMqVFWDcrGkp+EiUnZu/As5YvnbCnh6WxPlDBGLgarmCunI4IIyyMYINE
         NnF4FMHPoUt0ttCsOKTpbMea2wNwXY3or2lEdowsDLIAVZ0TWcZWBEDd9ycxrZvYVy
         T7YKlonapgbcw==
Received: by mail-yb1-f172.google.com with SMTP id m6so52102698ybc.9;
        Tue, 08 Feb 2022 09:58:30 -0800 (PST)
X-Gm-Message-State: AOAM530JjtYfecX1derNa4s59bdPMH9t+ZeiRn3nd/jQJFoHxOuTJFRI
        iQHVOp1POjv6uHDOQTynepfzNMo9kOvBajvEOAg=
X-Google-Smtp-Source: ABdhPJzy11YzMMOoas+Js5GboaV4Yyyap0cbD7IRCueOQVmr35FHuCdTWPMom70FNX4AcXsbM4shWGa8FMe3A0xxqbw=
X-Received: by 2002:a05:6902:1208:: with SMTP id s8mr6117418ybu.654.1644343109274;
 Tue, 08 Feb 2022 09:58:29 -0800 (PST)
MIME-Version: 1.0
References: <20220208152148.48534-1-pmenzel@molgen.mpg.de>
In-Reply-To: <20220208152148.48534-1-pmenzel@molgen.mpg.de>
From:   Song Liu <song@kernel.org>
Date:   Tue, 8 Feb 2022 09:58:18 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5zwFQsOHLOQ9b9eCC6Lh+frtB_c6vTP2yjg=nrAUpSEQ@mail.gmail.com>
Message-ID: <CAPhsuW5zwFQsOHLOQ9b9eCC6Lh+frtB_c6vTP2yjg=nrAUpSEQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] lib/raid6/test/Makefile: Use `$(pound)` instead of
 `\#` for Make 4.3
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Matt Brown <matthew.brown.dev@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 8, 2022 at 7:22 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Buidling `raid6test` on Ubuntu 21.10 (ppc64le) with GNU Make 4.3 shows th=
e
> errors below:
>
>     $ cd lib/raid6/test/
>     $ make
>     <stdin>:1:1: error: stray =E2=80=98\=E2=80=99 in program
>     <stdin>:1:2: error: stray =E2=80=98#=E2=80=99 in program
>     <stdin>:1:11: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98,=E2=80=
=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=80=98__attribute__=
=E2=80=99 before =E2=80=98<=E2=80=99 token
>     cp -f ../int.uc int.uc
>     awk -f ../unroll.awk -vN=3D1 < int.uc > int1.c
>     gcc -I.. -I ../../../include -g -O2                      -c -o int1.o=
 int1.c
>     awk -f ../unroll.awk -vN=3D2 < int.uc > int2.c
>     gcc -I.. -I ../../../include -g -O2                      -c -o int2.o=
 int2.c
>     awk -f ../unroll.awk -vN=3D4 < int.uc > int4.c
>     gcc -I.. -I ../../../include -g -O2                      -c -o int4.o=
 int4.c
>     awk -f ../unroll.awk -vN=3D8 < int.uc > int8.c
>     gcc -I.. -I ../../../include -g -O2                      -c -o int8.o=
 int8.c
>     awk -f ../unroll.awk -vN=3D16 < int.uc > int16.c
>     gcc -I.. -I ../../../include -g -O2                      -c -o int16.=
o int16.c
>     awk -f ../unroll.awk -vN=3D32 < int.uc > int32.c
>     gcc -I.. -I ../../../include -g -O2                      -c -o int32.=
o int32.c
>     rm -f raid6.a
>     ar cq raid6.a int1.o int2.o int4.o int8.o int16.o int32.o recov.o alg=
os.o tables.o
>     ranlib raid6.a
>     gcc -I.. -I ../../../include -g -O2                      -o raid6test=
 test.c raid6.a
>     /usr/bin/ld: raid6.a(algos.o):/dev/shm/linux/lib/raid6/test/algos.c:2=
8: multiple definition of `raid6_call'; /scratch/local/ccIJjN8s.o:/dev/shm/=
linux/lib/raid6/test/test.c:22: first defined here
>     collect2: error: ld returned 1 exit status
>     make: *** [Makefile:72: raid6test] Error 1
>
> The errors come from the `HAS_ALTIVEC` test, which fails, and the POWER
> optimized versions are not built. That=E2=80=99s also reason nobody notic=
ed on the
> other architectures.
>
> GNU Make 4.3 does not remove the backslash anymore. From the 4.3 release
> announcment:
>
> > * WARNING: Backward-incompatibility!
> >   Number signs (#) appearing inside a macro reference or function invoc=
ation
> >   no longer introduce comments and should not be escaped with backslash=
es:
> >   thus a call such as:
> >     foo :=3D $(shell echo '#')
> >   is legal.  Previously the number sign needed to be escaped, for examp=
le:
> >     foo :=3D $(shell echo '\#')
> >   Now this latter will resolve to "\#".  If you want to write makefiles
> >   portable to both versions, assign the number sign to a variable:
> >     H :=3D \#
> >     foo :=3D $(shell echo '$H')
> >   This was claimed to be fixed in 3.81, but wasn't, for some reason.
> >   To detect this change search for 'nocomment' in the .FEATURES variabl=
e.
>
> So, do the same as commit 9564a8cf422d ("Kbuild: fix # escaping in .cmd
> files for future Make") and commit 929bef467771 ("bpf: Use $(pound) inste=
ad
> of \# in Makefiles") and define and use a `$(pound)` variable.
>
> Reference for the change in make:
> https://git.savannah.gnu.org/cgit/make.git/commit/?id=3Dc6966b323811c37ac=
edff05b57
>
> Cc: Matt Brown <matthew.brown.dev@gmail.com>
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>

I removed all the "`", fixed some unwrapped commit log, shortened some line=
s
and applied the set to md-next. Please review that version and let me know =
if
anything need to change.

Thanks,
Song
