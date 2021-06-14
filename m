Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6403A633E
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 13:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhFNLLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 07:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbhFNLKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 07:10:35 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7701CC061574;
        Mon, 14 Jun 2021 04:08:17 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id ci15so16025344ejc.10;
        Mon, 14 Jun 2021 04:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kFtfaVPxjMz3zv5hk/Hdiro2VJqbqucIcvR4fgorvBk=;
        b=PDUUDMoAY3riQsSdC5LeJxet3fwNjmUasRW0dq0EQNnBvtVouuOgTmOXOCm0Igdyff
         iMIN4l6129ZibfAEIvS0vaxiyN/+O8zwGmWQW4rRX0yzU5IWW/TIhAiXF8oxIiGiagRB
         u+eBqCHRFdJA9nn8h+uN0hYRlC14pLMEEmq0CEzKXpxQujZ6ebQs7NJWpiW6YEpF+Ep0
         TjR+i82jHoLyCukKByne8Ij9jK9qFkLOFI3dZLINZhTUsdTGge/diyYl3uzFKh4jcqfj
         do0FF8pQOsO15O9Y4sIVnZPMBN81iLX1T2wnLxDa2jyz4Oem4pgYaL0ATPJLdsIRReoK
         kZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kFtfaVPxjMz3zv5hk/Hdiro2VJqbqucIcvR4fgorvBk=;
        b=FcB7Hnw+4XZe3TjiTaCZS8Y0KHkvgBBuwEs/2VH5NLe4tsu7DH0h3SCcR0mfY29bGW
         2KXo026ybE0+dWDBsv63A1HdT3WTP6rd/DKm4YiLyssGqNGlLpQhxzi+1jCTNERseks+
         Omglj0VrWc0mAvSFJ4eIuEt4ryZy4M0rF3DcKJsp6/O8BetFpFfHi2DSspwlBLVB+Cdw
         4LqAPzxOpKkpedxzOfFZUzdyxPVnA56yMJRSz6/yj8rE0jyGwi8LdFbbZDxvk/gFRL/j
         rRGiaDQArtkYYEA8E3eE1ns6wrptHiJQKNioVKBLZRKayoCfxIl8Fv0s5zX9BwVyfTIS
         +eZQ==
X-Gm-Message-State: AOAM531iGAjzK8DKc7Ik6rz+9s3K3i5V+lNV5kmPib66aV6wIHMRUiLY
        0Zjid3nWdNbB82WsTI4/DGhtGYS6QmZ8swXgrFs=
X-Google-Smtp-Source: ABdhPJyTeZQ6Dmi0v4P4wvVp5Nw2vOER7pPUInvNzCAdyKK/91eeQnqNnSCCXnSpCVTkUJK68r+gMz9gG11bRuyCVGg=
X-Received: by 2002:a17:906:4a17:: with SMTP id w23mr12910346eju.460.1623668896048;
 Mon, 14 Jun 2021 04:08:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAMy7=ZUXRJni3uUVWkWFu8Dkc5XCVsM54i_iLDwHQ5Y0Z3inJw@mail.gmail.com>
 <20210614101844.4jgq6sh7vodgxojj@apollo>
In-Reply-To: <20210614101844.4jgq6sh7vodgxojj@apollo>
From:   Yaniv Agman <yanivagman@gmail.com>
Date:   Mon, 14 Jun 2021 14:08:51 +0300
Message-ID: <CAMy7=ZULTCoSCcjxw=MdhaKmNM9DXKc=t7QScf9smKKUB+L_fQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Fixes for TC-BPF series
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E2=80=AB=D7=91=D7=AA=D7=90=D7=A8=D7=99=D7=9A =D7=99=D7=95=D7=9D =D7=91=D7=
=B3, 14 =D7=91=D7=99=D7=95=D7=A0=D7=99 2021 =D7=91-13:20 =D7=9E=D7=90=D7=AA=
 =E2=80=AAKumar Kartikeya Dwivedi=E2=80=AC=E2=80=8F
<=E2=80=AAmemxor@gmail.com=E2=80=AC=E2=80=8F>:=E2=80=AC
>
> On Mon, Jun 14, 2021 at 03:02:07PM IST, Yaniv Agman wrote:
> > Hi Kartikeya,
> >
> > I recently started experimenting with the new tc-bpf API (which is
> > great, many thanks!) and I wanted to share a potential problem I
> > found.
> > I'm using this "Fixes for TC-BPF series" thread to write about it, but
> > it is not directly related to this patch set.
> >
> > According to the API summary given in
> > https://lore.kernel.org/bpf/20210512103451.989420-3-memxor@gmail.com/,
> > "It is advised that if the qdisc is operated on by many programs,
> > then the program at least check that there are no other existing
> > filters before deleting the clsact qdisc."
> > In the example given, one should:
> >
> > /* set opts as NULL, as we're not really interested in
> > * getting any info for a particular filter, but just
> > * detecting its presence.
> > */
> > r =3D bpf_tc_query(&hook, NULL);
> >
>
> Yes, at some revision this worked, but then we changed it to not allow pa=
ssing
> opts as NULL and I forgot to remove the snippet from the commit message. =
Sorry
> for that, but now it's buried in the git history forever :/. Mea Culpa.
>
> > However, following in this summary, where bpf_tc_query is described,
> > it is written that the opts argument cannot be NULL.
> > And indeed, when I tried to use the example above, an error (EINVAL)
> > was returned (as expected?)
> >
> > Am I missing something?
> >
>
> You are correct. We could do a few thing things:
>
> 1. Add a separate documentation file that correctly describes things (eve=
rything
> minus that para).
> 2. Support passing NULL to just detect presence of filters at a hook.
> 3. Add a multi query API that dumps all filters.
>
> Regardless of what we choose here, it will still be racy to clean up the =
qdisc a
> program installs itself, as there is a small race (but a race nonetheless=
)
> between checking of installed filters and removing the qdisc.
>
> I will discuss this today in the TC meeting to find some proper solution =
instead
> of the current hack. For now it would probably be best to leave it around=
 I
> guess, though that does entail a small performance impact (due to enablin=
g the
> sch_handle_{ingress,egress} static key).
>
> --
> Kartikeya

Got it, thanks.
Another option (that will require an API change) can be to delete the
qdisc only if there are no other filters installed on it.
I'm not really familiar with the netlink API and if that's even
possible, but providing such an API can reduce the chances of having a
race condition.
For example, what I have in mind is adding a new flag to tc_bpf_flags
called something like BPF_TC_Q_DELETE, and also adding an "opts"
argument to the bpf_tc_hook_destroy() api so we can pass this flag
WDYT? Is that even an option?

Yaniv
