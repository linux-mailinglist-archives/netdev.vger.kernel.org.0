Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B964A61D1
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241363AbiBARDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241368AbiBARDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:03:05 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9118C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 09:03:04 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id t7so25017696ljc.10
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 09:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ka8pYyC0GHWoeLpCYw/LWy4USejRJXtfOSInUudnWSU=;
        b=rS1qZ0MOxeIwPmmzR+xQL1U2O7aHayJsuJjFuIAJ0B9BZDFJh9uBFRVq3Bjz558NrU
         mCd0QaMCyYLA7HCvj1f2WvxtmX4W1IxjHDbOOmD80ZWCsStxMawsl7ejifNbPOL3f7HD
         D3J5lSRrhUmvmp6Z8NwJCI5H0DV0Dh0HmYfIA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ka8pYyC0GHWoeLpCYw/LWy4USejRJXtfOSInUudnWSU=;
        b=7VYOoSJpPvsm2Tc92/vWQe0COaH2u1JLZAgsGFs7DSpZ0L2aVjtlXH2pWGfU6w1KUB
         +SiP5S/XzHRQ3GvDupJxRsY/47VOqQflXnIWMcDD8b1m7mXGHg6hudsFAyjn0cN2bk/S
         4nTZbhyuGvlXno76VHmDTVsUOvsxgVLHKYeIhZSn4BON9TM5uLscP9BG9/iL05t5s1xn
         cwZgkigKZ61XQyS1UM2gJOA8hB97cWwfJxchb14x9vMzxC9v+ojN1MWSvvOZDrdJLCF7
         lXuYdeVKbypinevPkIx2I0SeoHXg3KYG6ccjjwn60uWQz52cvIczGZTMIcruQdBoosu6
         v+5A==
X-Gm-Message-State: AOAM532foauaNGVIKIYq3lbWUB3jTK9I6ZwigGZ3E+51Exp5PZwGihyi
        I9dBHCO4DHgdNNPJ99cdqJ3E3PhTo92WYpp3D4+Opw==
X-Google-Smtp-Source: ABdhPJwVfxRmzCAilvAQPZlCwmMAtiCGJT37qvg1iWJ9Elg0tjJBVdNw4pveunQ9Laf20RIRO7WSqHq8U60qJGAsC8s=
X-Received: by 2002:a2e:99cf:: with SMTP id l15mr17334894ljj.298.1643734982959;
 Tue, 01 Feb 2022 09:03:02 -0800 (PST)
MIME-Version: 1.0
References: <20220124151146.376446-1-maximmi@nvidia.com> <20220124151146.376446-5-maximmi@nvidia.com>
 <CACAyw9_5-T5Y9AQpAmCe=aj9A0Q=SMyx1cMz6TRQvnW=NU9ygA@mail.gmail.com> <5090da78-305c-dc42-65a6-ef0b2927db51@nvidia.com>
In-Reply-To: <5090da78-305c-dc42-65a6-ef0b2927db51@nvidia.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 1 Feb 2022 17:02:51 +0000
Message-ID: <CACAyw99rvHp8FEn9_kjvcVBWB84DSXRSmad+bLDKcBk-E+BaHA@mail.gmail.com>
Subject: Re: [PATCH bpf v2 4/4] bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Jan 2022 at 13:38, Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> On 2022-01-26 11:45, Lorenz Bauer wrote:
> > On Mon, 24 Jan 2022 at 15:13, Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
> >>
> >> bpf_tcp_gen_syncookie and bpf_tcp_check_syncookie expect the full length
> >> of the TCP header (with all extensions). Fix the documentation that says
> >> it should be sizeof(struct tcphdr).
> >
> > I don't understand this change, sorry. Are you referring to the fact
> > that the check is len < sizeof(*th) instead of len != sizeof(*th)?
> >
> > Your commit message makes me think that the helpers will access data
> > in the extension headers, which isn't true as far as I can tell.
>
> Yes, they will. See bpf_tcp_gen_syncookie -> tcp_v4_get_syncookie ->
> tcp_get_syncookie_mss -> tcp_parse_mss_option, which iterates over the
> TCP options ("extensions" wasn't the best word I used here). Moreover,
> bpf_tcp_gen_syncookie even checks that th_len == th->doff * 4.
>
> Although bpf_tcp_check_syncookie doesn't need the TCP options and
> doesn't enforce them to be passed, it's still allowed.

Sorry, I was only looking at bpf_tcp_check_syncookie indeed.
Unfortunate, it would be better if that function had a th->doff check
as well. :(

Acked-by: Lorenz Bauer <lmb@cloudflare.com>

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
