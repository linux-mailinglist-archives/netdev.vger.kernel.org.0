Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C95F1D01D9
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 00:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731457AbgELWVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 18:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731434AbgELWVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 18:21:16 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B75EC061A0C;
        Tue, 12 May 2020 15:21:15 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 190so9844440qki.1;
        Tue, 12 May 2020 15:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rAny/KSMDJYb2X7Cf5i8wVgzdx3iFCLpbu1wjbgdsT8=;
        b=kWT72RYxX6fzabwfvG7DkEj7tBNxBFU4hTRyvoaAo0mSAh9FmkkLRSI5O+VqiRoOxV
         i/FBwFFSQ9ES66AQF37RXxdawn+HzC3tJNZC4vB3wcYIrekZ36QyvZf+TkrVEznRMCBj
         8tSnaYtkfDl3AvHQh3JWMatk5rs5S8ZMJyApAzGkWNu0CDbhuqoy9I/qnT+2Myl5Rbsk
         //DqbXLFHRgzsyMXKgSYSzEqpTK5GTn41RSb3FRD9w9AoxmLMd9DVIGOUpeL8oW0j6ck
         Ks800cT4Hxw38LEQqNGXZg/ICDciJ9GZpBKXwbhPQAz5/FRhbtpV9SimLp1aeyBxRr1f
         a8RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rAny/KSMDJYb2X7Cf5i8wVgzdx3iFCLpbu1wjbgdsT8=;
        b=O69k1AdNCuRzQIkNTXUl4dyMF3LXXGspRNDDBMcjYHbTcC06xKWGP30M0SR6UxE8Fr
         5OgWRYL5jyyVgnk4YH3mivmXnTH6B708A9qI+nkj4/+MvzWrUQwXZa7YJxnbqqgIYgnt
         uoOA/uh+0JMLbVIRY1xn7nj+Hk2bl+JdHHAxSHNs33c821c7/lNHq9ojhB38dM9I3rXg
         KMyOHDEM7i2z9aba8K2Wx176O5Y4xk5s2Pda6EkwVvv75SHATtClo0P3epwOC3q7r7Cp
         iN9k0cIXknEOX4PujJPHRARyegMfsUJLHUJ18Fb7HEI8LwkHt2sulMOlquUkwbONkTv1
         N70w==
X-Gm-Message-State: AGi0PubsYf2QDOqE3YHgQ8Be96gs/DvyucUkMK8nTwzvgxMRGHOVxoDC
        X7vZPkiOhAZsuyxdup0QLEze8Ry2LBdtKA0wzYIKAA==
X-Google-Smtp-Source: APiQypLzPbOQWDTf8Bm6PMe5mMi3ukics4KTMMgnAXRzlJUi94TQt5W2KSJqkNSuFTJtUeORrpEbuLcWGV2ATfZD6/0=
X-Received: by 2002:a05:620a:2049:: with SMTP id d9mr25179863qka.449.1589322074305;
 Tue, 12 May 2020 15:21:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200512155232.1080167-1-yhs@fb.com> <20200512155233.1080305-1-yhs@fb.com>
In-Reply-To: <20200512155233.1080305-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 May 2020 15:21:03 -0700
Message-ID: <CAEf4BzaNzOez7rjYYKzuSeSNKt7LXSDA-LaGjJJFJucO6G0zTA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/8] bpf: change btf_iter func proto prefix to "bpf_iter_"
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 8:54 AM Yonghong Song <yhs@fb.com> wrote:
>
> This is to be consistent with tracing and lsm programs
> which have prefix "bpf_trace_" and "bpf_lsm_" respectively.
>
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>


[...]
