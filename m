Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688293E31F7
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 00:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245643AbhHFWyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 18:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243612AbhHFWyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 18:54:07 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D305C0613CF;
        Fri,  6 Aug 2021 15:53:51 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id s48so17858822ybi.7;
        Fri, 06 Aug 2021 15:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cXtTQNGCWU+v1HC44qEHccDNHLr5bTrZzyF8Z2rSQ+k=;
        b=Hn1cBuyE5Hyqj+/oOpNVTROkko5iOn0RHQTNkxpfgGXpbPXdSGSKLWDQrvmTvmqlhL
         EC0Y5NieE42s7NZbeg2l/5GhAnP9tDUnZaDQsRcTq29Lre7olLRtcZkLq+8F7qqG9S2l
         gps3qqmIWvZCdRc1uNR4wBt4zv4hxc7tUuuLbP570r2rE07OYJI3GI8qJdjv5IQ5aBKo
         jM/DOuZQL/Xd6o2r2Lj3LbLkZzs94fb22DM4WdNjV4tPqYli9xm3ojAa6mK5S/Rz3IbN
         ltTKDUuzqYODosV/LaHMrchSNCTqbEaW664i9hJQa5I4s/EzIIMBhC7NvqfrqtSNch5J
         LlHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cXtTQNGCWU+v1HC44qEHccDNHLr5bTrZzyF8Z2rSQ+k=;
        b=cmicSTqEGrx2LjPSpnToQrq3nl0MV1KqOA2fDwXYScenAJsSmgAR/BUEgDpca/rPzA
         j44RwTQ7MH6GG8hF7k5r8j/6iHtisidn6YWM9RW4HBl9w5MdLqi5rn/DDirtcJ6rd9dI
         C736BF01HFky6vmlm4CS6TmkQm9EmyXv6G88dpXgGNPMyVQnfH6J2VPC7+jsjW/V7UV/
         48rSRXZH1u+jNVpcHZ3wn3iiHKJd7sLSOOIJGEBETn4NDvkKzviWMa50uok7O5J8PdRK
         djmi7efCBv4GB/HsqhhHbembFMYLEeZnEMh8G1zTpSNLt2uCxC0kcF1UrIIwc+UjdfkT
         bFEA==
X-Gm-Message-State: AOAM533zKTTRi+rm+S8n5uTij2aS1doaY5NdgQ0IVvt1UCX0kO2rzxVm
        P3k8rL5sIGU0FGOpSxq04MNnRbTTOlIJZEpOZDo=
X-Google-Smtp-Source: ABdhPJxHNq/vQlgNrI9wuWilsUS0XD73zkm8uuN9Su39lx2/+L7/7xau0Wat2Ou24eQcQrr3fLd1TIGGEeJMyDZ9nn4=
X-Received: by 2002:a25:9942:: with SMTP id n2mr16305410ybo.230.1628290430459;
 Fri, 06 Aug 2021 15:53:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210731055738.16820-1-joamaki@gmail.com>
 <20210731055738.16820-7-joamaki@gmail.com>
In-Reply-To: <20210731055738.16820-7-joamaki@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Aug 2021 15:53:39 -0700
Message-ID: <CAEf4BzaatKq-3VqYY7G2Eh2iD3TRin=i4_vfbH5u6JszPLjeXw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 6/7] selftests/bpf: Fix xdp_tx.c prog section name
To:     Jussi Maki <joamaki@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, j.vosburgh@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 5, 2021 at 9:10 AM Jussi Maki <joamaki@gmail.com> wrote:
>
> The program type cannot be deduced from 'tx' which causes an invalid
> argument error when trying to load xdp_tx.o using the skeleton.
> Rename the section name to "xdp" so that libbpf can deduce the type.
>
> Signed-off-by: Jussi Maki <joamaki@gmail.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/testing/selftests/bpf/progs/xdp_tx.c   | 2 +-
>  tools/testing/selftests/bpf/test_xdp_veth.sh | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/xdp_tx.c b/tools/testing/selftests/bpf/progs/xdp_tx.c
> index 94e6c2b281cb..5f725c720e00 100644
> --- a/tools/testing/selftests/bpf/progs/xdp_tx.c
> +++ b/tools/testing/selftests/bpf/progs/xdp_tx.c
> @@ -3,7 +3,7 @@
>  #include <linux/bpf.h>
>  #include <bpf/bpf_helpers.h>
>
> -SEC("tx")
> +SEC("xdp")
>  int xdp_tx(struct xdp_md *xdp)
>  {
>         return XDP_TX;
> diff --git a/tools/testing/selftests/bpf/test_xdp_veth.sh b/tools/testing/selftests/bpf/test_xdp_veth.sh
> index ba8ffcdaac30..995278e684b6 100755
> --- a/tools/testing/selftests/bpf/test_xdp_veth.sh
> +++ b/tools/testing/selftests/bpf/test_xdp_veth.sh
> @@ -108,7 +108,7 @@ ip link set dev veth2 xdp pinned $BPF_DIR/progs/redirect_map_1
>  ip link set dev veth3 xdp pinned $BPF_DIR/progs/redirect_map_2
>
>  ip -n ns1 link set dev veth11 xdp obj xdp_dummy.o sec xdp_dummy
> -ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec tx
> +ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec xdp
>  ip -n ns3 link set dev veth33 xdp obj xdp_dummy.o sec xdp_dummy
>
>  trap cleanup EXIT
> --
> 2.17.1
>
