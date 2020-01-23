Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF6EF147002
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgAWRsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:48:10 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41294 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728731AbgAWRsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:48:09 -0500
Received: by mail-ed1-f68.google.com with SMTP id c26so4177548eds.8
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 09:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pcQMG6PlSIo4ET+dNYjklFPxN+2P2yxLQZQp2y9DKg4=;
        b=ZUFZ3MXobcuBmg+zDBJ4uffsFp8DPc8C4LipjIYpYWJwEzv63OXsgl+oOf+eC0w0TL
         iYwGQeTkHn7h9PAhorjrpOhmUjqXSBmTsj0JHT3TWglA74eRk6Y2ldeY3kU/SEQFJbI7
         29ub7KPVsRGTzl3rdzZC2cgVmF02D3HIrbo4DTgvYcJm7peOZm/Vx8hSwpjl/wQ0Bh4N
         iDnP4Y+Wc3sidl/K69kkCukojS4bDFIjPs8da7ylSiUTB0DqVSjkUiDurcZ6T9lDqVeF
         JCQhhEekblny3cUTd5d+x0iDbnIsovuvtl7xDyuCDXpV9TU5x+64+hRtm6hmAagfZnF/
         fPnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pcQMG6PlSIo4ET+dNYjklFPxN+2P2yxLQZQp2y9DKg4=;
        b=pRw2HoD9/0h70QTkD+TV4AQoFyGX/2Vin2FDqBL8n++n05gfnRRHEqejtpTfAk1u/M
         Suc4kWV9N4ZA7hCgaG+M36FXRozPFan5dNJIarkCRs3+mVxPY9V2geR87XnLPp7z633a
         HnneCbTnTiUqVWl20qaTAd5VOzPeB1YWbK/3aapFkDwKNIwR3KrJcg2vrDUWtGfoissm
         ToWsN/nVhSN5GWdKnb1sK2n9zuY44+YFsp89HFYshJoJjrZCnCUGECsc1yUp7v8rjcHt
         A1WNpRVlMlnLJ1AUABCedIvZmzSs8uBO5+t5hnZT6ZFO44rlc6j9VsTmijJ3YwZ/wuFk
         L3Wg==
X-Gm-Message-State: APjAAAUSS4sy3YGVEpE+ROmc9usczySx0AaBfKppMFbX91vHlRkKZO5B
        CQl1dPUdrLV/Av/DCqPtMX3W0LpgZaRxSVOqUlaVmg==
X-Google-Smtp-Source: APXvYqzGyS2xqYWJkxfwdUQ5T5p8l5n39fqwVOGFHAeP1zh6XomIfbTq8jiGyKayDUMDY44/HAUstnQtiklPuXvvWVw=
X-Received: by 2002:a17:906:31c6:: with SMTP id f6mr8259556ejf.17.1579801687624;
 Thu, 23 Jan 2020 09:48:07 -0800 (PST)
MIME-Version: 1.0
References: <20200122223326.187954-1-lrizzo@google.com> <20200122234753.GA13647@lunn.ch>
 <CAMOZA0LiSV2WyzfHuU5=_g0Ru2z-osx0B-WkS-QHMaQeY4GXeA@mail.gmail.com> <20200123084000.GT22304@unicorn.suse.cz>
In-Reply-To: <20200123084000.GT22304@unicorn.suse.cz>
From:   Luigi Rizzo <lrizzo@google.com>
Date:   Thu, 23 Jan 2020 09:47:56 -0800
Message-ID: <CAMOZA0L7+ugo7e=VeiGUc49fyNTxr0HmU4cuM8jHfRO3OMYuXw@mail.gmail.com>
Subject: Re: [PATCH] net-core: remove unnecessary ETHTOOL_GCHANNELS initialization
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 12:40 AM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Wed, Jan 22, 2020 at 04:18:56PM -0800, Luigi Rizzo wrote:
> > On Wed, Jan 22, 2020 at 3:47 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Wed, Jan 22, 2020 at 02:33:26PM -0800, Luigi Rizzo wrote:
> > > > struct ethtool_channels does not need .cmd to be set when calling the
> > > > driver's ethtool methods. Just zero-initialize it.
> > > >
> > > > Tested: run ethtool -l and ethtool -L
> > >
> > > Hi Luigi
> > >
> > > This seems pretty risky. You are assuming ethtool is the only user of
> > > this API. What is actually wrong with putting a sane cmd value, rather
> > > than the undefined value 0.
> >
> > Hi Andrew, if I understand correctly your suggestion is that even if
> > the values are unused, it is better to stay compliant with the header
> > file include/uapi/linux/ethtool.h, which does suggest a value for .cmd
> > for the various structs
>
> Unless you check all in tree drivers, you cannot be sure there isn't one
> which would in fact rely on .cmd being set to expected value. And even
> then there could be some out of tree driver; we usually don't care too
> much about them but it's always matter of what you gain by the cleanup.
> AFAICS it might be just few CPU cycles in this case - if we are lucky.

The change was not about CPU savings, but trying to remove what I thought
were misleading or incorrect values.

Now I stand corrected, thank you for the feedback:
the header mentions that cmd should have a value
so let it be in, and as you say later, the first operation in
ethtool_set_channels()
is a get_channels so ETHTOOL_GCHANNELS is the correct value.

For the same reason though (comply with the header) we might perhaps
want to replace with cmd with ETHTOOL_SCHANNELS before actually
calling dev->ethtool_ops->set_channels()

(I realize this is not particularly important)

cheers
luigi
>
> > and only replace the value in ethtool_set_channels() with the correct
> > one ETHTOOL_SCHANNELS ?
>
> That would be incorrect. The initialization in ethtool_set_channels() is
> for curr variable which is passed to ->get_channels() (to get current
> values for checking new values against maximum). Therefore the correct
> command really is ETHTOOL_GCHANNELS.
>
> Michal
