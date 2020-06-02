Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58121EC1F4
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 20:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgFBSig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 14:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgFBSig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 14:38:36 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F14C08C5C0;
        Tue,  2 Jun 2020 11:38:36 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id c21so6798785lfb.3;
        Tue, 02 Jun 2020 11:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sGuOtLK0tyO+QL+rjz9vPf+X6I712kJWb/GmBEltk/o=;
        b=hsBl/lANsqieaj67cCVV02BEOEQlQ8TNGzwEwPr9wLcJWPndCHY+BGe5K/PRXxfV6P
         u2oEzPDQghzfX8EufE/bJ6Ia3ODMQ4CAND45+o9k7j1XCoo1LzWBf3mChsvNEt/zFH+o
         2G5n/ecM42ywmUWwRQWvmYgQIUCgO9xDauo+KxkPjGZRVcavJcLRiEqsfSFKw79MwhrM
         5SM7KsF4LL2Bmwvv5hyjA2odQ/I8kQuFpRP5493jtTLuOq6/fjZ9LUzsKXP1pdG9ZSWx
         MBp7650zs+MbBkXoIn/dMroSMALGy/QgLSBdUbDvWPZSSO9Mp4d69ZCVwbP4N7KP3r8M
         g7AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sGuOtLK0tyO+QL+rjz9vPf+X6I712kJWb/GmBEltk/o=;
        b=k8gYUWvAIToIY6OHMOr2G79BHQdP9lh0lwfMbT7590qMZe/P3RVBZZDxDqQ7gtCWE4
         Fcl2txQAW/a8X9As4qMMa7VICwTFdS8MJjKzjDLD3NixfHVheA4DwhoZro/AdqSRA1al
         1yh17gEUEfRJGicRjWz2cyAl8Y8VcItWKPT2gHjLdUYG7uha250MV1Zf+OpMsM/LStSf
         OFFFJ8jBmXa21g83GMPQ/raWOdP0xUp+PP9iPr0SzmUWHeHXBQsEr782lkNgaVO7Pre0
         kqI6xk1Zxs85rlcc4yAnuIAY1FsgKJBDPYOWrSDzQcAd2mhj+0zsq5df752ByrXMu88i
         RtCg==
X-Gm-Message-State: AOAM530lynpDr4pb67cjUA811zWNl86yqkz/veRclHdIuQoLUzcN7NC6
        ogc1GWVlrMTjCIcTkAEdVp9mm3aKvkRN+uFaCkU1CA==
X-Google-Smtp-Source: ABdhPJxs2q/h8Xh9VpAyOWBwYgIjv6PBElZT+zm9I6KWlsaMGJbkpKTtSB+C3Xtl6TE/4vSnbtZjdiOuvS+HkrYBg/A=
X-Received: by 2002:a19:84:: with SMTP id 126mr370776lfa.174.1591123114468;
 Tue, 02 Jun 2020 11:38:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200602092648.50440-1-zeil@yandex-team.ru> <20200602092648.50440-2-zeil@yandex-team.ru>
In-Reply-To: <20200602092648.50440-2-zeil@yandex-team.ru>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 2 Jun 2020 11:38:23 -0700
Message-ID: <CAADnVQ+3gMoO1ws8n63PPJjOQHh_B0jFaf6=-R0Cs+k6NpjxxQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] tcp: expose tcp_sock_set_keepidle_locked
To:     Dmitry Yakunin <zeil@yandex-team.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Lawrence Brakmo <brakmo@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 2:27 AM Dmitry Yakunin <zeil@yandex-team.ru> wrote:
>
> -static int __tcp_sock_set_keepidle(struct sock *sk, int val)
> +int tcp_sock_set_keepidle_locked(struct sock *sk, int val)
>  {
>         struct tcp_sock *tp = tcp_sk(sk);
>
> @@ -2922,13 +2922,14 @@ static int __tcp_sock_set_keepidle(struct sock *sk, int val)
>
>         return 0;
>  }
> +EXPORT_SYMBOL(tcp_sock_set_keepidle_locked);

why export it?
