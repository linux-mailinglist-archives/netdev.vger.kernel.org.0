Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B71264FE7
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgIJTyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbgIJTyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:54:37 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00311C061573;
        Thu, 10 Sep 2020 12:54:36 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id r7so4849744ybl.6;
        Thu, 10 Sep 2020 12:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JoiRjr4QzSYH1nSdAMXQjSqmGBiAzP672/JWpidYBuk=;
        b=EvgzHK98V2z8BFYTtP2IUGjouUkE+g/tdBAF+bU7fIWB50gAuuRbTzVEQykeHGbA4m
         wJotqJ7/eaFXUQHTYG8hv+Ty7xkXhyOX+sphrHVr2SJNStZwvHItmFyJhjP2AGUYLhMy
         ujiJ+czcApW+9hJ5+xTXAYX/PnhyYCgFiaJRK3BNprNyeKoiF8b1b0BztL3znauV1Lu8
         qarxG7pNVMpg3X3gpVj9OByLZa9YqA7rJdUthNe9dcDG+w0+b/4UZWW94Qw5kPf7Gk9S
         DCyP0w/FDVnfQlfpgBI9M7Q6QXYKnE8redtDW/PpYA6iUIoHPbRieDeZIYgzdQ89keRR
         NJFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JoiRjr4QzSYH1nSdAMXQjSqmGBiAzP672/JWpidYBuk=;
        b=OYplFpxGx4FY2zfGgc/yn5zXalMVs7/+vggAwlfPhwx+K+7rz12+x0pQxpiKQyNuCj
         WcsotRROEAebP93usCQ8s4Hh2kPCDrKUHK2bZTNUvDjEpXUw24QKuvlHUCK77t8nPPzk
         lN2xYTZJgY8jzf7jK/hfWEZex3jA3D/BA5QvC5d8fL1OB732QuIkH7Glfiej8Kmu4H2z
         67GujGd/s+6GJqg3HiLjeqM4+C4NUWag5fIfFU62QiHvnSh/42z8fJOaO4nqhl/5vIYw
         VZ35AsWZ/MeCSk0N7A+aI1b61g27gw1PmOoibwp87H/IU/Nze68c5z6ekrHKkkaiEH60
         jCcA==
X-Gm-Message-State: AOAM530YT3tlxtFWxTDV2h0EcxFI2DBTE8jFnSwVxnRTMm1jnYzzldf8
        XT95kuHa5tCC5iALya984fFlaVNNf6UCOFDD+hk=
X-Google-Smtp-Source: ABdhPJz+tX0XUg5bt0j+bZ6xT7Zl+QCGAcDOpfKn7X+Y68DOUAnDd5szBgNdWShBGjT6SLbtYh7ci7OHB3tsd0oodT8=
X-Received: by 2002:a25:6885:: with SMTP id d127mr14553801ybc.27.1599767676051;
 Thu, 10 Sep 2020 12:54:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200909182406.3147878-1-sdf@google.com> <20200909182406.3147878-5-sdf@google.com>
In-Reply-To: <20200909182406.3147878-5-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Sep 2020 12:54:25 -0700
Message-ID: <CAEf4BzaWxnm_X=nZWn0tcq7bMnbL8ZFDuU=qzMNDh_aSAayXsA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/5] bpftool: support dumping metadata
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 11:25 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> From: YiFei Zhu <zhuyifei@google.com>
>
> Dump metadata in the 'bpftool prog' list if it's present.
> For some formatting some BTF code is put directly in the
> metadata dumping. Sanity checks on the map and the kind of the btf_type
> to make sure we are actually dumping what we are expecting.
>
> A helper jsonw_reset is added to json writer so we can reuse the same
> json writer without having extraneous commas.
>
> Sample output:
>
>   $ bpftool prog
>   6: cgroup_skb  name prog  tag bcf7977d3b93787c  gpl
>   [...]
>         btf_id 4
>         metadata:
>                 a = "foo"
>                 b = 1
>
>   $ bpftool prog --json --pretty
>   [{
>           "id": 6,
>   [...]
>           "btf_id": 4,
>           "metadata": {
>               "a": "foo",
>               "b": 1
>           }
>       }
>   ]
>
> Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> Signed-off-by: YiFei Zhu <zhuyifei@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/bpf/bpftool/json_writer.c |   6 +
>  tools/bpf/bpftool/json_writer.h |   3 +
>  tools/bpf/bpftool/prog.c        | 222 ++++++++++++++++++++++++++++++++
>  3 files changed, 231 insertions(+)
>
> diff --git a/tools/bpf/bpftool/json_writer.c b/tools/bpf/bpftool/json_writer.c
> index 86501cd3c763..7fea83bedf48 100644
> --- a/tools/bpf/bpftool/json_writer.c
> +++ b/tools/bpf/bpftool/json_writer.c
> @@ -119,6 +119,12 @@ void jsonw_pretty(json_writer_t *self, bool on)
>         self->pretty = on;
>  }
>
> +void jsonw_reset(json_writer_t *self)
> +{
> +       assert(self->depth == 0);
> +       self->sep = '\0';
> +}
> +
>  /* Basic blocks */
>  static void jsonw_begin(json_writer_t *self, int c)
>  {
> diff --git a/tools/bpf/bpftool/json_writer.h b/tools/bpf/bpftool/json_writer.h
> index 35cf1f00f96c..8ace65cdb92f 100644
> --- a/tools/bpf/bpftool/json_writer.h
> +++ b/tools/bpf/bpftool/json_writer.h
> @@ -27,6 +27,9 @@ void jsonw_destroy(json_writer_t **self_p);
>  /* Cause output to have pretty whitespace */
>  void jsonw_pretty(json_writer_t *self, bool on);
>
> +/* Reset separator to create new JSON */
> +void jsonw_reset(json_writer_t *self);
> +
>  /* Add property name */
>  void jsonw_name(json_writer_t *self, const char *name);
>
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index f7923414a052..ca264dc22434 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -29,6 +29,9 @@
>  #include "main.h"
>  #include "xlated_dumper.h"
>
> +#define BPF_METADATA_PREFIX "bpf_metadata_"
> +#define BPF_METADATA_PREFIX_LEN strlen(BPF_METADATA_PREFIX)

this is a runtime check, why not (sizeof(BPF_METADATA_PREFIX) - 1) instead?

> +
>  const char * const prog_type_name[] = {
>         [BPF_PROG_TYPE_UNSPEC]                  = "unspec",
>         [BPF_PROG_TYPE_SOCKET_FILTER]           = "socket_filter",
> @@ -151,6 +154,221 @@ static void show_prog_maps(int fd, __u32 num_maps)
>         }
>  }
>
> +static int bpf_prog_find_metadata(int prog_fd, int *map_id)
> +{
> +       struct bpf_prog_info prog_info = {};
> +       struct bpf_map_info map_info;
> +       __u32 prog_info_len;
> +       __u32 map_info_len;
> +       int saved_errno;
> +       __u32 *map_ids;
> +       int nr_maps;
> +       int map_fd;
> +       int ret;
> +       __u32 i;
> +
> +       prog_info_len = sizeof(prog_info);
> +
> +       ret = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &prog_info_len);
> +       if (ret)
> +               return ret;
> +
> +       if (!prog_info.nr_map_ids) {
> +               errno = ENOENT;
> +               return -1;
> +       }
> +
> +       map_ids = calloc(prog_info.nr_map_ids, sizeof(__u32));
> +       if (!map_ids) {
> +               errno = ENOMEM;
> +               return -1;
> +       }
> +
> +       nr_maps = prog_info.nr_map_ids;
> +       memset(&prog_info, 0, sizeof(prog_info));
> +       prog_info.nr_map_ids = nr_maps;
> +       prog_info.map_ids = ptr_to_u64(map_ids);
> +       prog_info_len = sizeof(prog_info);
> +
> +       ret = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &prog_info_len);
> +       if (ret)
> +               goto free_map_ids;
> +
> +       for (i = 0; i < prog_info.nr_map_ids; i++) {
> +               map_fd = bpf_map_get_fd_by_id(map_ids[i]);
> +               if (map_fd < 0) {
> +                       ret = -1;
> +                       goto free_map_ids;
> +               }
> +
> +               memset(&map_info, 0, sizeof(map_info));
> +               map_info_len = sizeof(map_info);
> +               ret = bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len);
> +
> +               saved_errno = errno;
> +               close(map_fd);
> +               errno = saved_errno;
> +               if (ret)
> +                       goto free_map_ids;
> +
> +               if (map_info.type != BPF_MAP_TYPE_ARRAY)
> +                       continue;
> +               if (map_info.key_size != sizeof(int))
> +                       continue;
> +               if (map_info.max_entries != 1)
> +                       continue;
> +               if (!map_info.btf_value_type_id)
> +                       continue;
> +               if (!strstr(map_info.name, ".rodata"))
> +                       continue;
> +
> +               *map_id = map_ids[i];
> +               goto free_map_ids;
> +       }
> +
> +       ret = -1;
> +       errno = ENOENT;
> +
> +free_map_ids:
> +       saved_errno = errno;
> +       free(map_ids);
> +       errno = saved_errno;

not clear why all this fussing with saving/restoring errno and then
just returning 0 or -1? Just return -ENOMEM or -ENOENT as a result of
this function?

> +       return ret;
> +}
> +
> +static bool has_metadata_prefix(const char *s)
> +{
> +       return strstr(s, BPF_METADATA_PREFIX) == s;
> +}
> +
> +static void show_prog_metadata(int fd, __u32 num_maps)
> +{
> +       const struct btf_type *t_datasec, *t_var;
> +       struct bpf_map_info map_info = {};
> +       struct btf_var_secinfo *vsi;
> +       bool printed_header = false;
> +       struct btf *btf = NULL;
> +       unsigned int i, vlen;
> +       __u32 map_info_len;
> +       void *value = NULL;
> +       const char *name;
> +       int map_id = 0;
> +       int key = 0;
> +       int map_fd;
> +       int err;
> +
> +       if (!num_maps)
> +               return;
> +
> +       err = bpf_prog_find_metadata(fd, &map_id);
> +       if (err < 0)
> +               return;
> +
> +       map_fd = bpf_map_get_fd_by_id(map_id);
> +       if (map_fd < 0)
> +               return;
> +
> +       map_info_len = sizeof(map_info);
> +       err = bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len);
> +       if (err)
> +               goto out_close;
> +
> +       value = malloc(map_info.value_size);
> +       if (!value)
> +               goto out_close;
> +
> +       if (bpf_map_lookup_elem(map_fd, &key, value))
> +               goto out_free;
> +
> +       err = btf__get_from_id(map_info.btf_id, &btf);
> +       if (err || !btf)
> +               goto out_free;

if you make bpf_prog_find_metadata() to do this value lookup and pass
&info, it would probably make bpf_prog_find_metadata a bit more
usable? You'll just need to ensure that callers free allocated memory.
Then show_prog_metadata() would take care of processing BTF info.

> +
> +       t_datasec = btf__type_by_id(btf, map_info.btf_value_type_id);
> +       if (!btf_is_datasec(t_datasec))
> +               goto out_free;
> +
> +       vlen = btf_vlen(t_datasec);
> +       vsi = btf_var_secinfos(t_datasec);
> +
> +       /* We don't proceed to check the kinds of the elements of the DATASEC.
> +        * The verifier enforces them to be BTF_KIND_VAR.
> +        */
> +

[...]
