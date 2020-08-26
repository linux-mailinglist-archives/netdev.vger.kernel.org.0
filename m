Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F7D2525BF
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 05:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgHZDSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 23:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgHZDSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 23:18:33 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C28FC061574;
        Tue, 25 Aug 2020 20:18:33 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id a34so155149ybj.9;
        Tue, 25 Aug 2020 20:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8OTN+ZAFhh4zGTx/WbIfAbTeq99SU0Zwk8FzOcPKJVM=;
        b=qPpwSCmbzSj4PKKlySPKmZNIH2sU/2MtkpXHldAaltVTLT4vAiQEhDwk7C8ML4GI9V
         mNl7lDThjPuzekTx/N+Iv6GLuhqBSeWDm7FhPdIcsiIIsDUZ4mIlX9vt8Y8ak+tn6Tkp
         O+4mzXjwxsWzd5ZiEQZoa9QxPqTRB7EVNbrg4VGcIHrlbINkQQuJA11q8paKbrLXX4ga
         WChdB7XXfY/j7bE+jPC9znYaDwQV0Xrr4qpLOH5+pBHjbjZWrleXIaDrK9Y3nhpv6qSk
         sSdpWUT0H6i+rAcCt6YmrNTg0ErfGvO/PtGsdPV9XHk/4E4ceRZpRHkZQpJ/7N+7sRqj
         3nGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8OTN+ZAFhh4zGTx/WbIfAbTeq99SU0Zwk8FzOcPKJVM=;
        b=sTt6Qhdq6+DUbHz4UNgB93E8vFADlmhN3ku3Nrcv8o36h8M46tRV1szZsiOHNdDCmW
         pCYK0beQpGrKg3VJmGpS8noQ9Gv4YKtLcmRyjR04m54O8zGd86TL1uj/94YUPREbWkDs
         q9t2KN+C/8tmkZfzn5PR2N8yQ3oYzdAzz84VjZ9zmBADA7hXoHltSvHOSDLNFQd2P5Bb
         ZdkHFh1qTmNlbmsHTJGJXNnjdxgHvZO/f4tnb3+v8h+pCaWh7D8WqWF1hslTgC0yvJmy
         392ut8CmUz8qBsh/3wD9+vHdQaJxkEn+ZID5mR6q9sJW8Mk6OuWOAUFBrxG8WdzvgDfA
         3SSQ==
X-Gm-Message-State: AOAM533aIVE4OshT4s6MgmUDw8fAxkeF7gLjJwyu7gtcAWWGzOs6FzRo
        PnHnolvChlVgxmT1uUT+d+P8FLhL5pF9rhH6EDhTnzV0doI=
X-Google-Smtp-Source: ABdhPJz/W1I3B7CWV2dPowTFTHmUAjYmM9+691eyF7RdNKOZbY6D2BXf8ijYp1NnLz4QI0KEIQ0aRy1ZCD+USaWfiIU=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr17765766ybq.27.1598411912561;
 Tue, 25 Aug 2020 20:18:32 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYvWkGp9p95DQ5T87GDBmUMecEYBZC0TYHmfwHysanQ7zA@mail.gmail.com>
In-Reply-To: <CA+G9fYvWkGp9p95DQ5T87GDBmUMecEYBZC0TYHmfwHysanQ7zA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 25 Aug 2020 20:18:21 -0700
Message-ID: <CAEf4BzZO_NnBSRe--V1GAu=ZeennVpZDOAzcE6e+0V=coVuXcw@mail.gmail.com>
Subject: Re: expects argument of type 'size_t', but argument 5 has type 'Elf64_Xword
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, lkft-triage@lists.linaro.org,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 2:00 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> while building perf with gcc 7.3.0 on linux next this warning/error is found.
>
> In file included from libbpf.c:55:0:
> libbpf.c: In function 'bpf_object__elf_collect':
> libbpf_internal.h:74:22: error: format '%zu' expects argument of type
> 'size_t', but argument 5 has type 'Elf64_Xword {aka long long unsigned
> int}' [-Werror=format=]
>   libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);
> cc1: all warnings being treated as errors
>

You left out the most useful part:

| libbpf.c:2826:4: note: in expansion of macro 'pr_info'
|     pr_info("elf: skipping section(%d) %s (size %zu)\n", idx, name,
sh.sh_size);
|     ^~~~~~~
| libbpf.c:2826:50: note: format string is defined here
|     pr_info("elf: skipping section(%d) %s (size %zu)\n", idx, name,
sh.sh_size);
|                                                 ~~^
|                                                 %llu

But I fixed it as part of [0], thanks.

  [0] https://patchwork.ozlabs.org/project/netdev/patch/20200826030922.2591203-1-andriin@fb.com/

> OE perf build long link,
> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-next/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/846/consoleText
>
> - Naresh
