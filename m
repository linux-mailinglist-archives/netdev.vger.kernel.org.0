Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDCBC125E89
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 11:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfLSKH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 05:07:59 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:45445 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbfLSKH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 05:07:59 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d951a01c;
        Thu, 19 Dec 2019 09:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=grSjh8ZYo6kNeSpD6HM/l+7r1Mo=; b=FV3R3e
        Z6vTu1Jr9LLECtX9dsaP1iiZ+lIz33emDMD/YS2L4FJB/MyhPSeZHv2KIVIYOAtv
        QRDW3qwEVNWSfqry1i+rS0huWRSvMDrUzYT/QMV9ezVh+WJkkMgQPoFh2YI237hK
        4HbuJHjVkCzVQ0Kmv135pe/9AdelFZS36CbwrZugN2P7tlHc7YFE0qEnshUi6/E4
        lwlEfa/NwBcPfIlkygjnTofXbR0pZwWLI4rQWCqyJZvSoeHdk0AGhDbK4IzZs756
        vAZ/Zp21022VIZe7OvZJ4X13jYZAqkdEGUEyaHm2B6rFQ+Ir3h1nKfrDVvnh/ElS
        kbJ5jAYRG40RwveQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3f89190a (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 19 Dec 2019 09:11:15 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id w1so6592527otg.3;
        Thu, 19 Dec 2019 02:07:55 -0800 (PST)
X-Gm-Message-State: APjAAAXzTUvVKi21zlhv2EqryQPE7eu6as1VO8E6JYfOHw8RZqywGfzH
        5kEA/gWw6MXV6lYmPYezSZJZ2NfKrDH6Y5z/8oE=
X-Google-Smtp-Source: APXvYqzwOVzplTvcddAygWVCVuqVraVrkajgnmf85Z8HESCRMPzl+88fjE14dVdEE+NGWAqidEvjjCceKSo3+7NE680=
X-Received: by 2002:a9d:4f18:: with SMTP id d24mr2423429otl.179.1576750074960;
 Thu, 19 Dec 2019 02:07:54 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
 <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
 <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com> <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com>
In-Reply-To: <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 19 Dec 2019 11:07:43 +0100
X-Gmail-Original-Message-ID: <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com>
Message-ID: <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: WireGuard secure network tunnel
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 10:35 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> > Is this precise enough for race
> > condition bugs?
>
> It's finding lots of race conditions provoked bugs (I would say it's
> the most common cause of kernel bugs).

I meant -- are the reproducers it makes precise enough to retrigger
network-level race conditions?

> Well, you are missing that wireguard is not the only subsystem
> syzkaller tests (in fact, it does not test it at all) and there are
> 3000 other subsystems :)

Oooo! Everything is tested at the same time. I understand now; that
makes a lot more sense.

I'll look into splitting out the option, as you've asked. Note,
though, that there are currently only three spots that have the "extra
checks" at the moment, and one of them can be optimized out by the
compiler with aggressive enough inlining added everywhere. The other
two will result in an immediately corrupted stack frame that should be
caught immediately by other things. So for now, I think you can get
away with turning the debug option off, and you won't be missing much
from the "extra checks", at least until we add more.

That's exciting about syzcaller having at it with WireGuard. Is there
some place where I can "see" it fuzzing WireGuard, or do I just wait
for the bug reports to come rolling in?

Jason
