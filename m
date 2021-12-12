Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5014717B5
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 02:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhLLBxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 20:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbhLLBxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 20:53:49 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889D8C061714;
        Sat, 11 Dec 2021 17:53:49 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id k26so11855468pfp.10;
        Sat, 11 Dec 2021 17:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=28IDWmEuuMa9Hdo0pq67vUNP/LnTqKCPRzx/AIyjFVk=;
        b=Mgln7ic3xKgLM2C4pKtwQz2U8+2GWbx6s1/9F7xceFG+qIp/9N+DTArPNv4GHeOdxP
         QNf1TU8KRWK82Kp1PTor3w5492D/FvTo34ulGekl/XmibZUAEQPppHMLNlOqNjApEY4U
         ODEc4sJb1kSp1CXBuYZAAFN3pnERsnAlnZraP27i74ESLwOO/p9ystUIfMZTOLG4Xo6o
         hTJkoNKjhkmnmdVz0+KhcRgnWxSxJhyFaTWVVNwVABpgxxq12G5eO6YVG7gA1MzZYKtJ
         QSWpPMO3zdbRxX6CMyayBobnoPowIrYnzoMDf4dbGLC1X0n9OCkvWQYjuT+J61uEir1P
         TgNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=28IDWmEuuMa9Hdo0pq67vUNP/LnTqKCPRzx/AIyjFVk=;
        b=BKVNslHmkSJKA0FoxKb7/K6UwdgriOEhdByhFAN+ujrP+kEo22IJ95nUqUblHn732r
         8Y5GuqjqLfvYV7rT6txDwRLDrGB7J/993pKJcT7iKU9v+xMFfJlwULMxN0GVRl2r1Cyc
         8dTWKihkpK8EJrYlmFsF1wMsKPeM8/EBsXIreqZgnHIY3VHbgpAiB3LNNeT7SPtqSpD8
         hzKuKfqtTnLAB+GaOWhsnn7eUXIWUnTST4gZ6ZeDYYTbsqIFemzikHI2Z75bcJ4e6Hvn
         7h5vZR6tjijZe02xsyhMzMNQ649o+nq0RRnahpqTsp9mBFRMXMNZkMS4DUHDutqT+Tkr
         7V3g==
X-Gm-Message-State: AOAM531M2nDtSiPBXeqJZs8JE8tNcCMZeObLGdUToSZZxczAcBqj/x6/
        Aq77F13mr915TJL7WgyN+YKbldBllI+PwbKpQPZAdk4ZxXE=
X-Google-Smtp-Source: ABdhPJxvfex0tAYFlBaaZbONK+8xpQgvwo76J48WOncwb2aJG4FDNaQKmRghuqOcc+LeO9GVtpGfs+wpng6MTzo4RpI=
X-Received: by 2002:a63:8f06:: with SMTP id n6mr33306484pgd.95.1639274028602;
 Sat, 11 Dec 2021 17:53:48 -0800 (PST)
MIME-Version: 1.0
References: <20211210173433.13247-1-skhan@linuxfoundation.org>
In-Reply-To: <20211210173433.13247-1-skhan@linuxfoundation.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 11 Dec 2021 17:53:37 -0800
Message-ID: <CAADnVQ+Fnn-NuGoLq1ZYbHM=kR_W01GB1DCFOnQTHhgfDOrnaA@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: remove ARRAY_SIZE defines from tests
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 9:34 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> ARRAY_SIZE is defined in multiple test files. Remove the definitions
> and include header file for the define instead.
>
> Remove ARRAY_SIZE define and add include bpf_util.h to bring in the
> define.
>
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> ---
>  tools/testing/selftests/bpf/progs/netif_receive_skb.c | 5 +----
>  tools/testing/selftests/bpf/progs/profiler.inc.h      | 5 +----
>  tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 5 +----
>  tools/testing/selftests/bpf/progs/test_sysctl_loop2.c | 4 +---
>  tools/testing/selftests/bpf/progs/test_sysctl_prog.c  | 5 +----
>  5 files changed, 5 insertions(+), 19 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> index 1d8918dfbd3f..7a5ebd330689 100644
> --- a/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> +++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> @@ -5,6 +5,7 @@
>  #include <bpf/bpf_helpers.h>
>  #include <bpf/bpf_tracing.h>
>  #include <bpf/bpf_core_read.h>
> +#include <bpf/bpf_util.h>

It doesn't look like you've built it.

progs/test_sysctl_prog.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
#include <bpf/bpf_util.h>
         ^~~~~~~~~~~~~~~~
  CLNG-BPF [test_maps] socket_cookie_prog.o
progs/test_sysctl_loop2.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
#include <bpf/bpf_util.h>
         ^~~~~~~~~~~~~~~~
1 error generated.
In file included from progs/profiler2.c:6:
progs/profiler.inc.h:7:10: fatal error: 'bpf/bpf_util.h' file not found
#include <bpf/bpf_util.h>
         ^~~~~~~~~~~~~~~~
