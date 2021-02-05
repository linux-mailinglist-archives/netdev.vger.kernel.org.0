Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710F4310ECF
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 18:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbhBEPwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 10:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbhBEPtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 10:49:49 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B27CC061756;
        Fri,  5 Feb 2021 09:31:22 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id b2so11040577lfq.0;
        Fri, 05 Feb 2021 09:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EHVbv5GfJGAsh+baRD0vDhgGaM/gYkYk9FBbp0Bh6eE=;
        b=kZnARjDIfpGFwANoHQ9TZhVN3aIWi0i50pevZdPAqQjoKpbzhD0PsaZbfReZLYExqF
         5u5Im/m60DQiw8ucypozpvdZfrktU0OakcSMF+nxwCxACHyYb1aX6Mgb5TfVXoJLunX9
         mcw/adGZ/wcSnM618POi692+S9FzCiq6XFbI3uAyR8rjBtvtJhO4lzedJGPyGJcUHlby
         UXdsxkxS9Qp6oEzcDVppPLef7MtlhRlPAE9UrFBcVSiaTwED6ZMuiSIjX28Jy7Ey0MHm
         qS7rO1eDNmJ5l+5k4RcrIZv34Ju30p+Zq9DamGxUUUrH/d8RXm/3TItvlkxESoJmwhkH
         zaYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EHVbv5GfJGAsh+baRD0vDhgGaM/gYkYk9FBbp0Bh6eE=;
        b=Casqr/aoss58tJf41j9EAMyJNksAc0IonLwIH0O4/hQB01zYWX83vL8KJFxgHOBgud
         OxELQ8r2ZsO8oyua7rSkhzD9zx4OCc0hqXb594UYcn6lFtBIUVuX4jDtgePmR9HZ+BHL
         bCn2Pl9gY7AJ0PTTAaz3qp4IKlEGpgVMdkZ5E6kiG1CE/1bxI79tf8ayJLlLhPAc0ZgZ
         +JeXcI/u7BQ3xh9R2AhjrvJhZErVVSzChgRQyhoVdXJ0VJ3CFZfqqeRR7KfTQkzgkBo+
         JFugayhwoqMmJ9O2AoZCwT2n1aauHBlOti3RLJdovqslArb8iyDTYDyYswWFhPBGAXKA
         4aVA==
X-Gm-Message-State: AOAM530Jh/ZagZ/vaqCLtRvrm3RaUG51HU+SzYCzT4EDg+YVQtpRvwn8
        5xJM9Mnxyl2cf3PyZyw8sBpvTN9mG9cmlqR4MSw=
X-Google-Smtp-Source: ABdhPJw0z2Xu+lZeuiQ8P54kSz/s5E5mBb8UNFUgXgx2v/3z5akvXEYoj1xKN1O0YVt0uXEFIOVKzrHwobm266FdVGo=
X-Received: by 2002:a19:341:: with SMTP id 62mr3106093lfd.196.1612546280908;
 Fri, 05 Feb 2021 09:31:20 -0800 (PST)
MIME-Version: 1.0
References: <20210205170950.145042-1-bjorn.topel@gmail.com>
In-Reply-To: <20210205170950.145042-1-bjorn.topel@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 5 Feb 2021 09:30:44 -0800
Message-ID: <CALDO+SZhgSr5haWT=c1b-+WMpeaPGkDYoxCoWtTaX2+L85WEJA@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: use bash instead of sh in test_xdp_redirect.sh
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 9:09 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com=
> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> The test_xdp_redirect.sh script uses some bash-features, such as
> '&>'. On systems that use dash as the sh implementation this will not
> work as intended. Change the shebang to use bash instead.
>
> Also remove the 'set -e' since the script actually relies on that the
> return value can be used to determine pass/fail of the test.
>
> Fixes: 996139e801fd ("selftests: bpf: add a test for XDP redirect")
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
LGTM, thanks.
Acked-by: William Tu <u9012063@gmail.com>
