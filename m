Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23860CFD97
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfJHP1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:27:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55740 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfJHP1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 11:27:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id a6so3627659wma.5;
        Tue, 08 Oct 2019 08:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3j5k4kFsYjl7lRvs5vk8aQPFH9UOzkMAmPJc4BnNYos=;
        b=QCv1kBCO/2JYwY0e5a61IPH8d9kqLRcmUsN52DL+9b75fG0GaHn9FjmNLfJIlOiOyk
         y8SmGPPOYRZYltLJHFObjvymyXPmBguZcac13Na2dLA9vq7aWNrHccB2CFAsBbk8RBZt
         yo8oE7xlBl0+3qCyuimtNDTyZDNRvU9fWOqifyfFxYoobJhAE99WseueITlLnLGfXhMm
         ZActn5GNS03NA4UO4TUTqQuTL0JLVGsBZSj6UyE3WziVtUp4b7XjXA63my6gvG6QnWfX
         ofQn5Z8hXwBvDXPViHLiQiRiMI4B/C3RlEq7SiavoFr1zr9St9k01NSVFKSFT6jr4fi/
         Rj2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3j5k4kFsYjl7lRvs5vk8aQPFH9UOzkMAmPJc4BnNYos=;
        b=klZlmFQXvQ+KAq/iHtEnnprXQc7CegSCYMXYZdk9jr3kcH2SiGJ4Serx6Z+EXAGG0w
         CmLpqeJVHwc10YS/8kF3JHhdYDX+zTFvq4g5/B9mind4tb7w4pVEUWy3JdmhOgwdQ1mG
         rCr3HxwUeB0BVwKkbuvlNR+0vZZJhXJfKANfYMDHVN+Hx3SlUrepxx8Ge1p2UI98bvMU
         tQOWbfAvCNxhjzAiFY3gtL/xobXXpgs1LdZO9tkyzT5n9wHJylb7g14kHqhrDI0Ka4lW
         ioVrrq7dYilfAh50D1oXJ2Z0LqM7nhKnMkooGtJCa/5EztGjU6XxY0hWlbCQlQJPtCUc
         65cw==
X-Gm-Message-State: APjAAAUVOS/S8072Gc9rPPncvzj6OOon1oD6SryOP/ohQNU1Oltl0c/z
        2r2xoY6k2sOU7Mo6KjGg6O/Y1E3dke0UUVGEOGO4pvRU
X-Google-Smtp-Source: APXvYqxZfVYrdmQk32nanfKG7fxyR7ocxrUSQX6Fb0WtPxKfveIZD7LmnF6jo+c2+zGDAIM3Xa0DYCv2/1D28K9y0Es=
X-Received: by 2002:a1c:968b:: with SMTP id y133mr4192972wmd.56.1570548459339;
 Tue, 08 Oct 2019 08:27:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570533716.git.lucien.xin@gmail.com> <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
 <60a7f76bd5f743dd8d057b32a4456ebd@AcuMS.aculab.com>
In-Reply-To: <60a7f76bd5f743dd8d057b32a4456ebd@AcuMS.aculab.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 8 Oct 2019 23:28:32 +0800
Message-ID: <CADvbK_cFCuHAwxGAdY0BevrrAd6pQRP2tW_ej9mM3G4Aog3qpg@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 3/5] sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE
 sockopt
To:     David Laight <David.Laight@aculab.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 8, 2019 at 9:02 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Xin Long
> > Sent: 08 October 2019 12:25
> >
> > This is a sockopt defined in section 7.3 of rfc7829: "Exposing
> > the Potentially Failed Path State", by which users can change
> > pf_expose per sock and asoc.
>
> If I read these patches correctly the default for this sockopt in 'enabled'.
> Doesn't this mean that old application binaries will receive notifications
> that they aren't expecting?
>
> I'd have thought that applications would be required to enable it.
If we do that, sctp_getsockopt_peer_addr_info() in patch 2/5 breaks.

>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
