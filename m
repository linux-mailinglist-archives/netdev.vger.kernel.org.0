Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E1E2B3361
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 11:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgKOKVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 05:21:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:43674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbgKOKVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 05:21:42 -0500
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D5CB22447;
        Sun, 15 Nov 2020 10:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605435701;
        bh=rzydftkceju63cCVzuN0vhHudbX1SeIpRs/FyMWETVk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NJMH+ARhBlVaZfdlzWIlEqaZFzUwEXOS2Rfd6FOaNrZxBbeybaf0ozWCmU7O/GxID
         PDdDGSpwXad9RPkBwvoeXLYXh2+MHpMf9NtTHWJuAE4fbBY+1CVNxI0xviTteiiMx7
         CwEAFN2+pREj7/2KF+sNzOV8AVmnTk3b8qSmIi9U=
Received: by mail-ed1-f49.google.com with SMTP id a15so15676408edy.1;
        Sun, 15 Nov 2020 02:21:41 -0800 (PST)
X-Gm-Message-State: AOAM532uygchxxigBfOy8sW60yJTzF6M0DHwsAnYzV7samLcgxG4cB3d
        z1rsfE37JhBET3sJ5UN+1N3WXxxrpk5UQarZkmM=
X-Google-Smtp-Source: ABdhPJxKJq+2E3NzY82/TP8puJiteJX7GiWRD0G9jz4iNvHTs5V6oRbmUX8fAg7hVa7VlUteGYG02s/rE9KjLwtr2yI=
X-Received: by 2002:a05:6402:290:: with SMTP id l16mr11065020edv.104.1605435700190;
 Sun, 15 Nov 2020 02:21:40 -0800 (PST)
MIME-Version: 1.0
References: <CGME20201113050719epcms2p7ba0a549e386259a01753714da1b79ea3@epcms2p7>
 <20201113050719epcms2p7ba0a549e386259a01753714da1b79ea3@epcms2p7>
 <CAJKOXPePgqWQpJjOeJ9U0jcNG7et6heAid2HnrPeWTDKXLUgjA@mail.gmail.com> <CAEx-X7eEbL8Eoxk0smUCzxb+XOeRQTGBNUZcmDyuZNYCNa1Ghw@mail.gmail.com>
In-Reply-To: <CAEx-X7eEbL8Eoxk0smUCzxb+XOeRQTGBNUZcmDyuZNYCNa1Ghw@mail.gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Sun, 15 Nov 2020 11:21:27 +0100
X-Gmail-Original-Message-ID: <CAJKOXPdXYLPbYwJiroNPtzgE7v5-bHxpmt-g1zNPFrjPo4G_MA@mail.gmail.com>
Message-ID: <CAJKOXPdXYLPbYwJiroNPtzgE7v5-bHxpmt-g1zNPFrjPo4G_MA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] nfc: s3fwrn82: Add driver for Samsung
 S3FWRN82 NFC Chip
To:     Bongsu Jeon <bs.jeon87@gmail.com>
Cc:     bongsu.jeon@samsung.com, "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 at 01:54, Bongsu Jeon <bs.jeon87@gmail.com> wrote:
>
> On Fri, Nov 13, 2020 at 4:26 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> >
> > On Fri, 13 Nov 2020 at 06:09, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
> > >
> > >
> > > Add driver for Samsung S3FWRN82 NFC controller.
> > > S3FWRN82 is using NCI protocol and I2C communication interface.
> > >
> > > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> > > ---
> > >  drivers/nfc/Kconfig             |   1 +
> > >  drivers/nfc/Makefile            |   1 +
> > >  drivers/nfc/s3fwrn82/Kconfig    |  15 ++
> > >  drivers/nfc/s3fwrn82/Makefile   |  10 ++
> > >  drivers/nfc/s3fwrn82/core.c     | 133 +++++++++++++++
> > >  drivers/nfc/s3fwrn82/i2c.c      | 288 ++++++++++++++++++++++++++++++++
> > >  drivers/nfc/s3fwrn82/s3fwrn82.h |  86 ++++++++++
> > >  7 files changed, 534 insertions(+)
> > >  create mode 100644 drivers/nfc/s3fwrn82/Kconfig
> > >  create mode 100644 drivers/nfc/s3fwrn82/Makefile
> > >  create mode 100644 drivers/nfc/s3fwrn82/core.c
> > >  create mode 100644 drivers/nfc/s3fwrn82/i2c.c
> > >  create mode 100644 drivers/nfc/s3fwrn82/s3fwrn82.h
> >
> > No, this is a copy of existing s3fwrn5.
> >
> > Please do not add drivers which are duplicating existing ones but
> > instead work on extending them.
> >
> > Best regards,
> > Krzysztof
>
> I'm bongsu jeon and working for samsung nfc chip development.
> If I extend the code for another nfc chip model, Could I change the
> s3fwrn5 directory and Module name?
> I think the name would confuse some people if they use the other nfc
> chip like s3fwrn82.

Hi,

Renaming would only make git history trickier to follow. Multiple
drivers get extended and not renamed. Anyone configuring the kernel
should check through Kconfig description, compatibles or description
in bindings, so name of directory does not matter when looking for HW
support. Then someone would add different chip support, and you would
rename as well? So no, do not rename it.

Best regards,
Krzysztof
