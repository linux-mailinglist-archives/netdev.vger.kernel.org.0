Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B371ADF627
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 21:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387401AbfJUTkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 15:40:17 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:55405 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387394AbfJUTkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 15:40:17 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1M1YlB-1iK9cy2UZf-0036fo; Mon, 21 Oct 2019 21:40:15 +0200
Received: by mail-qk1-f170.google.com with SMTP id f18so13270557qkm.1;
        Mon, 21 Oct 2019 12:40:15 -0700 (PDT)
X-Gm-Message-State: APjAAAW6O2stIxmiT3XHipLkkygH6FKdQbrCR8E9x0yZW2vYm0repa3g
        eLuITuZa9p+mahU009lJEpV/i+6ASDMxPgR1wic=
X-Google-Smtp-Source: APXvYqxdREhPMNq3Hj/hmWoaovXx6TMUq6d8s20yFnIwk6900ufyhMjnMph2e0AWm2lpV+wYLkj4FI2Tiuqz0h+Wlg0=
X-Received: by 2002:a37:db0a:: with SMTP id e10mr23631832qki.3.1571686814233;
 Mon, 21 Oct 2019 12:40:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190731155057.23035-1-johannes@sipsolutions.net>
In-Reply-To: <20190731155057.23035-1-johannes@sipsolutions.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 21 Oct 2019 21:39:58 +0200
X-Gmail-Original-Message-ID: <CAK8P3a10Gz_aDaOKBDtoPyaUc-OuCmn2buY4+GHHdWERnU+jrg@mail.gmail.com>
Message-ID: <CAK8P3a10Gz_aDaOKBDtoPyaUc-OuCmn2buY4+GHHdWERnU+jrg@mail.gmail.com>
Subject: Re: pull-request: mac80211-next 2019-07-31
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Crispin <john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:raTexEeV7vHFaqRcd846Wpo1pjaZLmKzXHipHMcVjep2FDyTMDW
 L3pBGkp2D9llM+4+LgNI4hNEkcWWIEBkdRlwZEBg3qzlxL/077KQh9C4Fj6BR9rZYFsM5SV
 9qyWodVQTNJTSa1+m6pcYlUNQ7QWQYtN5LLOYAbqNbAeOOeeDYqZTDR8h3VRb4qW8LaRtHe
 8gn7HOcPWbZ9YbcbRpMKQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PZO+prq3e3Y=:6Mm/XEEULHQIX9IgKYH1LK
 VvUb/Xc46Ej/q6ZdTf14q8ouXjZzIIWA+dPIXuuj774QdoAmChRn7oyrM50mEM6c34vEZT1a1
 UBQ3IgJUC6iJHBwXJv9vLcsvMnlBT9k0wz9dwY/DV6EyYQ8KR4EPDncxZFSWnjTuWMz6bTirD
 2MP6f7w+M3EMlFtgeYAcT4wVpf22ftIG1iuNrjy1uHT0r4Funwfd8jjpsnvbhk6RBDfYtSb4F
 uSgN1Is4he4UmVNRpnwCmOnrwSSSpDbdtyPsJVB5ZSZcnFvsyeC8tgzyA1KA7JXr7ZPOesnIO
 QgKmJY5XP0WAzaMrvb+FSVwQXYCFZmOhE/9Ph38LESoKcXFOyNXf3TXVhrOUQiaJLr2FKnoBx
 cIXMPLyh99v1uoYMoDS7V1hBpft8LxtKt3f+xNPxaPKXltASMQ+r5yX5ZUTty9kihJYxp9ivc
 ycrVpXgr8nM1xDlYwEWXIIoehaQj+7Z6GF5ngRcV/J9QE1ONXyNN5A26cmvH7moXcRj5Xuk29
 pShouszJgz4rRf9CTPqefCPC87BoQyKaGEyqkPykWt4clW5xSrNSFC1iP9VVT6HaG+FgjvScS
 99M44oBX0vu1fV1zGGfZCJjXTPLUsRtDi2OtBBR/yPjxGT3O21Qe2t3PdEfCCuPOzvwxyT3Jt
 ozWWR1qOyLzs2on62q5staX00sMwqbHQ4QeKn+8LO8bVa1wt1q7MPo6CpBEFIBtQrPrQUbF+Q
 TuwUIu3/JohRbg0KaYXfmjAIQfNaJaEvvxNtTOD8kRKjMLDrvWZme3qjREijqmnvfsL+2Mbii
 MLBriSCWDozoQPnBOcvmy163PJLM5HA6kKYfpcfx+8qf1vGgAMDcxW3bTTttwlIHtAM+gqMnL
 fUBQ6mOgTX39wa3W1LYg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 5:53 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> John Crispin (10):
>       mac80211: add support for parsing ADDBA_EXT IEs
>       mac80211: add xmit rate to struct ieee80211_tx_status
>       mac80211: propagate struct ieee80211_tx_status into ieee80211_tx_monitor()
>       mac80211: add struct ieee80211_tx_status support to ieee80211_add_tx_radiotap_header
>       mac80211: HE: add Spatial Reuse element parsing support

Hi Johannes and John,

It looks like one of the last additions pushed the stack usage over
the 1024 byte limit
for 32-bit architectures:

net/mac80211/mlme.c:4063:6: error: stack frame size of 1032 bytes in
function 'ieee80211_sta_rx_queued_mgmt' [-Werror,-Wframe-larger-than=]

struct ieee802_11_elems is fairly large, and just grew another two pointers.
When ieee80211_rx_mgmt_assoc_resp() and ieee80211_assoc_success()
are inlined into ieee80211_sta_rx_queued_mgmt(), there are three copies
of this structure, which is slightly too much.

Marking any of those functions as __noinline_for_stack would shut up the
warning but not fix the underlying issue. Silencing the warning might
be enough if there is a fairly short call chain leading up to
ieee80211_sta_rx_queued_mgmt(). Another option would be a dynamic
allocation.

Thoughts?

      Arnd
