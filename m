Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2D640FE8E
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343550AbhIQRVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 13:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245754AbhIQRVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 13:21:05 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752C4C061574;
        Fri, 17 Sep 2021 10:19:42 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id b64so19736870qkg.0;
        Fri, 17 Sep 2021 10:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yEuHcEoTPhrJMHC9qczQ1zTZGx1PP9TVKF6T/LQNqgw=;
        b=h9BmRkFvq8Tw0BUoP2OqOak1QZa7azLRc/ZLIxCowUtFeLIEXmIVbzK4RRJxRbpxKA
         t+0pwpMosoG3+n2hRJyfbv7/6iZH3E61i4amg4LM2lEv3hUE9IIzlsNShfGsEmIyIbgg
         NvnjL3RhdkCjM3Pthh2delGuxp0e1/eqydc6utgUUgN1ZfaGZ4YTrTXp+OGSDWA3NcAh
         45mgKI8M+PhLmlmGM3IEVjBOcFojBVm1JuGENbBi7/TA9jJeyworq7sUXhdON25H+dBo
         otHXhSkalw87nBtswnTMMSCzOXQ7kGEk8MYVwsqTCBx3lcVzjx03Cc8Tx4b6YAUtXRdt
         YQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yEuHcEoTPhrJMHC9qczQ1zTZGx1PP9TVKF6T/LQNqgw=;
        b=DTxTSYD5h/xDCopC2hAUUaLS3zCR7hRcxlRoSAG435Tq0wJkgrnkWetbwWlBDjzN3F
         le3p7j179yqbm64twMpX49gaDKCeUwJW/ZjpeKcQlZg06nJ594JzErwds21w4MuOfNSz
         M5DGw1dCinlgZSI/2ojBMgtFDgCX93KfdVe4j+wqvXbRtWSnZ6qyUwSs2DYX0Tm0RqfH
         dlQDt6E3do+bdynA07IN/dSUHsBE6G0U9vKIp7UnAGgsCVztyA+yZ5iFk7OhoE9xk458
         dVn/ar9f9TMdkqW/QQmdX1k5bVgE/SzUSB+sGmRIPf8MQgHFblQ1F2dLg5qsA6iQy8iZ
         UclQ==
X-Gm-Message-State: AOAM530P1NSGSY5/++QcudUgKIsJkyi/V88oTr5ngW7u2f2MiMvn2yuF
        2oel+XRp0BZvbX1LgKVa6FA26BuWLgEPFlmEqzw=
X-Google-Smtp-Source: ABdhPJy/4sOJNTJQKBKNPQeCpUOewSj7Hlyg3iQvB3Cl4VJP4x9wnMhvfdo2aCTvmGJS+auCzr98i5IDVv51vxXWC5U=
X-Received: by 2002:a5b:408:: with SMTP id m8mr14966427ybp.2.1631899181660;
 Fri, 17 Sep 2021 10:19:41 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1631785820.git.mchehab+huawei@kernel.org> <9e9f62ab09c26736338545f9aa27c0e825517a32.1631785820.git.mchehab+huawei@kernel.org>
In-Reply-To: <9e9f62ab09c26736338545f9aa27c0e825517a32.1631785820.git.mchehab+huawei@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Sep 2021 10:19:30 -0700
Message-ID: <CAEf4BzZhr+3JzuPvyTozQSts7QixnyY1N8CD+-ZuteHodCpmRA@mail.gmail.com>
Subject: Re: [PATCH v2 10/23] bpftool: update bpftool-cgroup.rst reference
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Roman Gushchin <guro@fb.com>, Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 2:55 AM Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
>
> The file name: Documentation/bpftool-cgroup.rst
> should be, instead: tools/bpf/bpftool/Documentation/bpftool-cgroup.rst.
>
> Update its cross-reference accordingly.
>
> Fixes: a2b5944fb4e0 ("selftests/bpf: Check consistency between bpftool source, doc, completion")
> Fixes: 5ccda64d38cc ("bpftool: implement cgroup bpf operations")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  tools/testing/selftests/bpf/test_bpftool_synctypes.py | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> index 2d7eb683bd5a..c974abd4db13 100755
> --- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> +++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> @@ -392,7 +392,7 @@ class ManCgroupExtractor(ManPageExtractor):
>      """
>      An extractor for bpftool-cgroup.rst.
>      """
> -    filename = os.path.join(BPFTOOL_DIR, 'Documentation/bpftool-cgroup.rst')
> +    filename = os.path.join(BPFTOOL_DIR, 'tools/bpf/bpftool/Documentation/bpftool-cgroup.rst')

Same, this is wrong, please double-check all bpftool path adjustments,
in case you didn't CC me on all of the related patches. Thanks!

>
>      def get_attach_types(self):
>          return self.get_rst_list('ATTACH_TYPE')
> --
> 2.31.1
>
