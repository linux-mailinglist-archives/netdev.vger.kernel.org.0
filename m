Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1232C5616EC
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 11:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbiF3J5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 05:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbiF3J5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 05:57:34 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C15433BD;
        Thu, 30 Jun 2022 02:57:34 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q18so16541835pld.13;
        Thu, 30 Jun 2022 02:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rwia0VdFehH5wT6gPhoFqGiZeLttRegpHQE0PVOn3Qw=;
        b=G3/wvJ2Xp9cyeUCEOl5v0njqeifCt3YkhU7rH7bx4looSwYcIxMIIOjLwcL504psNg
         MKnkc4T5fgF/tL2C9wx2/b/8C+p97+HavexKavsS3pZQMyQEQc2oMSxfEUCfrq5jRIJI
         IOMO1CU82Zq7o0XI0gr3zOdAmmmkusrUt6LibV7gfMZAgIWavPEBNF78uqnnvCXJdI7J
         RJzCaltnirpTFsz4u3qsf8xQnkK3UQSO2+ZM1YMWb4+jjZf+BB5KRdBMtqBkJGcndxL8
         8h6S8wmGjGxFPeF97eNEq12kMOI06GkoKXiExPTO6WouYSSyvNZI0UR6BHyntGFzXdMO
         Asag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rwia0VdFehH5wT6gPhoFqGiZeLttRegpHQE0PVOn3Qw=;
        b=Ykc4BRaXty4FUvRH7kVu2WhSuiCKK0vaxpe+FX61M9cYFENMc2PEcifNXEQSsIs8v+
         8qVIZgGfK2BhutFAOKsO8vlZZun24bVJn4GKDDSZDESE0+71zAea7w4IVch8XG0gmbma
         0StT8qG8b44zdolyaOGHnJ5snQh2Z+ce36xBHDna59UKWRB/xiGA4NXvaHzdqDSvaOr3
         xtUS98HsIo4ecq/BXmhWolWkFT3gC3QIYXghpRt0MW8MS1Xz0lXmsaRtWNAhFNIdnexX
         uNg5ljE+vXL8n+n6SWEQIuT0rv8pzVnfFykySiJLjD3o+Dp7GH6kd5qPvZPY0aaWvBQs
         Cv9w==
X-Gm-Message-State: AJIora9DARNtRyL7TfkkHaCkWEqCGHKg+nGBWP1Kbn39oj2qslhNBs2w
        WMHncXqGoZosZ991M2pWgtwkfs5tx0buwEZutqnoDEjUFoxMt3LSHEo=
X-Google-Smtp-Source: AGRyM1siXF6/2CWHJJeLPjQoIGjliQv/6n5btBsbIpNbsEORr3vK3Gat3ETnxsyTVhOgtf6CHCSSIp/ULXtHrfXhVwc=
X-Received: by 2002:a17:902:d292:b0:16a:2a8d:616e with SMTP id
 t18-20020a170902d29200b0016a2a8d616emr13544932plc.5.1656583053663; Thu, 30
 Jun 2022 02:57:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220629143458.934337-1-maciej.fijalkowski@intel.com> <20220629143458.934337-3-maciej.fijalkowski@intel.com>
In-Reply-To: <20220629143458.934337-3-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 30 Jun 2022 11:57:22 +0200
Message-ID: <CAJ8uoz3+_9=YwGCOCBKYC1UjSS5WMPX44KrAgmv8-zifU9kKMw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] selftests: xsk: introduce XDP prog load
 based on existing AF_XDP socket
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 4:38 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Currently, xsk_setup_xdp_prog() uses anonymous xsk_socket struct which
> means that during xsk_create_bpf_link() call, xsk->config.xdp_flags is
> always 0. This in turn means that from xdpxceiver it is impossible to
> use xdpgeneric attachment, so since commit 3b22523bca02 ("selftests,
> xsk: Fix bpf_res cleanup test") we were not testing SKB mode at all.
>
> To fix this, introduce a function, called xsk_setup_xdp_prog_xsk(), that
> will load XDP prog based on the existing xsk_socket, so that xsk
> context's refcount is correctly bumped and flags from application side
> are respected. Use this from xdpxceiver side so we get coverage of
> generic and native XDP program attach points.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 2 +-
>  tools/testing/selftests/bpf/xsk.c        | 5 +++++
>  tools/testing/selftests/bpf/xsk.h        | 1 +
>  3 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index 019c567b6b4e..c024aa91ea02 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -1130,7 +1130,7 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
>         if (!ifindex)
>                 exit_with_error(errno);
>
> -       ret = xsk_setup_xdp_prog(ifindex, &ifobject->xsk_map_fd);
> +       ret = xsk_setup_xdp_prog_xsk(ifobject->xsk->xsk, &ifobject->xsk_map_fd);
>         if (ret)
>                 exit_with_error(-ret);
>
> diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
> index fa13d2c44517..db911127720e 100644
> --- a/tools/testing/selftests/bpf/xsk.c
> +++ b/tools/testing/selftests/bpf/xsk.c
> @@ -880,6 +880,11 @@ static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp, int *xsks_map_fd)
>         return err;
>  }
>
> +int xsk_setup_xdp_prog_xsk(struct xsk_socket *xsk, int *xsks_map_fd)
> +{
> +       return __xsk_setup_xdp_prog(xsk, xsks_map_fd);
> +}
> +
>  static struct xsk_ctx *xsk_get_ctx(struct xsk_umem *umem, int ifindex,
>                                    __u32 queue_id)
>  {
> diff --git a/tools/testing/selftests/bpf/xsk.h b/tools/testing/selftests/bpf/xsk.h
> index 915e7135337c..997723b0bfb2 100644
> --- a/tools/testing/selftests/bpf/xsk.h
> +++ b/tools/testing/selftests/bpf/xsk.h
> @@ -269,6 +269,7 @@ struct xsk_umem_config {
>         __u32 flags;
>  };
>
> +int xsk_setup_xdp_prog_xsk(struct xsk_socket *xsk, int *xsks_map_fd);
>  int xsk_setup_xdp_prog(int ifindex, int *xsks_map_fd);
>  int xsk_socket__update_xskmap(struct xsk_socket *xsk, int xsks_map_fd);
>
> --
> 2.27.0
>
