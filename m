Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D29B140E92
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 17:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgAQQEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 11:04:52 -0500
Received: from mail-vk1-f195.google.com ([209.85.221.195]:43154 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgAQQEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 11:04:52 -0500
Received: by mail-vk1-f195.google.com with SMTP id h13so6787849vkn.10
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 08:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IWEBV/LXW44KxushBGBXu3NdJdEnQ+HBr71l0GfADms=;
        b=bD3clqDl5zKKUgcWCNHT5k/M+ATQeq5z/3n3tk6wPnbMWh1yU9xjzK36rALIncKWl4
         nR/bi3U79W53Je8tiduWiGfOCOpCKDKU+x+j12dE7aJaJ7KGiSDIACo2tTs+HMODrlQH
         HEm+26nwzLr0un+zcQvfZV9DHhehr6MTaftRilOUrNiLxMJX/EDleES8q5hLhrxJQL0L
         KEK9PIZO54aqsVPh0D+75dUGrI8OzmcrQIqooNRu+XPtMhD1ul7bLD8AwrVa12I7dAfh
         LYK3yVIZxmbG3uNo/p83KHbWcDlGHIvY/JdMF+EacAtapQzGASSC4ATKQ59qFjWDQtwG
         hbZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IWEBV/LXW44KxushBGBXu3NdJdEnQ+HBr71l0GfADms=;
        b=f8kwsidWn3fcUaSSbFsh3FdFRehiFmYVlJFQC5DJBQMBKKDwf8Q/2IZbZqcS5ua5hf
         3sW+7EhL2+1t79QXFtNTuPAJ1ZPpYGwr2XFJn/PuOuKgUOm4FdAtVsKLyYTaGzS+rna/
         OVrpVJuj9l2kQmdfwUZ796K5jHCodM83njGsJW+qlsAY9fvTNVnQxm2NBqeCHPuGf/I3
         ah3+gjDNUBsKeGuspmNd4iUy0uV2MVGXsfErCskM7X4nAswrqCi8wHxGcxhP1c8lUbIn
         yuC5S5qkDE8gOSmQUCdoDGxts0Kr1caoA1/YfPl+e0AUVNhogQiIN8VrterEKRkAmuKE
         tJgg==
X-Gm-Message-State: APjAAAUFsKcTdKSqsKM/ArSfwjl22TMVFLUOa8qNFL/GJSaCbJe9+hy/
        oFcuxS9xe3rrGpLGWLkL/hnKTDCbzkanBB1FDVo=
X-Google-Smtp-Source: APXvYqw/O7WthoEjdEwTG201D/JjZLbNjCNvQyu4r4zdTVkHFw2BinzSK63S85u+jkM/5JqGD81zeHgJh84l1gRYY08=
X-Received: by 2002:a1f:8cd5:: with SMTP id o204mr24449849vkd.66.1579277091011;
 Fri, 17 Jan 2020 08:04:51 -0800 (PST)
MIME-Version: 1.0
References: <CAH6h+hczhYdCebrXHnVy4tE6bXGhSJg4GZkfJVYEQtjjb-A-EQ@mail.gmail.com>
 <CACKFLimgUxTV7Cgg5dYtWtvTsWpOK538UtLmyyxP0tTaYOzL6g@mail.gmail.com>
In-Reply-To: <CACKFLimgUxTV7Cgg5dYtWtvTsWpOK538UtLmyyxP0tTaYOzL6g@mail.gmail.com>
From:   Marc Smith <msmith626@gmail.com>
Date:   Fri, 17 Jan 2020 11:04:40 -0500
Message-ID: <CAH6h+hevYD8DOr-NnRTNDB_ph2QNpCTyAJSrQJgvxwgYZ28MjQ@mail.gmail.com>
Subject: Re: 5.4.12 bnxt_en: Unable do read adapter's DSN
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 5:19 PM Michael Chan <michael.chan@broadcom.com> wrote:
>
> On Thu, Jan 16, 2020 at 2:08 PM Marc Smith <msmith626@gmail.com> wrote:
> >
> > Hi,
> >
> > I'm using the 'bnxt_en' driver with vanilla Linux 5.4.12. I have a
> > Broadcom P225p 10/25 GbE adapter. I previously used this adapter with
> > Linux 4.14.120 with no issues. Now with 5.4.12 I observe the following
> > kernel messages during initialization:
> > ...
> > [    2.605878] Broadcom NetXtreme-C/E driver bnxt_en v1.10.0
> > [    2.618302] bnxt_en 0000:00:03.0 (unnamed net_device)
> > (uninitialized): Unable do read adapter's DSN
> > [    2.622295] bnxt_en: probe of 0000:00:03.0 failed with error -95
> > [    2.632808] bnxt_en 0000:00:0a.0 (unnamed net_device)
> > (uninitialized): Unable do read adapter's DSN
> > [    2.637043] bnxt_en: probe of 0000:00:0a.0 failed with error -95
> > ...
>
> I have received a similar report about this issue recently.  I believe
> some kernels are not configured to read extended configuration space
> and so the driver's call to read the DSN would fail on such a kernel.
> This failure should not be considered a fatal error and the driver
> should continue to load.  I will send out a driver patch to fix this
> very shortly.

Thanks Michael for providing a patch so quickly! I'll try the patches
you posted in just a bit.

I'm curious though about your comment: Is there in a fact a kernel
config option I can enable for "extended configuration space support"?
I looked through the PCI support options in the kernel config menu on
5.4.x but nothing jumped out at me that sounded similar to this.

--Marc


>
> Thanks.
