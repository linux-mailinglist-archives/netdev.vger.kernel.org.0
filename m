Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC7A4B3221
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 01:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354478AbiBLAm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 19:42:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349382AbiBLAmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 19:42:55 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB5CD7E;
        Fri, 11 Feb 2022 16:42:53 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id m8so8121789ilg.7;
        Fri, 11 Feb 2022 16:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Uvk0lSkAmQ8V+y+39vQh8Xa6bJV8tcjxfMjgi5RWk1E=;
        b=Y56XbDxWWJeBMtQJVKnQNgKF103lGHHPu9XZLcLKqx7zKmDC+7QzJCHcQHi70jDKnN
         RDALsl4ASR1sppJDzZH0oqZ1atMMecSb5sta7rVa+mkgkGHCM9Z/na/eMXYiKWd6nevW
         IcDLVAn0A89Q5NnXMd6TPKFAfqiIULYkpxQO3w9OtKtlbVGF0/WGu/QMntAKKgkdAwiQ
         TbtIVeNBaqrHI9d8zAZEzrDh0ZTOJLmoLXlBjEqs9itXVD+biT/YZqPhPNX3nGwv98Uk
         35DbgYSkc3tUcrgEjUeJgSrtwZYcCjrfJjfve7MsacqX990WuIakTBk7E5TBogEYjJsr
         Jkow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Uvk0lSkAmQ8V+y+39vQh8Xa6bJV8tcjxfMjgi5RWk1E=;
        b=TkkrGE1ZzrAtnbh723xDfBv6RGidTkENP8uZgxN7nSXJ4KqHo05CvHlulVnqTGl+Uf
         MZJYP5urYZOH2hjWtaoBi0TUa+QCTJESxnuR8NM2PlemF7gmYF9IcjRoIS49WPesVb8/
         +m2vT1I2AvAX1MTLnVYCgOTDKkvrsK6Y4f1ulicKLjmwLWB+X2o/sTf35AilC036wmjH
         MFc5/EuBLifiRah1IRj++qUIgvb2QTeNeOQigNAMg/wlSJ6ueBiMoiFtZMuOgXpGBu2W
         rYlP5Vyn32Sc/camm3TmAPS66rMv9po6dPge9ybuYm/kkXtMOH1XsFZktBAwL4tk74bE
         nFdw==
X-Gm-Message-State: AOAM533roueTbOVjZtlLPCQJsdoe7g2V2FmJySNNk798nFoiQEs4q+Sp
        KQl70oP2btHmxWePVU6BzbY6CMUhNPn+XND4rDQ=
X-Google-Smtp-Source: ABdhPJz1LpLzzBHs3TZFirFJ0NBlbHy4pRwfQw/n2TtVtVh6ajaxpDdPGiDrQ4k69A8pgfxYlfPs2c2BB7j+aN9aPik=
X-Received: by 2002:a05:6e02:2163:: with SMTP id s3mr2122649ilv.252.1644626573210;
 Fri, 11 Feb 2022 16:42:53 -0800 (PST)
MIME-Version: 1.0
References: <20220209222646.348365-1-mauricio@kinvolk.io> <20220209222646.348365-7-mauricio@kinvolk.io>
In-Reply-To: <20220209222646.348365-7-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Feb 2022 16:42:42 -0800
Message-ID: <CAEf4BzYp4bCBYrbXGw75x6WFqM_k6Bhy3D73hR9TR1O8S7gXcQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 6/7] bpftool: gen min_core_btf explanation and examples
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 9, 2022 at 2:27 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io> =
wrote:
>
> From: Rafael David Tinoco <rafaeldtinoco@gmail.com>
>
> Add "min_core_btf" feature explanation and one example of how to use it
> to bpftool-gen man page.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  .../bpf/bpftool/Documentation/bpftool-gen.rst | 93 +++++++++++++++++++
>  1 file changed, 93 insertions(+)
>

[...]

> +Now, the "5.4.0-smaller.btf" file may be used by libbpf as an external B=
TF file
> +when loading the "one.bpf.o" object into the "5.4.0-example" kernel. Not=
e that
> +the generated BTF file won't allow other eBPF objects to be loaded, just=
 the
> +ones given to min_core_btf.
> +
> +::
> +
> +  struct bpf_object *obj =3D NULL;
> +  struct bpf_object_open_opts openopts =3D {};
> +
> +  openopts.sz =3D sizeof(struct bpf_object_open_opts);
> +  openopts.btf_custom_path =3D "./5.4.0-smaller.btf";
> +
> +  obj =3D bpf_object__open_file("./one.bpf.o", &openopts);

Can you please use LIBBPF_OPTS() macro in the example, that's how
users are normally expected to use OPTS-based APIs anyways. Also there
is no need for "./" when specifying file location. This is a different
case than running a binary in the shell, where binary is searched in
PATH. This is never done when opening files.

So all this should be:

LIBBPF_OPTS(bpf_object_open_opts, opts, .btf_custom_path =3D "5.4.0-smaller=
.btf");
struct bpf_object *obj;

obj =3D bpf_object__open_file("one.bpf.o", &opts);

That's all.


> +
> +  ...
> --
> 2.25.1
>
