Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B0740FE16
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 18:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238962AbhIQQob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 12:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:32986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238807AbhIQQoa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 12:44:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4C6461100
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 16:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631896987;
        bh=e58R4BpoE3fqAf6lRt0Q/+77YblKnxrNLid9gNHZRl4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=c0tXYHyqbNwrebcMdnNroQOuwuW9sCHbM/pHAFqowpzBolqdtigmbSUp+v2BW3mII
         RPEsQjPVgHG7TO4TfaVLZhxs6+EwytU4tlZ+8L2JyYXihnuOEeofCDcVkiZzueFrTO
         wpmjY7n0nsU4zfYf8uxrV3odvqNvP6byMheIbnafRL/b1BlejTdZfmUjR4SufrOecr
         bluXaSuLVfC7BcLgkcvSZINaBuQ5okYHaAAhpKUmIZ4hTQ12CTH2/U7K7R1bF11tLG
         V5am1Q9eI2deGfRitf1dcXxurqBegDrwlVDWn63oohL+YedpOBCLL2H64wWBVZWPrB
         Z5nBuhW4kyElA==
Received: by mail-ed1-f47.google.com with SMTP id g21so32305158edw.4
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 09:43:07 -0700 (PDT)
X-Gm-Message-State: AOAM5308AdBgKvPuBclFoavQwTqt6El6Rf49VPZPu3If4axGusGeo/gD
        9Wo/g0Vlhmj3eIqHufzremMrMW4QWg8r6PumpGm8XA==
X-Google-Smtp-Source: ABdhPJyr2Dku3RVW2nmU54gU6k/2YwwitND/BB5XTm5pP51/YXlA2crL1Q8l2uEd3hXyPGt21d4ynNpFsW2/tUPaIKE=
X-Received: by 2002:a17:906:3fd7:: with SMTP id k23mr12946326ejj.176.1631896986418;
 Fri, 17 Sep 2021 09:43:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210916032104.35822-1-alexei.starovoitov@gmail.com>
 <87bl4s7bgw.fsf@meer.lwn.net> <CAADnVQ+y5hmCmxM6jKY=TqpM0cGE-uSO=mObZ=LDxiVd9YUzuQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+y5hmCmxM6jKY=TqpM0cGE-uSO=mObZ=LDxiVd9YUzuQ@mail.gmail.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Fri, 17 Sep 2021 18:42:55 +0200
X-Gmail-Original-Message-ID: <CACYkzJ7HEsFno4fVJ8--An+dPEbqnLY1-y2Px1nFrCyoDGkTJQ@mail.gmail.com>
Message-ID: <CACYkzJ7HEsFno4fVJ8--An+dPEbqnLY1-y2Px1nFrCyoDGkTJQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Document BPF licensing.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 10:49 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Sep 16, 2021 at 9:05 AM Jonathan Corbet <corbet@lwn.net> wrote:
> >
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > Document and clarify BPF licensing.
> >
> > Two trivial things that have nothing to do with the actual content...
> >
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > > Acked-by: Daniel Borkmann <daniel@iogearbox.net>
> > > Acked-by: Joe Stringer <joe@cilium.io>
> > > Acked-by: Lorenz Bauer <lmb@cloudflare.com>
> > > Acked-by: Dave Thaler <dthaler@microsoft.com>

Thanks for writing this up!

Acked-by: KP Singh <kpsingh@kernel.org>
