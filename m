Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC49F4A8858
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352088AbiBCQIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiBCQIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:08:52 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13359C06173B
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:08:52 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id n8so7013368lfq.4
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 08:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BtSlgZlv3rdg4xQgXHdmtk+SFHDQUR6Ka2X6gjGV0AU=;
        b=a1E3iGitIhUPBwyEXaTzSxlS1kAbC/c745QQnwrUonnxYOtnDPGCAW3J+j5PJrl8GK
         04CX82yjUKy1dKphMnUVRPkto14UdpVxaBajjH2pmXG+5WdztPvTZ6IVknJFxd8ZRTSl
         lANZkUhQaVFGk8HDrJzZ3zALPuJm7nhW6ij30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BtSlgZlv3rdg4xQgXHdmtk+SFHDQUR6Ka2X6gjGV0AU=;
        b=HrdfMilsl7z510A3kwsMzCYawRj7lujUKNedjAKi9+MPjbUR6o5lYEEX1/acd4Twy0
         EqWoJxvsTLPNuI3cxWE0/mTX62xHQBCc9UohXhjGV+VKIOCHs+GhTg/2s+bBVTuyCAaN
         5YyM9KnWmJTVycIDQ9hw8sUZFJETgGlUs9AzUqDEaHVFeJsbZcoDenk8wBJdzs5hpejp
         aM1e+39WzbwMBhVNJ8VyzBiityqeSodXASTDH0rc0zJOgp08jN2UYoeYL44uZUv/+Q8E
         S8lO1WQ/iMNR7JNJQHZmPP1S96IF/G89vL9NhL6d/2cFslGITk7EfCxfnQnDOlNVDD1Z
         htkA==
X-Gm-Message-State: AOAM532d9UfDt1EPL8+F4KM9viH8iLOajm16ACbDpZIhwbgRjx9JjJzs
        mz64024lyQZK7Plesaj5lXH0dJrLkstt6r1NmEv9KQ==
X-Google-Smtp-Source: ABdhPJyJo2yuToMwvhfoqysChdQOMFkhIbuTAcTvjbunYXV1X/HJWHPrk87mUaU7ZJoqNwDp5oqQyIkBNON5lg6sHbg=
X-Received: by 2002:a05:6512:3a95:: with SMTP id q21mr25644065lfu.569.1643904530446;
 Thu, 03 Feb 2022 08:08:50 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-5-mauricio@kinvolk.io>
 <CAEf4BzaCJMUZ5ZVNgbVnCE0nmEETBo1iAp75nKp+mh2uKfJ9HQ@mail.gmail.com>
In-Reply-To: <CAEf4BzaCJMUZ5ZVNgbVnCE0nmEETBo1iAp75nKp+mh2uKfJ9HQ@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Thu, 3 Feb 2022 11:08:39 -0500
Message-ID: <CAHap4zuC4EbSfX_N64Uc4m=3hi-hrQWMVuZm9jefPsjPVLNGpw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 4/9] bpftool: Add struct definitions and
 helpers for BTFGen
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 1:55 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jan 28, 2022 at 2:33 PM Mauricio V=C3=A1squez <mauricio@kinvolk.i=
o> wrote:
> >
> > Add some structs and helpers that will be used by BTFGen in the next
> > commits.
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > ---
>
> Similar considerations with unused static functions. It's also harder
> to review when I don't see how these types are actually used, so
> probably better to put it in relevant patches that are using this?
>

The next iteration splits the patches in a way that types are
introduced in the same commit they're used.

> >  tools/bpf/bpftool/gen.c | 75 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 75 insertions(+)
> >
> > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > index 64371f466fa6..68bb88e86b27 100644
> > --- a/tools/bpf/bpftool/gen.c
> > +++ b/tools/bpf/bpftool/gen.c
> > @@ -1118,6 +1118,81 @@ static int btf_save_raw(const struct btf *btf, c=
onst char *path)
> >         return err;
> >  }
> >
> > +struct btfgen_type {
> > +       struct btf_type *type;
> > +       unsigned int id;
> > +};
> > +
> > +struct btfgen_info {
> > +       struct hashmap *types;
> > +       struct btf *src_btf;
> > +};
> > +
> > +static size_t btfgen_hash_fn(const void *key, void *ctx)
> > +{
> > +       return (size_t)key;
> > +}
> > +
> > +static bool btfgen_equal_fn(const void *k1, const void *k2, void *ctx)
> > +{
> > +       return k1 =3D=3D k2;
> > +}
> > +
> > +static void *uint_as_hash_key(int x)
> > +{
> > +       return (void *)(uintptr_t)x;
> > +}
> > +
> > +static void btfgen_free_type(struct btfgen_type *type)
> > +{
> > +       free(type);
> > +}
> > +
> > +static void btfgen_free_info(struct btfgen_info *info)
> > +{
> > +       struct hashmap_entry *entry;
> > +       size_t bkt;
> > +
> > +       if (!info)
> > +               return;
> > +
> > +       if (!IS_ERR_OR_NULL(info->types)) {
> > +               hashmap__for_each_entry(info->types, entry, bkt) {
> > +                       btfgen_free_type(entry->value);
> > +               }
> > +               hashmap__free(info->types);
> > +       }
> > +
> > +       btf__free(info->src_btf);
> > +
> > +       free(info);
> > +}
> > +
> > +static struct btfgen_info *
> > +btfgen_new_info(const char *targ_btf_path)
> > +{
> > +       struct btfgen_info *info;
> > +
> > +       info =3D calloc(1, sizeof(*info));
> > +       if (!info)
> > +               return NULL;
> > +
> > +       info->src_btf =3D btf__parse(targ_btf_path, NULL);
> > +       if (libbpf_get_error(info->src_btf)) {
>
> bpftool is using libbpf 1.0 mode, so don't use libbpf_get_error()
> anymore, just check for NULL
>

hmm, I got confused because libbpf_get_error() is still used in many
places in bpftool. I suppose those need to be updated.

> also, if you are using errno for propagating error, you need to store
> it locally before btfgen_free_info() call, otherwise it can be
> clobbered
>

Fixed.



> > +               btfgen_free_info(info);
> > +               return NULL;
> > +       }
> > +
> > +       info->types =3D hashmap__new(btfgen_hash_fn, btfgen_equal_fn, N=
ULL);
> > +       if (IS_ERR(info->types)) {
> > +               errno =3D -PTR_ERR(info->types);
> > +               btfgen_free_info(info);
> > +               return NULL;
> > +       }
> > +
> > +       return info;
> > +}
> > +
> >  /* Create BTF file for a set of BPF objects */
> >  static int btfgen(const char *src_btf, const char *dst_btf, const char=
 *objspaths[])
> >  {
> > --
> > 2.25.1
> >
