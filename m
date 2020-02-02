Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A31F14FD09
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 13:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgBBMOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 07:14:33 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40095 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgBBMOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 07:14:33 -0500
Received: by mail-lf1-f65.google.com with SMTP id c23so7813575lfi.7
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 04:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=niTIOrnciGEkdW3zMb8N3PdCWHDi6n2D+UwUUOrATeM=;
        b=OekF5yiMHTjO4fDrXOqQGFGplfkyC+3CKM+3EiYnq2VmU6qriU0HaA66gEM3ZM0wZ5
         SfdWcvWmgVqjGUI6UEOa7OWBxaV+g3rnogcB70xpjMgN5HPkvwu6GuSEs0PISZpBzp4K
         C3NGgbSm8DiTkG4l/7zusM1vsW2cttib/RPk92Wfdyr7LUrpIF67aRLevATNbXkqzu/P
         fKL9TwDNkVZgy5LqogOcG+Xgv7i1TEGyhcZHngj+zU2xZIU6lIuNeefXLPUOgsdZsN3K
         ut/nVKncTADKFW2v3d+pjqvspCQ4Mg/Ge1GSxXovD5kaa/KwDUlFN6Esxt2PqZfrbYVo
         Gbdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=niTIOrnciGEkdW3zMb8N3PdCWHDi6n2D+UwUUOrATeM=;
        b=PJNWMqbDo0ET9fJJ4CkMDgXsgRx8+1DG5lUNFgkzhL1u8Ng7xey1MhZH5kbxiOv144
         pgCrGhflx36ucBPauQaDJwWiO8rGaQ5XLt9sFidTSXbeixybupv6WIQBWtpzVlI+1bAp
         3pWpFYSjZoq9xiCnYcHFhG46R2UXEwum7cW2VzMjULE8A8TY21jHvFofCCwyD5du1t6k
         qdsdD2YLmMUL/o7s2em8+QcswrUbpxx4oE8D8aE8xoS0BehUgb+PzvWefEMMY3GroBHp
         /CPqBuVMfUMyo1xlHXSOE7Na7JtxsL03h1TPycxpMOTCGMH1jbW56K0G5ZR12WqWrkaD
         NLgg==
X-Gm-Message-State: APjAAAVi+fofNiYbsPIEdVA2H4z0IcVeBS8Uibqv6krQGQgKR2M7Ykc2
        yEsBDHsPOP2KgLQw+cxWrkq4L80NofGmGcKZNP8wK9pe
X-Google-Smtp-Source: APXvYqxdzVYriwg7Hju5PN9GKH1io2RqnCIrJ7aFaNB5nA0jgeSOfFnPnMNeUYL4RFbtzx4Mn6iFFEnrb54oDaMifvQ=
X-Received: by 2002:ac2:5478:: with SMTP id e24mr9572284lfn.58.1580645670838;
 Sun, 02 Feb 2020 04:14:30 -0800 (PST)
MIME-Version: 1.0
References: <20200127143015.1264-1-ap420073@gmail.com> <20200127200414.41a6d521@cakuba>
 <CAMArcTV7jxsYEQ29Ga9Q-DeMsMnfPAtu95TU=afMA4f-eAJmHA@mail.gmail.com> <20200201092320.10a3381b@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200201092320.10a3381b@cakuba.hsd1.ca.comcast.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 2 Feb 2020 21:14:19 +0900
Message-ID: <CAMArcTW6MCoVKF27Be3wabUKDBwoFe8wNm7R0CO70ZVfZO3j2g@mail.gmail.com>
Subject: Re: [PATCH net v2 2/6] netdevsim: disable devlink reload when
 resources are being used
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Feb 2020 at 02:23, Jakub Kicinski <kuba@kernel.org> wrote:
>

Hi Jakub,

> On Sat, 1 Feb 2020 18:37:58 +0900, Taehee Yoo wrote:
> > > > +     mutex_lock(&nsim_bus_dev_ops_lock);
> > >
> > > Not sure why we have to lock the big lock here?
> >
> > The reason for using this lock is to protect "nsim_dev".
> > nsim_dev_take_snapshot_write() uses nsim_dev.
> > So if nsim_dev is removed while this function is being used,
> > panic will occur.
> > nsim_dev is protected by nsim_bus_dev_ops_lock.
> > So, this lock should be used.
>
> I see.
>
> > But, I found deadlock because of this lock.
> > Structurally, this lock couldn't be used in snapshot_write().
> > So, I will find another way.
>
> Could we perhaps use the lock in struct device? Seems like it would
> be a good fit for protecting nsim_dev?

Thank you for your suggestion!

There is a lock in the struct device, which is "mutex".
This lock is used by wrapper function "device_lock()".
I think this lock is usually used for protecting members of the struct
device in device driver core logic.
And I think that both variables "nsim_dev" and "nsim_dev->dummy_region"
are not the actual member of the struct device.
nsim_dev and nsim_dummy_region would be allocated and freed independently
of struct device. So, I don't know device_lock() is fit for protecting
nsim_dev and nsim_dev->dummy_region.

I already sent a v3 patchset, which has a patch to avoid this problem.
The way of this is to use internal debugfs synchronize routine.
debugfs_remove() internally waits for opened users.
So, If we remove debugfs file before removing nsim_dev and
nsim_dev->dummy_region, the use-after-free case will not occur.
And it doesn't need an additional lock. So the performance would be
a little bit better.

Thank you!
Taehee Yoo
