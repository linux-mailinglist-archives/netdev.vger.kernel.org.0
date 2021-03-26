Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DEA34B310
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhCZX0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbhCZX0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:26:03 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB6AC0613AA;
        Fri, 26 Mar 2021 16:26:02 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id x189so7473033ybg.5;
        Fri, 26 Mar 2021 16:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JwoWSd3I6DQh4plH9Ches26MIkmP+U0Q2+NtTvu4upE=;
        b=DZ7+VZzY15/Vqg7Pww2/gm1LAXEZ7S8BxcmAHsSxckMxGo5YuO9qXNb8m2Gpxzpcqo
         gH1LLYMaDlLg0ubxTCqCX8b/1Bkl8EJSXuDx+p7cNmPikMpQUYUqJnVsD6t+HcSeT5Wt
         AsvY9vnc/l85wWMWAYngYVWY9a0d6RIAFhBlW1kSa2E2x+d+zroyAdeiQq5Oz/dglB2B
         B45RSeVpDOkPMxIksl73RWEe26tMh8xPnJrP+pBnxFyrdjQLOGay9nrMdsUg4rmh6Yls
         eS825d8mSnwcXi+2aCZMQiQ3nYOZvJTNOafQ5EbPhgltXX/CTWni7rCIBgMevUckSf56
         Inog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JwoWSd3I6DQh4plH9Ches26MIkmP+U0Q2+NtTvu4upE=;
        b=Fbjd4RxAt9LpUaw9Y0jJ4EmBLpTfEy/F7dAslNPP8dukui0/IUkK72/0iNlFCoGxpn
         xCS10A8M39i/GjSLdbhPg1j9db43p78ZZGTdx3e5y4/mb/vx7VGbvwb9lNhmqldqhJdJ
         bB0Q05uZ6pON1nHN3SiUru8QR6is+Tg316tINIwKJRi845bzD48wX1T4i2lDguo6Llj3
         FmnH6wQITkSIQY9bnlOvP7lz+3SYXl4blFrYXuOaOBGkUzgLOWNYdNIGgnxBmovcjt3l
         kqQIKs281RbkNduxQL78EQmO9f4Vm5Gw+bcIQTJ19gDN7U/FqKG7qwUe64ZvqdXTFkRA
         lHdQ==
X-Gm-Message-State: AOAM530cSRfkZ1vy9ae2Pjkv5Mi8/yT3Jvuk9Ebp0bYvKnrlhIE8rJcl
        ydBTnlrUObzZTlUvaWcQXxm2wbEPMfeUXMS4Blg=
X-Google-Smtp-Source: ABdhPJxEe22PD0WE6yFXdPyPzqRnjEOu5TA9aVZw5QyYMBtLwiJF06tiulZFymWsQ9iqjR8eHmmcZhv/BzQEN0YHWNQ=
X-Received: by 2002:a25:874c:: with SMTP id e12mr21769586ybn.403.1616801161889;
 Fri, 26 Mar 2021 16:26:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-1-memxor@gmail.com> <20210325120020.236504-2-memxor@gmail.com>
In-Reply-To: <20210325120020.236504-2-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Mar 2021 16:25:51 -0700
Message-ID: <CAEf4BzaVK4=vB6xaMc-VwhQagg6ghx8JAnuLsf43qZa_w_nyyw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] tools pkt_cls.h: sync with kernel sources
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 5:01 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> Update the header file so we can use the new defines in subsequent
> patches.
>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/include/uapi/linux/pkt_cls.h | 174 ++++++++++++++++++++++++++++-

If libbpf is going to rely on this UAPI header, we probably need to
add this header to the list of headers that are checked for being up
to date. See Makefile, roughly at line 140.

>  1 file changed, 170 insertions(+), 4 deletions(-)
>

[...]
