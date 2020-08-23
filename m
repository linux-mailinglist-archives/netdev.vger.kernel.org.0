Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CC324EF63
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 21:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgHWTMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 15:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgHWTMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 15:12:13 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0568C061573
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 12:12:13 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g6so1157841pjl.0
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 12:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZzcPv7RWGyRjVrpxVSIcaVugJVwqXVQuedC7u/ct2pQ=;
        b=QxCyEw+x1dsOj9zFF5RL6De7zHdwJR0HIagfNKD5aJqHF4QU0vyPGVS8ve2o7tE6Cj
         9ZGTjgxjLT5E2Gg0sOv+vjj0MmXn1Gku2sK9o+vo/+Wtg1IfmwQG2z3hlFtJdMvISVqX
         ALx/8QPrVIu2me7wWlrhN6AK33IMYKovaa2qfhn3v+cuDvHdEERNTHk5Sv/d7MhBu1qg
         ygDcILv3EuJnLXcWDRIuULFmuVfD9GJHUGnIcssU3NgfBoS/6rth/04iedjyO8iA+3QJ
         49qyJxiv8QeFk6lvv0hGWijaRHokOJyn86Hj340fpMprwAmzFSzEjwbuzmjslNoH9wbV
         fmSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZzcPv7RWGyRjVrpxVSIcaVugJVwqXVQuedC7u/ct2pQ=;
        b=s9ruacsm+8Q2qjMBwNv9pqypuwTdC7opyvRRUHIDkQ6ktVswTAMZlw/HUsQG7sKJ5J
         71AI2DbmkLr839QzpoIQWfDTqgUi7xkpMzQ0iIcXKOGzA79CTXVq4CQ4GoAEjiZrJ8QU
         OU72czJmPQ+Dq8RFxdOUJkpZ0pFI+yY2Ppsu6Bo6nT5LLY2VL2mnbEdBejU9dS/AjzF1
         0w2syjT+hRTmzfEPK3qneQnNOLyeza15du6X4KCLW6SAPzUqQKEW+9ECkPnuGBVGtvVO
         hYzguEKeG9YWfHdECuKVuZrjZ6GFLy+uncwJcosDf4tAZxaH3DT5Nk9ZamEkGqs42brd
         TM1g==
X-Gm-Message-State: AOAM531l+0HDRchkecj3D9H+/jsC99MuLcKWPxv9tVMZCC1NZeHcmI/k
        0zqWYMd3UqEwAkm6Yo/rC9hcDABCN23HYUlDrL8=
X-Google-Smtp-Source: ABdhPJz4HuT/j5AVMsal7irCM72uaiAOvBv+Vg1jMRP10+sYl9hRBL2gwGPxeAjJB7dWyrRXjOkSvCZZshZ/eAU+eeg=
X-Received: by 2002:a17:902:8543:: with SMTP id d3mr1529932plo.244.1598209932724;
 Sun, 23 Aug 2020 12:12:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAD=jOEY=8T3-USi63hy47BZKfTYcsUw-s-jAc3xi9ksk-je+XA@mail.gmail.com>
In-Reply-To: <CAD=jOEY=8T3-USi63hy47BZKfTYcsUw-s-jAc3xi9ksk-je+XA@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sun, 23 Aug 2020 12:12:01 -0700
Message-ID: <CAJht_EPrOuk3uweCNy06s0UQTBwkwCzjoS9fMfP8DMRAt8UV8w@mail.gmail.com>
Subject: Re: Regarding possible bug in net/wan/x25_asy.c
To:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        andrianov <andrianov@ispras.ru>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 23, 2020 at 8:28 AM Madhuparna Bhowmik
<madhuparnabhowmik10@gmail.com> wrote:
>
> sl->xhead is modified in both x25_asy_change_mtu() and
> x25_asy_write_wakeup(). However, sl->lock is not held in
> x25_asy_write_wakeup(). So, I am not sure if it is indeed possible to
> have a race between these two functions. If it is possible that these
> two functions can execute in parallel then the lock should be held in
> x25_asy_write_wakeup() as well. Please let me know if this race is
> possible.

I think you are right. These two functions do race with each other.
There seems to be nothing preventing them from racing. We need to hold
the lock in x25_asy_write_wakeup to prevent it from racing with
x25_asy_change_mtu.

By the way, I think this driver has bigger problems. We can see that
these function pairs are not symmetric with one another in what they
do:
"x25_asy_alloc" and "x25_asy_free";
"x25_asy_open" and "x25_asy_close";
"x25_asy_open_tty" and "x25_asy_close_tty";
"x25_asy_netdev_ops.ndo_open" and "x25_asy_netdev_ops.ndo_stop".

This not only makes the code messy, but also makes the actual runtime
behavior buggy.

I'm planning to fix this with this change:
https://github.com/hyanggi/linux/commit/66387f229168014024117d50ade01092e3c9932c
Please take a look if you are interested. Thanks!

Thanks,
Xie He
