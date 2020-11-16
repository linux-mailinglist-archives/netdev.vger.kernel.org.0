Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFCE2B3B3F
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 02:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgKPB72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 20:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728413AbgKPB72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 20:59:28 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F081C0613CF;
        Sun, 15 Nov 2020 17:59:26 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id d1so2080913ybr.10;
        Sun, 15 Nov 2020 17:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=pFGInHRGdqEGsvVqPYvaZz37g34COkN/zxnAelojjto=;
        b=YURNrb6f4g6wlo4PHzIUUH18U9AJd61l1JDBz/eBGbnFTMpmj1uySvpw3oRIujLEDD
         83pg1jF2T1azTcm3paAwWovOb0gyFMhJgZcyx80UdFYRLFv1O0MuDxBed8wG8QdRVjPQ
         VJKoROCGZaFY3T1YHI+LNMHoLVpZNNzn1kWqzJFJIS25SVZGfAD1IG5lQ1msIuEon7xo
         aeRTqjuSz5ceVwhbVguUVodCcI48mApBy9BqyLx5Ns3mKuL7NlWCu4Lx/WWUryaJv4Vq
         HM2vByuoPUwu8Fi4kAoKHH9ayfQ0lBxsnKHmzCffCHG17n3+DxMJ/CnVHP5ZM/JHXh8i
         PKSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=pFGInHRGdqEGsvVqPYvaZz37g34COkN/zxnAelojjto=;
        b=d5HdwgCJ8CVzO1Z9pL+zuCN41bQA9piNWBWSmcyZesCvd15GawofqoTCCsDLwHxTrt
         3ULlTnNnCfjnBtr5jubb6B9c+TE1kcJrO9NsdUne/QOjjfcONHLK69cq4+IkDevTZPvf
         FP8zb88hNh4ISd1RTZ2Vb9f3R96hVTsi674Y5qMMvVxgJH0QEWDonpEmStsENR16+COc
         wv+jtV9mNWIjiW0TpAo0IcVs6b8i+kz2yObO7dtOy5nMrP1yyNfCW/2MCGCKqR4Env0k
         1ZvHH3D41Ik5Jlnk9eaCDX8pcqJJnuct9T32dh+oJPh+8T8iMgmtJ+I5cW9OI2bsKvZR
         kcPg==
X-Gm-Message-State: AOAM531GyBiNQNEtyVVXwLDol/kwD1blpYpDP1To7duzpTRGLHgdGdwF
        2WHTWNjnxTuXwJnxwXUTiNa/NTKLQXaLrHLb8o0=
X-Google-Smtp-Source: ABdhPJyZSU5HnajrZ6tnN0hPSlqKGxF08HHOqbnwCAb+o89DKIjkC7JHykmTv2BdYGq1reIZPuY2Eu6TRMtQifMSeCQ=
X-Received: by 2002:a25:3102:: with SMTP id x2mr384613ybx.495.1605491964636;
 Sun, 15 Nov 2020 17:59:24 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a25:9785:0:0:0:0:0 with HTTP; Sun, 15 Nov 2020 17:59:24
 -0800 (PST)
In-Reply-To: <CAJKOXPePgqWQpJjOeJ9U0jcNG7et6heAid2HnrPeWTDKXLUgjA@mail.gmail.com>
References: <CGME20201113050719epcms2p7ba0a549e386259a01753714da1b79ea3@epcms2p7>
 <20201113050719epcms2p7ba0a549e386259a01753714da1b79ea3@epcms2p7> <CAJKOXPePgqWQpJjOeJ9U0jcNG7et6heAid2HnrPeWTDKXLUgjA@mail.gmail.com>
From:   Bongsu Jeon <bs.jeon87@gmail.com>
Date:   Mon, 16 Nov 2020 10:59:24 +0900
Message-ID: <CAEx-X7cufBcO38RR2SQzvTOA=JRyG7XSR-KNMcui99WGrsvfZw@mail.gmail.com>
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

On Fri, Nov 13, 2020, 4:26 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:

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
>

I understand your explain.
Actually I thought that generic name like samsung-nci would be better
than samsung's nfc chip name.
