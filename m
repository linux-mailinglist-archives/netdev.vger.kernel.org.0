Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC5631F9B2
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 14:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhBSNNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 08:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhBSNNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 08:13:15 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D7DC061574;
        Fri, 19 Feb 2021 05:12:35 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id d2so4136382pjs.4;
        Fri, 19 Feb 2021 05:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WYLPdLD/fMdkJnEXcg174O1DbhT+UlnhEq0zSK1ne6I=;
        b=kwVEfRPB/aWLP+iPHJqV4cm++jcMngT2BTKplzaPQQ8yF31p1KaG/FY635CejKhiiG
         8BuAXOvOjDpYaPzDxcslrBhc/VUaDN4gBoPn66/aMggA9STYGhd/meXzNr6AUfgzGQ5l
         To44A56SDcTjvv7kYlzq2ac1Wk75Jpm5+xQmK+xJuCRvOjPvzsgGA/OQbZPKHTXk8Q3C
         0yj25wVPj5E1dV9Cgm9kuWtgQbu4jWH+zeaJY1sdv1WxqGve0e1V5ETXB4xe6xfxA/06
         4bUIeado3VUel1boi/DFI5EYfzkBwOwK915M2FlQ3hpBYNfI8kjYmjmXZ4KSlCs/O9cP
         /bsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WYLPdLD/fMdkJnEXcg174O1DbhT+UlnhEq0zSK1ne6I=;
        b=pYR7/Ff718oK8sngpCuxXv5s3FhSvrF9s9jJN/e8RNWVr5+8otoFh7OZe48SnNfFeg
         WxJdluynBN3Au2vyx97SZ5FGoUOPbm3sjs//J493yN0trxV5b+Ktzpm8g8IDaBwtR7bK
         gC+gC1K+sFTNDTyvRzxowiRsPEV7wmQNiUEqgQqV2pl/i1SSY+svLVosv39f64u98Tpk
         GW53K5atTTtq0pdCEln8VHn7pq47n9EEmzmmOTdxV+TMc/QkItHZDNVkg6FTrMaHkn9Q
         nm+jq3McNN7BVdB/egA3ohxtBFgDRKtLOoBqfShh36IxUcrCRHuGdVroeaqzkIjEQGr+
         V7cw==
X-Gm-Message-State: AOAM533VYNvcCiiCin3ScScQQUQ4DDRNjb/s0oPxTsTkjMk9fPyvGAU0
        EN/GoX38TO+UhMST0ozdjJvu3D1xVgH5Mh3Ok4w=
X-Google-Smtp-Source: ABdhPJw3MGuOU5LEQVnlPu2uNAnzBnkd1peuvaE5mlPJN468zecRYr490GgeieLfllc3CcpITAnFXzVGoB2oHHjV/uw=
X-Received: by 2002:a17:90a:ba86:: with SMTP id t6mr8838267pjr.168.1613740354999;
 Fri, 19 Feb 2021 05:12:34 -0800 (PST)
MIME-Version: 1.0
References: <20210217160214.7869-1-ciara.loftus@intel.com> <20210217160214.7869-3-ciara.loftus@intel.com>
In-Reply-To: <20210217160214.7869-3-ciara.loftus@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 19 Feb 2021 14:12:23 +0100
Message-ID: <CAJ8uoz0CnquDSRZDRAYhLu=y8m-_Dzqs-J0d+-NSJk73wxfh4Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] selftests/bpf: expose debug arg to shell
 script for xsk tests
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 5:36 PM Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> Launching xdpxceiver with -D enables debug mode. Make it possible

Would be clearer if the option was the same both in the shell and in
the xdpreceiver app, so please pick -d or -D and stick with it. And
how about calling the mode "dump packets" instead of debug, because
that is what it is doing right now?

> to pass this flag to the app via the test_xsk.sh shell script like
> so:
>
> ./test_xsk.sh -d
>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  tools/testing/selftests/bpf/test_xsk.sh    | 7 ++++++-
>  tools/testing/selftests/bpf/xsk_prereqs.sh | 3 ++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
> index 91127a5be90d..a72f8ed2932d 100755
> --- a/tools/testing/selftests/bpf/test_xsk.sh
> +++ b/tools/testing/selftests/bpf/test_xsk.sh
> @@ -74,11 +74,12 @@
>
>  . xsk_prereqs.sh
>
> -while getopts "cv" flag
> +while getopts "cvd" flag
>  do
>         case "${flag}" in
>                 c) colorconsole=1;;
>                 v) verbose=1;;
> +               d) debug=1;;
>         esac
>  done
>
> @@ -135,6 +136,10 @@ if [[ $verbose -eq 1 ]]; then
>         VERBOSE_ARG="-v"
>  fi
>
> +if [[ $debug -eq 1 ]]; then
> +       DEBUG_ARG="-D"
> +fi
> +
>  test_status $retval "${TEST_NAME}"
>
>  ## START TESTS
> diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
> index ef8c5b31f4b6..d95018051fcc 100755
> --- a/tools/testing/selftests/bpf/xsk_prereqs.sh
> +++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
> @@ -128,5 +128,6 @@ execxdpxceiver()
>                         copy[$index]=${!current}
>                 done
>
> -       ./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${copy[*]} -C ${NUMPKTS} ${VERBOSE_ARG}
> +       ./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${copy[*]} -C ${NUMPKTS} ${VERBOSE_ARG} \
> +               ${DEBUG_ARG}
>  }
> --
> 2.17.1
>
