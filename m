Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CE433F802
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 19:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhCQSQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 14:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbhCQSQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 14:16:06 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41AAC06174A;
        Wed, 17 Mar 2021 11:16:05 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id z7so343385lfd.5;
        Wed, 17 Mar 2021 11:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RnRKNpQgUsNpaNv3dsr453+uGBMHftMBsGXsYkGT7rE=;
        b=KMYWWZ9xdJ794AYGtt+jrqZ1WOEUPreEYwTDM5S5UPYRNJm2B4yjNYGkJpcGSEboIU
         JQmRCmMenOQR9fI9TlQMImVZygZvas7RQqs+YYCEF5dsSLtwpu2ggtCjP0d2URBYjErg
         T0dpwe06zeqUs0s0myEAn6zbPUeIKY9fnfiGcmFroffJNCQAegbzvMvh8gOq0A9v7a/m
         rAGKOeTZJjmQnARguRLjOJu8pdPAu+QFiXoPzqD8EjuToZgevfwxHCarRSjdlq8V04OU
         4V0aRpy+GI1VtvX7wdRECj1Ym7SpFQaTyWaPoJEfp7zTdJgK6fVnDKKDUdr0s62xAjKK
         iBeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RnRKNpQgUsNpaNv3dsr453+uGBMHftMBsGXsYkGT7rE=;
        b=b17996BC9YKIhHFVLhZenwrPxYWWzF1aiMCwsA8Fh1SooAPHyYyPtRYnTQDLPJzqCz
         T29KV+McQg45hhH7VfabNJQQbJM0t2TUaxcebvWZcqbyZ2ZthPQx+QlryzkDygygWjwh
         2G4JA0IFnUb7xitTWPPpFycTaqEVsfNWdBq96IYHLBfTbWjEkmiI7xR2ovadXComXHTR
         EOEJWCRW2Gt5HoIWGiE/rBYXzmSHE0/ZA7y/E51VRSbW2JprulM+Q62lq2sjt98bDcwh
         g8fdkmjorXtMIXrh7To0jmYyokNKQWndZV5uNx+EkhM0Q/cZWbMCfaZhTGvqc6yiFygg
         dGag==
X-Gm-Message-State: AOAM532c0xlP9vfdzHHVvDV3nr6ZfjmylPU5wLotH0muCpY0IKkxAzZt
        59YoPxqDNqjjzp8NRMHZvaumzsnnvH0uwNQtBBY=
X-Google-Smtp-Source: ABdhPJwjxBiUafEVHyuGWn52BbQJ0CqM03RZxe6x+nPFht8IsWTxeJtB50Hqe7SlhdXwLRQr60FBUsOLgpi2U/OtPIQ=
X-Received: by 2002:ac2:5b5a:: with SMTP id i26mr2986484lfp.182.1616004964394;
 Wed, 17 Mar 2021 11:16:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210317031257.846314-1-andrii@kernel.org> <20210317031257.846314-2-andrii@kernel.org>
 <CAEf4BzYYkJqdvamkgoCqGF23Av44n322FMz+-HWO9YxXBNLqVw@mail.gmail.com>
In-Reply-To: <CAEf4BzYYkJqdvamkgoCqGF23Av44n322FMz+-HWO9YxXBNLqVw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 17 Mar 2021 11:15:53 -0700
Message-ID: <CAADnVQJ2+m4DVGpBQ_0a+vGDSodRqfpFhWzw1umEf_ytyY7kVw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpftool: generate NULL definition in vmlinux.h
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 10:38 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
> > diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> > index 62953bbf68b4..ff6a76632873 100644
> > --- a/tools/bpf/bpftool/btf.c
> > +++ b/tools/bpf/bpftool/btf.c
> > @@ -405,6 +405,8 @@ static int dump_btf_c(const struct btf *btf,
> >         printf("#ifndef __VMLINUX_H__\n");
> >         printf("#define __VMLINUX_H__\n");
> >         printf("\n");
> > +       printf("#define NULL ((void *)0)\n");
>
>
> On second thought, this could also be done in bpf_helpers.h, which is
> pretty much always included in BPF programs. I think that's a bit more
> maintainable and less magical to users, so I'll go with that in v3.

yep. good idea.
