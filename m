Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6158290472
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 13:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406924AbgJPLz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 07:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405122AbgJPLz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 07:55:26 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71A7C061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 04:55:25 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id w25so1247391vsk.9
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 04:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SsBIR3dvaDHQ902c3OEzYsauqWLqJtVfaaprWeq67qQ=;
        b=ztCGwyttV6ILTkzUSbC/kl0Qoc70NUKpuzd2TtG+zixnssKL5XXWDDBZ6VIu63L7fT
         KrvtukVMPdL7oSDor6ieoMDilEsOm3qFWHrawKqLLMUqP/5yiB8GRrxBUvUigklgYnaG
         VONDu89Hp9GWmOePfff/CwpMnWG78JVt9hViaxHWhSMC8ZHzBhnXghk6WKU+kQk9AQeQ
         m44I8f9EGlwMTML9BFL0UL8xrSLkHQFLQhsq8MRtrT31TgKEQTNDpGleQNzIlDGGlXVs
         kh1IF5AnIBZ2697Ed+rxRyneYYcZmidVemYQn68F5LJwwYjDz4lS2a7y0x3pPk1bw33J
         R7pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SsBIR3dvaDHQ902c3OEzYsauqWLqJtVfaaprWeq67qQ=;
        b=IXqpWUtgu6XBwll/PYnhV57ln0KKGc751FSmJas+mAFmqxnToDP5s0iAx6sYF0vY5B
         Jhn2KI0sN8kuoTTBt23Flf0iV1TuRIH4uSmm4O6NAoprPBnTHwvCUCa/aY7q8lx5Ssi0
         5Mwd3AzyaJ4KDhuugxHa7ldm1R3HQvXRF/LT5Qoe6ksWuUf8vO8TvSLIaHh09zqvsWB8
         V4TEeO1VFJMkjDz9kix9h64Y5oxJ8kCNhIxw8WAw2tIw5dz66dHKXYnANJ9uzUsGZdgq
         AYJLMhNoanu6ZdVZrBBomkD9Ve6RYNAKh+05AOsJUxiepnj1Nlthpynt2cayzsPZQ4FN
         pCYw==
X-Gm-Message-State: AOAM533CkpTzmADbY31QXizhYAJm6uqD3f/cb3aAmTBOZmeQAsKEcxXB
        qjOXyc4NWfvu8quB0b5y58gv1sdJ/uCpBq6z2GpUWA==
X-Google-Smtp-Source: ABdhPJyeYjE+8eamILtS1pokBl5vFazdX2HSavvELgO98C6wDqKlcBKSz+b4lYCJM39oW1Ee51+NCV37XT3kR1P6R5g=
X-Received: by 2002:a67:6c86:: with SMTP id h128mr1531354vsc.42.1602849324804;
 Fri, 16 Oct 2020 04:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <20201012104648.985256-1-Jerome.Pouiller@silabs.com>
 <2628294.9EgBEFZmRI@pc-42> <20201014124334.lgx53qvtgkmfkepc@pali> <2444203.ROLCPKctRj@pc-42>
In-Reply-To: <2444203.ROLCPKctRj@pc-42>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 16 Oct 2020 13:54:48 +0200
Message-ID: <CAPDyKFqCn386r4ecLDnMQmxrAZCvU9r=-eY71UUNpXWNxKOz2g@mail.gmail.com>
Subject: Re: [PATCH 07/23] wfx: add bus_sdio.c
To:     =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>
Cc:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 at 16:03, J=C3=A9r=C3=B4me Pouiller
<jerome.pouiller@silabs.com> wrote:
>
> On Wednesday 14 October 2020 14:43:34 CEST Pali Roh=C3=A1r wrote:
> > On Wednesday 14 October 2020 13:52:15 J=C3=A9r=C3=B4me Pouiller wrote:
> > > On Tuesday 13 October 2020 22:11:56 CEST Pali Roh=C3=A1r wrote:
> > > > On Monday 12 October 2020 12:46:32 Jerome Pouiller wrote:
> > > > > +#define SDIO_VENDOR_ID_SILABS        0x0000
> > > > > +#define SDIO_DEVICE_ID_SILABS_WF200  0x1000
> > > > > +static const struct sdio_device_id wfx_sdio_ids[] =3D {
> > > > > +     { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_=
WF200) },
> > > >
> > > > Please move ids into common include file include/linux/mmc/sdio_ids=
.h
> > > > where are all SDIO ids. Now all drivers have ids defined in that fi=
le.
> > > >
> > > > > +     // FIXME: ignore VID/PID and only rely on device tree
> > > > > +     // { SDIO_DEVICE(SDIO_ANY_ID, SDIO_ANY_ID) },
> > > >
> > > > What is the reason for ignoring vendor and device ids?
> > >
> > > The device has a particularity, its VID/PID is 0000:1000 (as you can =
see
> > > above). This value is weird. The risk of collision with another devic=
e is
> > > high.
> >
> > Those ids looks strange. You are from Silabs, can you check internally
> > in Silabs if ids are really correct? And which sdio vendor id you in
> > Silabs got assigned for your products?
>
> I confirm these ids are the ones burned in the WF200. We have to deal wit=
h
> that :( .

Yep. Unfortunately this isn't so uncommon when targeting the embedded
types of devices.

The good thing is, that we already have bindings allowing us to specify thi=
s.

>
>
> > I know that sdio devices with multiple functions may have different sdi=
o
> > vendor/device id particular function and in common CIS (function 0).
> >
> > Could not be a problem that on one place is vendor/device id correct an=
d
> > on other place is that strange value?
> >
> > I have sent following patch (now part of upstream kernel) which exports
> > these ids to userspace:
> > https://lore.kernel.org/linux-mmc/20200527110858.17504-2-pali@kernel.or=
g/T/#u
> >
> > Also for debugging ids and information about sdio cards, I sent another
> > patch which export additional data:
> > https://lore.kernel.org/linux-mmc/20200727133837.19086-1-pali@kernel.or=
g/T/#u
> >
> > Could you try them and look at /sys/class/mmc_host/ attribute outputs?
>
> Here is:
>
>     # cd /sys/class/mmc_host/ && grep -r . mmc1/
>     mmc1/power/runtime_suspended_time:0
>     grep: mmc1/power/autosuspend_delay_ms: Input/output error
>     mmc1/power/runtime_active_time:0
>     mmc1/power/control:auto
>     mmc1/power/runtime_status:unsupported
>     mmc1/mmc1:0001/vendor:0x0000
>     mmc1/mmc1:0001/rca:0x0001
>     mmc1/mmc1:0001/device:0x1000
>     mmc1/mmc1:0001/mmc1:0001:1/vendor:0x0000
>     mmc1/mmc1:0001/mmc1:0001:1/device:0x1000
>     grep: mmc1/mmc1:0001/mmc1:0001:1/info4: No data available
>     mmc1/mmc1:0001/mmc1:0001:1/power/runtime_suspended_time:0
>     grep: mmc1/mmc1:0001/mmc1:0001:1/power/autosuspend_delay_ms: Input/ou=
tput error
>     mmc1/mmc1:0001/mmc1:0001:1/power/runtime_active_time:0
>     mmc1/mmc1:0001/mmc1:0001:1/power/control:auto
>     mmc1/mmc1:0001/mmc1:0001:1/power/runtime_status:unsupported
>     mmc1/mmc1:0001/mmc1:0001:1/class:0x00
>     grep: mmc1/mmc1:0001/mmc1:0001:1/info2: No data available
>     mmc1/mmc1:0001/mmc1:0001:1/modalias:sdio:c00v0000d1000
>     mmc1/mmc1:0001/mmc1:0001:1/revision:0.0
>     mmc1/mmc1:0001/mmc1:0001:1/uevent:OF_NAME=3Dmmc
>     mmc1/mmc1:0001/mmc1:0001:1/uevent:OF_FULLNAME=3D/soc/sdhci@7e300000/m=
mc@1
>     mmc1/mmc1:0001/mmc1:0001:1/uevent:OF_COMPATIBLE_0=3Dsilabs,wfx-sdio
>     mmc1/mmc1:0001/mmc1:0001:1/uevent:OF_COMPATIBLE_N=3D1
>     mmc1/mmc1:0001/mmc1:0001:1/uevent:SDIO_CLASS=3D00
>     mmc1/mmc1:0001/mmc1:0001:1/uevent:SDIO_ID=3D0000:1000
>     mmc1/mmc1:0001/mmc1:0001:1/uevent:SDIO_REVISION=3D0.0
>     mmc1/mmc1:0001/mmc1:0001:1/uevent:MODALIAS=3Dsdio:c00v0000d1000
>     grep: mmc1/mmc1:0001/mmc1:0001:1/info3: No data available
>     grep: mmc1/mmc1:0001/mmc1:0001:1/info1: No data available
>     mmc1/mmc1:0001/ocr:0x00200000
>     grep: mmc1/mmc1:0001/info4: No data available
>     mmc1/mmc1:0001/power/runtime_suspended_time:0
>     grep: mmc1/mmc1:0001/power/autosuspend_delay_ms: Input/output error
>     mmc1/mmc1:0001/power/runtime_active_time:0
>     mmc1/mmc1:0001/power/control:auto
>     mmc1/mmc1:0001/power/runtime_status:unsupported
>     grep: mmc1/mmc1:0001/info2: No data available
>     mmc1/mmc1:0001/type:SDIO
>     mmc1/mmc1:0001/revision:0.0
>     mmc1/mmc1:0001/uevent:MMC_TYPE=3DSDIO
>     mmc1/mmc1:0001/uevent:SDIO_ID=3D0000:1000
>     mmc1/mmc1:0001/uevent:SDIO_REVISION=3D0.0
>     grep: mmc1/mmc1:0001/info3: No data available
>     grep: mmc1/mmc1:0001/info1: No data available
>
>

Please have a look at the
Documentation/devicetree/bindings/mmc/mmc-controller.yaml, there you
find that from a child node of the mmc host's node, we can specify an
embedded SDIO functional device.

In sdio_add_func(), which calls sdio_set_of_node() - we assign the
func->dev.of_node its corresponding child node for the SDIO func.
Allowing the sdio functional driver to be matched with the SDIO func
device.

Perhaps what is missing, is that we may want to avoid probing an
in-correct sdio driver, based upon buggy SDIO ids. I don't think we
take some actions in the mmc core to prevent this, but maybe it's not
a big problem anyway.

When it comes to documenting the buggy SDIO ids, please add some
information about this in the common SDIO headers. It's nice to have a
that information, if any issue comes up later on.

Kind regards
Uffe
