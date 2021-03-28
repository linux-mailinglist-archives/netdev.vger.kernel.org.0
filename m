Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C871334BA6B
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 04:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhC1B73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 21:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbhC1B7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 21:59:13 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB21C0613B1;
        Sat, 27 Mar 2021 18:59:12 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 8so9925382ybc.13;
        Sat, 27 Mar 2021 18:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MjDUv5VADxIWSRBmY55ywdD0LW1sif7nfEKlshnVoPU=;
        b=jZL/IeO/Ji7dcbK5V/a7JDkK4OjLOXqsH8M0pYAbcxIli3HCaPPJq6KMl+16SNed4h
         78gXIz5KkVNVp/hO272yRbD6qBjW+G+Dvpf00PBAENlPB79eZCKq6D+3evRoETOUXgmp
         S+4rqR8EwZdpC4NsfxMm5QPy1z/huk9iPsHMgPOuoJgorp/3aHA1s6baFXNkZ0IOsG5Y
         l2wzMFBnsbuN5I/HRLiZ1hGvdG+knvD2gFw2yju+ZMnwrG7LQ03w5+VG8IrELTyDQ1M0
         BERjz50xxyWGkWXi/uXpE9ugqEC3KbNQsNwerjZYZctnJPvv6MHGaO7bGQ2V7+gahdxD
         +i9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MjDUv5VADxIWSRBmY55ywdD0LW1sif7nfEKlshnVoPU=;
        b=dN0Ny3EDwPBiDtsh/7qb0dmLJKv0o5Y/yp66JVtVNLJIhU78+XOlotclNsshN/oieC
         Aq+RZ9DG6sO8zEKrzWBNPEMQqltMFYhupZPHR/0jhQBugwr3PgoBwPcN6OiaFcZIEnBi
         3NsnJ0euJeO78E2ijbD9IN5veWjzD9y4J1Eq4o1Zjh35hCY4WNnRzSp/rroTeR0iR6eZ
         KUziS+OyMYeQxCz6HqDhOIBzPbkz4URDLh97jBjJrrqPJOmvSksiIQHgkbIvocivU7qa
         gBwbXaiGV59JTTHkMcOfsYYzwfpi021HBjefiihmeqZERHqcGqgOcApcozhDaFUqLsdn
         Y/1A==
X-Gm-Message-State: AOAM531yKzQsR/4TwvA/iHxSjw/2ZgG7fkQwOwz/uJVYFKHX4X8kvBIm
        LgA2G775AUTY6pX72bZn9T/hEcrs5I3LmG+FxAcQqRbIDZ1IQw==
X-Google-Smtp-Source: ABdhPJybrqhOn2jKtnVFckxOO44bya5rRJvA3nfSRhPCEj3W6Bw9nVTUDBGX0lp27+XgOWSFPvdppdDMfjCTWMa1UzA=
X-Received: by 2002:a25:2544:: with SMTP id l65mr28868062ybl.304.1616896751532;
 Sat, 27 Mar 2021 18:59:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210326124030.1138964-1-Jianlin.Lv@arm.com> <CAADnVQ+W79=L=jb0hcOa4E067_PnWbnWHdxqyw-9+Nz9wKkOCA@mail.gmail.com>
 <AM6PR08MB3589CCA99AEF14F9B610A70E98609@AM6PR08MB3589.eurprd08.prod.outlook.com>
 <CAADnVQJsG-c+AdpwS6xTCwZq4-uVoPH7FZ8CV_XCA-+QaCKA8g@mail.gmail.com>
In-Reply-To: <CAADnVQJsG-c+AdpwS6xTCwZq4-uVoPH7FZ8CV_XCA-+QaCKA8g@mail.gmail.com>
From:   Jianlin Lv <iecedge@gmail.com>
Date:   Sun, 28 Mar 2021 09:59:00 +0800
Message-ID: <CAFA-uR_ryDcPNDp1Tve+jaax6ftZ9LNUHo3TypkC07SKJcw_4w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: trace jit code when enable BPF_JIT_ALWAYS_ON
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jianlin Lv <Jianlin.Lv@arm.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrey Ignatov <rdna@fb.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Mahesh Bandewar <maheshb@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>, nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 11:19 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Mar 27, 2021 at 1:19 AM Jianlin Lv <Jianlin.Lv@arm.com> wrote:
> >
> > > On Fri, Mar 26, 2021 at 5:40 AM Jianlin Lv <Jianlin.Lv@arm.com> wrote=
:
> > > >
> > > > When CONFIG_BPF_JIT_ALWAYS_ON is enabled, the value of
> > > bpf_jit_enable
> > > > in /proc/sys is limited to SYSCTL_ONE. This is not convenient for d=
ebugging.
> > > > This patch modifies the value of extra2 (max) to 2 that support
> > > > developers to emit traces on kernel log.
> > > >
> > > > Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
> > > > ---
> > > >  net/core/sysctl_net_core.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.=
c
> > > > index d84c8a1b280e..aa16883ac445 100644
> > > > --- a/net/core/sysctl_net_core.c
> > > > +++ b/net/core/sysctl_net_core.c
> > > > @@ -386,7 +386,7 @@ static struct ctl_table net_core_table[] =3D {
> > > >                 .proc_handler   =3D proc_dointvec_minmax_bpf_enable=
,
> > > >  # ifdef CONFIG_BPF_JIT_ALWAYS_ON
> > > >                 .extra1         =3D SYSCTL_ONE,
> > > > -               .extra2         =3D SYSCTL_ONE,
> > > > +               .extra2         =3D &two,
> > >
> > > "bpftool prog dump jited" is much better way to examine JITed dumps.
> > > I'd rather remove bpf_jit_enable=3D2 altogether.
> >
> > In my case, I introduced a bug when I made some adjustments to the arm6=
4
> > jit macro A64_MOV(), which caused the SP register to be replaced by the
> > XZR register when building prologue, and the wrong value was stored in =
fp,
> > which triggered a crash.
> >
> > This bug is likely to cause the instruction to access the BPF stack in
> > jited prog to trigger a crash.
> > I tried to use bpftool to debug, but bpftool crashed when I executed th=
e
> > "bpftool prog show" command.
> > The syslog shown that bpftool is loading and running some bpf prog.
> > because of the bug in the JIT compiler, the bpftool execution failed.
>
> Right 'bpftool prog show' command is loading a bpf iterator prog,
> but you didn't need to use it to dump JITed code.
> "bpftool prog dump jited name my_prog"
> would have dumped it even when JIT is all buggy.
>
> > bpf_jit_disasm saved me, it helped me dump the jited image:
> >
> > echo 2> /proc/sys/net/core/bpf_jit_enable
> > modprobe test_bpf test_name=3D"SPILL_FILL"
> > ./bpf_jit_disasm -o
> >
> > So keeping bpf_jit_enable=3D2 is still very meaningful for developers w=
ho
> > try to modify the JIT compiler.
>
> sure and such JIT developers can compile the kernel
> without BPF_JIT_ALWAYS_ON just like you did.
> They can also insert printk, etc.
> bpf_jit_enable=3D2 was done long ago when there was no other way
> to see JITed code. Now we have proper apis.
> That =3D2 mode can and should be removed.

Thanks for your reply, I will prepare another patch to remove =3D2mode.

>
> > IMPORTANT NOTICE: The contents of this email and any attachments are co=
nfidential and may also be privileged. If you are not the intended recipien=
t, please notify the sender immediately and do not disclose the contents to=
 any other person, use it for any purpose, or store or copy the information=
 in any medium. Thank you.
>
> please fix your email server/client/whatever. No patches will ever be
> accepted with
> such disclaimer.

Apologize for this.
Jianlin
