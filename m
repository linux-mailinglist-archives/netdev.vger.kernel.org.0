Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B8A2796F7
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 06:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbgIZEgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 00:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730006AbgIZEgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 00:36:16 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A33CC0613CE;
        Fri, 25 Sep 2020 21:36:16 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id m13so4297084otl.9;
        Fri, 25 Sep 2020 21:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=cltFfaRb1BosoRg8mDWI26ET3SE7mMaxq/k+EP/er4Y=;
        b=AGF/mNg3pQ9eoy6BIATRqgn7AYGFwl+f4lfDwooCYoj9VJ4JOVjWZTbSWPDIpDkwgD
         EpJ+tcPyokmh70cjT3BMLBEDK2oXjiweqbyOctFxb6yVn9Y4JaVjXEdLPL8s70SMVQ3F
         P6cwFduhn8QA7hEW1s1jPEPhhiys6JPCRQYUTJfnm7mRlA+g23iWu3D2SIds8I/NIMjr
         GPOJwTsTw9Fa4wycU3v7f75OPCpbj41NJVV/VNS4TaLSs4iNzX+GRuKTTqNGXnLswCBC
         T6PiRcSAppO3ZnoTy/eRIZn3FDYF+z8oGnm4sMuPfbsxyg5LlkDf+z+qx934XYJcbK3s
         1hOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=cltFfaRb1BosoRg8mDWI26ET3SE7mMaxq/k+EP/er4Y=;
        b=YmSbw8NteSB3uiM3LHBSu1KzcejQFZ9nkaHmGZA32cjgTiKVLSII712i9WvxUXoulF
         UVdBhzxMwIgBZFXfIEQC83h1w0apisCAkgoG7+aqKoDM/tYQm8R+vvwysd592nziaVSq
         xzF8gpGd5+cPkrTBkfeJu0NrwHN23DuBvq0Y8QEjZ4DdtRu9jw0lx20oq4FOe0dyH19m
         ilYIYoTJxf48J6ZxudYw3mWtpGMY33hi6X8nNqTOXlPJ4NZ+0dhYszeJZXCKW15CLvoa
         ELltXAhoF+b/VFeTaHyk2cTSPBlPBcDl9zwmYw8fNpWj4IkE5k2Gb8JJnkviCqNi828t
         7FAA==
X-Gm-Message-State: AOAM532xgFC+GYHgsIpKu8fCvUS+5MafOj7pZFeYYVJwsqlE4IFQ/Q9x
        4bi6x402jG7bi8eC9qu1FYNRcZExRNE6Ow==
X-Google-Smtp-Source: ABdhPJyFqAHsORdJj0JhOaad7HIUoCcFcIVC/JzfoxdC1mzFF5sGDA6us9ZZin0TaCK6x41N/jdW6Q==
X-Received: by 2002:a9d:3b76:: with SMTP id z109mr2526373otb.250.1601094975891;
        Fri, 25 Sep 2020 21:36:15 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l4sm1103137oie.25.2020.09.25.21.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 21:36:15 -0700 (PDT)
Date:   Fri, 25 Sep 2020 21:36:06 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Message-ID: <5f6ec536c3f22_af05120838@john-XPS-13-9370.notmuch>
In-Reply-To: <CAADnVQ+5CbptcUpjJN8bP64zrwu1j3doz+iyDEoH6mApELLNWQ@mail.gmail.com>
References: <160097310597.12106.6191783180902126213.stgit@john-Precision-5820-Tower>
 <CAADnVQ+5CbptcUpjJN8bP64zrwu1j3doz+iyDEoH6mApELLNWQ@mail.gmail.com>
Subject: Re: [bpf-next PATCH 1/2] bpf, verifier: Remove redundant
 var_off.value ops in scalar known reg cases
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Thu, Sep 24, 2020 at 11:45 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > In BPF_AND and BPF_OR alu cases we have this pattern when the src and dst
> > tnum is a constant.
> >
> >  1 dst_reg->var_off = tnum_[op](dst_reg->var_off, src_reg.var_off)
> >  2 scalar32_min_max_[op]
> >  3       if (known) return
> >  4 scalar_min_max_[op]
> >  5       if (known)
> >  6          __mark_reg_known(dst_reg,
> >                    dst_reg->var_off.value [op] src_reg.var_off.value)
> >
> > The result is in 1 we calculate the var_off value and store it in the
> > dst_reg. Then in 6 we duplicate this logic doing the op again on the
> > value.
> >
> > The duplication comes from the the tnum_[op] handlers because they have
> > already done the value calcuation. For example this is tnum_and().
> >
> >  struct tnum tnum_and(struct tnum a, struct tnum b)
> >  {
> >         u64 alpha, beta, v;
> >
> >         alpha = a.value | a.mask;
> >         beta = b.value | b.mask;
> >         v = a.value & b.value;
> >         return TNUM(v, alpha & beta & ~v);
> >  }
> >
> > So lets remove the redundant op calculation. Its confusing for readers
> > and unnecessary. Its also not harmful because those ops have the
> > property, r1 & r1 = r1 and r1 | r1 = r1.
> >
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> 
> Applied. Thanks for the follow up.
> In the future please always cc bpf@vger for two reasons:
> - to get proper 'Link:' integrated in git commit
> - to get them into a new instance of
> https://patchwork.kernel.org/project/bpf/list

+1

>   which we will start using soon to send automatic 'applied' emails.


Apologies, I updated some scripts and unfortunately typo dropped a '-'
and cut off bpf@vger from the CC list. Also I just used it to land
two more patches without bpf@vger happy to resend with CC included
if folks want. Sorry for the extra work/noise.

Thanks.
