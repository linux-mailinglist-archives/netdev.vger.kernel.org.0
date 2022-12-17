Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4410864F85F
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 10:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiLQJBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 04:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiLQJBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 04:01:39 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675A81B9E0
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 01:01:37 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id x22so11181229ejs.11
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 01:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vK0TZW6SYzMO8GJcX0vIR6Bw0LJNQhztjdVIUby5uwE=;
        b=aRaARTQBZZZuk/VU/VusJZClWP8dWJEDi2BZR+u7kcvHQ2/ZMwU9eccWdiOuI/YuG+
         HbNez89BIhShn6BnL2PELxiELE8GxiaadQNdweXW06UtO0T+EigIitWp+GDnWl4eG5lQ
         H6ERgsa5vQcQ4DRgZTuW5VYr9lwRd4E6WnMxc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vK0TZW6SYzMO8GJcX0vIR6Bw0LJNQhztjdVIUby5uwE=;
        b=7iEhejf8oV7Dz0zbsIWxDJe7DJAr/aXaVwsetkTAo8nALsT60pQQFl2qXqtSHsXqOP
         7565Dhcb0r3hkOQ0bTA7L7Q4VVMPgk7gMqONKQJwnGk0Fhao4k5yuMwFrRW5O0yJdz8w
         t8m82kbpksqNv7mYS7vHMd0QhTgUTMp5NbJh/d420PFgqPZZ2EacE0XeKvMa4gtOh3vD
         HNCq5/0xlpzMBJt3+k5Oo80UjwMHO02qJJiiKOgBj3guamSDNR0gtFn6lsllO0G3xfLE
         bJj7v4pATM87TdZXDwlzDs8q7AFBrWJD70sR0J5y5e23Pd3+bGGUo+CO8LkWGAAPyqwA
         dGKw==
X-Gm-Message-State: ANoB5pmvYURdSKCNQwiUTCABlezYbRXmIAZirbP4sR+35xuNa7w18ibA
        aG2jMv39uZym01+98k5L2wmgRseYCY6xxeC86TwSSw==
X-Google-Smtp-Source: AA0mqf6cg0tsIZBexBusYHjO1PwoPuvESDbdCXGNxJo3TpNxUNUoxiYf5E/awJEDfFRWdgm4ftoUS2ZS9QGvRqlTqr8=
X-Received: by 2002:a17:906:8383:b0:7c1:19ea:dda with SMTP id
 p3-20020a170906838300b007c119ea0ddamr8603728ejx.31.1671267695782; Sat, 17 Dec
 2022 01:01:35 -0800 (PST)
MIME-Version: 1.0
References: <20220414110838.883074566@linuxfoundation.org> <CA+G9fYvgzFW7sMZVdw5r970QNNg4OK8=pbQV0kDfbOX-rXu5Rw@mail.gmail.com>
 <CA+G9fYscMP+DTzaQGw1p-KxyhPi0JB64ABDu_aNSU0r+_VgBHg@mail.gmail.com>
 <165094019509.1648.12340115187043043420@noble.neil.brown.name>
 <Y5y5n8JoGZNt1otY@panicking> <332A0C50-D53E-4C86-9795-6238C961C869@hammerspace.com>
In-Reply-To: <332A0C50-D53E-4C86-9795-6238C961C869@hammerspace.com>
From:   Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Date:   Sat, 17 Dec 2022 10:01:24 +0100
Message-ID: <CAOf5uwmVrH6nwkp1fb+WAS0XR=hm4XoQfHZK=OyGLFajMHtnRw@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/338] 4.19.238-rc1 review
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     Neil Brown <neilb@suse.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
        "slade@sladewatkins.com" <slade@sladewatkins.com>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Anna Schumaker <anna.schumaker@netapp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On Fri, Dec 16, 2022 at 10:25 PM Trond Myklebust
<trondmy@hammerspace.com> wrote:
>
>
>
> > On Dec 16, 2022, at 13:31, Michael Trimarchi <michael@amarulasolutions.=
com> wrote:
> >
> > [You don't often get email from michael@amarulasolutions.com. Learn why=
 this is important at https://aka.ms/LearnAboutSenderIdentification ]
> >
> > Hi Neil
> >
> > On Tue, Apr 26, 2022 at 12:29:55PM +1000, NeilBrown wrote:
> >> On Thu, 21 Apr 2022, Naresh Kamboju wrote:
> >>> On Mon, 18 Apr 2022 at 14:09, Naresh Kamboju <naresh.kamboju@linaro.o=
rg> wrote:
> >>>>
> >>>> On Thu, 14 Apr 2022 at 18:45, Greg Kroah-Hartman
> >>>> <gregkh@linuxfoundation.org> wrote:
> >>>>>
> >>>>> This is the start of the stable review cycle for the 4.19.238 relea=
se.
> >>>>> There are 338 patches in this series, all will be posted as a respo=
nse
> >>>>> to this one.  If anyone has any issues with these being applied, pl=
ease
> >>>>> let me know.
> >>>>>
> >>>>> Responses should be made by Sat, 16 Apr 2022 11:07:54 +0000.
> >>>>> Anything received after that time might be too late.
> >>>>>
> >>>>> The whole patch series can be found in one patch at:
> >>>>>        https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/p=
atch-4.19.238-rc1.gz
> >>>>> or in the git tree and branch at:
> >>>>>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-s=
table-rc.git linux-4.19.y
> >>>>> and the diffstat can be found below.
> >>>>>
> >>>>> thanks,
> >>>>>
> >>>>> greg k-h
> >>>>
> >>>>
> >>>> Following kernel warning noticed on arm64 Juno-r2 while booting
> >>>> stable-rc 4.19.238. Here is the full test log link [1].
> >>>>
> >>>> [    0.000000] Booting Linux on physical CPU 0x0000000100 [0x410fd03=
3]
> >>>> [    0.000000] Linux version 4.19.238 (tuxmake@tuxmake) (gcc version
> >>>> 11.2.0 (Debian 11.2.0-18)) #1 SMP PREEMPT @1650206156
> >>>> [    0.000000] Machine model: ARM Juno development board (r2)
> >>>> <trim>
> >>>> [   18.499895] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>> [   18.504172] WARNING: inconsistent lock state
> >>>> [   18.508451] 4.19.238 #1 Not tainted
> >>>> [   18.511944] --------------------------------
> >>>> [   18.516222] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> >>>> [   18.522242] kworker/u12:3/60 [HC0[0]:SC0[0]:HE1:SE1] takes:
> >>>> [   18.527826] (____ptrval____)
> >>>> (&(&xprt->transport_lock)->rlock){+.?.}, at: xprt_destroy+0x70/0xe0
> >>>> [   18.536648] {IN-SOFTIRQ-W} state was registered at:
> >>>> [   18.541543]   lock_acquire+0xc8/0x23c
> >>
> >> Prior to Linux 5.3, ->transport_lock needs spin_lock_bh() and
> >> spin_unlock_bh().
> >>
> >
> > We get the same deadlock or similar one and we think that
> > can be connected to this thread on 4.19.243. For us is a bit
> > difficult to hit but we are going to apply this change
> >
> > net: sunrpc: Fix deadlock in xprt_destroy
> >
> > Prior to Linux 5.3, ->transport_lock needs spin_lock_bh() and
> > spin_unlock_bh().
> >
> > Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> > ---
> > net/sunrpc/xprt.c | 4 ++--
> > 1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
> > index d05fa7c36d00..b1abf4848bbc 100644
> > --- a/net/sunrpc/xprt.c
> > +++ b/net/sunrpc/xprt.c
> > @@ -1550,9 +1550,9 @@ static void xprt_destroy(struct rpc_xprt *xprt)
> >         * is cleared.  We use ->transport_lock to ensure the mod_timer(=
)
> >         * can only run *before* del_time_sync(), never after.
> >         */
> > -       spin_lock(&xprt->transport_lock);
> > +       spin_lock_bh(&xprt->transport_lock);
> >        del_timer_sync(&xprt->timer);
> > -       spin_unlock(&xprt->transport_lock);
> > +       spin_unlock_bh(&xprt->transport_lock);
> >
> >        /*
> >         * Destroy sockets etc from the system workqueue so they can
> > =E2=80=94
>
> Agreed. When backporting to kernels that are older than 5.3.x, the transp=
ort lock needs to be taken using the bh-safe spin lock variants.
>
> Reviewed-by: Trond Myklebust <trond.myklebust@hammerspace.com <mailto:tro=
nd.myklebust@hammerspace.com>>
>

Seems already applied, but for some reason I miss it. I will re-align
to stable again

Michael

> _________________________________
> Trond Myklebust
> Linux NFS client maintainer, Hammerspace
> trond.myklebust@hammerspace.com
>


--=20
Michael Nazzareno Trimarchi
Co-Founder & Chief Executive Officer
M. +39 347 913 2170
michael@amarulasolutions.com
__________________________________

Amarula Solutions BV
Joop Geesinkweg 125, 1114 AB, Amsterdam, NL
T. +31 (0)85 111 9172
info@amarulasolutions.com
www.amarulasolutions.com
