Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6D52B31B1
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 01:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgKOAyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 19:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgKOAyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 19:54:39 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76814C0613D1;
        Sat, 14 Nov 2020 16:54:39 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id 10so12311607ybx.9;
        Sat, 14 Nov 2020 16:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AfxM2cqq+f7m6hD/XAirrDNjFgyuW8df8NHmU4BPDB8=;
        b=mja2mR1Qzyse538hjtvAW26k75hM7Cpt3xHZG2yKZirr84ZYfvv+0pwdmTQ3rzeplE
         Xj/H+wZGoLgjRNK4w6Xs9Wv39+3AuPNA00dHEopHn67QAPHskIe9EFrkue8kPZCS/md+
         kr3Zm6Y3a52FhyS3nUCuIWg0wJPF0rm4g2S8AqTfk25FthzkOZuFEqGWUnm96SiJ255l
         ftoliWvPulj0JGPgNCBZwNjnwJ7XJIs3rPCfXE/X0ZPn1e3EzOaoe/f+RCAC/1NZQDUC
         Gt4StP+mwYhGRrbUlsSyXq8foaNRVu33ag5PUMLvKw5FfK7bq0s8mJQMkzfm1tm/OdI7
         7STg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AfxM2cqq+f7m6hD/XAirrDNjFgyuW8df8NHmU4BPDB8=;
        b=uIWOvr8RqvsNe/Pp92G1dvvFa/vl5QBG2vlvrRqbcvYApI6MW7ZRyAB3f1PJuKehY7
         HaDr195WsPGI0yjc9c7X3ruMRCrxHsrEywoGRC81lZGH6+Q/bBO9qZhPn0xW5eBaf7Yq
         s+G9rZVTN57oJrrkvQFlIPTIpJP3mPbiT/aDxlIqyNIcAMW+XvhtrVDJ/7YrFmJHGjnj
         6+ctRKXjAmys5WzCOY+4qAYJfqnI7S+3hlDPj2a9fYS0c5UkKgEvY+qTJn2MlLCn7TCw
         5xOSr51mHg8bptFudnvTkf+55eUkpRwmCRePThrily1rrTeA/yeR54TjyovSG+Flk3Zr
         Sj4w==
X-Gm-Message-State: AOAM531R7XAjjgeaAIzeJnprb2HuRUINTke1JV73CywOfulD2o+ldT1d
        0FuMCVrrKcln1HcRmYmFiZ4xcxe7IpiL9W9P1D0=
X-Google-Smtp-Source: ABdhPJxJMFcJZP1GphExUfXtO+o5/zVkg5i+xNGxPrCwdDXONOqB9vuNXxpThoA4PGe8MLaGfXco6NAqnXsWaa/a+PQ=
X-Received: by 2002:a25:a468:: with SMTP id f95mr10629457ybi.327.1605401678816;
 Sat, 14 Nov 2020 16:54:38 -0800 (PST)
MIME-Version: 1.0
References: <CGME20201113050719epcms2p7ba0a549e386259a01753714da1b79ea3@epcms2p7>
 <20201113050719epcms2p7ba0a549e386259a01753714da1b79ea3@epcms2p7> <CAJKOXPePgqWQpJjOeJ9U0jcNG7et6heAid2HnrPeWTDKXLUgjA@mail.gmail.com>
In-Reply-To: <CAJKOXPePgqWQpJjOeJ9U0jcNG7et6heAid2HnrPeWTDKXLUgjA@mail.gmail.com>
From:   Bongsu Jeon <bs.jeon87@gmail.com>
Date:   Sun, 15 Nov 2020 09:54:28 +0900
Message-ID: <CAEx-X7eEbL8Eoxk0smUCzxb+XOeRQTGBNUZcmDyuZNYCNa1Ghw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] nfc: s3fwrn82: Add driver for Samsung
 S3FWRN82 NFC Chip
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     bongsu.jeon@samsung.com, "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 4:26 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Fri, 13 Nov 2020 at 06:09, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
> >
> >
> > Add driver for Samsung S3FWRN82 NFC controller.
> > S3FWRN82 is using NCI protocol and I2C communication interface.
> >
> > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> > ---
> >  drivers/nfc/Kconfig             |   1 +
> >  drivers/nfc/Makefile            |   1 +
> >  drivers/nfc/s3fwrn82/Kconfig    |  15 ++
> >  drivers/nfc/s3fwrn82/Makefile   |  10 ++
> >  drivers/nfc/s3fwrn82/core.c     | 133 +++++++++++++++
> >  drivers/nfc/s3fwrn82/i2c.c      | 288 ++++++++++++++++++++++++++++++++
> >  drivers/nfc/s3fwrn82/s3fwrn82.h |  86 ++++++++++
> >  7 files changed, 534 insertions(+)
> >  create mode 100644 drivers/nfc/s3fwrn82/Kconfig
> >  create mode 100644 drivers/nfc/s3fwrn82/Makefile
> >  create mode 100644 drivers/nfc/s3fwrn82/core.c
> >  create mode 100644 drivers/nfc/s3fwrn82/i2c.c
> >  create mode 100644 drivers/nfc/s3fwrn82/s3fwrn82.h
>
> No, this is a copy of existing s3fwrn5.
>
> Please do not add drivers which are duplicating existing ones but
> instead work on extending them.
>
> Best regards,
> Krzysztof

I'm bongsu jeon and working for samsung nfc chip development.
If I extend the code for another nfc chip model, Could I change the
s3fwrn5 directory and Module name?
I think the name would confuse some people if they use the other nfc
chip like s3fwrn82.

Best regards,
bongsu.
