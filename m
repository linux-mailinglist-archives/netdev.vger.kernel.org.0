Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563A91E572A
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 08:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgE1GCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 02:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgE1GCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 02:02:14 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276AAC05BD1E;
        Wed, 27 May 2020 23:02:14 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id f89so12417597qva.3;
        Wed, 27 May 2020 23:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=45G1LDDlVetLDg7OKETYjBt8f5wWe6ZxSy9i5esK7+k=;
        b=eSAvTXgyfNSZ9Y8cbyeWStfJ/phhH+Y9IbQ+Rg4rAA/LHP67OnhbGbUgp2qnJzXe9K
         mdCFPDEev5M4Sy5uk9Op/KZpvoCmj7VWxyZGMHqM8Jhmq+JJ2NuZtmQ+SXuj2lmYuzSq
         Y8xRXQUmwJhL/eHI8Fo+EqhvSWST9v+j+w29hiVMFCDuzHSdRhW/rekintuRIH69KzMq
         5bPHzENhje8lFy5/hC+gvbYFKVi/lVDFWb2HPEj1tLCW8EIqoxLQO4RIfDJsopFYVmZb
         4pIfDPX4NYbYnR0rqHRhI1njko5FO3h1Vu5SyyYNuMyRN9zmua0tIzbjlmE36jMrMDjj
         bWIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=45G1LDDlVetLDg7OKETYjBt8f5wWe6ZxSy9i5esK7+k=;
        b=cQ1PdmPHEGd6SuHfR1xLzSQzMtXJW6m+mj5sdEc54dzMopkktA7trluAmxOcoBY0rg
         l2Xm7ktBrkRG9LXGtYkTtmH9dTdZdZ780Y6Y+A0rt9rtp7zyXLVtSI0MR7BcMVmMD1Vk
         aEjRQHQw++2xndUxrQfLUIuJO9jaiPM5z3V3kMrWQ43OM0U7Xb4DY5cYfnrSMKvsO4k+
         xDoHeeIkfWEZfm0rERvJFxnuHP0MaxYmvwAImIGjgf3n+eFXOfp8hz0+kFYL42WHOnoQ
         JcNC1QSzpqRKh5qgCUnkn4qnhIE77aFgOiQ30Gd+6o2cDBOLfqugpreI6ZXrnZ3dBLiQ
         rcJA==
X-Gm-Message-State: AOAM530PjZuFK/BpDttBLR6P9Xy9LUOowfsDgruu5kjFb3+yODapNVb3
        KN4vy9WX3Gpp8SyDCGTivGL9/zinxK7792kS1Ww=
X-Google-Smtp-Source: ABdhPJxqCMNd09Kwmt2fKA0rosttsoiX1WdfBD78oyhh+hXVs9be7HNQuRRMBnctkVSpYkaVJSKlEFacoJ5PiMpMg3g=
X-Received: by 2002:a0c:a9c6:: with SMTP id c6mr1550426qvb.224.1590645732928;
 Wed, 27 May 2020 23:02:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200527170840.1768178-1-jakub@cloudflare.com> <20200527170840.1768178-8-jakub@cloudflare.com>
In-Reply-To: <20200527170840.1768178-8-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 May 2020 23:02:02 -0700
Message-ID: <CAEf4Bzb8cAOTc4G01020_Kd=z5p+XA+zqmtRvEj9JQsLw3-8sQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 7/8] bpftool: Support link show for
 netns-attached links
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 12:16 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Make `bpf link show` aware of new link type, that is links attached to
> netns. When listing netns-attached links, display netns inode number as its
> identifier and link attach type.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  tools/bpf/bpftool/link.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
> index 670a561dc31b..83a17d62c4c3 100644
> --- a/tools/bpf/bpftool/link.c
> +++ b/tools/bpf/bpftool/link.c
> @@ -17,6 +17,7 @@ static const char * const link_type_name[] = {
>         [BPF_LINK_TYPE_TRACING]                 = "tracing",
>         [BPF_LINK_TYPE_CGROUP]                  = "cgroup",
>         [BPF_LINK_TYPE_ITER]                    = "iter",
> +       [BPF_LINK_TYPE_NETNS]                   = "netns",
>  };
>
>  static int link_parse_fd(int *argc, char ***argv)
> @@ -122,6 +123,16 @@ static int show_link_close_json(int fd, struct bpf_link_info *info)
>                         jsonw_uint_field(json_wtr, "attach_type",
>                                          info->cgroup.attach_type);
>                 break;
> +       case BPF_LINK_TYPE_NETNS:
> +               jsonw_uint_field(json_wtr, "netns_ino",
> +                                info->netns.netns_ino);
> +               if (info->netns.attach_type < ARRAY_SIZE(attach_type_name))
> +                       jsonw_string_field(json_wtr, "attach_type",
> +                               attach_type_name[info->netns.attach_type]);
> +               else
> +                       jsonw_uint_field(json_wtr, "attach_type",
> +                                        info->netns.attach_type);
> +               break;

Can you please extract this attach_type handling into a helper func,
it's annoying to read so many repetitive if/elses. Same for plain-text
variant below. Thanks!

>         default:
>                 break;
>         }
> @@ -190,6 +201,14 @@ static int show_link_close_plain(int fd, struct bpf_link_info *info)
>                 else
>                         printf("attach_type %u  ", info->cgroup.attach_type);
>                 break;
> +       case BPF_LINK_TYPE_NETNS:
> +               printf("\n\tnetns_ino %u  ", info->netns.netns_ino);
> +               if (info->netns.attach_type < ARRAY_SIZE(attach_type_name))
> +                       printf("attach_type %s  ",
> +                              attach_type_name[info->netns.attach_type]);
> +               else
> +                       printf("attach_type %u  ", info->netns.attach_type);
> +               break;
>         default:
>                 break;
>         }
> --
> 2.25.4
>
