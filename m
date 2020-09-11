Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D11265738
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 05:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgIKDDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 23:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgIKDDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 23:03:49 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3D1C061573;
        Thu, 10 Sep 2020 20:03:46 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id s205so10833177lja.7;
        Thu, 10 Sep 2020 20:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pjDuSWQDMIfFRrtnCSZ2cjlpYS9X+lyOuSgqN7r89ZE=;
        b=PRe8gHqX4Pif+KsN6JkFnBn2ZrCikKhFYk0ljtN2c3m41SQtCzMrytU2AviU9TsP1d
         tJHL4jzn4Od/RCgbA1awbBveBQz/BhwL9YatUM+k2w7nwW+TCVi7GmW0tuB+kIyNb4oB
         7Gl3xandp7c+SJGAFJqMRPFqh+q8YKqbEACoIb6cMP3lAIpuTPhX8lvfql7f2clf90r/
         VkuMpsB71zF/hLufAs8LhX5j1f1VTpSEUEqHDnKSagBn4dUHGu85hzOc3KOeMsG80g32
         AOMXep6cA4m111wz9SXO6vDM4abNx9XDgPk7zNkYFw3ciAhJhfU8Sl2p471gtRS1d++y
         emew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pjDuSWQDMIfFRrtnCSZ2cjlpYS9X+lyOuSgqN7r89ZE=;
        b=ED8CQj4hszXBg1fdZU7d3tqr16aIS2NMjDGyGUzuuUmTRTX3ABVjrgcTzCoJPQhmht
         TtfL9ZKaZwS8yQW3uwuajqjkuEegxUBxjmq3KOadMnDOtICXgG6Bkk9dzAXLZIU2RxXR
         zC0b2Rvr5SB8jF5sIeWh7ClpJ1q7SPWULMoQmd1g5d8ibtPvDSCLjqUxYtd7tUKa7Ad+
         W8RO7huAMis+zl1iY89CpjFWtNHZzNnc/GX0wn9hosQCO6qGvbGfkzWKUARV6gOiciiP
         lOYxe4Bm9fR2+osKei7uZ0pYSeMG+LCgi7HegWCHtwwMkIrfm/S/E+z0qVAMwjAGLPLj
         25nQ==
X-Gm-Message-State: AOAM533Eu9L6x9jGiGW4pxakCsocngtwuAIvO9Z1h/ln5vKvLUqXwiD1
        NuDpZLDqZTVxDjajgFGxTh0eCPS+YkhTTYXUfY8=
X-Google-Smtp-Source: ABdhPJxTNWvDUF92znyBRyBTLaEGFZtA35jDlxbruoWX12oUjyVUGRxNHSQcN3HXTQ0w+7RXlhpMT2ThWqfUdhCTCD0=
X-Received: by 2002:a2e:808f:: with SMTP id i15mr5582922ljg.51.1599793425119;
 Thu, 10 Sep 2020 20:03:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200910202718.956042-1-yhs@fb.com>
In-Reply-To: <20200910202718.956042-1-yhs@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Sep 2020 20:03:33 -0700
Message-ID: <CAADnVQ+cFw-b5GsyeUpFeSLJinbg5kNyHexf0hrERdj1eWUzAw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: define string const as global for test_sysctl_prog.c
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 1:27 PM Yonghong Song <yhs@fb.com> wrote:
>
> When tweaking llvm optimizations, I found that selftest build failed
> with the following error:
>   libbpf: elf: skipping unrecognized data section(6) .rodata.str1.1
>   libbpf: prog 'sysctl_tcp_mem': bad map relo against '.L__const.is_tcp_mem.tcp_mem_name'
>           in section '.rodata.str1.1'
>   Error: failed to open BPF object file: Relocation failed
>   make: *** [/work/net-next/tools/testing/selftests/bpf/test_sysctl_prog.skel.h] Error 255
>   make: *** Deleting file `/work/net-next/tools/testing/selftests/bpf/test_sysctl_prog.skel.h'
>
> The local string constant "tcp_mem_name" is put into '.rodata.str1.1' section
> which libbpf cannot handle. Using untweaked upstream llvm, "tcp_mem_name"
> is completely inlined after loop unrolling.
>
> Commit 7fb5eefd7639 ("selftests/bpf: Fix test_sysctl_loop{1, 2}
> failure due to clang change") solved a similar problem by defining
> the string const as a global. Let us do the same here
> for test_sysctl_prog.c so it can weather future potential llvm changes.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
