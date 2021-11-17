Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CE345449B
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 11:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbhKQKHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 05:07:40 -0500
Received: from mail-vk1-f182.google.com ([209.85.221.182]:37383 "EHLO
        mail-vk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhKQKHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 05:07:40 -0500
Received: by mail-vk1-f182.google.com with SMTP id e64so1291779vke.4
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 02:04:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PBTYzfde2NihoxyD9Jtp+PtaW561USblT66v/CMUGP0=;
        b=hBzCe3jcihH05vIZCJLXiJsyJwqGUo3pilUtPWV9N9+9wj9vK3mqyOmVv5khDqMCCd
         RL/lMM4mtgbx1gv5t1+j4p9B2ovIUGWR6pqB3vK4rA34tUedfriicWBOr0RNWHAsBxRb
         v833b/rwfz/dGMxvsxGtG6ipy11ODKyN1KVllwk2BsfiYahSDZo78VEwkx5CtE6wfzqx
         Ci3dHSUW7EUas0OwqJ3+Q1+ZkH3oGmUtZZKs2IPFjCckcUKECQ4CI3LxGyepIQrlh1VW
         xaX+j2NwaDszCNu79nooNMNMZ7C4MF+E3SFDRA8MAq18/zA/Rgz0cHNFn1cVEI5OXCM1
         iBVg==
X-Gm-Message-State: AOAM53391QfCRUU+5HTr3tW4sEEBstOh3kFiElObDfsUjmWKm6ciRREE
        rF1q6hAOLZxG8cDM+6vRNmOg/NKdkBgmqA==
X-Google-Smtp-Source: ABdhPJzn7Y6fjpJYkMLyJON3q5Vj6Y9BV1U17B+Bbxp8JOMMk1zI3NPTVTv5O5kbWWivUzok6ETfSg==
X-Received: by 2002:a05:6122:178b:: with SMTP id o11mr87789271vkf.17.1637143481590;
        Wed, 17 Nov 2021 02:04:41 -0800 (PST)
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com. [209.85.222.49])
        by smtp.gmail.com with ESMTPSA id y2sm11587338vke.43.2021.11.17.02.04.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 02:04:41 -0800 (PST)
Received: by mail-ua1-f49.google.com with SMTP id w23so4641536uao.5
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 02:04:40 -0800 (PST)
X-Received: by 2002:a67:af0a:: with SMTP id v10mr66289821vsl.35.1637143480697;
 Wed, 17 Nov 2021 02:04:40 -0800 (PST)
MIME-Version: 1.0
References: <20211117100130.2368319-1-eric.dumazet@gmail.com>
In-Reply-To: <20211117100130.2368319-1-eric.dumazet@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 17 Nov 2021 11:04:29 +0100
X-Gmail-Original-Message-ID: <CAMuHMdV51-T_7GTYtogjnqpsS4Y2XzB4vwn6qsCbTjnP-9geAA@mail.gmail.com>
Message-ID: <CAMuHMdV51-T_7GTYtogjnqpsS4Y2XzB4vwn6qsCbTjnP-9geAA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net: add missing include in include/net/gro.h
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 11:01 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> From: Eric Dumazet <edumazet@google.com>
>
> This is needed for some arches, as reported by Geert Uytterhoeven,
> Randy Dunlap and Stephen Rothwell
>
> Fixes: 4721031c3559 ("net: move gro definitions to include/net/gro.h")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
