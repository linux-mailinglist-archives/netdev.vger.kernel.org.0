Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F65D155C9D
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgBGRIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:08:20 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:57065 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgBGRIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:08:20 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MN5W7-1jGPTj1UO5-00J5cC; Fri, 07 Feb 2020 18:08:18 +0100
Received: by mail-lj1-f174.google.com with SMTP id d10so42636ljl.9;
        Fri, 07 Feb 2020 09:08:18 -0800 (PST)
X-Gm-Message-State: APjAAAVG+HQjcCudOoMKOtklYFVo0H2f2va+Q5TUdse1BQZJvhZ/4iRd
        HBxOuhz1sy5wNEtN/aj4CSLlJr1jINKtQ5Uxxqg=
X-Google-Smtp-Source: APXvYqw9u3WcxbpVw6rO3j9Ozu9XMB+H2m1FoTnlA7ltWTv2RF4oTSzNzORrzx5UZNelPR7iZjN33BiBam2VYEndX7Q=
X-Received: by 2002:a2e:5056:: with SMTP id v22mr142178ljd.164.1581095297786;
 Fri, 07 Feb 2020 09:08:17 -0800 (PST)
MIME-Version: 1.0
References: <20200203095325.24c3ab1c@cakuba.hsd1.ca.comcast.net>
 <C11859E1-BE71-494F-81E2-9B27E27E60EE@xenosoft.de> <87tv441gg1.fsf@mpe.ellerman.id.au>
 <42888ad2-71e0-6d03-ddff-3de6f0ee5d43@xenosoft.de>
In-Reply-To: <42888ad2-71e0-6d03-ddff-3de6f0ee5d43@xenosoft.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 7 Feb 2020 17:08:06 +0000
X-Gmail-Original-Message-ID: <CAK8P3a39L5i4aEbKe9CiW6unbioL=T8GqXC007mXxUu+_j84FA@mail.gmail.com>
Message-ID: <CAK8P3a39L5i4aEbKe9CiW6unbioL=T8GqXC007mXxUu+_j84FA@mail.gmail.com>
Subject: Re: Latest Git kernel: avahi-daemon[2410]: ioctl(): Inappropriate
 ioctl for device
To:     Christian Zigotzky <chzigotzky@xenosoft.de>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        DTML <devicetree@vger.kernel.org>,
        Darren Stevens <darren@stevens-zone.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@ozlabs.org, "contact@a-eon.com" <contact@a-eon.com>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>, Christoph Hellwig <hch@lst.de>,
        mad skateman <madskateman@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Christian Zigotzky <info@xenosoft.de>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:v2NzRURWLNpNd5Vze0NOfOG4ZOZI6pKd6oWf7SO7mXuEZ0uoq11
 KIi7GIY9VO6IemzyHMrVkk3L/+sEJALYga7ggOoqu41gIyuPangzZ85ag2fGOYOLXfj/V3B
 KM6ZABN5SojVwgP5IyTRC4koA0GQgVTFfleZnoZsj4VbZZ7kh94akKt2pa29f1yTbXEs452
 +cxQF9hCDz6ciVAl4ia9Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:16TBwXtvMN0=:qj5wbBvyRHNYDWfCZ3BwpA
 qStdA9EFKDLUeL/ZGWvDz3mniWDrTvEBPhJtQeL4qy4I94TEOIYFuC2MVyZkVHqYLw7u78Cqt
 oUIM/FNGMD7OMxizSxJpRCUebYacCpHVdGA/ZDCoUZIji0ijFQj2FiHsKIqKAoJFuVAOVZwX1
 ukZ1z2S9FWHJxzOfTgBOLWdgkNIiTjLRqTJi+ofrTBaEghh2ApLBgT3ro2aU21Nw8/6jMJ5nr
 AKAdr29Mk8Pu5FWZYUUvSKHgyhcTknjtn+LzUv6TiCYA96rm7vn+yofxCZFK51BQ85SAWObdx
 WggGIUnZYkcJWmRvZcMA7zeuWgqBfsLV+0dAgJtz+ls6WBtQkOxT/MGksnJJ1u1OMi4wa4+cY
 DN2gjHIX0uHWJ/Aw16Hi3BhMLwp2vpFyKxJ4tUdGWC3I5xR0AR3HZ0DcUnBabmiHCpw8Qj+9A
 3Epyj6TjxJKbvGvnrJKH84SW/12CgsyKsMi50gP2+2x4bFSXtFuRQmm/sm+om5wBxGn/bxSUc
 q0tCu5ptcBcD6M+tq3H2UiFb+9FvrYnDEJNVltp533eKm+NrR4CuuryA51DzWu/wW1o2TFzoG
 05GEfPMRwlR5yFfgZ/4CNIeN0wOueVJZIu2K1mQXq8oUZ1gt5bobybPl05+abGodTrqZRYUW7
 yB97MwPfdj6GA82JJ8jETSqnFeMvY6zk8HCcKjz+Nyl3y67qTgJg/hwx6Z3PNcGgV9MGdI/cD
 CzvbKtaDGXpKZBx7iAQxr5wasH69V0xCge4Zn/fexNjse+iD38J+9CcWuTYX/pN08DLBtSdsc
 EJtiJltwArGHWfypdLLs2zJolInjMeNS+sq6kivFpOn4tbiPdw=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 7, 2020 at 3:34 PM Christian Zigotzky
<chzigotzky@xenosoft.de> wrote:
>
> Hello Arnd,
>
> We regularly compile and test Linux kernels every day during the merge
> window. Since Thursday last week we have very high CPU usage because of
> the avahi daemon on our desktop Linux systems (Ubuntu, Debian etc). The
> avahi daemon produces a lot of the following log message. This generates
> high CPU usage.
>
> Error message: avahi-daemon[2410]: ioctl(): Inappropriate ioctl for device
>
> strace /usr/sbin/avahi-daemon:
>

Thanks a lot for the detailed analysis, with this I immediately saw
what went wrong in my
original commit and I sent you a fix. Please test to ensure that this
correctly addresses
the problem.

        Arnd
