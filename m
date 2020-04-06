Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5770919F69A
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgDFNPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 09:15:39 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:38139 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbgDFNPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:15:39 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MQ5jC-1jhWor11UG-00M5t0; Mon, 06 Apr 2020 15:15:37 +0200
Received: by mail-qt1-f177.google.com with SMTP id z12so12722257qtq.5;
        Mon, 06 Apr 2020 06:15:36 -0700 (PDT)
X-Gm-Message-State: AGi0Pua2eAG1q45ORCf6QKN97fvEUVaM7Wev7gS2YJmZ0T9alRSZaIZi
        R4JJNha7ZUvzZ/aX35KjJt1OgusXw2ULcuV+tLs=
X-Google-Smtp-Source: APiQypLa5L7CKwlGZNhn/7xAjUoLc+7MSyvfCvi3f7raJ3Pm4QCoa8xTD4iijCH0Ufx8gGRQ4K6mPgVfCzePn/2MrKM=
X-Received: by 2002:ac8:12c2:: with SMTP id b2mr379999qtj.7.1586178935967;
 Mon, 06 Apr 2020 06:15:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200406121233.109889-1-mst@redhat.com> <20200406121233.109889-3-mst@redhat.com>
 <CAK8P3a1nce31itwMKbmXoNZh-Y68m3GX_WwzNiaBuk280VFh-Q@mail.gmail.com> <20200406085707-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200406085707-mutt-send-email-mst@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 6 Apr 2020 15:15:20 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1=-rhiMyAh6=6EwhxSmNnYaXR9NWhh+ZGh4Hh=U_gEuA@mail.gmail.com>
Message-ID: <CAK8P3a1=-rhiMyAh6=6EwhxSmNnYaXR9NWhh+ZGh4Hh=U_gEuA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] vhost: disable for OABI
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "christophe.lyon@st.com" <christophe.lyon@st.com>,
        kbuild test robot <lkp@intel.com>,
        "daniel.santos@pobox.com" <daniel.santos@pobox.com>,
        Jason Wang <jasowang@redhat.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Richard Earnshaw <Richard.Earnshaw@arm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:eOGOvwDewauxKWRDEnPVWf5EDRque1mRx2tHK0CCdFO0/T32fwP
 jQxBIk34uZzQ7k0wZY9g7R6UAVBvVBoNL+NRz4LOpAzBJW2wCckUPV7qamp0ue6eB0pUspg
 3UXQ6e6bHEE2DxDKEs0sO3N+fBI6+DSdtvT41xtgUjlDuUz7CVo2Z/Pae6+0WHakBg7Ogfl
 e8IT7NxxG1cWjOQfuzsbg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gaqzuPgItbY=:jaYoCVrNlG+E/xXN6wtuV9
 Rgr9tN6wO1eoGvuqdCKp6NpLQZ2+EGfqLrCAMueSpYtXG1wN1SFECQjyRnMKmGNTfwnYgf3KU
 iBhD+x8zSHx0TcWMWI5RC0S3zlMAsm+IVkBYVm+tiS+wSomaLyLUDQIH91Cp3+WTGlOfL1zQG
 fOJKCYEPgK/tMLMpDUlgzR7Cs32AqVHgc16H2YxRwLXfpVCjnvDqOqZ4dLyEAqtN9tCJg/b/R
 p9pMzwhNhS1bU29LJl7FGn4xYmzb+dnibbtVHWXPNev5nEyB3ns8Mh4cLXnqH0AWSI+ACp5zC
 HmImnZQ66T+arEi2xTygH3/hcf4o+dv3fXphtmfZ/1l6S+CUAHsAPYnWxmv7N57l34iYJ/sT8
 SJG0gdCUXTugCcxdBAZ3Cdc3tuE1mPcjybDUJywymi43O6oz47itN1Nzwzlr1h15CeNuBvyu2
 +jflbl4ytueSdoSRseYrKjZK8EPVX/0uF6gaj2tVGUMHGXhJ3PDdIzDlVim0d/99swoocQTln
 Ai9/gxkHFiykCyFZ9q/uAfojsm+MjOQvjzAMpbHuqoJllpXfME0xd1tWym54uHXRXx9TTFFI9
 wBrys2OmuEeOQapioghOCg+P5ffo0CNsHC7Fe+8pLYuy8PeHhVLwfuGLssYjDErmrNnJakEk8
 x+0JptYnpqteN3hhi3raMJ0hRy4/m3bMrSXL0LbBYQoGjYzW4PD3HiU9Yk4buGOOrxYWYJB0N
 XznDa0FlrlCxswh88MnolbyPhqWwQfMbJZr5izyFqHBBc6bAJ0jHpNMfISjcGS1D/2rYZN0xt
 3ULwwPOas6WUlQX4L2JTF3llMtlf6dAxkxYvlq1Hj59slx4Lis=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 3:02 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Apr 06, 2020 at 02:50:32PM +0200, Arnd Bergmann wrote:
> > On Mon, Apr 6, 2020 at 2:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > >
> > > +config VHOST_DPN
> > > +       bool "VHOST dependencies"
> > > +       depends on !ARM || AEABI
> > > +       default y
> > > +       help
> > > +         Anything selecting VHOST or VHOST_RING must depend on VHOST_DPN.
> > > +         This excludes the deprecated ARM ABI since that forces a 4 byte
> > > +         alignment on all structs - incompatible with virtio spec requirements.
> > > +
> >
> > This should not be a user-visible option, so just make this 'def_bool
> > !ARM || AEABI'
> >
>
> I like keeping some kind of hint around for when one tries to understand
> why is a specific symbol visible.

I meant you should remove the "VHOST dependencies" prompt, not the
help text, which is certainly useful here. You can also use the three lines

     bool
     depends on !ARM || AEABI
     default y

in front of the help text, but those are equivalent to the one-line version
I suggested.

     Arnd
