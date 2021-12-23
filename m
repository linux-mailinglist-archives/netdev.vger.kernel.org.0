Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95A447DC08
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 01:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbhLWAd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 19:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbhLWAd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 19:33:27 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F2EC061574;
        Wed, 22 Dec 2021 16:33:27 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id y16so3021062ilq.8;
        Wed, 22 Dec 2021 16:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U1WLmerrlNpWkMEO2cFxQCeX0eYKdfN2pmF45N3xZ3Q=;
        b=XnM5ZYTefRbckJ6IzSoVqB0+f+R6jJhwy/JwPTnKwzOOBI3ADDPJyM8M65t0E2oxrT
         ThC7MSiXcw6CgF3Gh4Z3CsfLrlad9d+HmKfNweed39ebzU9Ca5J1P7y+yrzI2gkOjI50
         r9IEijIplIWGIuCHy6Rm9qJrY+KLFZwAao2P0S3leESEyiJgH1L6AZxgTNEzbpCVKR2z
         fN56AYuhN4XXnbC5dH+4r/j49zxsxdXxEhe1+PgOn3v3bwmTGBUOX5I3wFxW0OGLf4mF
         Z4uYvcOZegRPegFKn3PUMZz7TAmoGgf3gztYSNcCreWn48JqJlCMUE9y1uySL8k8+LR+
         K8sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U1WLmerrlNpWkMEO2cFxQCeX0eYKdfN2pmF45N3xZ3Q=;
        b=aFBScG+oup/9Q+ZV2P3phE0tCfi0HTgpmVDMRQCjyYOY7NcXPmvG0n1BkoQ0J4bR8+
         F+dBOywoRtYAneTITGMLd6RUfbtaJtbss5ngDwNlu2EGAgWWYXULpBYNZY/4uvpiqrss
         sL3j7U59i4YgUTxFvVt7tg4bMUwAJS+oIJqbuh4bS4wisZ1h8Go0Ujc/SBeaJfvP+Mmt
         3M+AYqLDaxewVOyoric6FRb8mUdP/p9tPZgmL5WoeO2UzqN3AwnNoSUZ/ZIh7+ayja0C
         jY/88jQz8rAwRzYR4VuIyx34CymKB8X4MHYBdepPK09yNjx4KXEdWwplAxl6i43ZMTgs
         DkPg==
X-Gm-Message-State: AOAM530CRWN8bUItaMZOk5qBpDUNy9Jmgj1HIhAn93vYFQjc/ryDHEpb
        tkXh+9zNaxtiiz/SlLUbr+GrH7CV7h3dBCFA1uAmG3BVkas=
X-Google-Smtp-Source: ABdhPJxBXid85PtrDMueq0MgAy4/GKqI3JaPQiv77gq+AHhWlXKIX6Z2NYD9G/vA7bK33bP/vYAdfz32fiBK8GYxTJg=
X-Received: by 2002:a05:6e02:1a21:: with SMTP id g1mr2524767ile.71.1640219606825;
 Wed, 22 Dec 2021 16:33:26 -0800 (PST)
MIME-Version: 1.0
References: <20211217185654.311609-1-mauricio@kinvolk.io> <20211217185654.311609-4-mauricio@kinvolk.io>
In-Reply-To: <20211217185654.311609-4-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 Dec 2021 16:33:15 -0800
Message-ID: <CAEf4BzZ6E_iRT-pBon5G6xA0kK=EYKSZQ3zDLVKQmTT8A12J_Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/3] bpftool: Implement btfgen
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 10:57 AM Mauricio V=C3=A1squez <mauricio@kinvolk.io=
> wrote:
>
> The BTFGen's goal is to produce a BTF file that contains **only** the
> information that is needed by an eBPF program. This algorithm does a
> first step collecting the types involved for each relocation present on
> the object and "marking" them as needed. Types are collected in
> different ways according to the type relocation, for field based
> relocations only the union and structures members involved are
> considered, for type based relocations the whole types are added, enum
> field relocations are not supported in this iteration yet.
>
> A second step generates a BTF file from the "marked" types. This step
> accesses the original BTF file extracting the types and their members
> that were "marked" as needed in the first step.
>
> This command is implemented under the "gen" command in bpftool and the
> syntax is the following:
>
> $ bpftool gen btf INPUT OUTPUT OBJECT(S)
>
> INPUT can be either a single BTF file or a folder containing BTF files,
> when it's a folder, a BTF file is generated for each BTF file contained
> in this folder. OUTPUT is the file (or folder) where generated files are
> stored and OBJECT(S) is the list of bpf objects we want to generate the
> BTF file(s) for (each generated BTF file contains all the types needed
> by all the objects).
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/bpf/bpftool/gen.c | 892 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 892 insertions(+)
>

I haven't looked through details of stripping BTF itself, let's
finalize CO-RE relocation parts first. Maybe for the next revision you
could split bpftool changes in two in some reasonable way so that each
patch concentrates on different steps of the process a bit more? E.g.,
first patch might set up new command and BTF stripping parts but leave
the CO-RE relocation logic unimplemented, and the second path fills in
that part. Should make it easier to review this big patch.

Please also cc Quentin Monnet to review bpftool parts as well.


[...]

> +static int btf_reloc_info_gen_type(struct btf_reloc_info *info, struct b=
pf_core_spec *targ_spec)
> +{
> +       struct btf *btf =3D (struct btf *) info->src_btf;
> +       struct btf_type *btf_type;
> +       int err =3D 0;
> +
> +       btf_type =3D (struct btf_type *) btf__type_by_id(btf, targ_spec->=
root_type_id);
> +
> +       return btf_reloc_put_type_all(btf, info, btf_type, targ_spec->roo=
t_type_id);
> +}
> +
> +static int btf_reloc_info_gen_enumval(struct btf_reloc_info *info, struc=
t bpf_core_spec *targ_spec)
> +{
> +       p_err("untreated enumval based relocation");

why untreated? what's the problem supporting it?

> +       return -EOPNOTSUPP;
> +}
> +
> +static int btf_reloc_info_gen(struct btf_reloc_info *info, struct bpf_co=
re_spec *res)
> +{
> +       if (core_relo_is_type_based(res->relo_kind))
> +               return btf_reloc_info_gen_type(info, res);
> +
> +       if (core_relo_is_enumval_based(res->relo_kind))
> +               return btf_reloc_info_gen_enumval(info, res);
> +
> +       if (core_relo_is_field_based(res->relo_kind))
> +               return btf_reloc_info_gen_field(info, res);

you can have a simple switch here instead of exposing libbpf internal helpe=
rs

> +
> +       return -EINVAL;
> +}
> +
> +#define BPF_INSN_SZ (sizeof(struct bpf_insn))
> +
> +static int btfgen_obj_reloc_info_gen(struct btf_reloc_info *reloc_info, =
struct bpf_object *obj)
> +{
> +       const struct btf_ext_info_sec *sec;
> +       const struct bpf_core_relo *rec;
> +       const struct btf_ext_info *seg;
> +       struct hashmap *cand_cache;
> +       int err, insn_idx, sec_idx;
> +       struct bpf_program *prog;
> +       struct btf_ext *btf_ext;
> +       const char *sec_name;
> +       size_t nr_programs;
> +       struct btf *btf;
> +       unsigned int i;
> +
> +       btf =3D bpf_object__btf(obj);
> +       btf_ext =3D bpf_object__btf_ext(obj);
> +
> +       if (btf_ext->core_relo_info.len =3D=3D 0)
> +               return 0;
> +
> +       cand_cache =3D bpf_core_create_cand_cache();
> +       if (IS_ERR(cand_cache))
> +               return PTR_ERR(cand_cache);
> +
> +       bpf_object_set_vmlinux_override(obj, reloc_info->src_btf);
> +
> +       seg =3D &btf_ext->core_relo_info;
> +       for_each_btf_ext_sec(seg, sec) {
> +               bool prog_found;
> +
> +               sec_name =3D btf__name_by_offset(btf, sec->sec_name_off);
> +               if (str_is_empty(sec_name)) {
> +                       err =3D -EINVAL;
> +                       goto out;
> +               }
> +
> +               prog_found =3D false;
> +               nr_programs =3D bpf_object__get_nr_programs(obj);
> +               for (i =3D 0; i < nr_programs; i++)       {
> +                       prog =3D bpf_object__get_program(obj, i);
> +                       if (strcmp(bpf_program__section_name(prog), sec_n=
ame) =3D=3D 0) {
> +                               prog_found =3D true;
> +                               break;
> +                       }
> +               }
> +
> +               if (!prog_found) {
> +                       pr_warn("sec '%s': failed to find a BPF program\n=
", sec_name);
> +                       err =3D -EINVAL;
> +                       goto out;
> +               }
> +
> +               sec_idx =3D bpf_program__sec_idx(prog);
> +
> +               for_each_btf_ext_rec(seg, sec, i, rec) {
> +                       struct bpf_core_relo_res targ_res;
> +                       struct bpf_core_spec targ_spec;
> +
> +                       insn_idx =3D rec->insn_off / BPF_INSN_SZ;
> +
> +                       prog =3D find_prog_by_sec_insn(obj, sec_idx, insn=
_idx);
> +                       if (!prog) {
> +                               pr_warn("sec '%s': failed to find program=
 at insn #%d for CO-RE offset relocation #%d\n",
> +                                       sec_name, insn_idx, i);
> +                               err =3D -EINVAL;
> +                               goto out;
> +                       }
> +
> +                       err =3D bpf_core_calc_relo_res(prog, rec, i, btf,=
 cand_cache, &targ_res,
> +                                                    &targ_spec);


I don't think you need to do *exactly* what libbpf is doing.
bpf_core_calc_relo_res() doesn't add much on top of
bpf_core_calc_relo_insn(), if you use bpf_core_calc_relo_insn()
directly and expose bpf_core_add_cands/bpf_core_free_cands and use
them directly as well, bypassing bpf_object completely, you won't need
btf_vmlinux override and make everything less coupled, I think. In the
future, if you'd like to support BTF module BTFs, you'll have all the
necessary flexibility to do that, while if you try to reuse every
single line of bpf_object's code we'll be adding more hacks like your
bpf_object_set_vmlinux_override().

Fundamentally, you don't care about bpf_object and bpf_programs. All
you need to do is parse .BTF.ext (you can do that just btf__parse, no
need to even construct bpf_object!). Construct candidate cache, then
iterate each CO-RE record, add find/add candidates, calculate
relocation result, use it for your algorithm.

Yes, there will be a bit of duplication (candidate search), but that's
better than trying to turn bpf_object inside out with all the custom
getters/setters that you are exposing (even if it's libbpf internal
only, still makes it really hard to reasons what's going on and what
are consequences of manual control over a lot of bpf_object internal
implementation details).


> +                       if (err)
> +                               goto out;
> +
> +                       err =3D btf_reloc_info_gen(reloc_info, &targ_spec=
);
> +                       if (err)
> +                               goto out;
> +               }
> +       }
> +
> +out:
> +       bpf_core_free_cand_cache(cand_cache);
> +
> +       return err;
> +}
> +

[...]
