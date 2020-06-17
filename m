Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53281FD1CD
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgFQQT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFQQT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 12:19:27 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85045C06174E;
        Wed, 17 Jun 2020 09:19:27 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id d82so2539928qkc.10;
        Wed, 17 Jun 2020 09:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PVufv+wGfM5FlL19P66hJ3jDiaqB0sb6Nsu+imjTKnw=;
        b=eD3sX1aK3YUFUi938YQ//SvRlHM1et8inYDL7kUlLxB3EYr4goLGxtdbKLKgCtLOxP
         42ZwsYSV0o4B5gq3v0OdCDseM304stNszqQRNClpJgS7QzfSXiG+449rNcVUd2LHGZ7j
         4XagsUw5Gwr/V1mEDhorc+1P+SmzbHW4dN1CN0A6SMQyCWG4VMhE/hGVAKlRGXB5cngO
         fT7Yn/mGcJq2DkuUmNy9yOEEaOdCBdQkKTaS6L0So6CX9SI4izdeFw+CdteB+V+6OsYA
         D3N8cWf6viPCAMs8p8DPFH1lGe/9cTWUIE7t+Gs95SXGHriv1ku5TrJATv9A4oQQsNUS
         k7Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PVufv+wGfM5FlL19P66hJ3jDiaqB0sb6Nsu+imjTKnw=;
        b=FKuo2ISB6PfPH7I0DPKWvPWv0127cGQarSUXuHCxHgguudR2kqqTpaOXf6b+V/njT9
         I+e3JtlaQ3ntFy7ao9T4bUhq3Lc/Ag+Kr9M5iL72FXgtGX0MOAovXb5GWqUYEM5Xzp69
         5K/nNkLNaGDRqhggHM35pz4HEPtjMer7G0GDZRn8mxogXEgMYsr1a0nP1Naw4KxbInrG
         ZvhApY2Qu5ZTSM6TkP0VdOyofc5t7oIkczdmimKgKF3ZRoriOTmI8jQUXzV8vDc396ty
         g/Pg8gChDzcXuId0+z13xT0rAyscukKtIcrmtTo4l6zFtstR2tMJ3YA7mGYU3ITYSZS2
         LG3A==
X-Gm-Message-State: AOAM532XubIOMEVw9UWnNR+pJ75zSAkzYtjaLQoOWJqW1vK34cxb2Vyg
        kTVV1kCkMQ//it3HffIPZN/LJtX80uI3vZp6enI=
X-Google-Smtp-Source: ABdhPJz7QGnkQFztlyaYHLpZisLJDqmRW08vS28q4CL1huTuy5xbvFBw9U0xBB51DIjBNzjcPKK9PIV7nnJoY0xJ72Q=
X-Received: by 2002:a37:a89:: with SMTP id 131mr25908887qkk.92.1592410766355;
 Wed, 17 Jun 2020 09:19:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200617155539.1223558-1-andriin@fb.com> <CAADnVQLqg5DSXQXMeVAmCBx001cz-ogkZO1TZ43aJ4Grp93cSA@mail.gmail.com>
In-Reply-To: <CAADnVQLqg5DSXQXMeVAmCBx001cz-ogkZO1TZ43aJ4Grp93cSA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 17 Jun 2020 09:19:14 -0700
Message-ID: <CAEf4Bzb4WeHSgM0up99wPV75Fq-tmSMZ5Q=Kw7vkD11YqFRS3w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: bump version to 0.0.10
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 9:18 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jun 17, 2020 at 8:59 AM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Let's start new cycle with another libbpf version bump.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.map | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index f732c77b7ed0..3b37b8867cec 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -270,3 +270,6 @@ LIBBPF_0.0.9 {
> >                 ring_buffer__new;
> >                 ring_buffer__poll;
> >  } LIBBPF_0.0.8;
> > +
> > +LIBBPF_0.0.10 {
> > +} LIBBPF_0.0.9;
>
> How about 0.1.0 instead?

sure, why not?
