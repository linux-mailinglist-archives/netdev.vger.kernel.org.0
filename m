Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292B21CB99B
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgEHVRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:17:23 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:43117 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgEHVRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 17:17:23 -0400
Received: from mail-qt1-f171.google.com ([209.85.160.171]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N7zW7-1j2UZ13jt5-014zR7; Fri, 08 May 2020 23:17:21 +0200
Received: by mail-qt1-f171.google.com with SMTP id i68so2666803qtb.5;
        Fri, 08 May 2020 14:17:20 -0700 (PDT)
X-Gm-Message-State: AGi0PuaeFJIU8XIdfoAHtwvhX2yMwpgymFmBKL0RcoglYQK2Ote8IZYc
        nxaFxZgUyERiJvpR7ipOwrK9Tsi0xXc387ehLjM=
X-Google-Smtp-Source: APiQypIvad7aLitn+xmQk8X/JPRvw7lw5m5ERGWfXFfVhFVyjM1R3g6aMc8Zoq+xZMsllg7Bcor/yZaVVRwxCxHOGHU=
X-Received: by 2002:ac8:4c8d:: with SMTP id j13mr5033840qtv.142.1588972639703;
 Fri, 08 May 2020 14:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200508194132.3412384-1-natechancellor@gmail.com>
In-Reply-To: <20200508194132.3412384-1-natechancellor@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 8 May 2020 23:17:03 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2YqJojpS7eDgVzqRPLibXBzWDp5JWSf=U81EbvA81Y6Q@mail.gmail.com>
Message-ID: <CAK8P3a2YqJojpS7eDgVzqRPLibXBzWDp5JWSf=U81EbvA81Y6Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ipa: Remove ipa_endpoint_stop{,_rx_dma} again
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:yVmCAf9a3z5zbArULHCkeKcnA54A/0bIGRvyKkIfMaKwvlO8NIq
 EqKUDQR4d68LrxzjMvI3mrQJ3Kr3Gh3k12t+xFD5yDawloLNziYvepIuWb/rsrl0HydHyBl
 HJuwUmmzvXjUEFsbPNGqhb6zsboaHzU4wpfBOHb65eyzLTnarA0xCWV3K76zsDstnMsr/iM
 QJYkuZ/18TCmuYcBv4Azg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nIxqF1si7OA=:rLD/U0qximF00Y5RH89lG8
 YzNEP1y7PtiPYe3zlxjSzSQZ/tvmucqppqG83V8CP06E3EcGw0psGhcrgKBQuafj5qdPB9STj
 e7Ag6DIa5gWV7jqjIqfdYTX3c/vxSj/iIHLGGf3BVlIpBuaJzEGa9bcNRaOGpRebtC3yOOcQS
 nzJeQUgDGkq5PvYhKMVbeGJz5XzrJCooEb9rGW7fbt3zF3cScWy+po1cVW/YWtRNgxSnj7rxB
 UtoTrDl3EHjcE8dKmQfJjxvluWsRcQuOaOt+9THRGuA5H6Xg0/wAgYsXbNx0BMbqGEdG9qoh3
 UOjneAOyHtjsDoODngx5eDzPw3UGPjPeDG6C7BNpGt3Qrr0imXUPgaOx2POYmmVwlEPlFl+Bx
 Gy+jyMcHjwqdbt4d1wXJOxyJ/HBW1l0k6JwbA7IVquI1uf8H3qBmG1c7d7w7pKbWo1QjfQd4F
 GaxhZqfwh7LpdZ3oyZu3jhb20wx7vyvacbmRTPqm9Hjf0fMaU0m1jvsJ4nNcPSS9eWW4kmhbm
 HOw+McR/dJxRFJ/h8lgW4X8ABzdmNkjcFpkCLXTGGSFFil3plUn+hwxf0/7qPkSLXDP0oWhZB
 OMWw3nhC+01cXVwT65AE+FR83i4FK44vn4nlDQqqVyBICMfobmHofsI0EaD+0VohREjDo/bO9
 HWEqLumDGMIGDqxTDBUGu/0OeERx6Sxw1saLURwOJiTz+YEWrgUrkFgBVR8VZSuM6ujL43Z5z
 0zxnXvS6j24KexLYzvQc5Jk0i/hZ+57eNYDscYZfkxlnQ6Rc4AuBFZ4UmtqPHYmizky2oEjXh
 4bimjTuum4CUf6cfF5ZlRBh9Q8rt5IS7OEYgvhfUWISo57uaB8=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 9:44 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> When building arm64 allyesconfig:
>
> drivers/net/ipa/ipa_endpoint.c: In function 'ipa_endpoint_stop_rx_dma':
> drivers/net/ipa/ipa_endpoint.c:1274:13: error: 'IPA_ENDPOINT_STOP_RX_SIZE' undeclared (first use in this function)
> drivers/net/ipa/ipa_endpoint.c:1274:13: note: each undeclared identifier is reported only once for each function it appears in
> drivers/net/ipa/ipa_endpoint.c:1289:2: error: implicit declaration of function 'ipa_cmd_dma_task_32b_addr_add' [-Werror=implicit-function-declaration]
> drivers/net/ipa/ipa_endpoint.c:1291:45: error: 'ENDPOINT_STOP_DMA_TIMEOUT' undeclared (first use in this function)
> drivers/net/ipa/ipa_endpoint.c: In function 'ipa_endpoint_stop':
> drivers/net/ipa/ipa_endpoint.c:1309:16: error: 'IPA_ENDPOINT_STOP_RX_RETRIES' undeclared (first use in this function)
>
> These functions were removed in a series, merged in as
> commit 33395f4a5c1b ("Merge branch 'net-ipa-kill-endpoint-stop-workaround'").
>
> Remove them again so that the build works properly.
>
> Fixes: 3793faad7b5b ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

I ran into the same issue but didn't see the solution right away. Your patch
looks good to me.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
