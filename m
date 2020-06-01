Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E391EB1C5
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgFAWfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgFAWfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:35:53 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21030C061A0E;
        Mon,  1 Jun 2020 15:35:53 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id c185so10744927qke.7;
        Mon, 01 Jun 2020 15:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=saDRZSQN+EO7hXiyKj+8p9AKheZQg+BkB4hiacIVfQA=;
        b=qDIyR6k+ojmOSeeaOGXKN+EfFJ76qNUtnz3A+L/Ok28wnhzJyK6/jNwUf6gow8HZaN
         xtKjRCX9V8wwhh24980eq/D5ekEpxgOcLmoEM4oeVsvvl+HJJTtutY/iDAPPPheRS2WB
         4rhMMR1lS25P4Pn4NJkDani2jNryK50OPKG7e5w6ZhO1T4/1wVEMnM8LZkq7NSPtGYOo
         XUN3elwLK+U6FcArpC/HYc/XtVaQx6DPZSY5ucnxABBQyIBUm/P+oPTK0AkwvAMWWtOD
         1KZUKrMbs8Zci7Qd2wqubUMikBH2fnuGzd+LENO/yMolQNdliR31F9Wpb6JCl12Yls3Q
         0zng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=saDRZSQN+EO7hXiyKj+8p9AKheZQg+BkB4hiacIVfQA=;
        b=qHbee2qC2UR9b9OAshkPlQ/PKNK0PTvrWz7QHgRkxia52ddXZwuksxRJRv1T+c0zHQ
         +TW7VQB8iRDZIdOOGOXujlhWrClB9uPmuBIajZP96V5p/0iZDevndCUNl6vXwoP6gIuY
         aMeF89D6O9F4eLsyoxEcsJpVLAzjQXvi35JCQa6SdIAYL5S0aX3/lAcvM+puW7LSG2ld
         sMLPUORiBkU6lMA/MbU7TZjR7CofgtV3dvJnWw6OjO2qY5e2UTxfm3tbQTSXAbei7ZID
         xvh5z1mKiG5D34PuGXIrwxtmq93bap+VLs3sqVCqxDedbwbiIYU+ist3g606OMY4gj0s
         JEVw==
X-Gm-Message-State: AOAM531TxSxfhnCaOK0QLShZYICSLVRhzpUmIWVYWM+iN7RSMJSAExdi
        Qh+f+gZ7KhuPjW5whQpCG9QtOxQss4Grdafy4iwOKEO8
X-Google-Smtp-Source: ABdhPJyfPXNuzgIhc2y4HFofcO6Tll7FFEr+iZn7PXBxcjfl9P2XT1rgtOQ7PCayKTIktvgdn/tQpXXdi/39o/pD2RM=
X-Received: by 2002:a05:620a:247:: with SMTP id q7mr22355592qkn.36.1591050952371;
 Mon, 01 Jun 2020 15:35:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200531082846.2117903-1-jakub@cloudflare.com> <20200531082846.2117903-8-jakub@cloudflare.com>
In-Reply-To: <20200531082846.2117903-8-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jun 2020 15:35:41 -0700
Message-ID: <CAEf4BzZqtuA_45g_87jyuAdmvid=XuLGekgBdWY8i94Pnztm7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 07/12] bpftool: Extract helpers for showing
 link attach type
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com, Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 31, 2020 at 1:32 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Code for printing link attach_type is duplicated in a couple of places, and
> likely will be duplicated for future link types as well. Create helpers to
> prevent duplication.
>
> Suggested-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

LGTM, minor nit below.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/bpf/bpftool/link.c | 44 ++++++++++++++++++++--------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
>
> diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
> index 670a561dc31b..1ff416eff3d7 100644
> --- a/tools/bpf/bpftool/link.c
> +++ b/tools/bpf/bpftool/link.c
> @@ -62,6 +62,15 @@ show_link_header_json(struct bpf_link_info *info, json_writer_t *wtr)
>         jsonw_uint_field(json_wtr, "prog_id", info->prog_id);
>  }
>
> +static void show_link_attach_type_json(__u32 attach_type, json_writer_t *wtr)

nit: if you look at jsonw_uint_field/jsonw_string_field, they accept
json_write_t as a first argument, because they are sort of working on
"object" json_writer_t. I think that's good and consistent. No big
deal, but if you can adjust it for consistency, it would be good.

> +{
> +       if (attach_type < ARRAY_SIZE(attach_type_name))
> +               jsonw_string_field(wtr, "attach_type",
> +                                  attach_type_name[attach_type]);
> +       else
> +               jsonw_uint_field(wtr, "attach_type", attach_type);
> +}
> +

[...]
