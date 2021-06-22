Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2473B104C
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 01:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFVXEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 19:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhFVXE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 19:04:29 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2474C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 16:02:11 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id k5so805120ilv.8
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 16:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=0MxNVUkBRIm4nx/zTuFEoleFRds4t2gWstweB7w63DA=;
        b=H5k+5dQddfuTGsfInqT31LgeYM/Rt/2k+Y07fLKvuKd4ZJj6+irhskB9rtkYiiCxtN
         sujNfkWU5smZeG6xqozpQK61XMO4+LGtgNVBkRCYRwfmv+kBRuHaXM5zP/gLVAHp9yLG
         5YLoND4PbsQW1oOcQ2SL0A3xc558wgiX7fO4Ba38RgKF23SoH3gm3R/ogD9sHQRGhQCJ
         MOrp9D/wTY43RE02Zi1fAap9XzdH1heTQRiuM977PA5Xppd1t4dbPV2q4r2sR9XmAvZO
         73lCbQ/v0hJdJniihngD7vK/wILzwha5zNyrRMN5DOJ70mQgadU4W69H9EahyZViZwYD
         89+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=0MxNVUkBRIm4nx/zTuFEoleFRds4t2gWstweB7w63DA=;
        b=d4Ts6skb/Sh4541dws1gNAE06f3650FAowZEdgQAJyarBWinFX9gfsGRLv5Fbq4ytq
         FTkcD/CvFtH7Gf1Qay/J+4ykx7+Xso4BIdE+Eivx4mlIx+cblo6ZSGcBLTpXc7miQYw7
         4xc4D2S3lVd4MDdyeHEIT/YhRPlZ4XCh9Dk/fNsUN/aS2qktOfTLp8mlU5YUzUaaYGTE
         pkF3U+egQh8rU3BvpZfGpj0oDlrzu3C5sEohTqD3aKIQ1kaMJWwCtkqOF3AJ5EAZJOYt
         iqSbN1hyXhropUxeN/0HUYzN80cqDAdOED4gzlzWlS1QYxGblcNS1O5ODfgf+j0tQ0vQ
         LjOw==
X-Gm-Message-State: AOAM530fIoJATlXqxStlLsj3np2YYQXrPkB6mU3Uk4m0QuLj13BQ9oZE
        UN9oihn5tBQS4WtsoX3/AGA=
X-Google-Smtp-Source: ABdhPJwngWzgILg6o7T83iXcYR3qC9Xxc/qETC9TkdmzHXAzVI/nvG9suF/CPZWPZCVA1T9+i/RQMg==
X-Received: by 2002:a92:6b06:: with SMTP id g6mr695420ilc.270.1624402931427;
        Tue, 22 Jun 2021 16:02:11 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id b20sm8926204ile.82.2021.06.22.16.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 16:02:11 -0700 (PDT)
Date:   Tue, 22 Jun 2021 16:02:02 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     maciej.fijalkowski@intel.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, netdev@vger.kernel.org
Message-ID: <60d26bea8722e_1342e20834@john-XPS-13-9370.notmuch>
In-Reply-To: <20210622220037.6uwrba6tl7vofcu5@ast-mbp.dhcp.thefacebook.com>
References: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
 <162388413965.151936.16775592753297385087.stgit@john-XPS-13-9370>
 <20210622220037.6uwrba6tl7vofcu5@ast-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf v2 3/4] bpf: track subprog poke correctly
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Wed, Jun 16, 2021 at 03:55:39PM -0700, John Fastabend wrote:
> >  
> > -static void bpf_free_used_maps(struct bpf_prog_aux *aux)
> > +void bpf_free_used_maps(struct bpf_prog_aux *aux)
> >  {
> >  	__bpf_free_used_maps(aux, aux->used_maps, aux->used_map_cnt);
> >  	kfree(aux->used_maps);
> > @@ -2211,8 +2211,10 @@ static void bpf_prog_free_deferred(struct work_struct *work)
> >  #endif
> >  	if (aux->dst_trampoline)
> >  		bpf_trampoline_put(aux->dst_trampoline);
> > -	for (i = 0; i < aux->func_cnt; i++)
> > +	for (i = 0; i < aux->func_cnt; i++) {
> > +		bpf_free_used_maps(aux->func[i]->aux);
> >  		bpf_jit_free(aux->func[i]);
> > +	}
> 
> The sub-progs don't have all the properties of the main prog.
> Only main prog suppose to keep maps incremented.
> After this patch the prog with 100 subprogs will artificially bump maps
> refcnt 100 times as a workaround for poke_tab access.

Yep.

> May be we can use single poke_tab in the main prog instead.
> Looks like jit_subprogs is splitting the poke_tab into individual arrays
> for each subprog, but maps are tracked by the main prog only.
> That's the root cause of the issue, right?

Correct.

> I think that split of poke_tab isn't necessary.
> bpf_int_jit_compile() can look into main prog poke_tab instead.
> Then the loop:
> for (j = 0; j < prog->aux->size_poke_tab)
>     bpf_jit_add_poke_descriptor(func[i], &prog->aux->poke_tab[j]);
> can be removed (It will address the concern in patch 2 as well, right?)
> And hopefully will fix UAF too?

Looks like it to me as well. A few details to work out around
imm value and emit hooks on the jit side, but looks doable to me.
I'll give it a try tomorrow or tonight.

Thanks,
John
