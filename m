Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445D911BA5A
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730630AbfLKRcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:32:24 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37032 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730284AbfLKRcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:32:24 -0500
Received: by mail-qk1-f195.google.com with SMTP id m188so20369738qkc.4;
        Wed, 11 Dec 2019 09:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y74W7ds/oFSqwevvK+SoBp1jmUpvfeeCvpHuniIjFnI=;
        b=ga2dZfSN+dgMxCb7+mr0MXMi4VZEM4Kbl2ZHFI55U7CSELZlckhDsuxYeaAyUcLllD
         0pMTWWi9heBvi+CDF2TuO2cjXEszibIByTzP1pX6UqrvQc4yhBVGPdarnCr7Pn1j0jjR
         +WWPbzCRC3yQs5uSknCMFKjAz8906bulU0calnoiZCJwhnb+Wn2BVBC9ewN+s+wyQicm
         KBZA7chwUtzR+DEMpUum576m7n1Tozm82FmJ2KJm2q7ZTdhwK5PbOyX82yRRf3aYyJLU
         2P1QJWPg//B9rFaoi6LhmpEP2WbB3QNzDJsHvoNUA3jqBathx9ygFm+lIrtrsSdZ6Le/
         WkRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y74W7ds/oFSqwevvK+SoBp1jmUpvfeeCvpHuniIjFnI=;
        b=QuZaTnjIEcJgKRO8h4ottdeSehHUofip46GDXxrDRZ/ckVtFpuaD7++UR9lt6whCoV
         kx6weU7OR7ww+SSQxBs/tlD1M+a0syN2y1CsPfrm5V8LhrC7CZXBxOkeV1e+vvTXXxKa
         M0xNjO2xf0JoHVDYwQPWomIiLk6ws2P1mrRNvBwNYSzxy+9nRP5pkXTpNg8Yr9HkKupv
         0f1/+MN/0vMpSL5zoVg19uclWfmWx394XtqJlwOXYfMcABPy3C8GrdNAQqerTYVC/yn4
         DLUHvKtsWmM0QJhRGJAWnZzmTY97zU+qw8WAEBmf/a6v/OFcK5tvOuaOeFIdtJqy9zoz
         XlBA==
X-Gm-Message-State: APjAAAVyt4yggMj2SVUH1omPJZS/zYUVYU1MYYm8IU3FRcwxvPs5H5wb
        CgTak+g2nwen6vsIZIp7RKW7Upj5jyP2RJW+gUU=
X-Google-Smtp-Source: APXvYqzeKrfttwoz7uCUCmS3pptZ2DRwu3fNc1/S/9GLlDtRYDRGVejZaLAuSslD9Gvd1luGOeT1OpV0LeGyZbWXyBc=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr4123300qkq.437.1576085543078;
 Wed, 11 Dec 2019 09:32:23 -0800 (PST)
MIME-Version: 1.0
References: <20191209224022.3544519-1-andriin@fb.com> <20191211135703.GB25011@linux.fritz.box>
In-Reply-To: <20191211135703.GB25011@linux.fritz.box>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Dec 2019 09:32:12 -0800
Message-ID: <CAEf4BzZjAiWkYdCwDyE-vy4zdO6j461m1Wj5qKffRrzfFj1G_A@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: Bump libpf current version to v0.0.7
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 5:57 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Mon, Dec 09, 2019 at 02:40:22PM -0800, Andrii Nakryiko wrote:
> > New development cycles starts, bump to v0.0.7 proactively.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Subject says 'bpf', but I applied this to bpf-next, thanks!

Oh, my bad, was intending against bpf-next, of course. Thanks for fixing up!
