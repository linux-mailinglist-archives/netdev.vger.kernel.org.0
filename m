Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C42C589BA
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfF0STW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:19:22 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40116 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfF0STW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 14:19:22 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so6576069wmj.5
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5v05SZJJckJSDJXXNu0rjdM9JJNGZobt85eUW28X+6s=;
        b=Jcjg3n9Q4cwdIRonnFpdmJ1VmGeQsolZVr0iVn2y5qLbph7BHzsJkU6szJNd7tnQBE
         mSuUCth0lWKXT6T288rRAwfJ0bpbtgl4FApCoRkztyp+D7tQF52q5z1N8Opz7cpScU4Z
         IZf+H0C/C9VZgJk5gJVpGHZ9erm7Qn535vxoudtWQLRU/2yEC53bLzOR/a58w3bKPPI1
         I3Qxiro4Jn8rPlHgWEe8vrZTF+VuqUeMn6SMs8fqLFDmTW3dVvMXz2jBW/niT60H3nr5
         uNBujRQxhOkKItiN1Pgq3hiy9JNrHbSqDMEEfcO/k0eZrkqRC8WQi8Kjk5WDupEmzHpd
         KG2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5v05SZJJckJSDJXXNu0rjdM9JJNGZobt85eUW28X+6s=;
        b=oPdsgG/YaxEJPBuonslu0aI231aGqFI3cIo2ODTPPstCQFDzX+siywFAx4TAMT7rsg
         A30uc2m0qF2IxDimzAkTdcGDp4FdU3RhhnpAH2XGUuZFU/TXWpyFW7rR04HdZB/vtASq
         UdHzv8GXB7QgUBX9+cTX045sHhw34F7pKZPiWjbY+gY29z2q5Lv2oeisbyfSNdisksz5
         rjWxGA7uxqs8sMjwPcaY8jy+uDW7i1nUKci7wQmqJw7tpgxQAA2LYZVFl8vrr+s2l6P8
         60EiE8dTRCIXM/V0myd4ICbtM9xbdirMFZ7v8ac/cRbODDe4fE2zDnw+vX+JUCd6JOpp
         nukw==
X-Gm-Message-State: APjAAAX7TC9gx3R1Pk7hwzbBAKP3hSfgqV0m/a8HxTz4WOfA9TMA8+aY
        0BHh7qrg4JwuSK11OOv8tJxMqBtwdBPp6aLqDt4X+e/O
X-Google-Smtp-Source: APXvYqxP6/Wy3ws2EU3h2/taMwXTSN+gOytIBrEa4JJ0aREVvlSczUoEJM7V7oTTNZeMVbbrpYHtz7UF+OxQJmiNSgc=
X-Received: by 2002:a1c:6a06:: with SMTP id f6mr4059490wmc.159.1561659559837;
 Thu, 27 Jun 2019 11:19:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190622004539.92199-1-maheshb@google.com> <20190627.110852.372215308913618999.davem@davemloft.net>
In-Reply-To: <20190627.110852.372215308913618999.davem@davemloft.net>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Thu, 27 Jun 2019 11:19:02 -0700
Message-ID: <CAF2d9jj2ijVaqgkzjGFdjtX9fOaiehE=owucwfaqX159v9u8Zw@mail.gmail.com>
Subject: Re: [PATCH next 3/3] blackhole_dev: add a selftest
To:     David Miller <davem@davemloft.net>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, michael.chan@broadcom.com,
        dja@axtens.net, mahesh@bandewar.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 11:08 AM David Miller <davem@davemloft.net> wrote:
>
> From: Mahesh Bandewar <maheshb@google.com>
> Date: Fri, 21 Jun 2019 17:45:39 -0700
>
> > --- a/tools/testing/selftests/net/Makefile
> > +++ b/tools/testing/selftests/net/Makefile
> > @@ -4,8 +4,9 @@
> >  CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g
> >  CFLAGS += -I../../../../usr/include/
> >
> > +<<<<<<< HEAD
> >  TEST_PROGS := run_netsocktests run_afpackettests test_bpf.sh netdevice.sh \
>
> Ummm... yeah... might want to resolve this conflict...
>
oops, my bad! Let me send v2
> :-)
