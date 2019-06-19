Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC08B4AF19
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 02:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbfFSAi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 20:38:58 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:33841 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfFSAi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 20:38:58 -0400
Received: by mail-ed1-f47.google.com with SMTP id s49so24449566edb.1;
        Tue, 18 Jun 2019 17:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bzqQ+p0cZVycGM5xoroio2oFHWU/EFJ7b4KcGZXlaeg=;
        b=HN7jxVczRQw8BuODliUaJx1krrC5u0bSv6wNlzTeiaqxI5/WxtVswZ3/DAWD3LA5YL
         Y4gfFvi+vdPHwY/bthNBq0K4X5A4wkbn/CJSKU+yQF80lHT3Ml2rM1UgkGs9mKdS6+ht
         VHyufg+NObVes7lMGYtjCZKxeMJOMk4tXMNWgWvvSjy71Wq2AEHIByUOIvEz0cBuZ/Xn
         hl8/zmqnKCTgz4hPtyq1O7QGfbDe+sgnz5pfCJzXH3iX1/1YxGLL1miyo79m1tQDcX75
         UeICZSDBK3SsYI9YBBDuXE6F98sbyGg7BrtQoadRSa3hewpRQkIPWgF+Rf69Nxd44/Ua
         2Dvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bzqQ+p0cZVycGM5xoroio2oFHWU/EFJ7b4KcGZXlaeg=;
        b=bMDrGpGyRinb958rmRD+SfWzQnwkI7kPx0STyP88utqpjuQ2Vx2ckVnMv/JVlZjY0/
         rr35q+pYRKXQHByl0qaV+yEpKtfIecCAwoBp8mEdip+3Hvhl9xr+Dt3a6znfwmiX4S2k
         hiR4chahwlbrDVheyixQVC+7v9+tn3bYyN2+lwTd56oP+HJIwTe+oB8GGdyySEtCxcqz
         ob/ZUJHUZ8Vbk8oyTQ28I6CaxA8OeMeC5decS0yipGoxI6ro3LVX7WpMejtaA/9kxRmT
         HGdsJBqUD4+4lxs4GeQftf9fJhgoA8wsFbsIzLO4rgWIrEAZveufpvtQa0ioz5m4ba6L
         zH9w==
X-Gm-Message-State: APjAAAVHWTSQAbf9iuuqPJ0SE1dNEk8tCLyuDnAy9qKbpqRK6cH6cSwa
        njOTMFOIZB358y3p7X/O7OVpBmivYTd8E/62bJM=
X-Google-Smtp-Source: APXvYqz2nfPfBq4jE5jWuxHzrHdBZZE1KQ51bus1GR9GIax2909JzFg58fQoGJ5fTXlFX/pPbOunF2yaU9+f9tl+EgY=
X-Received: by 2002:a50:9153:: with SMTP id f19mr21543708eda.70.1560904736103;
 Tue, 18 Jun 2019 17:38:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAF=yD-+pNrAo1wByHY6f5AZCq8xT0FDMKM-WzPkfZ36Jxj4mNg@mail.gmail.com>
 <20190618173906.GB3649@kroah.com> <CA+FuTSdrphico4044QTD_-8VbanFFJx0FJuH+vVMfuHqbphkjw@mail.gmail.com>
 <20190618.184409.2227845117139305004.davem@davemloft.net>
In-Reply-To: <20190618.184409.2227845117139305004.davem@davemloft.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 18 Jun 2019 20:38:19 -0400
Message-ID: <CAF=yD-JPxx8EQ6ezs5dm+hsXQc8BVTLU8RnMLcw8qYR=OcU8XQ@mail.gmail.com>
Subject: Re: 4.19: udpgso_bench_tx: setsockopt zerocopy: Unknown error 524
To:     David Miller <davem@davemloft.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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

On Tue, Jun 18, 2019 at 6:44 PM David Miller <davem@davemloft.net> wrote:
>
> From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date: Tue, 18 Jun 2019 14:58:26 -0400
>
> > I see that in similar such cases that use the test harness
> > (ksft_test_result_skip) the overall test returns success as long as
> > all individual cases return either success or skip.
> >
> > I think it's preferable to return KSFT_SKIP if any of the cases did so
> > (and none returned an error). I'll do that unless anyone objects.
>
> I guess this is a question of semantics.
>
> I mean, if you report skip at the top level does that mean that all
> sub tests were skipped?  People may think so... :)

Yes, it's not ideal. Erring on the side of caution? Unlike pass, it is
a signal that an admin may or may not choose to act on. I run a
selected subset of tests from tools/testing that are all expected to
pass, so if one returns skip, I would want to take a closer look.
