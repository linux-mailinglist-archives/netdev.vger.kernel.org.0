Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A89C1CA982
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 13:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgEHLZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 07:25:32 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:53715 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgEHLZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 07:25:31 -0400
Received: from mail-qv1-f51.google.com ([209.85.219.51]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MLQl3-1jop8E0tIB-00IQOB; Fri, 08 May 2020 13:25:29 +0200
Received: by mail-qv1-f51.google.com with SMTP id h6so530757qvz.8;
        Fri, 08 May 2020 04:25:28 -0700 (PDT)
X-Gm-Message-State: AGi0PualJxPnxEKPSgGwLsW/QiwEv3yAoSye8KoQz66n2fv0mYwpEjpf
        an56zmcaw6DmuMbPL+1ZP9mWwUcoahSu3pyR/+0=
X-Google-Smtp-Source: APiQypKP7zSjz563Q47ftI8vSMTS44GtpXWK8IqV4snmbCtzxnXEyx+F4Gu3Bvc4WC6wp9pjrwFUD39xIhs1aUhY1bc=
X-Received: by 2002:a0c:e781:: with SMTP id x1mr2425587qvn.4.1588937127849;
 Fri, 08 May 2020 04:25:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200508095914.20509-1-grygorii.strashko@ti.com>
 <CAK8P3a0qfFzJGya-Ydst8dwC8d7wydfNG-4Ef9zkycEd8WLOCA@mail.gmail.com> <7df7a64c-f564-b0cc-9100-93c9e417c2fc@ti.com>
In-Reply-To: <7df7a64c-f564-b0cc-9100-93c9e417c2fc@ti.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 8 May 2020 13:25:11 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0-6vRpHJugnUFhNNAALmqx4CUW9ffTOojxu5a80tAQTw@mail.gmail.com>
Message-ID: <CAK8P3a0-6vRpHJugnUFhNNAALmqx4CUW9ffTOojxu5a80tAQTw@mail.gmail.com>
Subject: Re: [PATCH net v3] net: ethernet: ti: fix build and remove
 TI_CPTS_MOD workaround
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Clay McClure <clay@daemons.net>, Dan Murphy <dmurphy@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:XZd2NI9K9woe7pS7VYePjL3/1sBMIWIWN3C1EZIKq2jfpUZOG/a
 mUqNE2/PA/CLCnjefd/KgSZNVQuzbUX9tLZb5OaphUVB+xs+NCaSTbRCcnAG4CSSIuBtd2N
 S/+2DI3mr4FH0huzMz0uyJsQa3eBS0jnBxsoZ1KXwcxWpeL4FzcMBtSI7ZiOYBrTU9D9Cwa
 uPazwMgzWzZIMlc7X1iNA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:77m6WKCYY70=:G7Ex5rkPFtdKiHJHnpDwH0
 jbbAkDxOou9b3jh0zqHpCdFmrYFlIo73nJWSJmWc/dsfZa8EOPAaYjzJ6vS7K0wBD3TDRMTGl
 6DbBhj7d1/9bBStJ6SMr6dvRco9BbUnMozr3oSWmN54GYYsd0Kd2zH44FmGjw69QlEkiH3jPy
 t71uXHPVfdEtocmRy7vhtJZi8PFWcTHKNWUYCqKWfzCad4hO5jtTyfgdKIbMW//V+f0qQN1Mh
 W08tpjxp/9qWTp+8wmdbvWAcKDpvDpmvYXHEhj2//6rEDkCMJHs6Vm/nxurvT6qySUnUHBNLO
 bQIEDktrq3CrIgv2HMkn3/tOlypPTneNGUDhkeDynA5BMH71CDb7TEbsZIKsXJdGP+uGj5Qnj
 Lc76Z68U+DYKD09Pb3T1Xeh/qiKrY2lEnN80c/MjrZouEX10RNmtYuex07qDFMpETLR1jTX/b
 acAfwzdqLmIlTTCScCXwBp9pDBV2im8cXL3VZNHUQ1zp9oj8NNUjv5HPwsz2uUtVEs2M1+9hd
 7YaGeiU7ZUKbER5azRIqFJRicDMDlj0s7EpwRhj66s9d2f7vn+/1xPkVWxgu7kBZNEkk7TBlN
 fQFPQt8ZA+fRQhzBY4g3IL4aDrpje5tQovkUY0MH2OkhZQu0YGr/Whp/JLvFEa5zGrEp4svCT
 4ts3QxGBjAxOFkO+s6FA1vVkCm8xzr/FPCVZ5NcEFf3d2eyyf6p1LFCOqDshF+dS/USjmYT29
 KtV/LN3rYqC0DKaMZD+o3ltbX3VvGFWRqQbvd1ijgHpi5TJ9eXwjOBHHtcYzBHZfu+bpILQgH
 xeP6AoLdaBzenh4DSwgjr+Ppd3kPevRfSCxuS4S+CusKE4Zd50=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 1:14 PM Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> On 08/05/2020 13:10, Arnd Bergmann wrote:
> > On Fri, May 8, 2020 at 11:59 AM Grygorii Strashko

> >> That's because TI_CPTS_MOD (which is the symbol gating the _compilation_ of
> >> cpts.c) now depends on PTP_1588_CLOCK, and so is not enabled in these
> >> configurations, but TI_CPTS (which is the symbol gating _calls_ to the cpts
> >> functions) _is_ enabled. So we end up compiling calls to functions that
> >> don't exist, resulting in the linker errors.
> >>
> >> This patch fixes build errors and restores previous behavior by:
> >>   - ensure PTP_1588_CLOCK=y in TI specific configs and CPTS will be built
> >>   - use IS_REACHABLE(CONFIG_TI_CPTS) in code instead of IS_ENABLED()
> >
> > I don't understand what IS_REACHABLE() is needed for once all the other
> > changes are in place. I'd hope we can avoid that. Do you still see
> > failures without
> > that or is it just a precaution. I can do some randconfig testing on your patch
> > to see what else might be needed to avoid IS_REACHABLE().
>
> I've not changed this part of original patch, but seems you're right.
>
> I can drop it and resend, but, unfortunately, i do not have time today for full build testing.

I have applied to patch locally to my randconfig tree, with the IS_REACHABLE()
changes taken out.

> By the way in ptp_clock_kernel.h
> #if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)

This should also be changed I think, but it can wait for another day.

      Arnd
