Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79DC1250AF
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfLRSb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:31:56 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38175 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfLRSbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:31:55 -0500
Received: by mail-qt1-f194.google.com with SMTP id n15so2731570qtp.5;
        Wed, 18 Dec 2019 10:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oa+OryP6aRC588wXmTUa5c53bZo1GWBbm2otIkopLj4=;
        b=ic/JWmZPIpkepq9wExGAJrOIa7ovCMo4qkmifKXr91zMAYS+pmckeq0UEkB2B80Xay
         j915Z+phi9kDFCk8ZURFjgYxFpzDXrlfq880yIor0z2/WmFgXbSP+UeP6HFXaglS20yY
         vTStA1FxS8mej2FORNC6ln4qWTqkiouddFqpms6U0pEwo1i/+d+LCj/3wlpyqanbNWk2
         a4dnU1xi+uWUo1lZq7EeXHAHnfeL26XPFVx0pHZoWMzxtjUyWmiJmAWgf8HEBlFQI36i
         7eZu3omEYTRVFtR4SWkHy6tYdU//NGzEsRE7yQCbOXt8kNIa6idKtVB4nCBXV9FbjK4Y
         xSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oa+OryP6aRC588wXmTUa5c53bZo1GWBbm2otIkopLj4=;
        b=gqwFMr1Oe+PAKUk8pVYl4VW+0S2k19SQ6+KCzlo2Q42jvogdYqUiblok1tcPDitx2j
         tvWN0BAVRt5AR6//07qzsmr/rcfkzRaWqwOlQSpksLkEzT1cuXZ6Xrn3ESPkbCzbqtW0
         +VBdGvZsApOuxpNaGndNDs40gu5y/dvWQOoWDetgSdcprDgj9WAcr2gMxWN3OHIVHk37
         FDnAFr5cHbDWs1l5/HV76kI9pHILo+j/cNM/E9vqQHShZ97mAro2e2m5WPKt29iFt5wT
         tmubKgVfrRw7//2mJYCilUFE2Eszy2qPyfg3bx8NqAF9VmsEANhbXU5mqNBD6Idn/cg3
         9+LA==
X-Gm-Message-State: APjAAAWAxmUmBiaru0N3QL/aV7Nq9w2V7olBTIheqqXxzqxq0uRm2cQF
        aXOkyPkfCDNYCTopCFHMHEMfyO+ITXodM5dO1hQ=
X-Google-Smtp-Source: APXvYqw4UItI+33AMwW8cKPtG4sAVHjMCw3su1uqLyoRPWLwjpNxaz6bHqr6SgyxIOEggQKQ+C+2XjZEtFg2XawyKU0=
X-Received: by 2002:ac8:1385:: with SMTP id h5mr3437619qtj.59.1576693914854;
 Wed, 18 Dec 2019 10:31:54 -0800 (PST)
MIME-Version: 1.0
References: <20191218052552.2915188-1-andriin@fb.com> <20191218062335.folwsve44bkawsvi@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191218062335.folwsve44bkawsvi@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Dec 2019 10:31:43 -0800
Message-ID: <CAEf4BzZU62cEfkA0JBAC0sNc8bKsD9vHh=3AnNXoT9fMDsoR=g@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/3] Skeleton improvements and documentation
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 10:23 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Dec 17, 2019 at 09:25:49PM -0800, Andrii Nakryiko wrote:
> > Simplify skeleton usage by embedding source BPF object file inside skeleton
> > itself. This allows to keep skeleton and object file in sync at all times with
> > no chance of confusion.
> >
> > Also, add bpftool-gen.rst manpage, explaining concepts and ideas behind
> > skeleton. In examples section it also includes a complete small BPF
> > application utilizing skeleton, as a demonstration of API.
> >
> > Patch #2 also removes BPF_EMBED_OBJ, as there is currently no use of it.
> >
> > v2->v3:
> > - (void) in no-args function (Alexei);
> > - bpftool-gen.rst code block formatting fix (Alexei);
> > - simplified xxx__create_skeleton to fill in obj and return error code;
> >
> > v1->v2:
> > - remove whitespace from empty lines in code blocks (Yonghong).
>
> Applied. Thanks.
>
> This bit:
> +                 layout will be created. Currently supported ones are: .data,
> +                 .bss, .rodata, and .extern structs/data sections. These
> didn't render correctly in the man page for me.
> Not sure whehther it's an issue in my setup or .rst is invalid.
> Please take a look.

Will do, I see the same. Must be some weird dot interaction in
reStructureText syntax, no idea...


> Overall new man page looks great.
>

Thanks!
