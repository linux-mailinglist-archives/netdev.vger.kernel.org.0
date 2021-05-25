Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B52B38FC79
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 10:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhEYIRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 04:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbhEYIRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 04:17:13 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14397C061756
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 01:15:43 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g24so16352386pji.4
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 01:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VSOmN8vpjaX/z35OXF1bxLuubUtd57bZng4619wbR0Y=;
        b=n90pA4TW89iTjszb8q6zIjsQNno5vsrxL/do39F4V/WNx0CzxJ6IDk3RPyZm8c5S3V
         wkBA0bxJcVucO2W81dm9Dv8/op/nwlscQSLM+NeDvtq7qlhUyWmyfkjqXo0j06kWNC/y
         bz7Sh4EumGlen9e2EG/59JaP/Ih2NgaRVSQKtwqrKxoy2PO8rk3k8XRJSx+q09+B2Sk2
         Dc9Vx5wg3PP0erOS9xSx/6DX7OujoCx4/xozXCcIE2wWjIdOj5MXPfSyKv78nnYwjmbq
         gKq51jynmh8yKFcwA7fovJNWMsCexTnt5hiyZO4RPXxi7jzKQrtrFtf64L4dkzAh/T+c
         kWIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VSOmN8vpjaX/z35OXF1bxLuubUtd57bZng4619wbR0Y=;
        b=EXAQL4Xf+9SH4ygEKKfrpTe/uaH6+zMCj2hkZBJ/UU38yjIrmCWN/Plm470qcxcXLj
         Cqe/wLJvIeL6FfhB54JrpYWXUNgFvik0X3BOpCsUo7aqlw/KrXDARaK3Ke2euGI1TAiy
         BpyIK1fNNnS9b3Ya+UtFgL/+FhznncMolzdSeiKfPASbzfedasO4TtuaPJaFatAFoqKC
         pcHNdT8xUogkgU1M87ldPX/l7hrBaoJ3PP97m9Dgr1KybNb+eeD0Txm8BJi1122d85kQ
         gmL2bJ3AUsOStes0r1HUyMhR6KBI6whW2LhErat8svRSaZ52MasMrF/hhrkyZfTJoEMQ
         bFRA==
X-Gm-Message-State: AOAM532swVZfV2gaHz3anEvh96o3cqiuwgVxfqsetIpuy3bV5uo1LLi7
        jmX0HR1IcpDlDqbecxfqSMkpzpHMeczn5LqAVjjwqQ==
X-Google-Smtp-Source: ABdhPJwp5uQJT1a070FBhP7oXJdr2zrGdRBSQQ/8mDUrvvqUpBD0jItxzDcGgIR7K2cLQpQL6JLeEXnM0yDnv99Ufds=
X-Received: by 2002:a17:90a:c096:: with SMTP id o22mr3603930pjs.231.1621930542472;
 Tue, 25 May 2021 01:15:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210520140158.10132-1-m.chetan.kumar@intel.com>
 <20210520140158.10132-16-m.chetan.kumar@intel.com> <CAMZdPi-Xs00vMq-im_wHnNE5XkhXU1-mOgrNbGnExPbHYAL-rw@mail.gmail.com>
 <90f93c17164a4d8299d17a02b1f15bfa@intel.com>
In-Reply-To: <90f93c17164a4d8299d17a02b1f15bfa@intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 25 May 2021 10:24:00 +0200
Message-ID: <CAMZdPi_VbLcbVA34Bb3uBGDsDCkN0GjP4HmHUbX95PF9skwe2Q@mail.gmail.com>
Subject: Re: [PATCH V3 15/16] net: iosm: net driver
To:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        linuxwwan <linuxwwan@intel.com>, Dan Williams <dcbw@redhat.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chetan,

On Mon, 24 May 2021 at 12:36, Kumar, M Chetan <m.chetan.kumar@intel.com> wr=
ote:
>
> Hi Loic,
>
> > > +static void ipc_netdev_setup(struct net_device *dev) {}
> > > +
> > > +struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct
> > > +device *dev) {
> > > +       static const struct net_device_ops iosm_wwandev_ops =3D {};
> > > +       struct iosm_wwan *ipc_wwan;
> > > +       struct net_device *netdev;
> > > +
> > > +       netdev =3D alloc_netdev(sizeof(*ipc_wwan), "wwan%d",
> > NET_NAME_ENUM,
> > > +                             ipc_netdev_setup);
> > > +
> > > +       if (!netdev)
> > > +               return NULL;
> > > +
> > > +       ipc_wwan =3D netdev_priv(netdev);
> > > +
> > > +       ipc_wwan->dev =3D dev;
> > > +       ipc_wwan->netdev =3D netdev;
> > > +       ipc_wwan->is_registered =3D false;
> > > +
> > > +       ipc_wwan->ipc_imem =3D ipc_imem;
> > > +
> > > +       mutex_init(&ipc_wwan->if_mutex);
> > > +
> > > +       /* allocate random ethernet address */
> > > +       eth_random_addr(netdev->dev_addr);
> > > +       netdev->addr_assign_type =3D NET_ADDR_RANDOM;
> > > +
> > > +       netdev->netdev_ops =3D &iosm_wwandev_ops;
> > > +       netdev->flags |=3D IFF_NOARP;
> > > +
> > > +       SET_NETDEV_DEVTYPE(netdev, &wwan_type);
> > > +
> > > +       if (register_netdev(netdev)) {
> > > +               dev_err(ipc_wwan->dev, "register_netdev failed");
> > > +               goto reg_fail;
> > > +       }
> >
> > So you register a no-op netdev which is only used to represent the mode=
m
> > instance, and to be referenced for link creation over IOSM rtnetlinks?
>
> That=E2=80=99s correct driver creates wwan0 (no-op netdev) to represent t=
he
> modem instance and is referenced for link creation over IOSM rtnetlinks.
>
> > The new WWAN framework creates a logical WWAN device instance (e.g;
> > /sys/class/wwan0), I think it would make sense to use its index as para=
meter
> > when creating the new links, instead of relying on this dummy netdev. N=
ote
> > that for now the wwan_device is private to wwan_core and created implic=
itly
> > on the WWAN control port registration.
>
> In order to use WWAN device instance any additional changes required insi=
de
> wwan_core ?  Or simply passing /sys/class/wwan0 device to ip link add is =
enough.

So basically the rtnetlink ops would be implemented and define in
wwan_core, as "wwan" link  type.
Allowing users to create a new WWAN link/context whatever the
underlying hardware is. We could therefore pass the WWAN device name
or index to e.g:
ip link add wwan0.1 type wwan hw wwan0 session 1

> Can you please share us more details on wwan_core changes(if any)/how we =
should
> use /sys/class/wwan0 for link creation ?

Well, move rtnetlink ops to wwan_core (or wwan_rtnetlink), and parse
netlink parameters into the wwan core. Add support for registering
`wwan_ops`, something like:
wwan_register_ops(wwan_ops *ops, struct device *wwan_root_device)

The ops could be basically:
struct wwan_ops {
    int (*add_intf)(struct device *wwan_root_device, const char *name,
struct wwan_intf_params *params);
    int (*del_intf) ...
}

Then you could implement your own ops in iosm, with ios_add_intf()
allocating and registering the netdev as you already do.
struct wwan_intf_params would contain parameters of the interface,
like the session_id (and possibly extended later with others, like
checksum offload, etc...).

What do you think?

>
> > Moreover I wonder if it could also be possible to create a generic WWAN=
 link
> > type instead of creating yet-another hw specific one, that could benefi=
t
> > future WWAN drivers, and simplify user side integration, with a common
> > interface to create links and multiplex PDN (a bit like wlan vif).
>
> Common interface could benefit both wwan drivers and user side integratio=
n.
> WWAN framework generalizes WWAN device control port, would it also consid=
er
> WWAN netdev part ? Is there a plan to support such implementation inside
> wwan_core.

I also plan to submit a change to add a wwan_register_netdevice()
function (similarly to WiFi cfg80211_register_netdevice), that could
be used instead of register_netdevice(), basically factorizing wwan
netdev registration (add "wwan" dev_type, add sysfs link to the 'wwan'
device...).

Regards,
Loic
