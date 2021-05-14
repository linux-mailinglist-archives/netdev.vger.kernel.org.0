Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611AA38141E
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 01:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhENXNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 19:13:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230371AbhENXNB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 19:13:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30F3C61106;
        Fri, 14 May 2021 23:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621033909;
        bh=5gdw4ZcDsWSlOI6RP0IAEfHaCZQwRhBzAJ3Y3Km3FmU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DhGyjuejftNAwkLGkMJ+BxirSBqCMogD7h1dHwh+MIIN+XCHLRGwTtzgxTjICunzr
         oYBzWtiwBpnuqkbsOLBKkyeOp8Rx/WKZPTc9bMWT9Ab50ksQvtBQEuyDAywqTs3k/0
         MFdMN5Ih+ZV9CJnUenGOd/ZW4REq0h9n5KP8slLNVLQ8KJT7zZWlObHrdESmAz7x/7
         KHEACi6/MJVGmSMhrE0o+N2jkIMwazjFTKgcTyYUYyuyH6+QcmjFALcTkdmWSOSDtB
         6Z45aBO4hrXAZIYERYY/gm3jHB1AQVZjpv72NfxDT3zl9V5+IT1A8Dpg4kGqdvAQLB
         69rc9g1r8T4ag==
Received: by mail-lf1-f48.google.com with SMTP id j10so548959lfb.12;
        Fri, 14 May 2021 16:11:49 -0700 (PDT)
X-Gm-Message-State: AOAM5334WGLRH/BSbGXiVZ+3Q+qFyppMDagWeHrl8X+ISmyLL7LU5voZ
        uae0D9qACU4990rASFjMCfQGulfq0ACOulzflOE=
X-Google-Smtp-Source: ABdhPJxuh7GzAxFz5Y7IZ7T7krZp6Y3hl8x19DpVpT+XEQ/pnHDJgCCYw66D/KshiDqyKadZnOQJwS6k3ksG7ElCxRg=
X-Received: by 2002:a19:5208:: with SMTP id m8mr34206146lfb.372.1621033907578;
 Fri, 14 May 2021 16:11:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210514180726.843157-1-andrii@kernel.org>
In-Reply-To: <20210514180726.843157-1-andrii@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Fri, 14 May 2021 16:11:36 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7typcvUU+Hot_eCKsXVPru4Sc4q+oVO30=UQx8QBiSHg@mail.gmail.com>
Message-ID: <CAPhsuW7typcvUU+Hot_eCKsXVPru4Sc4q+oVO30=UQx8QBiSHg@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: test ringbuf mmap read-only and
 read-write restrictions
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 1:11 PM Andrii Nakryiko <andrii@kernel.org> wrote:
>
> Extend ringbuf selftest to validate read/write and read-only restrictions on
> memory mapping consumer/producer/data pages. Ensure no "escalations" from
> PROT_READ to PROT_WRITE/PROT_EXEC is allowed. And test that mremap() fails to
> expand mmap()'ed area.
>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
