Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B094A1BC485
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgD1QIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:08:05 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:33041 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgD1QIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 12:08:04 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1M5jA2-1jWCs42Tuc-007Cf0; Tue, 28 Apr 2020 18:08:02 +0200
Received: by mail-lj1-f175.google.com with SMTP id a21so19183214ljj.11;
        Tue, 28 Apr 2020 09:08:02 -0700 (PDT)
X-Gm-Message-State: AGi0PuYUOq8MazV62YikamNGZturQV6nlt5i3hO8MfsD2yuKeVw4ewn3
        NGxFx/7XQFE6fJ8ZJfRXL1ovW8jFIIjnTshtb3w=
X-Google-Smtp-Source: APiQypLjCfbDbry068u6vxlKzJcflxkRwat6fVOMH+US4GAHbh3y8PTlg2fnsUbpMYOK7K8IFz3FdB+JzQ7CtznK4ww=
X-Received: by 2002:a2e:9842:: with SMTP id e2mr18192759ljj.273.1588090082023;
 Tue, 28 Apr 2020 09:08:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200428090749.31983-1-clay@daemons.net> <CAMuHMdXhVcp3j4Sq_4fsqavw1eH_DksN-yjajqC_8pRKnjM0zA@mail.gmail.com>
In-Reply-To: <CAMuHMdXhVcp3j4Sq_4fsqavw1eH_DksN-yjajqC_8pRKnjM0zA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 28 Apr 2020 18:07:45 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2rG-A6_qhU9vrcadZqq2r1FdCDFMVPhSzPEAO83WrA9A@mail.gmail.com>
Message-ID: <CAK8P3a2rG-A6_qhU9vrcadZqq2r1FdCDFMVPhSzPEAO83WrA9A@mail.gmail.com>
Subject: Re: [PATCH] net: Select PTP_1588_CLOCK in PTP-specific drivers
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Clay McClure <clay@daemons.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Mao Wenan <maowenan@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Josh Triplett <josh@joshtriplett.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:0+QGPAJgYT3AuDOXDuVZJl/GVgCZgUasWRfsVnr299ZBPU/ljYb
 D+6RnzTUco8WKSxZrl8LG/I6sxC6tymAcmrsXDiRAbXBSshjWnBi6aE1rgS43X//maObXf+
 tGeoWKE4AFzuWLJilDDjTtgv1E0wWK+xRFcObkL99zh96Lg0gMQLFHQFxUSUsZR98rI4eth
 KWGdOBCZ3js9P2oUJFDhQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9tMlXwbHIIM=:f4pYF/VEBIk2lgG50JAJBL
 JDgJdURDuCSysbBHbL6Nb51b9W8tKMI9QwL0iInii9UjPSz6jxR6l3AGQ6VB7G/ua8plt6LHm
 yItS9u3LeIVBGEXjGca4eOts4KC3GFPORTJ4fM7er8K9OlsGl6b9UP1572d7hfWJajq2Tln+w
 ULzQghg55dOQ/OezWrNcw7J3ourdvXvbenoT1bceeXwKvgEW0/qPoqU3yehv+g3oiA4CBCKLD
 VbL8+RohFue2XbVf4b6nG9MlAxVStmh0jSHdwFBR+4V2UAwKglYSOFXFZjLiAAFFAOzqylzHF
 HKeTSwIRXmzXN2YkOFMGn+DVr78pTCS+ZdiwJtJLy7tv+M9+xNDbUr1PrGjzneXDhFfdaWJv2
 irvgBwn2Y1frZet7EMqC7iCiG0Ju2lUg8g8gnumdQeW2T+EmxEMePg3PRBGQAQMNvxz2TWXy6
 32px6aMvC29SwWFg7SB5hPCm+YeFGVO7AT3B2mWuv2sdxDLD3Zdusv3sxZbyazP7CWCItcQLE
 rf4v4FscJeY3gT7QgDp0trYTHArsrZB38qHs0CLYxoj8Z1XB6BP62v4hK6pb7xSQedOEFAMRh
 5cRGpWf5Ye1YeC691YG/SU5a3P9PZyGhGhVEJkctIb0nP3AFiqSZjfiRhDnvPbwTOr2+MuNda
 7IRj+hg8MnND0aA2hLg7Im/7xSrLLxD+5Xvnh91wPSs6njH/30dQ/y5Jc8WlIuWIn2u+PdQxb
 4Do+WHN/+Whs2HjZzDj/aPyPX9MdmA+fP2F9JVet729tbFqvv9x2Tvk7hLHZRgdq4Z0tNEPSL
 q4X7tDeQtBt0Spvkl0+xFT7EnVt92FhlPWd9MMgPQbUCMQbfNY=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:21 AM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, Apr 28, 2020 at 11:14 AM Clay McClure <clay@daemons.net> wrote:
> > Commit d1cbfd771ce8 ("ptp_clock: Allow for it to be optional") changed
> > all PTP-capable Ethernet drivers from `select PTP_1588_CLOCK` to `imply
> > PTP_1588_CLOCK`, "in order to break the hard dependency between the PTP
> > clock subsystem and ethernet drivers capable of being clock providers."
> > As a result it is possible to build PTP-capable Ethernet drivers without
> > the PTP subsystem by deselecting PTP_1588_CLOCK. Drivers are required to
> > handle the missing dependency gracefully.
> >
> > Some PTP-capable Ethernet drivers (e.g., TI_CPSW) factor their PTP code
> > out into separate drivers (e.g., TI_CPTS_MOD). The above commit also
> > changed these PTP-specific drivers to `imply PTP_1588_CLOCK`, making it
> > possible to build them without the PTP subsystem. But as Grygorii
> > Strashko noted in [1]:
> >
> > On Wed, Apr 22, 2020 at 02:16:11PM +0300, Grygorii Strashko wrote:
> >
> > > Another question is that CPTS completely nonfunctional in this case and
> > > it was never expected that somebody will even try to use/run such
> > > configuration (except for random build purposes).
> >
> > In my view, enabling a PTP-specific driver without the PTP subsystem is
> > a configuration error made possible by the above commit. Kconfig should
> > not allow users to create a configuration with missing dependencies that
> > results in "completely nonfunctional" drivers.
> >
> > I audited all network drivers that call ptp_clock_register() and found
> > six that look like PTP-specific drivers that are likely nonfunctional
> > without PTP_1588_CLOCK:
> >
> >     NET_DSA_MV88E6XXX_PTP
> >     NET_DSA_SJA1105_PTP
> >     MACB_USE_HWSTAMP
> >     CAVIUM_PTP
> >     TI_CPTS_MOD
> >     PTP_1588_CLOCK_IXP46X
> >
> > Note how they all reference PTP or timestamping in their name; this is a
> > clue that they depend on PTP_1588_CLOCK.
> >
> > Change these drivers back [2] to `select PTP_1588_CLOCK`. Note that this
> > requires also selecting POSIX_TIMERS, a transitive dependency of
> > PTP_1588_CLOCK.
>
> If these drivers have a hard dependency on PTP_1588_CLOCK, IMHO they
> should depend on PTP_1588_CLOCK, not select PTP_1588_CLOCK.

Agreed. Note that for drivers that only optionally use the PTP_1588_CLOCK
support, we probably want 'depends on PTP_1588_CLOCK ||
!PTP_1588_CLOCK' (or the syntax replacing it eventually), to avoid the
case where a built-in driver fails to use a modular ptp implementation.

     Arnd
