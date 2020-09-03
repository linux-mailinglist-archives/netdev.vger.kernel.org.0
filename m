Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9564F25B9F1
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 07:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbgICFAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 01:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgICFAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 01:00:23 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2681C061244;
        Wed,  2 Sep 2020 22:00:22 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id u6so1292333ybf.1;
        Wed, 02 Sep 2020 22:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hufVs9CSdVE99Y5iE4c1rRhMRkXCv/9nFdoUeT893t4=;
        b=Z4dLMpK/Ltw6sZxSRFz+mrtj7QYzbmn6vKfoWbS6wQT0jnCOUtCak4a83kMKSXmHlD
         u4Sk/gNH2vx/HXzExocRVxoiVIjYukQ4HESjZRblsHMnbs0AR9e5OqJXcwPzJIkVGUCS
         TVURRCfpzkTz3qMwsJ9Br8o4BVyBrttUEdwMvK6aMvMs/NOxkMVlwpPi7Y0aAg5xUKzv
         Jh8aUUr0aqO7SN/8Xf8MdbdP5HhNReQrauHQj7oNvWXEIB9s2wxS6JmyDqXQYIYQcnDv
         ekKOLo9re0b0j4dGJdQBPo0QgDeB0uvOT2ce0Ba3ZN0EyaWRc5c3j16eRhQ3sYqg5T86
         RxZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hufVs9CSdVE99Y5iE4c1rRhMRkXCv/9nFdoUeT893t4=;
        b=jFVYGsRyZmMfqFRt8Pqh8an6Cyl42TPzHSyEYvgTTA7NKonJ/VrKrK4sG6PpVVMwr9
         HljJes8WNGyUfUispYV+DpAnO3hAQ0BNYtM9Ms3tsNa+SLVKKLjHGgUO4DN5otJ6Cx5L
         bPkPkDw1V7CoZgy4FbWfervrsgYYxExAHy+RhBmIFH0En5VnhZ7p52DQ85Poj0NE0SA6
         KHaEzPFiyCCHcHrxUC5SKlkjVVaZ00AHJFxVNM33RSyU+sSsuhvTcn9mV+UQjXMsBWV+
         Bx0WVN6vAzUtzHxSQDUDz2FYktkQv+ACa0lnprChzj8669cn35AiCl9KX5D+hZyOiJr9
         GSpw==
X-Gm-Message-State: AOAM532+WlFdFaoVTZqzbiKgvTk1eVXnjsGSJ77buDSKR/uf3jidMIog
        rRZckg74N5IfyPIdoD0vnqaktBL/hDZf38XVhSk=
X-Google-Smtp-Source: ABdhPJyGUYleZJ8S1sTpHSKvKvpQZFkIfAiCIViOaPKVVkplMijxzs/qfrjmGrHxRZdu5pw/Qo7gK5QhztE9qd+Jrvg=
X-Received: by 2002:a25:c4c2:: with SMTP id u185mr266977ybf.347.1599109221681;
 Wed, 02 Sep 2020 22:00:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com> <20200828193603.335512-6-sdf@google.com>
In-Reply-To: <20200828193603.335512-6-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Sep 2020 22:00:10 -0700
Message-ID: <CAEf4BzZcb+CKwL72mgC5B+2wAi8hfT_OoVUNZCcZjKgu4zRxiA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 5/8] bpftool: support dumping metadata
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 28, 2020 at 12:37 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> From: YiFei Zhu <zhuyifei@google.com>
>
> Added a flag "--metadata" to `bpftool prog list` to dump the metadata
> contents. For some formatting some BTF code is put directly in the
> metadata dumping. Sanity checks on the map and the kind of the btf_type
> to make sure we are actually dumping what we are expecting.
>
> A helper jsonw_reset is added to json writer so we can reuse the same
> json writer without having extraneous commas.
>
> Sample output:
>
>   $ bpftool prog --metadata
>   6: cgroup_skb  name prog  tag bcf7977d3b93787c  gpl
>   [...]
>         btf_id 4
>         metadata:
>                 metadata_a = "foo"
>                 metadata_b = 1
>
>   $ bpftool prog --metadata --json --pretty
>   [{
>           "id": 6,
>   [...]
>           "btf_id": 4,
>           "metadata": {
>               "metadata_a": "foo",
>               "metadata_b": 1
>           }
>       }
>   ]
>
> Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> Signed-off-by: YiFei Zhu <zhuyifei@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/bpf/bpftool/json_writer.c |   6 ++
>  tools/bpf/bpftool/json_writer.h |   3 +
>  tools/bpf/bpftool/main.c        |  10 +++
>  tools/bpf/bpftool/main.h        |   1 +
>  tools/bpf/bpftool/prog.c        | 130 ++++++++++++++++++++++++++++++++
>  5 files changed, 150 insertions(+)
>

[...]

> +
> +       if (bpf_map_lookup_elem(map_fd, &key, value)) {
> +               p_err("metadata map lookup failed: %s", strerror(errno));
> +               goto out_free;
> +       }
> +
> +       err = btf__get_from_id(map_info.btf_id, &btf);

what if the map has no btf_id associated (e.g., because of an old
kernel?); why fail in this case?

> +       if (err || !btf) {
> +               p_err("metadata BTF get failed: %s", strerror(-err));
> +               goto out_free;
> +       }
> +
> +       t_datasec = btf__type_by_id(btf, map_info.btf_value_type_id);
> +       if (BTF_INFO_KIND(t_datasec->info) != BTF_KIND_DATASEC) {

btf_is_datasec(t_datasec)

> +               p_err("bad metadata BTF");
> +               goto out_free;
> +       }
> +
> +       vlen = BTF_INFO_VLEN(t_datasec->info);

btf_vlen(t_datasec)

> +       vsi = (struct btf_var_secinfo *)(t_datasec + 1);

btf_var_secinfos(t_datasec)

> +
> +       /* We don't proceed to check the kinds of the elements of the DATASEC.
> +        * The verifier enforce then to be BTF_KIND_VAR.

typo: then -> them

> +        */
> +
> +       if (json_output) {
> +               struct btf_dumper d = {
> +                       .btf = btf,
> +                       .jw = json_wtr,
> +                       .is_plain_text = false,
> +               };
> +
> +               jsonw_name(json_wtr, "metadata");
> +
> +               jsonw_start_object(json_wtr);
> +               for (i = 0; i < vlen; i++) {

nit: doing ++vsi here


> +                       t_var = btf__type_by_id(btf, vsi[i].type);

and vsi->type here and below would look a bit cleaner

> +
> +                       jsonw_name(json_wtr, btf__name_by_offset(btf, t_var->name_off));
> +                       err = btf_dumper_type(&d, t_var->type, value + vsi[i].offset);
> +                       if (err) {
> +                               p_err("btf dump failed");
> +                               break;
> +                       }
> +               }
> +               jsonw_end_object(json_wtr);

[...]
