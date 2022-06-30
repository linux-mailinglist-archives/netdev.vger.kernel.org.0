Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4DA5622A8
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 21:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbiF3TI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 15:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbiF3TI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 15:08:26 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236551BE93
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 12:08:25 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id e40so141799eda.2
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 12:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bUjAB1hlxseq0HISofNQZFEX0nJhIgr2Cm4sfLnRbSI=;
        b=HiEbbZZAhzqp449ArP2yby/K5vKoX89PX/8MVJ6D1/LIyMjPgPC2TM9xhShHeENqMA
         /VObFBymihGvpBG3qwT/daU4sTkarjp7FFYB4jDd9thpVl8ZzlGyaKVNP2dxxfkDIEpx
         C/548CNKpRlR6m7wkV2I3Hww1xO2/nOT9vktONi9V7FlcB3xJL6mjImahKOUcR6Dr0Oa
         0M+2eFXqnEQaXHYdhKR7jRdwjZTg/Kz5q5Za+QXlxNJbc0zKp7GRkFMA+b45cNtR5Gc0
         tniiI/1P88N/wTBPM5vzN7VGcWTnmHUyOBZPwfdhEhX8lD7zt2pCeph44GamCcoe6Deg
         SR/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bUjAB1hlxseq0HISofNQZFEX0nJhIgr2Cm4sfLnRbSI=;
        b=ovBTuZhX26jPZ9FsJOjSkL6sKTVRbEqmzJLtlcyffyEw9QrXuiWjhkY7zjqGxjfCVc
         4aiUkivxrSg/W8YjviEdt922wPDTxjDfrd8RM3Q28IOVytpcPPRvX3+Bp41brIhsi6d8
         OxFRQ2ihXEKC0H6jjRAqDSTOr3Nd6z0hTptSixMafOpmj52x0eEhbEdG1UZi1Zg9qrgD
         G2FKfAmop41Zg5A7PxWyOLpsdyoI1D146JMv9B7JMh12rManm4oV+bKYhKlPc0wu3mk9
         R3qSSM6xkcjUVbovxCYwk0c/L6nU4vuOwuJT7SvJgarLzufGlmMklRHxEx88aPqkKOLt
         Izew==
X-Gm-Message-State: AJIora/bU4AkYOusEw5VqqpBJ4MHsCNRHt/QC9PrlOetBiAbkIEOlKKJ
        njZt5naSq9KLiQ+nC4loSl9SvSzOnrxwA82vxlc=
X-Google-Smtp-Source: AGRyM1tGsZcNQSiVGzcbuYedSHv/hHFKHmY8aHyqB+J4c/PFfIpeJpf9AudmZQM3IHRwjWGUzFx5ENqqwZVTqlCVsgM=
X-Received: by 2002:a05:6402:5309:b0:435:6431:f9dc with SMTP id
 eo9-20020a056402530900b004356431f9dcmr13483905edb.14.1656616103506; Thu, 30
 Jun 2022 12:08:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220630062228.3453016-1-liuhangbin@gmail.com>
In-Reply-To: <20220630062228.3453016-1-liuhangbin@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 30 Jun 2022 12:08:11 -0700
Message-ID: <CAEf4BzZ-gn9VmMKx8m2kEvTc--DC8Z_hvKXaw_7Q2BY-J7JQQw@mail.gmail.com>
Subject: Re: [PATCH net] selftests/net: fix section name when using xdp_dummy.o
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
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

On Wed, Jun 29, 2022 at 11:22 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Since commit 8fffa0e3451a ("selftests/bpf: Normalize XDP section names in
> selftests") the xdp_dummy.o's section name has changed to xdp. But some
> tests are still using "section xdp_dummy", which make the tests failed.
> Fix them by updating to the new section name.
>
> Fixes: 8fffa0e3451a ("selftests/bpf: Normalize XDP section names in selftests")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

Thanks for fixing this! BTW, does iproute2 support selecting programs
by its name (not section name)? Only the program name is unique, there
could be multiple programs with the same SEC("xdp").

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/testing/selftests/net/udpgro.sh         | 2 +-
>  tools/testing/selftests/net/udpgro_bench.sh   | 2 +-
>  tools/testing/selftests/net/udpgro_frglist.sh | 2 +-
>  tools/testing/selftests/net/udpgro_fwd.sh     | 2 +-
>  tools/testing/selftests/net/veth.sh           | 6 +++---
>  5 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
> index f8a19f548ae9..ebbd0b282432 100755
> --- a/tools/testing/selftests/net/udpgro.sh
> +++ b/tools/testing/selftests/net/udpgro.sh
> @@ -34,7 +34,7 @@ cfg_veth() {
>         ip -netns "${PEER_NS}" addr add dev veth1 192.168.1.1/24
>         ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
>         ip -netns "${PEER_NS}" link set dev veth1 up
> -       ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp_dummy
> +       ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
>  }
>
>  run_one() {
> diff --git a/tools/testing/selftests/net/udpgro_bench.sh b/tools/testing/selftests/net/udpgro_bench.sh
> index 820bc50f6b68..fad2d1a71cac 100755
> --- a/tools/testing/selftests/net/udpgro_bench.sh
> +++ b/tools/testing/selftests/net/udpgro_bench.sh
> @@ -34,7 +34,7 @@ run_one() {
>         ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
>         ip -netns "${PEER_NS}" link set dev veth1 up
>
> -       ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp_dummy
> +       ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
>         ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
>         ip netns exec "${PEER_NS}" ./udpgso_bench_rx -t ${rx_args} -r &
>
> diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
> index 807b74c8fd80..832c738cc3c2 100755
> --- a/tools/testing/selftests/net/udpgro_frglist.sh
> +++ b/tools/testing/selftests/net/udpgro_frglist.sh
> @@ -36,7 +36,7 @@ run_one() {
>         ip netns exec "${PEER_NS}" ethtool -K veth1 rx-gro-list on
>
>
> -       ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp_dummy
> +       ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
>         tc -n "${PEER_NS}" qdisc add dev veth1 clsact
>         tc -n "${PEER_NS}" filter add dev veth1 ingress prio 4 protocol ipv6 bpf object-file ../bpf/nat6to4.o section schedcls/ingress6/nat_6  direct-action
>         tc -n "${PEER_NS}" filter add dev veth1 egress prio 4 protocol ip bpf object-file ../bpf/nat6to4.o section schedcls/egress4/snat4 direct-action
> diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
> index 6f05e06f6761..1bcd82e1f662 100755
> --- a/tools/testing/selftests/net/udpgro_fwd.sh
> +++ b/tools/testing/selftests/net/udpgro_fwd.sh
> @@ -46,7 +46,7 @@ create_ns() {
>                 ip -n $BASE$ns addr add dev veth$ns $BM_NET_V4$ns/24
>                 ip -n $BASE$ns addr add dev veth$ns $BM_NET_V6$ns/64 nodad
>         done
> -       ip -n $NS_DST link set veth$DST xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null
> +       ip -n $NS_DST link set veth$DST xdp object ../bpf/xdp_dummy.o section xdp 2>/dev/null
>  }
>
>  create_vxlan_endpoint() {
> diff --git a/tools/testing/selftests/net/veth.sh b/tools/testing/selftests/net/veth.sh
> index 19eac3e44c06..430895d1a2b6 100755
> --- a/tools/testing/selftests/net/veth.sh
> +++ b/tools/testing/selftests/net/veth.sh
> @@ -289,14 +289,14 @@ if [ $CPUS -gt 1 ]; then
>         ip netns exec $NS_SRC ethtool -L veth$SRC rx 1 tx 2 2>/dev/null
>         printf "%-60s" "bad setting: XDP with RX nr less than TX"
>         ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
> -               section xdp_dummy 2>/dev/null &&\
> +               section xdp 2>/dev/null &&\
>                 echo "fail - set operation successful ?!?" || echo " ok "
>
>         # the following tests will run with multiple channels active
>         ip netns exec $NS_SRC ethtool -L veth$SRC rx 2
>         ip netns exec $NS_DST ethtool -L veth$DST rx 2
>         ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
> -               section xdp_dummy 2>/dev/null
> +               section xdp 2>/dev/null
>         printf "%-60s" "bad setting: reducing RX nr below peer TX with XDP set"
>         ip netns exec $NS_DST ethtool -L veth$DST rx 1 2>/dev/null &&\
>                 echo "fail - set operation successful ?!?" || echo " ok "
> @@ -311,7 +311,7 @@ if [ $CPUS -gt 2 ]; then
>         chk_channels "setting invalid channels nr" $DST 2 2
>  fi
>
> -ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null
> +ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp 2>/dev/null
>  chk_gro_flag "with xdp attached - gro flag" $DST on
>  chk_gro_flag "        - peer gro flag" $SRC off
>  chk_tso_flag "        - tso flag" $SRC off
> --
> 2.35.1
>
