Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96C72FDA8F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731356AbhATOAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389841AbhATMgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 07:36:54 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F64C0613CF
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 04:36:13 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id 186so10499219vsz.13
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 04:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+SzMz5sdfmFR0sib+UFhLPPX1Glct3kb82oUkb/t3vc=;
        b=RoazY4lKUlW3mlfK+B+2+8+Td4q/ZTGKUb3GNeLW0UYDeT+VIskizF1IBoLThcQo0R
         devlFJC++sJSb+7I0y5KcOQ0LSxOg4G8VhUJAVx72ER9DiZYWCWu6UmCyGjuCx+x9zX/
         j6e5hPb8GVhbC7f7uV7KXgdOARj4x4hJAmwW50Jnqe5XbLzq/TbJ7O4O8i6X+P4HxYib
         M/EAtSRJf+Q+C6jfeBZHanyIsRUP9JXhtoKjw2ji+RfQpD5rRGpZ7Ys1Lz1kIswSsOMY
         Tz58i8Pk/vngiXN0hbI7F8pzN5s22EdLFwLJUFrGdpVnaVW5EuzjNp0uNrmNkHEhY9ug
         1gmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+SzMz5sdfmFR0sib+UFhLPPX1Glct3kb82oUkb/t3vc=;
        b=Q00TDJdgvj79vZe5B9z7tTrjGfnUlyQhx5esILc3NThk7UHa0NZiUnPLryrj/XYKf5
         hFh89DZ+oDfzz6qTLnpE8T1QlrSzz9+lk6iavxrhVfFOu6+0HF0tSqlstXe2N9AmEzxz
         KYeLgr/+lAbdx7mFhng56CgsjZHLXU62+QMWu1PlKUN6TRBBanZsQz3OMBQP2YTHJWra
         yPr1GQauXrjYu3VmCXep/ZnDGkKHWU83dscNcAeSIVG8YDX4rmbEo+6b9DP5WnwCDbek
         iojZ0N5lUqR/igcTBKUD2qOjE2jhAa/FK4cOzO5DMY8I693pFIZ5etTRqW3hCp9W+gBI
         OSCQ==
X-Gm-Message-State: AOAM532l9uhaDMcYUniWpE5T9fbnck5JE22kb38QddPOhmFN3oG1HyVI
        QNevrgbb04g5ZNuoxm1Gy8Vv6nrVFOp9Fk651wc=
X-Google-Smtp-Source: ABdhPJyF8xoxdGOi3cccJDZULlIDWsgAUz5pwnLbF7r1CdRnfL5Py0YpaHMPqu6cCxkr0FKkJKVnsCPZ3sjmTC1c2fs=
X-Received: by 2002:a67:ec45:: with SMTP id z5mr6370408vso.10.1611146172128;
 Wed, 20 Jan 2021 04:36:12 -0800 (PST)
MIME-Version: 1.0
References: <20210118054611.15439-1-gciofono@gmail.com> <20210118115250.GA1428@t-online.de>
 <87a6t6j6vn.fsf@miraculix.mork.no>
In-Reply-To: <87a6t6j6vn.fsf@miraculix.mork.no>
From:   Giacinto Cifelli <gciofono@gmail.com>
Date:   Wed, 20 Jan 2021 13:36:01 +0100
Message-ID: <CAKSBH7HbaVxyZJRuZPv+t2uBipZAkAYTcyJwRDy-UTB_sD4SJA@mail.gmail.com>
Subject: Re: [PATCH] net: usb: qmi_wwan: added support for Thales Cinterion
 PLSx3 modem family
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Reinhard Speyerer <rspmn@t-online.de>, netdev@vger.kernel.org,
        rspmn@arcor.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bj=C3=B8rn,

On Mon, Jan 18, 2021 at 10:02 PM Bj=C3=B8rn Mork <bjorn@mork.no> wrote:
>
> Reinhard Speyerer <rspmn@t-online.de> writes:
>
> >> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> >> index af19513a9f75..262d19439b34 100644
> >> --- a/drivers/net/usb/qmi_wwan.c
> >> +++ b/drivers/net/usb/qmi_wwan.c
> >> @@ -1302,6 +1302,8 @@ static const struct usb_device_id products[] =3D=
 {
> >>      {QMI_FIXED_INTF(0x0b3c, 0xc00a, 6)},    /* Olivetti Olicard 160 *=
/
> >>      {QMI_FIXED_INTF(0x0b3c, 0xc00b, 4)},    /* Olivetti Olicard 500 *=
/
> >>      {QMI_FIXED_INTF(0x1e2d, 0x0060, 4)},    /* Cinterion PLxx */
> >> +    {QMI_FIXED_INTF(0x1e2d, 0x006f, 8)},    /* Cinterion PLS83/PLS63 =
*/
> >> +    {QMI_QUIRK_SET_DTR(0x1e2d, 0x006f, 8)},
> >>      {QMI_FIXED_INTF(0x1e2d, 0x0053, 4)},    /* Cinterion PHxx,PXxx */
> >>      {QMI_FIXED_INTF(0x1e2d, 0x0063, 10)},   /* Cinterion ALASxx (1 Rm=
Net) */
> >>      {QMI_FIXED_INTF(0x1e2d, 0x0082, 4)},    /* Cinterion PHxx,PXxx (2=
 RmNet) */
> >
> > Hi Giacinto,
> >
> > AFAIK the {QMI_FIXED_INTF(0x1e2d, 0x006f, 8)} is redundant and can simp=
ly
> > be deleted. Please see also commit 14cf4a771b3098e431d2677e3533bdd962e4=
78d8
> > ("drivers: net: usb: qmi_wwan: add QMI_QUIRK_SET_DTR for Telit PID 0x12=
01")
> > and commit 97dc47a1308a3af46a09b1546cfb869f2e382a81
> > ("qmi_wwan: apply SET_DTR quirk to Sierra WP7607") for the correspondin=
g
> > examples from other UE vendors.
>
> Yup, please fix and send a v2.  And please use get_maintainer.pl to get
> the proper destinations.
>

I have fixed and resent, but from your comment I might not have
selected the right line from maintaner.pl?
what I have is this:
$ ./scripts/get_maintainer.pl --file drivers/net/usb/qmi_wwan.c
"Bj=C3=B8rn Mork" <bjorn@mork.no> (maintainer:USB QMI WWAN NETWORK DRIVER)
"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVERS)
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS)
netdev@vger.kernel.org (open list:USB QMI WWAN NETWORK DRIVER)
<<<< this seems the right one
linux-usb@vger.kernel.org (open list:USB NETWORKING DRIVERS)
linux-kernel@vger.kernel.org (open list)

I have at the same time sent a patch for another enumeration of the
same product, for cdc_ether.  In that case, I have picked the
following line, which also looked the best fit:
  linux-usb@vger.kernel.org (open list:USB CDC ETHERNET DRIVER)

Did I misinterpret the results of the script?

Thank you,
Giacinto
