Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA3C78EBE
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 17:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387913AbfG2PIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 11:08:52 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38764 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387402AbfG2PIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 11:08:52 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so32442795wmj.3
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 08:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=j0uuDf1QwIeP6p98TOM7M4ZqLlL5xuSjSOFdqx6jab4=;
        b=CHEO/4YonM+FokQxcqoUElX0pYoXC3d0W0fhq2W3xdDWm7qOd/H2Kwyt/RlGPCaVz/
         H3VK6VsRePDvhgIj8xzGwp2ga+AxmjwpfO1zUtKsUr4ZTvA00Yw8ZEcOTmnCW1yzHFjo
         QbvS1Y386G+WTJKCR68hz5ohIs26oonKsow7wm1g4jjmCNC08V+62ec2/T4LAKcMzqAc
         1kE4CZ67pWXp35pWbttECbr2+LVwIV5G8T/2ccl5TYT+lt+0x9sDof2HqOUWixiH8OC/
         CyFbq9PUiYeN31MpPHC4hwFBVp4DuoERNIeXnNA6SVIs7IkRPJ2sx+1fhR3JdbkSmjJs
         J9bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=j0uuDf1QwIeP6p98TOM7M4ZqLlL5xuSjSOFdqx6jab4=;
        b=QGa955RKe2rMjGrGeabr2dJ++76eeqauGd7YGR8p/K36cb5zqCgOW1smpocmdMvK4L
         PU0SK+dSrSjjmbhW0F9svRc2BrNse14d0H+XuHdpU1WKJpEaPYz64GFNjuh7/BpNnmBS
         JZqzS75Xl9xG7sIrkMqoOnRB/JOqbab6/eNELQn2gisv6UgL/3CKADFdgRf44vbP0vv8
         jes3TL9aqOaCwhwF/C0IIB3Fs//2X9X1Rt6eI73i3fDBKqwDuO0x+wvvkM7hFVgkcGyN
         0HuY8koq6rPhPDFEEBixACqz3FaUzPG49NabA593slyHtbEvCoC5PE1XL9Nb5RTPgJdd
         lXqA==
X-Gm-Message-State: APjAAAUt2W5d/ITY7p+KHXEoUhOWxZXVu6sAhNI63IQySdjznCpVZwxX
        eYnuc+nz1OMzLRd8trsmSWhXTtarw7xWk8CzDlQ=
X-Google-Smtp-Source: APXvYqzfRyx5lkxKoIMFvTWRp5M3omoPVncfuIyqgZLNq8qDCFM8X8TwhitwKjAofQWUcLGlWimkP5t7t0iGVf2ZqWg=
X-Received: by 2002:a05:600c:10ce:: with SMTP id l14mr97607730wmd.118.1564412930020;
 Mon, 29 Jul 2019 08:08:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190725193511.64274-1-andriy.shevchenko@linux.intel.com>
 <20190725193511.64274-11-andriy.shevchenko@linux.intel.com>
 <20190726.142346.407773857500139523.davem@davemloft.net> <20190729094047.GH9224@smile.fi.intel.com>
 <CA+icZUW5H+9VJvxViYYEDCJ-mLa-xudqYScjZFJ8eA6200YZmg@mail.gmail.com>
In-Reply-To: <CA+icZUW5H+9VJvxViYYEDCJ-mLa-xudqYScjZFJ8eA6200YZmg@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 29 Jul 2019 17:08:35 +0200
Message-ID: <CA+icZUU1Hi+OGhniw_cyG2xF29Xkqc-Rp-OoJixQFtGyE9=01A@mail.gmail.com>
Subject: Re: [PATCH v3 11/14] NFC: nxp-nci: Remove unused macro pr_fmt()
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     David Miller <davem@davemloft.net>,
        clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
        netdev@vger.kernel.org, Sedat Dilek <sedat.dilek@credativ.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 4:58 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Mon, Jul 29, 2019 at 12:38 PM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> >
> > On Fri, Jul 26, 2019 at 02:23:46PM -0700, David Miller wrote:
> > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Date: Thu, 25 Jul 2019 22:35:08 +0300
> > >
> > > > The macro had never been used.
> > > >
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > >  ...
> > > > @@ -12,8 +12,6 @@
> > > >   * Copyright (C) 2012  Intel Corporation. All rights reserved.
> > > >   */
> > > >
> > > > -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > >
> > > If there are any kernel log messages generated, which is the case in
> > > this file, this is used.
> >
> > AFAICS no, it's not.
> > All nfc_*() macros are built on top of dev_*() ones for which pr_fmt() is no-op.
> > If we would like to have it in that way, we rather should use dev_fmt().
> >
> >
> > > Also, please resubmit this series with a proper header posting containing
> > > a high level description of what this patch series does, how it is doing it,
> > > and why it is doing it that way.  Also include a changelog.
> >
> > Will do.
> >
> > Thank you for review!
> >
>
> Can you send out the latest series as v5?
> I got some new? patches from you, but a bit confused now.
>

Thanks for the cover-letter.

- Sedat -

[1] https://marc.info/?l=linux-netdev&m=156440732411578&w=2
