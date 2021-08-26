Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D853F7F80
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 02:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbhHZAwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 20:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235823AbhHZAwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 20:52:50 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7ACC0613CF;
        Wed, 25 Aug 2021 17:52:04 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u15so648318plg.13;
        Wed, 25 Aug 2021 17:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+S7Zp0ZIfeZv88e53HyYmAUqO6vVzDOYhVnDzaDTeFk=;
        b=ZXW0Je9j3CoRAKFhLhAczgzC4vPDQUnRakBmlEMj1buPnfcGZYfyDwKxB8NPUaX7S1
         x3rxYylNXng3Lg9j9+g50Letnn58XvJUZtJ40AgbzSxHlk5h5PBUB/NL6aXoV1wtWu4C
         eyzjb8kkJNwJ7HWFBATN3uZMtxnKKcGyDElZe4bTkLWj2ODYIjYzVrkmpX9In8P5Xc1H
         801HwRrL+4NaDUpnM4Qnib4dRJMeyc/qkAQjHZDyFFfEykyCRbTJiJ7Lgb2h1+yhqKjJ
         09WevsDxfRTCrBbRFQ7o4MMevUjtyH5nHF3Gq+6/laZar5SL7a1iC+2Zb8LUNPwwoR9b
         DbLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+S7Zp0ZIfeZv88e53HyYmAUqO6vVzDOYhVnDzaDTeFk=;
        b=MftaPQ65A3X9V0Pe3hheNWLD9cFJb4ly4DmhrTuRFxkHZURCqmH8mCAjNpfejEhxK0
         VgvoexT7eTIl3sjFKoD07sc6gl2JfPRkDsHQ1Dhg+7qdmYtrOJrHrSVPA3AptFj+SVh/
         U3xve758kZp0XVlIWKhj/wx812mVO52eWbsZIOMRb8ShPpIYU6/Yf9nLLzSVdE/DkKrC
         90Wa+k3wfCHQq8o4Gx8G/2e2LS4+2mGHzIwAsiRarzUYnmbR2qUyMbHvLpGxm4P2hRCl
         BlRefxL3yIJA8OFjfzsBuo5F3w9RYBpDjV6YYD36pqoF8qlvDX69G9UiXcDJSVx+a+Is
         f1Dg==
X-Gm-Message-State: AOAM531HcXAuwWrCY6k78PRg8eHtGZOBieS0G2x5LDPSsm+TDaMSZ2Tm
        RrvG2DAOjMdmouivqZZrxKkvn/ux2bEQYOZE3zhIiLaM
X-Google-Smtp-Source: ABdhPJw9YPItmMwR0Qik1m+i9sBJ293gyyW6m5e8iW9sbTHVNM/SZi9sSsrscNNnCXEL1c8WhFP2MSUigR9PAvDlmBM=
X-Received: by 2002:a17:90a:6009:: with SMTP id y9mr1108882pji.93.1629939123761;
 Wed, 25 Aug 2021 17:52:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210825195823.381016-1-davemarchevsky@fb.com> <20210825195823.381016-3-davemarchevsky@fb.com>
In-Reply-To: <20210825195823.381016-3-davemarchevsky@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 25 Aug 2021 17:51:52 -0700
Message-ID: <CAADnVQ+SOCwcBXhdOBdHweAuP=qg4DMSvZYvJAtPefhJqn-vJg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/6] bpf: add bpf_trace_vprintk helper
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 12:58 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -5048,6 +5056,7 @@ union bpf_attr {
>         FN(timer_cancel),               \
>         FN(get_func_ip),                \
>         FN(get_attach_cookie),          \
> +       FN(trace_vprintk),              \

It needs a rebase.
