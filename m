Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 379EB119293
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfLJU7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:59:07 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:34107 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJU7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:59:07 -0500
Received: from mail-qv1-f45.google.com ([209.85.219.45]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N6srB-1hfAhC0Qu7-018HpT; Tue, 10 Dec 2019 21:59:05 +0100
Received: by mail-qv1-f45.google.com with SMTP id b18so4776925qvo.8;
        Tue, 10 Dec 2019 12:59:04 -0800 (PST)
X-Gm-Message-State: APjAAAWqwpxGg5heSwzPP9LZKTF2cIC/4vMRdG2wYxS8ALwkky9kijvV
        I4EnoShgdRPNJ1W66NKACXewhIgTO3RzVseB2Rs=
X-Google-Smtp-Source: APXvYqxpaP4eHtfb0T1AafOuFFfZMxdK72/d9eCePNosbyemaiai5Ww7g6ZIkMFUlJlmnLpkyxwi/16JxNs8ZYi0oFM=
X-Received: by 2002:a0c:ead1:: with SMTP id y17mr29359318qvp.210.1576011543816;
 Tue, 10 Dec 2019 12:59:03 -0800 (PST)
MIME-Version: 1.0
References: <20191209151114.2410762-1-arnd@arndb.de> <20191210091905.GA3547805@kroah.com>
In-Reply-To: <20191210091905.GA3547805@kroah.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 10 Dec 2019 21:58:47 +0100
X-Gmail-Original-Message-ID: <CAK8P3a21ubUOvKKFYPbC7tqg0wPjBi7iR7ZZP0xTbvvt6=PiEw@mail.gmail.com>
Message-ID: <CAK8P3a21ubUOvKKFYPbC7tqg0wPjBi7iR7ZZP0xTbvvt6=PiEw@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: remove isdn capi drivers
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     driverdevel <devel@driverdev.osuosl.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        isdn4linux@listserv.isdn4linux.de,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:D9pUZUsP3PpPb4Icu3xX3V1NEKv9UKCFsjj64I2c7yx9hi3iJWg
 MNnd7RDoePmusu72ALj1olzxje35GQjW+l0Wcw+7NSmUlDTbezNsOOOSzWixDuFsIVn0yIV
 /PvQkl5OkQJtnWt02e6DAl+SytEzAavirDIZvAMwiCFg7N/JgfaqBD+uFA6/t0q8qk+HDHJ
 K7c+hyyPAPOZeho4hxExg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:B8OsLQgLUjE=:ErhHW6Jfi5MlFJkQjWeUVz
 UnVB6kaxJtyCPRWpKg/vzrUWGuhaaXvpQ6eXNlYosq3NDM4d3Rci0mIw2029YIZQzTXFCF79z
 ZI+2kqjNyBfK+WgM9tuR84s4pAqWlNefSiwQwNmFcnQPEOqO4OE64XbLQNSnta4ttcGTQQPiV
 hqfIgvs5ZitV876n6WrwT4KiONx+7GgSqdkT2WIM4kA/vSIOTZrkkudnrLRhRzpm3/3TPL6M6
 NEitQv59MHLv3DPf/ZMBokfyIly/NeRIhBzqSdpIoyo5XpwWcfunHzmvIfzchJYxFd3oHOJfY
 lCiPGunlQdqCwdJyFNs7y9umExwfyKedZYtYygB1qMwzUXaACONUw2zsagXMj44d0XoMMH2iO
 wBBMajtTH1k3LY7aX9nAVKr68EQMAzhKmdONbgL4L6Ldbz94LADVZbwR1C9H79vkcy5Ut8BgY
 wcUdrvfzjd+Bp81I0yXDXxAaxCWfUr8HtWJD+VInuEpszG2H0YeAq3ycCL62DbDdpQ/rQp0ar
 5aT5KoRnXDdfkDHw15bFTiRNvwyTgXNlX+0UlcNG6tF8NJSmzMbNd2aMYrtraTwtg8fKDF9uf
 RLjzplQW6Uv0JHnijvIPKVNDGy4AWw3H2blt00zJvE0kNM2f86/Q4TXYNonGf6PjEpRpwn4YH
 J2xu9ZAnKqllwoK/p/zFYFLitpItJxhjODDAchrvNroC5fLtQVo5ZsCGZJLsqwnFDykRqDt7k
 5zc4rpMPlsFQFecc/Kca841l0irautLryxcDigYFyVziBHwrnSsZfMKBZ+6rh8kfHS0oedM8q
 AB//cdAOqA4mJ9+Qc0zw1hEE1GM4qvO4omrXAArIZJ+GUnQDgy6uVRnoTH9h+/kedDscchMiz
 PspaQJd+nXa7YBHkB1uA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 10:19 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Dec 09, 2019 at 04:11:13PM +0100, Arnd Bergmann wrote:
> > As described in drivers/staging/isdn/TODO, the drivers are all
> > assumed to be unmaintained and unused now, with gigaset being the
> > last one to stop being maintained after Paul Bolle lost access
> > to an ISDN network.
> >
> > The CAPI subsystem remains for now, as it is still required by
> > bluetooth/cmtp.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  Documentation/ioctl/ioctl-number.rst        |    1 -
>
> This file is not in 5.5-rc1, what tree did you make this against?

This was against v5.4, sending a rebased version now.

      Arnd
