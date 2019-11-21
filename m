Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B65105117
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 12:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfKULHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 06:07:44 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:33495 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfKULHo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 06:07:44 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 88a73f4b;
        Thu, 21 Nov 2019 10:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type:content-transfer-encoding; s=mail; bh=61fXfe0NKcvB
        w4Cmm/ja0FOScFY=; b=vtSF7wZWkBeha5UYHrE8FnqSWUpC5AjG1seQCjGUgS1y
        5leda5Fst05ia/zT3iqtIHlNQc332cXRpJ4/VDcC21uBMjQtA0fW173PNm7+K3g+
        d2DHMusY0FbFG8C8IATbK96axfp1xwFRmZHDgIXfh2Xdkqiy2oxLjJHqKgXHvDf/
        WSKhRlvCf2mKVoQwXwRxBy4MQTlyJCoWD5LQKswuVKgJH2OdIh+YxQPlk7+UdMZp
        2lE8DiELGw5RsrsJYJyfyRDsckI715699ZjkHefG4WkDUUjYk8bTfAagIhtmBp2R
        tgCcy9H9YuN6QfyaDl9yD5bIbfaHkH6fliSzVdx6Iw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e550f2ca (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 21 Nov 2019 10:14:37 +0000 (UTC)
Received: by mail-oi1-f169.google.com with SMTP id s71so2764258oih.11;
        Thu, 21 Nov 2019 03:07:40 -0800 (PST)
X-Gm-Message-State: APjAAAV1zu/0BWjjtD9HcgpgX/1RXOIia9+S2sJhMIAIoDVrTx81T2Fe
        hNAFmRWNY2fuulb8gkuMUfev3AR+nlpRJ1A7Yek=
X-Google-Smtp-Source: APXvYqwPmTp2nkwJI5k2zldgO4vWMe6qszxEiAUe/OMq8cL+iGm0YkPWg1k+1+3UKuqspMztajBKI2eo8plROEGY/bY=
X-Received: by 2002:aca:af0c:: with SMTP id y12mr7355506oie.52.1574334459737;
 Thu, 21 Nov 2019 03:07:39 -0800 (PST)
MIME-Version: 1.0
References: <20191120203538.199367-1-Jason@zx2c4.com> <877e3t8qv7.fsf@toke.dk>
In-Reply-To: <877e3t8qv7.fsf@toke.dk>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 21 Nov 2019 12:07:28 +0100
X-Gmail-Original-Message-ID: <CAHmME9rmFw7xGKNMURBUSiezbsBEikOPiJxtEu=i2Quzf+JNDg@mail.gmail.com>
Message-ID: <CAHmME9rmFw7xGKNMURBUSiezbsBEikOPiJxtEu=i2Quzf+JNDg@mail.gmail.com>
Subject: Re: [PATCH RFC net-next] net: WireGuard secure network tunnel
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 11:29 AM Toke H=C3=B8iland-J=C3=B8rgensen
<thoiland@redhat.com> wrote:
> Could you please get rid of the "All Rights Reserved" (here, and
> everywhere else)? All rights are *not* reserved: this is licensed under
> the GPL. Besides, that phrase is in general dubious at best:
> https://en.wikipedia.org/wiki/All_rights_reserved

I've seen people make arguments for this in both ways, and code from
major corporation enters the kernel every day bearing that line, which
means lawyers of important kernel contributors disagree with you.
Neither one of us are lawyers. Lacking any wide scale precedent for
such changes, or the expertise to even be properly persuaded in any
direction, I follow the advice of my council to stick to the norm and
not to mess with copyright headers.

I think there are some Linux Foundation mailing lists that have
license lawyers on them, relating to SPDX mainly. Maybe we can ask
there?

> > +     MAX_QUEUED_INCOMING_HANDSHAKES =3D 4096, /* TODO: replace this wi=
th DQL */
> > +     MAX_STAGED_PACKETS =3D 128,
> > +     MAX_QUEUED_PACKETS =3D 1024 /* TODO: replace this with DQL */
>
> Yes, please (on the TODO) :)
>
> FWIW, since you're using pointer rings I think the way to do this is
> probably to just keep the limits in place as a maximum size, and then
> use DQL (or CoDel) to throttle enqueue to those pointer rings instead of
> just letting them fill.
>
> Happy to work with you on this (as I believe I've already promised), but
> we might as well do that after the initial version is merged...

I've actually implemented this a few times, but DQL always seems too
slow to react properly, and I haven't yet been able to figure out
what's happening. Let's indeed work on this after the initial version
is merged. I think this change, and several more like it, will be the
topic of some interesting discussions. But that doesn't need to happen
/now/ I don't think.
