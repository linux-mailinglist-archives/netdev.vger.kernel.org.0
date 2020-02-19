Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A76164C33
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 18:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgBSRjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 12:39:03 -0500
Received: from mail-io1-f47.google.com ([209.85.166.47]:41986 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgBSRjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 12:39:02 -0500
Received: by mail-io1-f47.google.com with SMTP id z1so1459162iom.9;
        Wed, 19 Feb 2020 09:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NqZqDn5bC3qrX9T7zgEhb8g+GU/FvR/stsrD4iObuZQ=;
        b=X9zvwLC9CcZHqgPIQ1bcvQT+Km6yEWdhEDcrdQxe+fm3rt5ZsyxEfnT7+2R40qx4XU
         w4QZZdzt/Y2xlQG/WVC3oTtpWVEM1eOhepq/dcqB31fwn2TvXd5so/U4wOlSY8gX20cw
         g2t35KwR7X6qEobOD/tUn+1PmV7lSp768CAY/ojMmEMQft6TYneX+a8x+Oy63XE356UQ
         xe0XV7fn8G6EtubUBLCj+79p2bKp3GKYlhEdkbPMVrmW17rFEWCeccB6CY6hj1edXlLx
         VbQaK/3yzdm9Je3omJDBxKMYNHu9E2dNfmhxJ+qNzm1xnSONUGlQtAWaB+dJ34+diT87
         oeDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NqZqDn5bC3qrX9T7zgEhb8g+GU/FvR/stsrD4iObuZQ=;
        b=f1cUiy2nQlQS2zVbzxjNYqmtu4LyWej+jq7ZCSLEqqL9JPuF5USLDLagRd+F7QYGQK
         P5MfS3lTf2vVPlTq0STU048jMp4j6Mq55Pr4TyQQHzrA/PwuhfFaUoBetuNP3E6YsTkl
         01saCz1XFflPP70SHmIe8G3FVFy2qJ63x/TteRAR7IMTOenevTZ10YWi69l0AZAf0w7K
         7ym/HDYjsg65VVvGVUul60DxZSFNhgGAfbdaheo/UA5JRiedQR4oifwFN0iwVpHbeQub
         rAfldTdrKOVh5bQ9XOTU/q2+nUxyZcIbSxOESTc8soG1k/Tp+5SyeXGhncruH2IscnOD
         LGjA==
X-Gm-Message-State: APjAAAUu2ORnuOwCPHLlPgjykZZGNo6Nh828EjbomrTR4tKR+/UT+J3V
        WpFhfiTKOML4sqKhR+08GAbsep7zxN/eUccML8s=
X-Google-Smtp-Source: APXvYqytcLP0/O6ZlyxJez2KhFIvkXe2f4moQl8SIVRyls4nKPmnebXa5UJbXseH8nkHQXBNd7lbw8Q3dUoDpxnAILc=
X-Received: by 2002:a02:81cc:: with SMTP id r12mr21169261jag.93.1582133941816;
 Wed, 19 Feb 2020 09:39:01 -0800 (PST)
MIME-Version: 1.0
References: <20200219133012.7cb6ac9e@carbon> <CAADnVQKQRKtDz0Boy=-cudc4eKGXB-yParGZv6qvYcQR4uMUQQ@mail.gmail.com>
 <20200219180348.40393e28@carbon>
In-Reply-To: <20200219180348.40393e28@carbon>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Feb 2020 09:38:50 -0800
Message-ID: <CAEf4Bza9imKymHfv_LpSFE=kNB5=ZapTS3SCdeZsDdtrUrUGcg@mail.gmail.com>
Subject: Re: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 9:04 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Wed, 19 Feb 2020 08:41:27 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > On Wed, Feb 19, 2020 at 4:30 AM Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote:
> > >
> > > I'm willing to help out, such that we can do either version or feature
> > > detection, to either skip compiling specific test programs or at least
> > > give users a proper warning of they are using a too "old" LLVM version.
> > ...
> > > progs/test_core_reloc_bitfields_probed.c:47:13: error: use of unknown builtin '__builtin_preserve_field_info' [-Wimplicit-function-declaration]
> > >         out->ub1 = BPF_CORE_READ_BITFIELD_PROBED(in, ub1);
> >
> > imo this is proper warning message already.
>
> This is an error, not a warning.  The build breaks as the make process stops.
>

Latest Clang was a requirement for building and running all selftests
for a long time now. There were few previous discussions on mailing
list about this and each time the conclusion was the same: latest
Clang is a requirement for BPF selftests.

> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
