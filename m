Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A543EB44A
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 12:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240224AbhHMKwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 06:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239044AbhHMKwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 06:52:07 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B661C061756;
        Fri, 13 Aug 2021 03:51:40 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id b7so11385397plh.7;
        Fri, 13 Aug 2021 03:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=y1kdczTRTUq0E8aAH+vtFhoJAvPT0kPuLojaeEkmlK4=;
        b=MK7CFkoZKvHbUmSmRQ4RYlRrjNUWXYbvWVv3ooMEHY1UrrC6+TNgo3yOvat4hz+s1/
         42ZqQ9+Bt/tq/eKQO15IagdqXMYHLmNuNrtrMs8uqe9wnR8r3ZcXuhi47xOywys3Vzpa
         CJtxuilBVSoV6dzHrUq+K85NThS6hzRiUfublOerQKt/mrfuleq1pb5M6S4bH8oJ0afp
         qPtTceMOL3cv8GfGZ0/ZX2e+/u3C+OQpZee7PUL0EZWz7Dj2BEg7L1huTjVYO5kR+pE5
         9j67BTbDoV3+otbN/6hQmb7hc8lrqWBGfmAUwyG/m5Nm+9iXyjH1q4Ef/mR33XhlPeDh
         Gstw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:from
         :message-id;
        bh=y1kdczTRTUq0E8aAH+vtFhoJAvPT0kPuLojaeEkmlK4=;
        b=IzDgC2SDD2S6+xKKoO3nqukJI1vOu/RekN+VxhCCPpqOmAOk+E5ezFvr0TspOHUYQx
         Aym+Xb/V+dZkgBpKI/Au9n+LsA9JadgpEqZh9B4dfm/6Tln/O96f+LpHqQF1/0AJJA26
         w2pKS6c83S/X8TlYLIJCuGOoZqviwRwbiIctaqZMVnqCX1zSGQHVLspOjJ9tSKFOBqPC
         0V7PSzpiTxU3KhWzfp8+RD3aAkTYlXGA3puRf+s/HUHarQJeFmUWwnckMgtnyQEhJNI5
         jSPwKXfi8UYKSjpX6zqJsH9MXZlII5q3koWDBi/5mLHB7kuQxyg0HJeK37i7RqDkS2NC
         CE4Q==
X-Gm-Message-State: AOAM531CRJMDHP6voSLMkzP0LbiBoKiFfsy9hv1ehJwfgVQsZ4pCT5/A
        3d7f8PwoAG4GtgNJD1JhBzw=
X-Google-Smtp-Source: ABdhPJxOPJdbAvGqQ5fHpx70w8gkZ4j54wwWOUoXuw4W9dPkwVjP2Wl5COtIr7eqZ/75R/sW5WMFdg==
X-Received: by 2002:a65:6717:: with SMTP id u23mr1858160pgf.28.1628851899898;
        Fri, 13 Aug 2021 03:51:39 -0700 (PDT)
Received: from [10.212.113.128] ([122.11.212.60])
        by smtp.gmail.com with ESMTPSA id x81sm1787568pfc.22.2021.08.13.03.51.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 03:51:39 -0700 (PDT)
Date:   Fri, 13 Aug 2021 18:51:35 +0800
User-Agent: K-9 Mail for Android
In-Reply-To: <8f324e46-f05c-42d7-9599-a43de7be17dc@gmail.com>
References: <20210811235959.1099333-1-phind.uet@gmail.com> <CANn89iLQj4Xm-6Bcygtkd5QqDzmJBDALznL8mEJrF1Fh_W32iQ@mail.gmail.com> <663ac8c4-b0c3-5af6-c3c3-f371e0410a43@gmail.com> <8f324e46-f05c-42d7-9599-a43de7be17dc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] net: drop skbs in napi->rx_list when removing the napi context.
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        memxor@gmail.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+989efe781c74de1ddb54@syzkaller.appspotmail.com,
        Mahesh Bandewar <maheshb@google.com>
From:   Nguyen Dinh Phi <phind.uet@gmail.com>
Message-ID: <804FB1AF-90C7-4430-9C5A-6837C32E431A@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On August 13, 2021 6:16:34 PM GMT+08:00, Eric Dumazet <eric=2Edumazet@gmail=
=2Ecom> wrote:
>
>
>On 8/12/21 9:17 PM, Phi Nguyen wrote:
>> On 8/12/2021 3:07 PM, Eric Dumazet wrote:
>>> Also I object to this fix=2E
>>>
>>> If packets have been stored temporarily in GRO, they should be
>>> released at some point,
>>> normally at the end of a napi poll=2E
>>>
>>> By released, I mean that these packets should reach the upper stack,
>>> instead of being dropped without
>>> any notification=2E
>>>
>>> It seems a call to gro_normal_list() is missing somewhere=2E
>>>
>>> Can you find where ?
>>>
>>> Thanks !
>>> H Eric,
>>=20
>> I think the location that should have a call to gro_normal_list() is
>__netif_napi_del()=2E Let say, if the driver call a function that lead to
>gro_normal_one(), and add a skb to the rx_list while the napi poll is
>not scheduled, and the driver remove the napi context before a napi
>poll could be triggered, then the added skb will be lost=2E
>>=20
>> Actually, this was the first solution that I tried with syzbot (It
>passed the test too)=2E
>> Best regards,
>> Phi
>
>I think the real bug is in drivers/net/tun=2Ec
>
>It can call napi_gro_frags() and I do not see corresponding
>napi_complete()
>
>This seems completely bogus=2E
>
>Your patch only works around one the many bugs caused by=20
>commit 90e33d45940793def6f773b2d528e9f3c84ffdc7 tun: enable
>napi_gro_frags() for TUN/TAP driver
>
>I suggest not adding your patch, because we should fix the root cause=2E

Yes, it truely comes from tun driver=2E But it was there before listified =
RX added (that time the skb will be put to stack immediately), that why I m=
ade the fix in dev=2Ec=2E I thought I should change the later commit=2E 
