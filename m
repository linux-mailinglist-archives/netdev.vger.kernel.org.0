Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC5E1A2AA5
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 22:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgDHUuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 16:50:08 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:54063 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbgDHUuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 16:50:08 -0400
Received: from mail-qt1-f178.google.com ([209.85.160.178]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MRn0U-1jjxYa1Qni-00TASI; Wed, 08 Apr 2020 22:50:06 +0200
Received: by mail-qt1-f178.google.com with SMTP id z90so755393qtd.10;
        Wed, 08 Apr 2020 13:50:05 -0700 (PDT)
X-Gm-Message-State: AGi0PuYSte0JCTfSv334dYLgt146dhcHbnZFs1fjjw/q07PHpKtg65KW
        TvjKchHvC767o4ppNWAkIV472zaYw57qMUMU/24=
X-Google-Smtp-Source: APiQypIP5yghqg/2MrWIAF2lP5PX73f0nNW4IRcRHBZR7UjH98P/p+NK0Mdk7nj6cOkNVhU/171r9JSmuzucI6UHA5Q=
X-Received: by 2002:ac8:12c2:: with SMTP id b2mr1560498qtj.7.1586379004961;
 Wed, 08 Apr 2020 13:50:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200408202711.1198966-1-arnd@arndb.de> <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
In-Reply-To: <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 8 Apr 2020 22:49:48 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com>
Message-ID: <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
To:     Nicolas Pitre <nico@fluxnic.net>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:Kc+e7gOBMBy4fgliV8+wTzDtBqkiekso8uwFk7zpl+8KOTV8+lX
 Ap1gmqRHFqlreu2JMKQibxZMLFg41DngvaRlbUp6bQ6HqHzNitKK6BAF17eRnVOzM+83oLR
 kdeMOO12t6SMt3u23iWu+r2JcMbLG35L2VIQNh1nfC7TKStTWi7e0AGrUEbXygGI1vJ5uPX
 4/AwJwq+3OpoQaCQiU3SA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:WPSVnHxAXP4=:WKy5dFAMgXMpgCWnVu65UZ
 QteWtKeojy14W0LmkgFTYQNlRL3eFXMl5aNJfxb/6OduNcFchA0paC7RAF/5V9qt/6yb+1rzi
 bHhU5mgLaOtgXHe+5YxLh4+XEOGHcuyVFZ1EgXhAro4wpzkTq5WZBtkWAJ2PzGw03LAXyjcJc
 cU944pFKMJzVuDc610M9KLSRtCOo2IftlKgcbUDdo+cOSBKor+r1cuAJkaJ1x3cFM9coDS6Jq
 jNZIz8EY3dx8nC6+9po6QN2vfIATPB9RO5e2fKeG0n3uWb5KWjV8yGS5jxxZx6/+8P/P32t2J
 M9tQmsUv5v+xdkrGrhmybW6qj+5g4ZFq4gKur5GE8AAhttBuQ2W00H2ZM6H+v8wf9SlyB6r/s
 g8VhW9DBF+O66BPTw4KUTKJ7AxlcSEgQ57+3HqgJFgVJllXM9+FlHIgVy3MUeZB+nQ+1475cK
 ZPYtLUnMbbRL9v55b+U/u7OOVAv9VxGLhild8wmli/zy+RU9SR2yMriJQ7iBdZbimMS+o75Uk
 oXA0npHY/vMi5T3LGN3OvH39aPng3rFMX/MtT7RJ8OjoM3qAmtkdF45vTCOOv0gFTG/rwS0J+
 HYX6fgc0NRfHWfxNgscRPgmzOv8CTbkUhex8KVxGLSDmt9Bwu5dHuQ1JSYO1zWP7abKxETagu
 paICl+4hQhFkZMyaShonq+2mkwRrPMxpynSZ2XTTypcip+noEfaVfTclpHkZjf9y20JrwAAy+
 tIrvDlgfM+zweorIIew+RnF6pGfndYFAoidP+I7letj/8BWi91/7mVJ2VmDmBFEkLAPWlIegC
 EMQYXagKpFV0ujNNzMFDCVfVafkkcWo78uIHnbIow74iR9ZtxQ=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 10:38 PM Nicolas Pitre <nico@fluxnic.net> wrote:
> On Wed, 8 Apr 2020, Arnd Bergmann wrote:
> > I have created workarounds for the Kconfig files, which now stop using
> > imply and do something else in each case. I don't know whether there was
> > a bug in the kconfig changes that has led to allowing configurations that
> > were not meant to be legal even with the new semantics, or if the Kconfig
> > files have simply become incorrect now and the tool works as expected.
>
> In most cases it is the code that has to be fixed. It typically does:
>
>         if (IS_ENABLED(CONFIG_FOO))
>                 foo_init();
>
> Where it should rather do:
>
>         if (IS_REACHABLE(CONFIG_FOO))
>                 foo_init();
>
> A couple of such patches have been produced and queued in their
> respective trees already.

I try to use IS_REACHABLE() only as a last resort, as it tends to
confuse users when a subsystem is built as a module and already
loaded but something relying on that subsystem does not use it.

In the six patches I made, I had to use IS_REACHABLE() once,
for the others I tended to use a Kconfig dependency like

'depends on FOO || FOO=n'

which avoids the case that IS_REACHABLE() works around badly.

I did come up with the IS_REACHABLE() macro originally, but that
doesn't mean I think it's a good idea to use it liberally ;-)

      Arnd
