Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3D61CDA67
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgEKMqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:46:19 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:47073 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgEKMqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:46:19 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MIxmm-1jo00p2Nre-00KMIH; Mon, 11 May 2020 14:46:17 +0200
Received: by mail-qt1-f170.google.com with SMTP id c24so1294537qtw.7;
        Mon, 11 May 2020 05:46:17 -0700 (PDT)
X-Gm-Message-State: AGi0PuacCc9IjKzMyUhzFkuC5SW03y1zovjtEMbiI1WVdeNrpyMgkFrC
        R/C8SkCZAz2IqYrU4BCAc7QqQJaNuQpcdbofRHA=
X-Google-Smtp-Source: APiQypKSzJ/nFFOsdlvHkR+heSh3jGZQCiUPW5LDnl1OaKCDIPTPHOgosmtPR+S66nwwWCLHUzRmkNbHyt4CJv33fy8=
X-Received: by 2002:ac8:4e2c:: with SMTP id d12mr16135898qtw.204.1589201176242;
 Mon, 11 May 2020 05:46:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200509120707.188595-1-arnd@arndb.de> <20200509154818.GB27779@embeddedor>
 <87zhae4r35.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87zhae4r35.fsf@kamboji.qca.qualcomm.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 11 May 2020 14:46:00 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2i-jqY8FnY_Tu41VDxQGqHHKRCyJ5U-GQbNmrqa=n0GQ@mail.gmail.com>
Message-ID: <CAK8P3a2i-jqY8FnY_Tu41VDxQGqHHKRCyJ5U-GQbNmrqa=n0GQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] ath10k: fix gcc-10 zero-length-bounds warnings
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Michal Kazior <michal.kazior@tieto.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wen Gong <wgong@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:ptJfG+TwRH/ZTRhKkPGAbQlLx8rP+rTu8Lc2pH2x559ex0BtEVe
 j9AASt+DulTy51xOV2Wda9mSOZ5fQ161unfARJ80G5D74/7doKcr3cvPYFIO2eneaJLO03I
 ABfB9TrDt20AgwBm6E7EdmyMbN8KbNk20FwcKX8egSe5gMpo92C/AYidTjL3pWxskS3Q94T
 hjUQVX5Kjj8Qu5oYZiJ7A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XkVXpEq479I=:WT2cNOneaAQyu1X5hn8N17
 vf+M4Txot7L6R2a2XROtHwl5dVwPd1te1KXQMX7yc6AFj2/TAfa4GkrVVdyS4y1xzAl68FIZB
 f2Z/IIxQTeC4ThS/OT+nGuiqbmOZ+wxkZHoABcTD4UU8IVyc03pk00EPaaAS6FAKmliI3qvFu
 IQCnFuOjvY4UX4hm2sczwZR8xzlJfHjhKs4+7T4Ac1sFnMSD7dT8dO/zKPfLckdugo9qVJf2d
 HGG2A0MJwE9Z8sOZrEaL+QWWK8j74OP00buQdYHf4RbpO2aiHnPSknotLLZisLBzN33uMoVLt
 50bsd6vsxD98uX6e7qqludxq3VDKcbONrEkXWRsq0TuISDzf15KZ1gFHGwWV0ggR/RgUeS8Z3
 n8kWzBlqPSGEEmN1ibIUgOHxoO9D5uzflmTMujLrKdaPbySwLXk2sNYUbFJo8/U15aPnQNP/h
 CykPkwrNi35XmlByPxXDfYbzBnsJO9ocbYnJB2L8twBX7oBE7ZeSTHev25tDJBQfP4Jlt2eAq
 i1l5CXOHy3GSRMShS7YxXqddCcxcxZfIk4hOYFALho0EP55Xa4yQKJxH8h4m7gyxCDuQltz4l
 Woo3u7yjGlzIZmWIHpz/fOsojWiFS3mUokgjBrsDW7xOJyZ46SCPOSRVXT1ExTCbLIjyPefvs
 trq848RS1yMFClxxTLlpGAUSM31FWoZqJCej7q3w7+8kUkMzwwNNzDfIEbJ8o7Wt/gErRWBuy
 qEnHJXnrBVhWsW73d5Mo5rD8E8UKitbKPu0pEQMvl69DhAZ5burJTljqqJ7WytEfaOGyEiNsw
 j5BobXCKa4wm9mhLEYdxoHMidQ0HwJSWR3PVKFDmgJdB6Nb2hE=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 2:03 PM Kalle Valo <kvalo@codeaurora.org> wrote:
> "Gustavo A. R. Silva" <gustavoars@kernel.org> writes:

> >
> > This treewide patch no longer contains changes for ath10k. I removed them
> > since Monday (05/04/2020). So, this "Fixes" tag does not apply.

Oops, I forgot to update the changelog trext when rebasing.

> Ok, I'll remove it. Also I'll take these to my ath.git tree, not to
> net-next.

Thanks a lot!

       Arnd
