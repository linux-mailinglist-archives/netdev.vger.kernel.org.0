Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EA41CDBB0
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbgEKNrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:47:40 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:53475 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgEKNrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 09:47:39 -0400
Received: from mail-qk1-f173.google.com ([209.85.222.173]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MryOx-1imib90FpV-00nwE1; Mon, 11 May 2020 15:47:38 +0200
Received: by mail-qk1-f173.google.com with SMTP id f83so9698474qke.13;
        Mon, 11 May 2020 06:47:37 -0700 (PDT)
X-Gm-Message-State: AGi0PubghKdF/fHMp1Ks/ApJH40MMIaxLu5kLyHsulx9Xkky5F32L+S1
        LM6qieHI5zdYi1m2qi8nI40vwtFFcnc2ilv8BOY=
X-Google-Smtp-Source: APiQypKAmn8UHB9s5fZFUEek8MrcF9YGNPQ+XRrD/RRIOUQTXBl4yaQtpyq7H+rrJXTAzdartJwHwlybaBPVbygbULs=
X-Received: by 2002:a37:4e08:: with SMTP id c8mr15521244qkb.286.1589204856778;
 Mon, 11 May 2020 06:47:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200509120707.188595-1-arnd@arndb.de> <20200509154818.GB27779@embeddedor>
 <87zhae4r35.fsf@kamboji.qca.qualcomm.com> <CAK8P3a2i-jqY8FnY_Tu41VDxQGqHHKRCyJ5U-GQbNmrqa=n0GQ@mail.gmail.com>
 <87mu6e4nyy.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87mu6e4nyy.fsf@kamboji.qca.qualcomm.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 11 May 2020 15:47:20 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2Qu6Byo5bddd1ECwRB1qiTXpYuV55_i_2CUw+J5zqtfQ@mail.gmail.com>
Message-ID: <CAK8P3a2Qu6Byo5bddd1ECwRB1qiTXpYuV55_i_2CUw+J5zqtfQ@mail.gmail.com>
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
X-Provags-ID: V03:K1:MKjPNguouTEMyLxjBKPiXJxXBXcv5XmWF2wWncSdO+Ls+e4MC/q
 sVv7tRKRKVPsdHdIYWu+wJviSYN47FNRK9ZLH3zL/vC99sn/+wj3kE47Rn17PObekmNhyP0
 CrkhfME1SfeohBr43HYTC1L4qpwpVzXH6UiA4pji/Rfi/XkdwfR6coBSoYElIz1VRZC9Vaq
 tEhWWZz+3O3B/m9ZvAAmw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:YLdioIYStU8=:KZPxhPlE+ofsSyL7xUutOw
 T0S5YN/ziwK1R/tYL0z7K3DDY6fcsZcku8dxH0mRJn8sA3YVe8tB9wAjTB1kbMhG5nhPY2yw4
 4LqsP9/3C8uoWS7xl6PhMItU0hRCMa2TXSQdmJVy8dYSq/j142RfVdQHQ+aOFlcC39EPj9fhy
 Xwh1pe4bxyIL0u9eyHUE9w67YNwOjOUujnDUvXLcIf3K2legvPLGeKr142prNArGcg7qjK9tF
 PbxSzcQ7HFX1NB9SfbVsmE9BjMURlUp/srH6d9deditwXV6pb2K6IMV1XAuJIKTCIhzohdxmu
 PLhNZG/GOYUeG/vZqklsyITCWW+S23W4xCOxOrUxl8pbBJhhlfU01l+hrXG4ZYnZL8mjn92LB
 sNz7Cy4pz4aIrMtxIcl89DmFqjzqAl71Ry9S8OYseNB1ByDHI/poCLPkH7W/X9E3WhnkJkx3y
 LV23DyC+OmV7SYTor7s+VvsL6MAjzY3XSJ010JhFFPXgBwzfhdubIsJs77sjxeC6W0C9NZo4k
 SKCKoD6lCpQ1bpfHPkNUQoSOfNMokc0wPoizY+tlToTNM/oDRzacAmutWDIgpBBBQjkH3M2GI
 VJ1sWwt0dm2lMsv9vgkS4fPZauYjEhVlrsXcid+AoZvSm4pzEV+lR5833bYdq8GH2QQn932Rf
 O6+idd2Vw4K0CN+vJmw3GR3NhwAqZhrA96MUuqtUR/r7HVaUzOjzpWnMBScdLokZebiVFUULR
 x1E/ceT3lyRck12qEQ3CT3A4Kvu91ehrBBHYJiZcCVoc/DJUZT329OVRALfqkKi70Ff/3UvSR
 1aWm1AehRRBwtLiYOSpNoZYfu/e25f/aEEWu45ON6hnyCU7Pts=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 3:10 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Arnd Bergmann <arnd@arndb.de> writes:
>
> > On Mon, May 11, 2020 at 2:03 PM Kalle Valo <kvalo@codeaurora.org> wrote:
> >> "Gustavo A. R. Silva" <gustavoars@kernel.org> writes:
> >
> >> >
> >> > This treewide patch no longer contains changes for ath10k. I removed them
> >> > since Monday (05/04/2020). So, this "Fixes" tag does not apply.
> >
> > Oops, I forgot to update the changelog trext when rebasing.
> >
> >> Ok, I'll remove it. Also I'll take these to my ath.git tree, not to
> >> net-next.
> >
> > Thanks a lot!
>
> Weird, I had a conflict with this patch but couldn't figure out why.
> Anyway, I fixed it in my pending branch and please double check:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=c3e5221f3c3ddabc76a33ff08440ff1dc664998d

Looks good to me. It may have been an artifact on my side, as I
have applied and later reverted Gustavo's patch on the same branch.

     Arnd
