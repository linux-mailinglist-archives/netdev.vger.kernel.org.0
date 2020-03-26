Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A0F193D23
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 11:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgCZKmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 06:42:37 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:40399 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbgCZKmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 06:42:37 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MacWq-1jopqI041y-00c7P9 for <netdev@vger.kernel.org>; Thu, 26 Mar 2020
 11:42:36 +0100
Received: by mail-qt1-f182.google.com with SMTP id t9so4761931qto.9
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 03:42:35 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1zsH6XWB6eMi6ZlQFvZ68TF9Wxsupws/fMtQXloEvh50t/I7+d
        wYjk3kweJgoquZ32nK8hcSsUqT63kfg7gzaIxrY=
X-Google-Smtp-Source: ADFU+vuC6TwuKt78/9qQYfveGjgAznAwHP3EnWzQmrdEad+9BHqSH58APzKKGi69Q2ihSmWA4gcmkY+zheRWt9mTdU4=
X-Received: by 2002:ac8:45ce:: with SMTP id e14mr7414092qto.304.1585219354856;
 Thu, 26 Mar 2020 03:42:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200326103230.121447-1-s.chopin@alphalink.fr>
In-Reply-To: <20200326103230.121447-1-s.chopin@alphalink.fr>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 26 Mar 2020 11:42:19 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2THNOTcx=XMxXRH3RaNYBhsE7gMNx91M8p8D8qUdB-7A@mail.gmail.com>
Message-ID: <CAK8P3a2THNOTcx=XMxXRH3RaNYBhsE7gMNx91M8p8D8qUdB-7A@mail.gmail.com>
Subject: Re: [PATCH net-next] pppoe: new ioctl to extract per-channel stats
To:     Simon Chopin <s.chopin@alphalink.fr>
Cc:     Networking <netdev@vger.kernel.org>,
        Michal Ostrowski <mostrows@earthlink.net>,
        "David S . Miller" <davem@davemloft.net>,
        Guillaume Nault <gnault@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:RGzQo1S9X0nyr3tm2hj3jsVNe7r0qDR+t9AKeLctUyR39UWLK3D
 tmTekUWvuR1hZQKklsh9tgcrK9f9P3r0qIeWl67vlFPFwRZ8D/8NFaant2Ydha7wPpTCK49
 47AwUC4hIZe44y1/Tjfr6/ruWzl42ar9BrtGFS3mjdoPR82sqqEaxKvSBX53/1BBREnoNnG
 7E0ABP2BdyHBzH422kf5w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tQrST1u3uXA=:3wI7Y/0OE+ENZMDOhVgush
 uNtpFNf2yKYhKKgt18JVR9s8F+Z+Z1gX6bt7MOkPlBeSHvvZuEAoNaVDK4X/7UQZ5BMzlW87R
 POy1QSANafeDXuOiTzvpSvEub8KpcaPgbERIWdKPDnKUmKGDvXnoEonqoQFiHgxNVxlXixXym
 xkxykXtqJFeap2TjdTvmwp0sT69vPXjO8nZh33sqABBGFwDicT3nhyvv4TdYAO4nCqe6QMNIK
 qC9Sh8ONdbUEoSjtVPC7k7aC0XYOLB3RqhuI3NA7gbdfpmkd+v1kr0mN14EnxLI7acxyslVel
 ZUhnFa4Wxhot+uG+3ERjWPkBttp05b62M6ki7OTXVBN7yhICtDll39VeosZ3zGJQ6pjPwQdzs
 dbHg+AMrdW9MgL2L5M28oRpmXRYIRyNCmPfviOXXOKM6XgPixPUm3vpntAOGo7y9ZqgIRTcdv
 yCk1IewJ0MVAO/jpUYuRhTL+zVehzQ9mEyx/OpHaF2g8ekUPlOboeMODWJHMYIGQxu5TBnepf
 khEz2eW7qXl8ou6DOgA/yolJ+joq1JnRZH0OZQJcFyB65PCOVBOJJtuvkV0nkSyopT0Sa98b6
 5SLoBqGedem36/e9fL3DwPZBBzd4/ZlIgJjXovW2YGEu+EFxov4ZWq6ismQM5doxDEatmnSf4
 GLZ79FXGsUEL+seibUJ9xdzEf45xEpdyXgmNTL/mWdl4OqtP+cL4mKge0AIIv3FRl1NWW97DW
 7l3asbTztOrrYTeAv4E6GqI/bYB1AWzwmfxzNBvIpI/CbCnUhKIgi6QcEvFlkw/krkjEny2gl
 fviPQSKxj1EFsp50tv1/hd7Qnfe+yAdTM7aEay8VntvP1422b0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 11:32 AM Simon Chopin <s.chopin@alphalink.fr> wrote:
>
> The PPP subsystem uses the abstractions of channels and units, the
> latter being an aggregate of the former, exported to userspace as a
> single network interface.  As such, it keeps traffic statistics at the
> unit level, but there are no statistics on the individual channels,
> partly because most PPP units only have one channel.
>
> However, it is sometimes useful to have statistics at the channel level,
> for instance to monitor multilink PPP connections. Such statistics
> already exist for PPPoL2TP via the PPPIOCGL2TPSTATS ioctl, this patch
> introduces a very similar mechanism for PPPoE via a new
> PPPIOCGPPPOESTATS ioctl.
>
> The contents of this patch were greatly inspired by the L2TP
> implementation, many thanks to its authors.

The patch looks fine from from an interface design perspective,
but I wonder if you could use a definition that matches the
structure layout and command number for PPPIOCGL2TPSTATS
exactly, rather than a "very similar mechanism" with a subset
of the fields. You would clearly have to pass down a number of
zero fields, but the implementation could be abstracted at a
higher level later.

      Arnd
