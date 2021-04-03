Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADAE3534AB
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 18:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236890AbhDCQKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 12:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236426AbhDCQKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 12:10:55 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65765C0613E6;
        Sat,  3 Apr 2021 09:10:52 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id i144so8087573ybg.1;
        Sat, 03 Apr 2021 09:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=snoN8K5hwLeuXBj58ttxu9S8FxsEYelVKPUjjifI7aw=;
        b=oyoZEC+CrfzzFLhunms0lyNFpWP9Gd+W7lwtc49DoHUXaki9rrmSn9sMs2ZJMKHhK7
         Gjy4OQ/Wy0awjwMx+hBJA4ucsLTw3KPANHhdyNHTvGQhLKty9o7Y1rsPs0oOPRM1cjZR
         9XJ7ZLS1IsYUM86sFkC2cmgoPHb55/vcg3C1rO8gYblCtT4NqFA1qytBxG68g7dukEMT
         WCzXRVzPDTP531SVu5GMXB15ZsKOGVGWszp/bgBhTGEX8ba/l6wG1e0RgMbCsh/98k74
         +NNB715ilGp9mLYXBqQSSCcwp/nfsoUDPSTC9bLwaEouOkNnWuirPVzS4o8azSzHxUoL
         XVGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=snoN8K5hwLeuXBj58ttxu9S8FxsEYelVKPUjjifI7aw=;
        b=Hq8sfjuqf2d65CdbzYwsiq3dQAjoxjImF0tMyPlA8ZmM/N04ezBSV5OCkR1xPXW6GH
         6bIA94K4s3LIvcIEc3+8nx8qcXXZ6giuh8PoF/4JB/1V23KMkdQjzw9sBytN8bQftJAG
         Up4vXP8Ciwy7Ub5qit4tuvG970Gu4HbWm4us2rE0DL14M7HqEiHn4wsBGA9DqVfEEyxg
         AtzrOuXZ/JtBGtfQYpytarmgugq5Vlv2e/8bTD9Zyf1V5KNMLIgGRG3lCH/vWjpsTOX6
         ybadTyhQuUbqHxN1lcpgL6zSzky3L6Zhs3SgC9s/3m0kZYddCwFpHchgsvVoGncFw4dc
         3MQQ==
X-Gm-Message-State: AOAM531k+/dEjONVfrRSoTUUdEAV11ZIAnKT3mGbvIYH2rRLRYfj9ZDJ
        E2d+z8u5Nbxp2g7RxUORhxguRXefT9rZZqdKScVSPvWrsLA=
X-Google-Smtp-Source: ABdhPJy/G/j2qQsXLjvkzo/hdEN2qP2Ulbk0ebzE9P/aMwnqM50P0pSDaczB6zjiFYZY2+8V5s6jAdBHgc3ZsHPRaOk=
X-Received: by 2002:a05:6902:6a3:: with SMTP id j3mr2246894ybt.403.1617466251761;
 Sat, 03 Apr 2021 09:10:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210403002921.3419721-1-kafai@fb.com>
In-Reply-To: <20210403002921.3419721-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 3 Apr 2021 09:10:40 -0700
Message-ID: <CAEf4BzZ946oyLMZs85AYAX+qx-dXg_Bvz80xmGDXG_eqUfApiA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: selftests: Specify CONFIG_DYNAMIC_FTRACE in
 the testing config
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 2, 2021 at 5:31 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The tracing test and the recent kfunc call test require
> CONFIG_DYNAMIC_FTRACE.  This patch adds it to the config file.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  tools/testing/selftests/bpf/config | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
> index 37e1f303fc11..528af74e0c8f 100644
> --- a/tools/testing/selftests/bpf/config
> +++ b/tools/testing/selftests/bpf/config
> @@ -44,3 +44,4 @@ CONFIG_SECURITYFS=y
>  CONFIG_IMA_WRITE_POLICY=y
>  CONFIG_IMA_READ_POLICY=y
>  CONFIG_BLK_DEV_LOOP=y
> +CONFIG_DYNAMIC_FTRACE=y

I've also added CONFIG_FUNCTION_TRACER=y, which seems to be a
dependency of DYNAMIC_FTRACE. Applied to bpf-next, thanks!

> --
> 2.30.2
>
