Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965D554915E
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378815AbiFMNuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 09:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379348AbiFMNsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 09:48:32 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D0922BFD;
        Mon, 13 Jun 2022 04:33:01 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c196so5506628pfb.1;
        Mon, 13 Jun 2022 04:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rJBDsMZWqQYDLoyuytGL2yDOjzA/T07r8tttMq0w66I=;
        b=PHADwQ0ke6z9p6HJa81YAs/wI2nJe68pBOFDBuJF8vJABajHLOvITspCdxm1dPWeju
         gLoeAFet5JzrN2FEmoV5JDSuoOrb8Kvodk6mPHDMdzOvakvmAlpCe/Pv6/ako6Z6daXA
         zf9XyyZHMQv9q5Jrh2M465wTqgEiuLrZoT5vEfi0gsP4pHBbWTzhBi35WZ1Gm14/lOic
         7SfVfXMeewM074nzYQ+v5KMbyAvPghD2mcUDfl+NX8MGs/kBOGyofuLUwC4Roprxd1gn
         5HLWtxD+6Dce0bQj37cpR6/g2S1SIw/0OWjhEtpqSuflvDsnF09i2KYewX6ZF68oP5QE
         URrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rJBDsMZWqQYDLoyuytGL2yDOjzA/T07r8tttMq0w66I=;
        b=N+wl6oQ/RDA2KOfXrFlGpFvKPTLz7nT7WrNczoBhIXQK/1tSIWZnZkmy5NKw0ESUnO
         turXnqjzxA9FMF5UpwENKMFPD0mvVyhIlxLbHX/3yvEZCiPo1lw23qF6zSoZXtU3PjM/
         ztgALXrdiPMaNN3r47R+VhRJ2ORf9AwRJeGD/6e2C+/8eUoAMg1kxaewUbfPTucTCfAo
         94zkzcTm5tPpZCt2zCnrkcHBd9qaGb3aF8kVp3EIPkTwiGNeVSvlOwuAvOyGhzKWfQsm
         rDztBo9jpQHpqi3VQ7YQLuO2GB+dNHwSy27D7O7a3mTaJMZfAhGHBDswuizzVBoAo7z/
         giMg==
X-Gm-Message-State: AOAM5330ap/oCX2qUFsfHj3xL2ZumFBrJnNz1p9POIUWm5cRTBcvxgrc
        b7EjbCf+znGjaU8OSOZb3jw/5HyM+BTPaH3RaRM=
X-Google-Smtp-Source: ABdhPJwOFo0QF/5iPGnkYpjuVuhrR7bdUEj5llOIYzjkRoiTIT45yGEVp5Hua2eMILZQPpFTjFN7fsAg/KiNgQomXNM=
X-Received: by 2002:a62:de84:0:b0:51b:e34b:ed2e with SMTP id
 h126-20020a62de84000000b0051be34bed2emr51985432pfg.86.1655119980829; Mon, 13
 Jun 2022 04:33:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220610150923.583202-1-maciej.fijalkowski@intel.com> <20220610150923.583202-10-maciej.fijalkowski@intel.com>
In-Reply-To: <20220610150923.583202-10-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 13 Jun 2022 13:32:49 +0200
Message-ID: <CAJ8uoz1GeVirhhCkK6ovuqhNJ7W=sxZ-eu2R4yFWAs-R3zmcTw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 09/10] selftests: xsk: remove struct xsk_socket_info::outstanding_tx
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
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

On Fri, Jun 10, 2022 at 5:31 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Previous change makes xsk->outstanding_tx a dead code, so let's remove
> it.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 20 +++-----------------
>  tools/testing/selftests/bpf/xdpxceiver.h |  1 -
>  2 files changed, 3 insertions(+), 18 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index c9385690af09..a2aa652d0bb8 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -815,7 +815,7 @@ static void kick_rx(struct xsk_socket_info *xsk)
>                 exit_with_error(errno);
>  }
>
> -static int complete_pkts(struct xsk_socket_info *xsk, int batch_size)
> +static void complete_pkts(struct xsk_socket_info *xsk, int batch_size)
>  {
>         unsigned int rcvd;
>         u32 idx;
> @@ -824,20 +824,8 @@ static int complete_pkts(struct xsk_socket_info *xsk, int batch_size)
>                 kick_tx(xsk);
>
>         rcvd = xsk_ring_cons__peek(&xsk->umem->cq, batch_size, &idx);
> -       if (rcvd) {
> -               if (rcvd > xsk->outstanding_tx) {
> -                       u64 addr = *xsk_ring_cons__comp_addr(&xsk->umem->cq, idx + rcvd - 1);
> -
> -                       ksft_print_msg("[%s] Too many packets completed\n", __func__);
> -                       ksft_print_msg("Last completion address: %llx\n", addr);
> -                       return TEST_FAILURE;
> -               }
> -
> +       if (rcvd)
>                 xsk_ring_cons__release(&xsk->umem->cq, rcvd);
> -               xsk->outstanding_tx -= rcvd;
> -       }
> -
> -       return TEST_PASS;
>  }
>
>  static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
> @@ -955,9 +943,7 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
>         pthread_mutex_unlock(&pacing_mutex);
>
>         xsk_ring_prod__submit(&xsk->tx, i);
> -       xsk->outstanding_tx += valid_pkts;
> -       if (complete_pkts(xsk, i))
> -               return TEST_FAILURE;
> +       complete_pkts(xsk, i);
>
>         usleep(10);
>         return TEST_PASS;
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
> index f364a92675f8..12b792004163 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.h
> +++ b/tools/testing/selftests/bpf/xdpxceiver.h
> @@ -104,7 +104,6 @@ struct xsk_socket_info {
>         struct xsk_ring_prod tx;
>         struct xsk_umem_info *umem;
>         struct xsk_socket *xsk;
> -       u32 outstanding_tx;
>         u32 rxqsize;
>  };
>
> --
> 2.27.0
>
