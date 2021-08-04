Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150EA3E000A
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 13:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237326AbhHDLTW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Aug 2021 07:19:22 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:55275 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbhHDLTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 07:19:19 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1N8oOk-1nFnPL30fW-015qOp; Wed, 04 Aug 2021 13:19:05 +0200
Received: by mail-wr1-f50.google.com with SMTP id c9so1795803wri.8;
        Wed, 04 Aug 2021 04:19:05 -0700 (PDT)
X-Gm-Message-State: AOAM531nAneJxxHbylRhiXrW36dOBMgJxREtco2XPOb97V5qFkENwKVh
        TC9EV7SuhN2W6RNnFmRhnNg4JC4Me3ARPnJF6JE=
X-Google-Smtp-Source: ABdhPJxcOne9J6k2uSSdvrG1nv5oauqkwR8eXbwGP2aDAtIw8xAZJ0g2yOgPrI4Msb6/USk4YQRzGktzDr6eUs1YRf8=
X-Received: by 2002:adf:f7c5:: with SMTP id a5mr28307602wrq.99.1628075945279;
 Wed, 04 Aug 2021 04:19:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210802145937.1155571-1-arnd@kernel.org> <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com> <20210802230921.GA13623@hoboy.vegasvil.org>
 <CAK8P3a2XjgbEkYs6R7Q3RCZMV7v90gu_v82RVfFVs-VtUzw+_w@mail.gmail.com>
 <20210803155556.GD32663@hoboy.vegasvil.org> <20210803161434.GE32663@hoboy.vegasvil.org>
 <CAK8P3a2Wt9gnO4Ts_4Jw1+qpBj8HQc50jU2szjmR8MmZL9wrgQ@mail.gmail.com>
 <CO1PR11MB50892EAF3C871F6934B85852D6F09@CO1PR11MB5089.namprd11.prod.outlook.com>
 <CAK8P3a06enZOf=XyZ+zcAwBczv41UuCTz+=0FMf2gBz1_cOnZQ@mail.gmail.com>
In-Reply-To: <CAK8P3a06enZOf=XyZ+zcAwBczv41UuCTz+=0FMf2gBz1_cOnZQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 4 Aug 2021 13:18:48 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2=pLt9iwE1xw5yhk=DA_i5HLsf5q94GQ2BCG48rS45jQ@mail.gmail.com>
Message-ID: <CAK8P3a2=pLt9iwE1xw5yhk=DA_i5HLsf5q94GQ2BCG48rS45jQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK dependencies
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yangbo Lu <yangbo.lu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:2C0s8y2+wI7zT8RjmWu65pqoSCbqCc0/bMWmECZkUjwh5Xe532W
 SvHDe0ccf6AkrhGkkIfn7YvBepfyM2zhRnFq6jFlmO6J7T8+FKFaPj6Z3lGOTo8f52Y5l6R
 +QGbwGO4cBEdHnSLHCSX5IjNDlFGPwPb4gcnpVJ6x1JUWeSpWPSKrDE89ry21tItrT4+XRu
 ffB+siELLoChDJW7F9IBw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:7m5kR69SaVU=:TrXKws7lzG5kLpvkh9jvvs
 rykZ9ip8uC5TGGIgu3HKvTIl7Kx3phowm/Ap8hSBlvRW5bNSh+YnN9VSjLnUjYAp1gulwkKdW
 pY2F7W1homDM6l5nMvou+FCj1fDTfkZQtOOxS2v+aHWR62l0jFmu7CjRQj1bOBJTfegUVvR21
 jdSJHfp/Gl8N+2UQqaWOYIzbYw7+KmPeYW2l1vUvIhKWqQAHiV8P42qqfttvCIcWzvuJCFJJx
 nL5/4quc10I5gTEcvA3uprXwi920eJBAx+iqUvfQN7C3RPZ4j+VIZ0CB8KgSBqL9jnQ/Pa55T
 T/KpTxfjbzsCJbJu/97BFBTU4nT5jFN7MK+JHRFDc/F5DieMN5bpX/ak1Mm1vqRXIcYZEJrne
 CX7C2+XbBxpxase2hATwSe0bPA35OEg9qdMgkal2toowFCxuEdMjO1VLfXoZQv3tigeP8bSg3
 c/4Juc/UY9W+NZKhGtpB490gdpPGYfx8elzcjjLb9Q2/0ilQXNnuakj0dAGg8JHWT8DWhhTER
 Dh7vzB60mA0DDsmTE7LeORxHBsND8G2u8i7le0hHzC9qE9QMKyPq/RtyC3tb6pV/9WcCnRkRk
 no8G3VHUsLuARN1pjBaNelBNP0sM0z7rUor74wCEqvMJ/uot/t9zNENSTQKYFqD9ktpv+6GjM
 EYAo9ZcFPz8TzTzst/EP4d8+oFCJc79l1E4n/vIGZQuzdicN3Rvrlwlb9eugsQNZF7NlTMubA
 psaJe4F0i4UWQguFuzqnSa9ttYpWL/HUrYTHmowY2UFrFr47T4fDR2MvCItDNa+QSNzy1tecn
 oX7E02LMbFp1r5IwsXMGb34eA6KaINR8YHKQYCJqwkrWEDNiue5f11EMKfhhOck6GKds1yT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 8:27 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Tue, Aug 3, 2021 at 7:19 PM Keller, Jacob E <jacob.e.keller@intel.com> wrote:
> > > On Tue, Aug 3, 2021 at 6:14 PM Richard Cochran <richardcochran@gmail.com> wrote:
>
> > There is an alternative solution to fixing the imply keyword:
> >
> > Make the drivers use it properly by *actually* conditionally enabling the feature only when IS_REACHABLE, i.e. fix ice so that it uses IS_REACHABLE instead of IS_ENABLED, and so that its stub implementation in ice_ptp.h actually just silently does nothing but returns 0 to tell the rest of the driver things are fine.
>
> I would consider IS_REACHABLE() part of the problem, not the solution, it makes
> things magically build, but then surprises users at runtime when they do not get
> the intended behavior.

Case in point: two patches from Yangbo Lu that call into the ptp core
from built-in
network code look like they could never have worked with CONFIG_PTP_1588_CLOCK,
but did not cause a link failure because of the IS_REACHABLE() check, see
commit d7c088265588 ("net: socket: support hardware timestamp conversion to
PHC bound") and c156174a6707 ("ethtool: add a new command for getting PHC
virtual clocks").

I found that by testing my patch that turns the IS_REACHABLE() back into
IS_ENABLED() and got

aarch64-linux-ld: net/socket.o: in function `__sock_recv_timestamp':
socket.c:(.text+0x1f20): undefined reference to `ptp_convert_timestamp'
aarch64-linux-ld: net/ethtool/common.o: in function `ethtool_get_phc_vclocks':
common.c:(.text+0x35c): undefined reference to `ptp_get_vclocks_index'

I added a workaround to my patch now to keep it working as before, but this
needs to be fixed properly. The easiest way would be to no longer support
modular PTP at all as Richard would like to do anyway, but I have not
attempted other fixes.

       Arnd
