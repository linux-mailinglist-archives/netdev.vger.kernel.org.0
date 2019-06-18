Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D25F34AB61
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 22:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbfFRUFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 16:05:20 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44938 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729331AbfFRUFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 16:05:20 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so23459731edr.11;
        Tue, 18 Jun 2019 13:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KWnI481UmCPDjIZ0XrCY42jsxMovXIO86L/MeMLISRM=;
        b=n0KpQEdSGQ5PKuTkB+/Z06u4nECf6mkQJz7Meo5OnYtsgDl9meBsiq2o00SAdXNvet
         TTZnNi4aG81ep1rsOQ8bk27QDuNzIaEBHYHNCna/jJ3ZA0e/oihc+yT36MSr0WpbMkvm
         GmmY4tcpSFcxjVLPzAmitdto6JN00+J3BuG+IOnATyFlzwZ++y9lQmnJYKiUHTDNfBOV
         KEScEjf/R/o9RXWmtxuqWvS92gPK7Ifh/FzIPaSCgpt2iV87dA3DHuDM1FBKPfblIrTk
         3/Cez3+C6gwBf/Uab6uUaVzjgf5mngEVZQNwRe4lGCKRWhdGXHe4R2v4IsOtz2fjpnWl
         3gCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KWnI481UmCPDjIZ0XrCY42jsxMovXIO86L/MeMLISRM=;
        b=In4HBfPtd4k9ssz2Xcy8uoAXmbGyq2t8VtVnpMGzOkdXudsnsnsra6h2LD1rNu9oFG
         su1iPoJRNWOAdM9wC/U5GhD4GmggFVZB8SJzTgDIHr4E/icOkWONqLGMlhL4gzU/PkUv
         NA9rNnJT4Nb01o5nKEgWDA9Gag5r+tAn3EwXs3hTd5En23F6Un0dV4EQbkZoZ7LgEcJf
         dVaFj1jk/myu0PtqzaigRGmZXd8eWDbYrTXhL1uRqoWpvDV8O+TqPfAA4RUTZUoBI1Ut
         HoLBIwauL+Ng4Kgz+9Ej22cwuOPQVFxZS5Ho4kSvSWhxwkbVVTsjnyKl3Qp9qrAgf7XX
         HNmA==
X-Gm-Message-State: APjAAAUjQzUx88/QGkEfgyipqQB0DjmTXSKnvKhTUWAY5PZtp9RGWmb9
        uaRt4Su7HM4RxwbRQO4uVxisAckjQ2mEvNslq4w=
X-Google-Smtp-Source: APXvYqzqoo0HXHFjoJtbtPpzDUDsVTfLgbc+FKH9YUlmQ4CiuTBdrnO5gZfvmnGS+KnlnynqpcJaiC2XfJXdmzWQW9I=
X-Received: by 2002:a50:a53a:: with SMTP id y55mr110598370edb.147.1560888318156;
 Tue, 18 Jun 2019 13:05:18 -0700 (PDT)
MIME-Version: 1.0
References: <CA+FuTSfBFqRViKfG5crEv8xLMgAkp3cZ+yeuELK5TVv61xT=Yw@mail.gmail.com>
 <20190618161036.GA28190@kroah.com> <CAF=yD-JnTHdDE8K-EaJM2fH9awvjAmOJkoZbtU+Wi58pPnyAxw@mail.gmail.com>
 <20190618.094759.539007481404905339.davem@davemloft.net> <20190618171516.GA17547@kroah.com>
 <CAF=yD-+pNrAo1wByHY6f5AZCq8xT0FDMKM-WzPkfZ36Jxj4mNg@mail.gmail.com>
 <20190618173906.GB3649@kroah.com> <CA+FuTSdrphico4044QTD_-8VbanFFJx0FJuH+vVMfuHqbphkjw@mail.gmail.com>
In-Reply-To: <CA+FuTSdrphico4044QTD_-8VbanFFJx0FJuH+vVMfuHqbphkjw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 18 Jun 2019 16:04:42 -0400
Message-ID: <CAF=yD-L8ZRwVJmp4WJcNW-B_1JdSAM9QmMHOQJ=x_nd24v5Qnw@mail.gmail.com>
Subject: Re: 4.19: udpgso_bench_tx: setsockopt zerocopy: Unknown error 524
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Fred Klassen <fklassen@appneta.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 2:59 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Jun 18, 2019 at 1:39 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jun 18, 2019 at 01:27:14PM -0400, Willem de Bruijn wrote:
> > > On Tue, Jun 18, 2019 at 1:15 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Tue, Jun 18, 2019 at 09:47:59AM -0700, David Miller wrote:
> > > > > From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > > > > Date: Tue, 18 Jun 2019 12:37:33 -0400
> > > > >
> > > > > > Specific to the above test, I can add a check command testing
> > > > > > setsockopt SO_ZEROCOPY  return value. AFAIK kselftest has no explicit
> > > > > > way to denote "skipped", so this would just return "pass". Sounds a
> > > > > > bit fragile, passing success when a feature is absent.
> > > > >
> > > > > Especially since the feature might be absent because the 'config'
> > > > > template forgot to include a necessary Kconfig option.
> > > >
> > > > That is what the "skip" response is for, don't return "pass" if the
> > > > feature just isn't present.  That lets people run tests on systems
> > > > without the config option enabled as you say, or on systems without the
> > > > needed userspace tools present.
> > >
> > > I was not aware that kselftest had this feature.
> > >
> > > But it appears that exit code KSFT_SKIP (4) will achieve this. Okay,
> > > I'll send a patch and will keep that in mind for future tests.
> >
> > Wonderful, thanks for doing that!
>
> One complication: an exit code works for a single test, but here
> multiple test variants are run from a single shell script.
>
> I see that in similar such cases that use the test harness
> (ksft_test_result_skip) the overall test returns success as long as
> all individual cases return either success or skip.
>
> I think it's preferable to return KSFT_SKIP if any of the cases did so
> (and none returned an error). I'll do that unless anyone objects.

http://patchwork.ozlabs.org/patch/1118309/

The shell script scaffolding can perhaps be reused for other similar tests.
