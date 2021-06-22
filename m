Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AE33B1044
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 01:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhFVXCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 19:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhFVXCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 19:02:13 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94D7C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 15:59:56 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id f10so1095819iok.6
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 15:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=nQhqB+0FtMYdOJdZD96mS0hFNCVxXSUuzWiANLHgV9s=;
        b=tCV6pvsMFbkAi4rSs7wV1bCNd8U8eurTNxvgimYrMSnHPSGDpW2DMA8Ppzs2AWOlIT
         q0KWdRUOBlYl8Uq70xhyClvgoW8JEkPqp9tbpyWFcZFLb6C+xhhd4mn3Y3y7X4hBlK15
         D/4NIPqVIl1IyDjXrY/A8YdQvlTADvJT398o8gMt+STxoYhI1NRfjqEYTB39KbSk3mHY
         zc9xKA2FDp+GRlsQ88bQITCUvR8SiWz/eN4b9gxplU/Jyh6eNYMMfHxrd1AEpdQD7Wfx
         SmQZvLoRYl5UCDCeHFtgy3saC1HVfH5by2M1r+3k392p53pW7YLQTUZqhxMF/sy8qXI6
         C9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=nQhqB+0FtMYdOJdZD96mS0hFNCVxXSUuzWiANLHgV9s=;
        b=R9Tv+tv4ZzpdaEYOkajMvJqU4y0UxR9PjeHMYDVpZ2yRpE/yogn7v5CGMo/45HVZC1
         ToevvDZcEf/T297P285EFqTB3EUXlyMEnYaFlhT2+462aXHFLJS/F+YPnyIizb0+VbS0
         KxeC1iyeLd68aHR4tGRjeOvWzrI6mK6AhxuN0gshAt4RgsQp7+6nqh/a/X1ze9sSZOrF
         KJmFwk3I2WW88D0XmkyccWj0aqrORt/NzouAduklcrajKDC6qW6O47Jp68C7L/CYKqIB
         saLEn+afFY/bJgf99UhVIfw7poSZ4NkvOvOnrDiFTI3SLjrp/jfG1RQkwXV1GpU13LPX
         VJlA==
X-Gm-Message-State: AOAM531Kvd98L5PAbIX4dN5pNfIku7JsHR4MCTMpl9+bhsvAord+ANt3
        qQ4ndwyF9ZAI9sOqseEdaM0=
X-Google-Smtp-Source: ABdhPJxQFolusZenGsjZQXMnzCKrxaZrGMGo11/ENe82OuyvHKFBpjTyympfuxwmy51bUwWQCEieHw==
X-Received: by 2002:a5d:9051:: with SMTP id v17mr4692944ioq.81.1624402796234;
        Tue, 22 Jun 2021 15:59:56 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id z12sm12273474iop.46.2021.06.22.15.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 15:59:55 -0700 (PDT)
Date:   Tue, 22 Jun 2021 15:59:47 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     maciej.fijalkowski@intel.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, netdev@vger.kernel.org
Message-ID: <60d26b639349c_1342e20896@john-XPS-13-9370.notmuch>
In-Reply-To: <20210622215439.wfi56kb77ewq2lx6@ast-mbp.dhcp.thefacebook.com>
References: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
 <162388411986.151936.3914295553899556046.stgit@john-XPS-13-9370>
 <20210622215439.wfi56kb77ewq2lx6@ast-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf v2 2/4] bpf: map_poke_descriptor is being called with
 an unstable poke_tab[]
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Wed, Jun 16, 2021 at 03:55:19PM -0700, John Fastabend wrote:
> > When populating poke_tab[] of a subprog we call map_poke_track() after
> > doing bpf_jit_add_poke_descriptor(). But, bpf_jit_add_poke_descriptor()
> > may, likely will, realloc the poke_tab[] structure and free the old
> > one. So that prog->aux->poke_tab is not stable. However, the aux pointer
> > is referenced from bpf_array_aux and poke_tab[] is used to 'track'
> > prog<->map link. This way when progs are released the entry in the
> > map is dropped and vice versa when the map is released we don't drop
> > it too soon if a prog is in the process of calling it.
> > 
> > I wasn't able to trigger any errors here, for example having map_poke_run
> > run with a poke_tab[] pointer that was free'd from
> > bpf_jit_add_poke_descriptor(), but it looks possible and at very least
> > is very fragile.
> > 
> > This patch moves poke_track call out of loop that is calling add_poke
> > so that we only ever add stable aux->poke_tab pointers to the map's
> > bpf_array_aux struct. Further, we need this in the next patch to fix
> > a real bug where progs are not 'untracked'.
> > 
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  kernel/bpf/verifier.c |    6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 6e2ebcb0d66f..066fac9b5460 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -12126,8 +12126,12 @@ static int jit_subprogs(struct bpf_verifier_env *env)
> >  			}
> >  
> >  			func[i]->insnsi[insn_idx - subprog_start].imm = ret + 1;
> > +		}
> >  
> > -			map_ptr = func[i]->aux->poke_tab[ret].tail_call.map;
> > +		for (j = 0; j < func[i]->aux->size_poke_tab; j++) {
> > +			int ret;
> > +
> > +			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
> 
> I don't see why it's necessary.

Agree its not necessary. Nothing else can get at poke_tab while we do
the realloc so I agree its fine as is. It still seems odd to me to do the
poke_track when we know we are about to do multiple reallocs in the
next round of the loop. Either way I'll reply on the feedback in 3/4 and
we can avoid this patch altogether I think.

> poke_tab pointer will be re-read after bpf_jit_add_poke_descriptor().
> The compiler is not allowed to cache it.
> 
> I've applied the patch 1.
