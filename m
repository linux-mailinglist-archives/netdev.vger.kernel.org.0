Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66DCE1207D3
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfLPOCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:02:41 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39572 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbfLPOCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 09:02:40 -0500
Received: by mail-lj1-f196.google.com with SMTP id e10so6925265ljj.6;
        Mon, 16 Dec 2019 06:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UhN/eqfKU832dKjc9f7z2JGm23eudeZhMsBeYXMgqeI=;
        b=P7hQ8ruiCJF2o8Oyvj0Ig9sxCiXH/oKpfbs4IUyJ/OGaRLFUaK4+YnLIkPsPq7oPjF
         xGkRoE2TUjdenj+AZC6L8R0rFk+quapjQNa3tI+DJZYKoj5qU/OmT/0KePZapjLD0vMp
         RF5kdrNG3mXF7sR/WXucCB4KQm3kIeN8Za4Z3gpD3LbuEH2Svewc5trUYjkVLwmukMPC
         SdJD2sRMdM98J1NsCDVJt1nRuC0sWF3AVDPaZjCZ3d7WmGh/hRkiPsyueM0PNTD3VPnD
         4YG9GEOrskc+nxwx3YdVD1o2JJmZltim/Y9p6G8DsHotVYsyeqa9p+6hJRx8ZUPqOnR/
         FySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UhN/eqfKU832dKjc9f7z2JGm23eudeZhMsBeYXMgqeI=;
        b=Mnl1EiP1LlMHhXG0sWGh+7pj3+iBZQtOCe7vm8VzCTtB79kUM5qnENdG7sBUIrabxd
         vJkggSCj+OzOS8mVu3zSYCJFOo5H9e7NIcFUgNq2fyRd0p45bbTPhWEUMfS5VoghcebM
         1a+5vgxXKjPPhuuiFDjUnI6gGhMuHnI7PkRVOImM9pfoAaI5iCfA4EZhaAfK3cZhMdIm
         z6C6GO3uqIu9SotMmp2B7MgfNlLWwiKjd0hi/hj+b+F2Y0M/ul9TDt8xisjAKKU7pMZl
         7e/MV0L62ZUaddos3iYubi/hDWrGPqXEq5lWNdPVSkSrBHSpqQss5ye9AbYiK/1NTKv2
         cwgg==
X-Gm-Message-State: APjAAAWGGoyyuzOEsq85KqZ6PZcgV+qszB15j2ZYoozGxrGIsxwzi1z3
        U5h7RZUEG+CVz551dYNfj8cJe2X3c9MoiC2Y+4M=
X-Google-Smtp-Source: APXvYqxkTe2BTe7bA2An7DZVfw7NaxBtMlGyhFIIEd/zUsJil7vzGMAyfGkQInWzrtE7aMM4LyliPj450+odcsl9PXg=
X-Received: by 2002:a2e:999a:: with SMTP id w26mr20000807lji.142.1576504958396;
 Mon, 16 Dec 2019 06:02:38 -0800 (PST)
MIME-Version: 1.0
References: <20191216082738.28421-1-prashantbhole.linux@gmail.com> <20191216132512.GD14887@linux.fritz.box>
In-Reply-To: <20191216132512.GD14887@linux.fritz.box>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 16 Dec 2019 06:02:26 -0800
Message-ID: <CAADnVQKB7hUmXBMmPfFUH4ZxSQfRtam0aEWykBNMhrKS+HjcwQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix build by renaming variables
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 5:25 AM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On Mon, Dec 16, 2019 at 05:27:38PM +0900, Prashant Bhole wrote:
> > In btf__align_of() variable name 't' is shadowed by inner block
> > declaration of another variable with same name. Patch renames
> > variables in order to fix it.
> >
> >   CC       sharedobjs/btf.o
> > btf.c: In function =E2=80=98btf__align_of=E2=80=99:
> > btf.c:303:21: error: declaration of =E2=80=98t=E2=80=99 shadows a previ=
ous local [-Werror=3Dshadow]
> >   303 |   int i, align =3D 1, t;
> >       |                     ^
> > btf.c:283:25: note: shadowed declaration is here
> >   283 |  const struct btf_type *t =3D btf__type_by_id(btf, id);
> >       |
> >
> > Fixes: 3d208f4ca111 ("libbpf: Expose btf__align_of() API")
> > Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
>
> Applied, thanks!

Prashant,
Thanks for the fixes.
Which compiler do use?
Sadly I didn't see any of those with my gcc 6.3.0
Going to upgrade it. Need to decide which one.
