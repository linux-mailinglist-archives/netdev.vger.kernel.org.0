Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E704717B1
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 02:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhLLBuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 20:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbhLLBut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 20:50:49 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70103C061714;
        Sat, 11 Dec 2021 17:50:49 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 133so11316812pgc.12;
        Sat, 11 Dec 2021 17:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HVR4cgAhcEwiFkKG5JNysFJ0C2jhZ2jNCzE2vsdu1fY=;
        b=LDAYkdqkNVKcQTS/mK2RweHaeGJy4nUQRKVXk5seloXxScKRTMtzEQcvbk0S3ZSD1R
         vguNKJYzIifsckhspD5+T5i82ILAzgH3aWmEkL5sFLTZs6c5AdG79yIRz/LBsmEw02m6
         3HfRGjt6p3Nr0vFerOFSP0aRleMnHfyJ9VQjO7S4CEEuH8c8ARSzez6Y2l9KC0LKQFH0
         kWhK5lR5Lwr8Piqthp9djX1zdAF2TN8Yef/R22MA0UzLc6phBGpfQ3rTbB2CufSj0q6D
         y3g9H1z6N8oxTTuPFG9ZD+bJeF4yWGoAz98tKlCZqHLiURLCzlDFzwM7V6DqzyBE6XBK
         U7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HVR4cgAhcEwiFkKG5JNysFJ0C2jhZ2jNCzE2vsdu1fY=;
        b=aCJVwuvqT/MuEb3s2jyb4j/pcqvCwTzOgbTDV1LsoxFJA0brLJor0ivFWoB4uMjDLv
         p1W20s7l6Fv9DSmBrmCjMmouQf8kppLq5K4f6dcU6XcNDMYydnMwu8SOh6Nz+n31czzp
         clBOjJuNoeqIboLwp/vU3Ixt2betfXYOnJE5wKmAbqkLFO+R9WA/v8TdXhj3C9pZP/V4
         ih4AEp6TH30vvvIAd8z1mQ9qDatbcVeOmR1rDfXyr1KuhxpaZ014RKvDf/jTsmi3nG1Y
         wss6iO41v9cv3xwg2EUNUJKCsI0pjhsnctTkRhCjZQ9lMnpqfJ+JpyvL9W6DB2RnfyqF
         zwEw==
X-Gm-Message-State: AOAM533S2CzK/0u9MMS3JjwePBA2P9sSkAp956/vEwKkcokFiV2AI+g6
        VzSucT8RdZOc7W/4q/Xt4CfrzVdB9Zucj8I1Hn4=
X-Google-Smtp-Source: ABdhPJxSzmjOUhVVylY/xIpnZDDw8xiHEW8ce/qKlXdSmVzhxg6q7r7TancqUkDmmoswbv8KdEaX9IRcYO9ktO+6uQc=
X-Received: by 2002:a62:33c6:0:b0:4a0:3a81:3489 with SMTP id
 z189-20020a6233c6000000b004a03a813489mr25976837pfz.59.1639273848945; Sat, 11
 Dec 2021 17:50:48 -0800 (PST)
MIME-Version: 1.0
References: <20211210141652.877186-1-houtao1@huawei.com>
In-Reply-To: <20211210141652.877186-1-houtao1@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 11 Dec 2021 17:50:37 -0800
Message-ID: <CAADnVQKP03sAUfrPARjB=x-B_MCE8=7H-vCT3AHmMHX2+XkwWQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/4] introduce bpf_strncmp() helper
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 6:01 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Hi,
>
> The motivation for introducing bpf_strncmp() helper comes from
> two aspects:
>
> (1) clang doesn't always replace strncmp() automatically
> In tracing program, sometimes we need to using a home-made
> strncmp() to check whether or not the file name is expected.
>
> (2) the performance of home-made strncmp is not so good
> As shown in the benchmark in patch #4, the performance of
> bpf_strncmp() helper is 18% or 33% better than home-made strncmp()
> under x86-64 or arm64 when the compared string length is 64. When
> the string length grows to 4095, the performance win will be
> 179% or 600% under x86-64 or arm64.
>
> Any comments are welcome.
> Regards,
> Tao
>
> Change Log:
> v2:
>  * rebased on bpf-next
>  * drop patch "selftests/bpf: factor out common helpers for benchmarks"
>    (suggested by Andrii)
>  * remove unnecessary inline functions and add comments for programs which
>    will be rejected by verifier in patch 4 (suggested by Andrii)
>  * rename variables used in will-fail programs to clarify the purposes.

Applied. Thanks
