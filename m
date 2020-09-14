Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7772699CB
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgINXjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgINXjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 19:39:00 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E05FC06174A;
        Mon, 14 Sep 2020 16:39:00 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id c17so1167742ybe.0;
        Mon, 14 Sep 2020 16:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I7dF91nOzRRZ9iB8QZc3cTZeG14m2pTqG63xcQleWuc=;
        b=F5y4ieTNDGYqlK/V4BzvyHRZagwId+FzU69gQyozMBNbE0Gq7Ss7bdpyrQYO5HgKlK
         QJ7Iv0SeQ6ptRMMSBPTDrO/Y3aLpINuuH6YJwbq99iz7J/8ox/6IOOfMzEJa6V9CiYGo
         wXb9LZqZ1m3pN3gk1g7MkbhKM1mAKfHprn7aNe6gXU3UqmVd5FHlWlP4LeK9Z4jYnAPu
         22Iqlgvdcit/AVhaufNP6GDk78OuvEw5qFN+FJD52CSkH6yc5T9u9TlBRy/iNq/A1E0w
         vr+x2zjDGN5X8OxX3WTaQ46ywD2Qwu26qHdfH7DTXF1aGuQvdtS7Hd8ur9TAZ0FqVGjR
         JYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I7dF91nOzRRZ9iB8QZc3cTZeG14m2pTqG63xcQleWuc=;
        b=pNo573e7LOMcA8Iz2xPAMi8Me196z11xhJOhljiY7P3ROagtU2jQwJl7w16HbyW4VA
         kRRpSlKsPWR9VrCCioSrvq9/UiicYXrVBzpyHy+czlsw1UV+ug6ehJUbwlSEA86jM89v
         n+/kTvF3cmgtkwVi2xxYPyNE1r3tmrALtkTvcWzrkhCe5aJnzykm4RtW6KjsVBBUP/eR
         qt1QOxQk3RYpWFxKX0hiCoLxY9kIIqHhQXzLXpj+8sh9u/H0UNZrVNy4qkSTV9F5yON+
         n1btHdmJNlX+TYqtTW/P/XOmQH0F2tbu6ULUdfslHfyzc3oktn16CaD6pSH5DZRJqL/N
         GM3A==
X-Gm-Message-State: AOAM532Aths0ws9/Tc4bKT7YcgfCOBHvdikgUrGHyIoJbfxr/vXdQ0f7
        KuiiFxu1LtqZzWC364OVvJWWio1g8+2rOZ+ESir9WDwJQ0E=
X-Google-Smtp-Source: ABdhPJxvDxFJI8bMDy++s8w3qoL476hMaaTORE4dH1L8en94rK6fR8wA/WDCXcZSmxwyU5OTqWymt8C/Ar2RlDR4hBk=
X-Received: by 2002:a25:9d06:: with SMTP id i6mr23294566ybp.510.1600126739513;
 Mon, 14 Sep 2020 16:38:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200914183615.2038347-1-sdf@google.com> <20200914183615.2038347-5-sdf@google.com>
In-Reply-To: <20200914183615.2038347-5-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Sep 2020 16:38:48 -0700
Message-ID: <CAEf4BzZUS1Ht9mu3R+RY=CYbkdLt7k-xG5r35hUkeSDr_sjnFQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 4/5] bpftool: support dumping metadata
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

On Mon, Sep 14, 2020 at 11:37 AM Stanislav Fomichev <sdf@google.com> wrote:
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
>  tools/bpf/bpftool/prog.c        | 232 ++++++++++++++++++++++++++++++++
>  3 files changed, 241 insertions(+)
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
> index f7923414a052..f3eb4f53dd43 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -29,6 +29,9 @@
>  #include "main.h"
>  #include "xlated_dumper.h"
>
> +#define BPF_METADATA_PREFIX "bpf_metadata_"
> +#define BPF_METADATA_PREFIX_LEN (sizeof(BPF_METADATA_PREFIX) - 1)
> +
>  const char * const prog_type_name[] = {
>         [BPF_PROG_TYPE_UNSPEC]                  = "unspec",
>         [BPF_PROG_TYPE_SOCKET_FILTER]           = "socket_filter",
> @@ -151,6 +154,231 @@ static void show_prog_maps(int fd, __u32 num_maps)
>         }
>  }
>
> +static int find_metadata_map_id(int prog_fd, int *map_id)
> +{
> +       struct bpf_prog_info prog_info = {};
> +       struct bpf_map_info map_info;
> +       __u32 prog_info_len;
> +       __u32 map_info_len;
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
> +               return -errno;
> +
> +       if (!prog_info.nr_map_ids)
> +               return -ENOENT;
> +
> +       map_ids = calloc(prog_info.nr_map_ids, sizeof(__u32));
> +       if (!map_ids)
> +               return -ENOMEM;
> +
> +       nr_maps = prog_info.nr_map_ids;
> +       memset(&prog_info, 0, sizeof(prog_info));
> +       prog_info.nr_map_ids = nr_maps;
> +       prog_info.map_ids = ptr_to_u64(map_ids);
> +       prog_info_len = sizeof(prog_info);
> +
> +       ret = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &prog_info_len);
> +       if (ret) {
> +               ret = -errno;
> +               goto free_map_ids;
> +       }
> +
> +       for (i = 0; i < prog_info.nr_map_ids; i++) {
> +               map_fd = bpf_map_get_fd_by_id(map_ids[i]);
> +               if (map_fd < 0) {
> +                       ret = -errno;
> +                       goto free_map_ids;
> +               }
> +
> +               memset(&map_info, 0, sizeof(map_info));
> +               map_info_len = sizeof(map_info);
> +               ret = bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len);
> +               if (ret < 0) {
> +                       ret = -errno;
> +                       close(map_fd);
> +                       goto free_map_ids;
> +               }
> +               close(map_fd);
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

return value_size here to avoid extra syscall below; or rather just
accept bpf_map_info pointer and read everything into it?

> +               goto free_map_ids;
> +       }
> +
> +       ret = -ENOENT;
> +
> +free_map_ids:
> +       free(map_ids);
> +       return ret;
> +}
> +
> +static void *find_metadata(int prog_fd, struct bpf_map_info *map_info)
> +{
> +       __u32 map_info_len;
> +       void *value = NULL;
> +       int map_id = 0;
> +       int key = 0;
> +       int map_fd;
> +       int err;
> +
> +       err = find_metadata_map_id(prog_fd, &map_id);
> +       if (err < 0)
> +               return NULL;
> +
> +       map_fd = bpf_map_get_fd_by_id(map_id);
> +       if (map_fd < 0)
> +               return NULL;
> +
> +       map_info_len = sizeof(*map_info);
> +       err = bpf_obj_get_info_by_fd(map_fd, map_info, &map_info_len);
> +       if (err)
> +               goto out_close;
> +

see above, you are doing bpf_obj_get_info_by_fd just to get
value_size, which you already know

> +       value = malloc(map_info->value_size);
> +       if (!value)
> +               goto out_close;
> +
> +       if (bpf_map_lookup_elem(map_fd, &key, value))
> +               goto out_free;
> +
> +       close(map_fd);
> +       return value;
> +
> +out_free:
> +       free(value);
> +out_close:
> +       close(map_fd);
> +       return NULL;
> +}
> +
> +static bool has_metadata_prefix(const char *s)
> +{
> +       return strstr(s, BPF_METADATA_PREFIX) == s;

this is a substring check, not a prefix check, use strncmp instead

> +}
> +
> +static void show_prog_metadata(int fd, __u32 num_maps)
> +{
> +       const struct btf_type *t_datasec, *t_var;
> +       struct bpf_map_info map_info = {};

it should be memset

> +       struct btf_var_secinfo *vsi;
> +       bool printed_header = false;
> +       struct btf *btf = NULL;
> +       unsigned int i, vlen;
> +       void *value = NULL;
> +       const char *name;
> +       int err;
> +
> +       if (!num_maps)
> +               return;
> +

[...]

> +       } else {
> +               json_writer_t *btf_wtr = jsonw_new(stdout);
> +               struct btf_dumper d = {
> +                       .btf = btf,
> +                       .jw = btf_wtr,
> +                       .is_plain_text = true,
> +               };

empty line here?

> +               if (!btf_wtr) {
> +                       p_err("jsonw alloc failed");
> +                       goto out_free;
> +               }
> +

[...]
