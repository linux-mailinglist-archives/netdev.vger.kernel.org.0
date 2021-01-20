Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AE12FD997
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 20:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392450AbhATT0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 14:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436467AbhATTZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 14:25:52 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D83CC061757;
        Wed, 20 Jan 2021 11:25:09 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id j3so7705900ljb.9;
        Wed, 20 Jan 2021 11:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=puPe6u5eGjzcnpW6TMCNyyzNjrLc2snw2qd9AmS3wOs=;
        b=SzZzHfAXPXi9k0Xc82ayuWcOl+5o9MCFSQ4b6b2hLQ0M3w6RGfSWN/dwCKd+2weeWj
         tP1eAb3Fsn6/0N7TQNyl7CKMZ8NJAsQrJeLBXVkXj41XO4w+NV4PRGb2htkNOP3QH98o
         9OnvbGjgu/QkW9hZrrizR8LuC4F6199aHwSJeglg4LSjJlnbNoybBIv5XWM4ynnqC4Y+
         F2lND5oHtYmU0qpu5cdaZdr9eaG6RZYSsSERG2pPcSRFFRTSbYzvY8XB7aihrUduGuid
         1zTkKpuyL8sRCxObqwqXcbQGGqCkc9Q9NcKRhg+Fkk5BKq2lkzOSgb3hwvknM6V22r7J
         RIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=puPe6u5eGjzcnpW6TMCNyyzNjrLc2snw2qd9AmS3wOs=;
        b=V61W8023ZR554XfvuVid4er9soCagjnsNDrwevbTBPLKDsebxuYI5Ymuk3noX+l5XX
         us5tzzsYDGPMBt7raMuxQvCabopg8SW5YlVt/htXYsnkeljbUlGNVtxS0D8b610X5Hgi
         iFsv5dj+whVQN1RaCZPE/1qWhe74qC85VrSAh8J7n4M+F1BdP4GZ6W9LlF8fMhiWJtKs
         7by3Wx939KL5wNCFSar3sqDw1Ay7ZK/ItcLZWvg4QFPhwORWw1QKmOecqqQtRk9Kuidm
         rpy1Mq/XCb1tD03hXoMmsexAXBMfqWJEgMmd/0pMTYDF3ghdZlF0dc9zGpEvnBQSa/8/
         oB6A==
X-Gm-Message-State: AOAM530b85ICuSn+yUmd7D3hLrIPNXGisZjYosx9TAtaoK9/xewX6nvt
        nVLdmT93u3v6Hce+NKIaLCuBDA11wwwy8UgQP3WzjgWR
X-Google-Smtp-Source: ABdhPJzT1oUxuE5392bHQf83WMKzKnsEbmAiuaOs1PYZRsjtysNd0GsvPlvmPhJchyQ4EiR8Lu0VIBhKjsysdaptuI8=
X-Received: by 2002:a2e:9dc1:: with SMTP id x1mr4838130ljj.32.1611170707741;
 Wed, 20 Jan 2021 11:25:07 -0800 (PST)
MIME-Version: 1.0
References: <20210120140350.883-1-angkery@163.com>
In-Reply-To: <20210120140350.883-1-angkery@163.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 20 Jan 2021 11:24:56 -0800
Message-ID: <CAADnVQK0RiGYRnzdLRvSQRwTdyCOr1nBqZaNz7YR9gvyXu82fg@mail.gmail.com>
Subject: Re: [PATCH] selftest/bpf: fix typo
To:     angkery <angkery@163.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Junlin Yang <yangjunlin@yulong.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 6:22 AM angkery <angkery@163.com> wrote:
>
> From: Junlin Yang <yangjunlin@yulong.com>
>
> Change 'exeeds' to 'exceeds'.
>
> Signed-off-by: Junlin Yang <yangjunlin@yulong.com>

The patch didn't reach patchwork.
Please reduce cc list and resubmit to bpf@vger only.
Also pls mention [PATCH bpf-next] in the subject.

> ---
>  tools/testing/selftests/bpf/prog_tests/btf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
> index 8ae97e2..ea008d0 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf.c
> @@ -914,7 +914,7 @@ struct btf_raw_test {
>         .err_str = "Member exceeds struct_size",
>  },
>
> -/* Test member exeeds the size of struct
> +/* Test member exceeds the size of struct
>   *
>   * struct A {
>   *     int m;
> @@ -948,7 +948,7 @@ struct btf_raw_test {
>         .err_str = "Member exceeds struct_size",
>  },
>
> -/* Test member exeeds the size of struct
> +/* Test member exceeds the size of struct
>   *
>   * struct A {
>   *     int m;
> --
> 1.9.1
>
>
