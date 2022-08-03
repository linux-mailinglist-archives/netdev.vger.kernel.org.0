Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F785886B9
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 07:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbiHCFRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 01:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiHCFRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 01:17:06 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECA11A07A;
        Tue,  2 Aug 2022 22:17:04 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id bq11so19729326lfb.5;
        Tue, 02 Aug 2022 22:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=meGtRj2XpcdLQbxtaV5Bfx8H3VBURAu0Eltn/X5mBLY=;
        b=jRXYNNMvjCoVtfVRUBLSxBokOeECrYYAujKZkIuus4JGz2PxvCBvMt/f6Xl3/ETawH
         sf6/+zklwJpLWgkTKlWesqrBXR1409EPI1DiFn9jh3TjYrKVQxLmsLRfgnqVV9oeHlCk
         VSzg2O4nePWOTrBYCy/2iUk/PY3lMNHDREDTE56vpLSwzT5aCCiqVb0kkFTTuzp/oZK9
         HWZUzZ5dDIGBI8LE9DUvJrvHRDvpCj43WML0bF5C3x7lDgOYkrcQYUzOwLGy24q7MnLO
         +ZVY/NDnzX9ywEtBBV/O3Pd4f/xkpCkA3AnEYlPe0kbcCsjzJIvkmVlg0ya3JupLIchb
         o/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=meGtRj2XpcdLQbxtaV5Bfx8H3VBURAu0Eltn/X5mBLY=;
        b=bEK6DGaa42qU3EMGOHHus5V1FmF59SUa1B/BE0v+Q7xH/MdabEpRFT61EYFYy6AyhE
         e5fLC8xOyRtRT8WwBkwDrGs3VVdW8aVCr4ZD4EByzQbOqbf0T7P7bUUrzCaSKR4Mw2Dn
         qpsZR/whe97NEMCtSPN01w85RFMhOmfNoJqN/RxzMzfxLWMAtTlVeuLhoA+9lxHJrVhF
         CaLOSGkpwfUr5PNUtQhfyaQ6mCLX4fnZrMs08qa9Ig7aMAD1Sm2ZF1P8zb6TmsZxhp/c
         MKSaLz+MzEyOkJedFpl98zZhSC6ipfnE1ApklRz2x61W2FBBI8ewQxClS8s8JPJ9Ufza
         9wxg==
X-Gm-Message-State: AJIora8oNmW3/b10b4lhUs5tqFpJnubmmvGfLs6DofXgh2CPyPnfGioL
        2oVf1T4sa1VsUOh63o8i0qmtMzqGqwF5sBEn8X8=
X-Google-Smtp-Source: AGRyM1vilQG/YRhPB39ZgYkBykCFsk2rcVwfRDmw+aPSQxx4aDdikstuAQEOmDhMsK5eTaiooWXHM2A9vTxCPk7ba9w=
X-Received: by 2002:a19:8c04:0:b0:47f:65b7:bf11 with SMTP id
 o4-20020a198c04000000b0047f65b7bf11mr9090178lfd.630.1659503822967; Tue, 02
 Aug 2022 22:17:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220625153439.513559-1-tanzixuan.me@gmail.com>
 <YrhxE4s0hLvbbibp@krava> <CABwm_eT_LE6VbLMgT31yqW=tc_obLP=6E0jnMqVn1sMdWrVVNw@mail.gmail.com>
 <Yrqcpr7ICzpsoGrc@krava> <YufUAiLqKiuwdvcP@krava> <YuloQYU72pe4p3eK@kernel.org>
 <YulpPqXSOG0Q4J1o@kernel.org>
In-Reply-To: <YulpPqXSOG0Q4J1o@kernel.org>
From:   Zixuan Tan <tanzixuan.me@gmail.com>
Date:   Wed, 3 Aug 2022 13:16:51 +0800
Message-ID: <CABwm_eR-UmVr71XxJE-SUVHUCi-2OniDh7S9hhHZeNfp4KcZgA@mail.gmail.com>
Subject: Re: [PATCH] perf build: Suppress openssl v3 deprecation warnings in
 libcrypto feature test
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Zixuan Tan <tanzixuangg@gmail.com>, terrelln@fb.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 2:13 AM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Tue, Aug 02, 2022 at 03:09:05PM -0300, Arnaldo Carvalho de Melo escrev=
eu:
> >
> > So, we should start with =E8=B0=AD=E6=A2=93=E7=85=8A patch, then fix th=
at ifdef and go on
> > from there?
>
> I.e. with this:
>
>
> diff --git a/tools/perf/util/genelf.c b/tools/perf/util/genelf.c
> index aed49806a09bab8f..953338b9e887e26f 100644
> --- a/tools/perf/util/genelf.c
> +++ b/tools/perf/util/genelf.c
> @@ -30,7 +30,11 @@
>
>  #define BUILD_ID_URANDOM /* different uuid for each run */
>
> -#ifdef HAVE_LIBCRYPTO
> +// FIXME, remove this and fix the deprecation warnings before its remove=
d and
> +// We'll break for good here...
> +#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
> +
> +#ifdef HAVE_LIBCRYPTO_SUPPORT
>
>  #define BUILD_ID_MD5
>  #undef BUILD_ID_SHA    /* does not seem to work well when linked with Ja=
va */

yea, i think that's ok, thank you

Zixuan
