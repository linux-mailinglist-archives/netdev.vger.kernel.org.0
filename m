Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DAC2637D3
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 22:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgIIUup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 16:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgIIUun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 16:50:43 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EBAC061573;
        Wed,  9 Sep 2020 13:50:42 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 16so3864047qkf.4;
        Wed, 09 Sep 2020 13:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=n1Ap85CGsZgV7Q88vgw7iUzU/rBKHft361Qv/p9ScyU=;
        b=ohAYRfO73/nYiKOSeXGf+FSuZTi47knyPzrNf4MnKW4AkVkoNdDishnOKbEdvghFxD
         ywkbk+Ad9hg2QMb63G0BtkAsyED6kIStsLQKljyHaX7Dcdll0IRMvoxltMEd+gwiNLKN
         dsqMMT7MaP3RAY8SSx4pyKr/7GH7L/UjAzDH4HrZn/4Dq6Rd27VW7DGm4JV3ITBW2ss9
         ufuCYIxsUUzV9/Jl5rnAP0fuf/PJggBZNFkXjGctUoqgoLOqX0LzvSMmwWrXDA0UfPhn
         l0k5K+zvCxGhXVuFUuu+B2frFKjq3l8aQMPPJVqATJ+JPxEG9T+jNdcB9UMNggk4ezHF
         mWkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n1Ap85CGsZgV7Q88vgw7iUzU/rBKHft361Qv/p9ScyU=;
        b=NIwbSyj1/TzJtYGcu/z3vzCDuGsASW/1T3F+yPuOlTSEW6As4ESPUA1jc6PHPzsBd3
         NHLNplcujzme11emkY2y0a/VEXFcE5fIkjuyZiXfzneWQl8z2iVkZmtbxiMElOhw4WJE
         bw5uv33MYrZ7EqrfVtvfDTxpgpxL7Phj8sG2AfosJtPgERZOXwKwqfOeTE3XYqjHx5BF
         nmVDzh3gU62RZC0gADU1rdP5dvQ99570S4z0bDweX8uELwb0L94bBoUa+B1AdvXV2sYh
         xWPfr7BcZc5RJfXdBB8ni8Nd+SmK65/Qh8On5Kume90wL0peJmaicjjU5HtBlXq/bDur
         GquA==
X-Gm-Message-State: AOAM531TwsPbmebEcQxbtDUwO4p70eKtV2XMLis9bq0kSwvf+pQoPU7d
        jI32qKlyW/S4ZNkrjNCr6eiB0SPIL2e2gsZKGSY=
X-Google-Smtp-Source: ABdhPJy6zRO51d3PU8IAqVccKcOMTC0ETaJF1Ufh9Y/zIpPngHzzBJfglHh91hz407YKah5RPrKJVR/dFy/aTDYT5FE=
X-Received: by 2002:a37:e509:: with SMTP id e9mr4699707qkg.469.1599684639686;
 Wed, 09 Sep 2020 13:50:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200909091302.20992-1-dnlplm@gmail.com> <20200909122853.GA669308@kroah.com>
In-Reply-To: <20200909122853.GA669308@kroah.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Wed, 9 Sep 2020 22:50:28 +0200
Message-ID: <CAGRyCJGWv19ikw6mZrvDJ5hmZ0T1zgcmQSEKZB=htXGzjz8F=Q@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net: usb: qmi_wwan: add default rx_urb_size
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Paul Gildea <paul.gildea@gmail.com>,
        Carl Yin <carl.yin@quectel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

Il giorno mer 9 set 2020 alle ore 14:28 Greg KH
<gregkh@linuxfoundation.org> ha scritto:
>
> On Wed, Sep 09, 2020 at 11:13:02AM +0200, Daniele Palmas wrote:
> > Add default rx_urb_size to support QMAP download data aggregation
> > without needing additional setup steps in userspace.
> >
> > The value chosen is the current highest one seen in available modems.
> >
> > The patch has the side-effect of fixing a babble issue in raw-ip mode
> > reported by multiple users.
> >
> > Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
>
> Any specific kernel commit that this "fixes:"?
>

Related to the aggregation, if I have to find a commit that would be
c6adf77953bcec0ad63d7782479452464e50f7a3 "net: usb: qmi_wwan: add qmap
mux protocol support", but I feel that this is an improvement rather
than a fix, since it avoids having userspace to configure the
rx_urb_size through changing the MTU of the master interface.

Related to the babble issue, my understanding is that it's not a
qmi_wwan issue, but a workaround for some chipsets' behavior.

> > ---
> > Resending with mailing lists added: sorry for the noise.
> >
> > Hi Bj=C3=B8rn and all,
> >
> > this patch tries to address the issue reported in the following threads
> >
> > https://www.spinics.net/lists/netdev/msg635944.html
> > https://www.spinics.net/lists/linux-usb/msg198846.html
> > https://www.spinics.net/lists/linux-usb/msg198025.html
> >
> > so I'm adding the people involved, maybe you can give it a try to
> > double check if this is good for you.
> >
> > On my side, I performed tests with different QC chipsets without
> > experiencing problems.
> >
> > Thanks,
> > Daniele
> > ---
> >  drivers/net/usb/qmi_wwan.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> > index 07c42c0719f5..92d568f982b6 100644
> > --- a/drivers/net/usb/qmi_wwan.c
> > +++ b/drivers/net/usb/qmi_wwan.c
> > @@ -815,6 +815,10 @@ static int qmi_wwan_bind(struct usbnet *dev, struc=
t usb_interface *intf)
> >       }
> >       dev->net->netdev_ops =3D &qmi_wwan_netdev_ops;
> >       dev->net->sysfs_groups[0] =3D &qmi_wwan_sysfs_attr_group;
> > +
> > +     /* Set rx_urb_size to allow QMAP rx data aggregation */
> > +     dev->rx_urb_size =3D 32768;
>
> Where did this "magic number" come from?
>

This is coming from the modem and it's the highest value I'm aware of
(Qualcomm SDX55 chipset). The problem is that different chipsets have
different maximum values, so while other modems have lower values
(e.g. 4096), if rx_urb_size can't be configured in user-space, the
maximum known value should be used to support all currently available
chipsets.

> And making an urb size that big can keep some pipelines full, it also
> comes at the expense of other potential issues, have you tested this to
> see that it really does help in throughput?
>

Yes, I had doubts about this: I could not test throughput for SDX55,
since at the moment I do not have the needed equipment. In the past I
tested a different value (16384) with 4G modems and I'm able to reach
the max dl throughput (1.1Gbit/s). Actually, enabling dl aggregation
is the only way to reach that throughput.

> And if it does, does this size really need to be that big?  What is it
> set to today, the endpoint size?  If so, that's a huge jump...
>

Since 16384 seems also the size used by the Windows driver, a
possibility is to use that value and add a comment in the driver
stating that higher values are not supported.

Today the default size is 1500, but it can be "configured" in user
space as a side-effect of changing the MTU.

To me that would still be acceptable since proved to be working fine
until now, but the problem is that to solve a babble issue seen with
recent chipsets the default rx_urb_size should be changed to an higher
value (QC suggested 2048) and this breaks the MTU workaround (see
function usbnet_change_mtu in usbnet.c).

Thanks,
Daniele

> thanks,
>
> greg k-h
