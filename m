Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB0A4A885F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352139AbiBCQKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352140AbiBCQKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:10:37 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A40C06173B
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:10:36 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id o12so6915899lfg.12
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 08:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0tkAxmlZeDxfe59hdMG4L0TPJuZdDFMedxxxRKehFAM=;
        b=Dxe3ieBEOKtkM7k9hRhxq+mLNhQf28X9k1FicACi6bVd9AI6ptSnufjnBv3K70FhdQ
         5tHgPk9tlAn3IWP1Je/bhHgliOGsWcHX6LHRhqVpNiu2kTPDpMjD52FzhZrMkDgYLT+O
         RWZfvIKEkGnYupyrfra1wqgrU+qjax5CmgCNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0tkAxmlZeDxfe59hdMG4L0TPJuZdDFMedxxxRKehFAM=;
        b=WFYYcvJCvUUpC+OmYiL27m3g3meOWHX2GozPRx2Je2VSvsIcEEZzghBrv1luoiY+y1
         UT09BWv0VcFdd7ZXo09tQGnBy1P1QBm7jqKerZvB/lq9mYCK1bHlLGV7+DKpou8pkNBV
         zKcZden3OTigoirjfW32gcrX9rY2nOI4GjT4UpWigR0em9w8Vf9lzPHYIplTK6DOm0Qg
         6+Blrj2o4UQBnC7WBGveZC2dM+ytiP25ww+7K3p3CofR9aj32olYsNxAuQZPnQZ7zQJ7
         2kpGVNyyvfUPUIJYEc9D5GeUZdy5UMnE2d2saI2aWpXDOtSEfeT1KBctyXHlanpmv3sA
         ZIZw==
X-Gm-Message-State: AOAM531GZQxcJ48gelVOSGRbi6m5G2cOuKY1179V9uqhR144tPFlbyXi
        z/vVbJAS0w6FQBxdWQn/GO0JUNdEeNpFi9nJRstXrQ==
X-Google-Smtp-Source: ABdhPJw3DsL3ApkNzehm5iNofgDYosUotWO99o/qiryUgUelNUPMkPMySJEVIwBMVg+8JB8HnhgHHEO24ZEXEpAIL0s=
X-Received: by 2002:ac2:4843:: with SMTP id 3mr26366813lfy.193.1643904633387;
 Thu, 03 Feb 2022 08:10:33 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-8-mauricio@kinvolk.io>
 <CAEf4BzaQ-hwdgqxYro5DjdY_=nnXTJVravt0D9qHW=PQZe-Lfg@mail.gmail.com>
In-Reply-To: <CAEf4BzaQ-hwdgqxYro5DjdY_=nnXTJVravt0D9qHW=PQZe-Lfg@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Thu, 3 Feb 2022 11:10:22 -0500
Message-ID: <CAHap4zsn2oQ53PKXgFAzii73SujwfY-Em92xWr9kCPP7vcxRyg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 7/9] bpftool: Implement btfgen_get_btf()
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

On Wed, Feb 2, 2022 at 2:37 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jan 28, 2022 at 2:33 PM Mauricio V=C3=A1squez <mauricio@kinvolk.i=
o> wrote:
> >
> > The last part of the BTFGen algorithm is to create a new BTF object wit=
h
> > all the types that were recorded in the previous steps.
> >
> > This function performs two different steps:
> > 1. Add the types to the new BTF object by using btf__add_type(). Some
> > special logic around struct and unions is implemented to only add the
> > members that are really used in the field-based relocations. The type
> > ID on the new and old BTF objects is stored on a map.
> > 2. Fix all the type IDs on the new BTF object by using the IDs saved in
> > the previous step.
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > ---
> >  tools/bpf/bpftool/gen.c | 158 +++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 157 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > index 7413ec808a80..55e6f640cbbb 100644
> > --- a/tools/bpf/bpftool/gen.c
> > +++ b/tools/bpf/bpftool/gen.c
> > @@ -1599,10 +1599,166 @@ static int btfgen_record_obj(struct btfgen_inf=
o *info, const char *obj_path)
> >         return err;
> >  }
> >
> > +static unsigned int btfgen_get_id(struct hashmap *ids, unsigned int ol=
d)
> > +{
> > +       uintptr_t new =3D 0;
> > +
> > +       /* deal with BTF_KIND_VOID */
> > +       if (old =3D=3D 0)
> > +               return 0;
> > +
> > +       if (!hashmap__find(ids, uint_as_hash_key(old), (void **)&new)) =
{
> > +               /* return id for void as it's possible that the ID we'r=
e looking for is
> > +                * the type of a pointer that we're not adding.
> > +                */
> > +               return 0;
> > +       }
> > +
> > +       return (unsigned int)(uintptr_t)new;
> > +}
> > +
> > +static int btfgen_add_id(struct hashmap *ids, unsigned int old, unsign=
ed int new)
> > +{
> > +       return hashmap__add(ids, uint_as_hash_key(old), uint_as_hash_ke=
y(new));
> > +}
> > +
> >  /* Generate BTF from relocation information previously recorded */
> >  static struct btf *btfgen_get_btf(struct btfgen_info *info)
> >  {
> > -       return ERR_PTR(-EOPNOTSUPP);
> > +       struct hashmap_entry *entry;
> > +       struct btf *btf_new =3D NULL;
> > +       struct hashmap *ids =3D NULL;
> > +       size_t bkt;
> > +       int err =3D 0;
> > +
> > +       btf_new =3D btf__new_empty();
> > +       if (libbpf_get_error(btf_new))
> > +               goto err_out;
> > +
> > +       ids =3D hashmap__new(btfgen_hash_fn, btfgen_equal_fn, NULL);
> > +       if (IS_ERR(ids)) {
> > +               errno =3D -PTR_ERR(ids);
> > +               goto err_out;
> > +       }
> > +
> > +       /* first pass: add all types and add their new ids to the ids m=
ap */
> > +       hashmap__for_each_entry(info->types, entry, bkt) {
> > +               struct btfgen_type *btfgen_type =3D entry->value;
> > +               struct btf_type *btf_type =3D btfgen_type->type;
> > +               int new_id;
> > +
> > +               /* we're adding BTF_KIND_VOID to the list but it can't =
be added to
> > +                * the generated BTF object, hence we skip it here.
> > +                */
> > +               if (btfgen_type->id =3D=3D 0)
> > +                       continue;
> > +
> > +               /* add members for struct and union */
> > +               if (btf_is_struct(btf_type) || btf_is_union(btf_type)) =
{
> > +                       struct hashmap_entry *member_entry;
> > +                       struct btf_type *btf_type_cpy;
> > +                       int nmembers, index;
> > +                       size_t new_size;
> > +
> > +                       nmembers =3D btfgen_type->members ? hashmap__si=
ze(btfgen_type->members) : 0;
> > +                       new_size =3D sizeof(struct btf_type) + nmembers=
 * sizeof(struct btf_member);
> > +
> > +                       btf_type_cpy =3D malloc(new_size);
> > +                       if (!btf_type_cpy)
> > +                               goto err_out;
> > +
> > +                       /* copy header */
> > +                       memcpy(btf_type_cpy, btf_type, sizeof(*btf_type=
_cpy));
> > +
> > +                       /* copy only members that are needed */
> > +                       index =3D 0;
> > +                       if (nmembers > 0) {
> > +                               size_t bkt2;
> > +
> > +                               hashmap__for_each_entry(btfgen_type->me=
mbers, member_entry, bkt2) {
> > +                                       struct btfgen_member *btfgen_me=
mber;
> > +                                       struct btf_member *btf_member;
> > +
> > +                                       btfgen_member =3D member_entry-=
>value;
> > +                                       btf_member =3D btf_members(btf_=
type) + btfgen_member->idx;
> > +
> > +                                       memcpy(btf_members(btf_type_cpy=
) + index, btf_member,
> > +                                              sizeof(struct btf_member=
));
>
> you know that you are working with btf_type and btf_member, each have
> just a few well known fields, why memcpy instead of just setting each
> field individually? I think that would make code much easier to follow
> and understand what transformations it's doing (and what it doesn't do
> either).
>

Removing those memcpy() helps a lot! Do you think doing a structure
assignment would be enough? Or do you prefer to copy field by field?

> > +
> > +                                       index++;
> > +                               }
> > +                       }
> > +
> > +                       /* set new vlen */
> > +                       btf_type_cpy->info =3D btf_type_info(btf_kind(b=
tf_type_cpy), nmembers,
> > +                                                          btf_kflag(bt=
f_type_cpy));
> > +
> > +                       err =3D btf__add_type(btf_new, info->src_btf, b=
tf_type_cpy);
> > +                       free(btf_type_cpy);
> > +               } else {
> > +                       err =3D btf__add_type(btf_new, info->src_btf, b=
tf_type);
> > +               }
> > +
> > +               if (err < 0)
> > +                       goto err_out;
> > +
> > +               new_id =3D err;
> > +
> > +               /* add ID mapping */
> > +               err =3D btfgen_add_id(ids, btfgen_type->id, new_id);
> > +               if (err)
> > +                       goto err_out;
> > +       }
> > +
> > +       /* second pass: fix up type ids */
> > +       for (unsigned int i =3D 0; i < btf__type_cnt(btf_new); i++) {
> > +               struct btf_member *btf_member;
> > +               struct btf_type *btf_type;
> > +               struct btf_param *params;
> > +               struct btf_array *array;
> > +
> > +               btf_type =3D (struct btf_type *) btf__type_by_id(btf_ne=
w, i);
> > +
> > +               switch (btf_kind(btf_type)) {
> > +               case BTF_KIND_STRUCT:
> > +               case BTF_KIND_UNION:
> > +                       for (unsigned short j =3D 0; j < btf_vlen(btf_t=
ype); j++) {
> > +                               btf_member =3D btf_members(btf_type) + =
j;
> > +                               btf_member->type =3D btfgen_get_id(ids,=
 btf_member->type);
> > +                       }
> > +                       break;
> > +               case BTF_KIND_PTR:
> > +               case BTF_KIND_TYPEDEF:
> > +               case BTF_KIND_VOLATILE:
> > +               case BTF_KIND_CONST:
> > +               case BTF_KIND_RESTRICT:
> > +               case BTF_KIND_FUNC:
> > +               case BTF_KIND_VAR:
> > +                       btf_type->type =3D btfgen_get_id(ids, btf_type-=
>type);
> > +                       break;
> > +               case BTF_KIND_ARRAY:
> > +                       array =3D btf_array(btf_type);
> > +                       array->index_type =3D btfgen_get_id(ids, array-=
>index_type);
> > +                       array->type =3D btfgen_get_id(ids, array->type)=
;
> > +                       break;
> > +               case BTF_KIND_FUNC_PROTO:
> > +                       btf_type->type =3D btfgen_get_id(ids, btf_type-=
>type);
> > +                       params =3D btf_params(btf_type);
> > +                       for (unsigned short j =3D 0; j < btf_vlen(btf_t=
ype); j++)
> > +                               params[j].type =3D btfgen_get_id(ids, p=
arams[j].type);
> > +                       break;
>
> did you try using btf_type_visit_type_ids() instead of this entire loop?
>

ah, that helped a lot, thanks!

> > +               default:
> > +                       break;
> > +               }
> > +       }
> > +
> > +       hashmap__free(ids);
> > +       return btf_new;
> > +
> > +err_out:
> > +       btf__free(btf_new);
> > +       hashmap__free(ids);
> > +       return NULL;
> >  }
> >
> >  /* Create BTF file for a set of BPF objects.
> > --
> > 2.25.1
> >
