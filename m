Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144342C017A
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 09:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgKWIbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 03:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgKWIbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 03:31:49 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C509C0613CF;
        Mon, 23 Nov 2020 00:31:48 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id b6so3793727pfp.7;
        Mon, 23 Nov 2020 00:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A2OCYPW48+EaJEiSvyQJ2+kFYlsiz/LUK7yoFIj7s/0=;
        b=ARYHclAhefMjQHT4pgy8KkNlOofEUe0LkbQSPGkdnzqUV2+hD6tBxSunTjYE5sCLw5
         uvuR9gciPL3KO0c8LfdT/WsDQyWWd+8g4+W/ZeM7hApLOw7CHS6PwFO0uXjUfPIpW8Rd
         atZazrkI4VZL27dree/jNephYhEoySeNnC0jFyiocUZ8WlGVYoIqytNkHjT/0gmiGaOx
         S2qdJszwvrGaAonzGFg9OAPsvqYO5yNiCoSt7nS2C8dHNUDX2EvA1Pa+Sj0kgJawS9td
         uJZB6Sp8xX5ouYYG2dtlYMSJ4/ani1XY3s1n5qXaCSlAnTxylkV4YOteyF2R5YeO31N9
         txqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A2OCYPW48+EaJEiSvyQJ2+kFYlsiz/LUK7yoFIj7s/0=;
        b=qA6MKfmz51/1KbXqXchcmjyinHT+QZPAiuQj+ZGXw/UQw15r2ohlIEbL5u/OWzTGUc
         dIB15d2Qy2TTdw94thjsPhTLcp6H6u47NXt/+re7dAqGROarapodTMfC4a6Z59UHGxAN
         Ks8xomn8BZ8bxzFD/B7KsPSL8qvhMdE4b4o6VaCstj7LUvFG05T72mPDkKb6tFjHy/Ys
         WyfRFKEzQFi8ZMnx8380hBx633h9KHSbiJfHadzIyvOcZzBo3l8j/yTIyxnJw3WnsUPv
         BPgJgjviO5tFqkiacpSwWNUamjLR1XXs5HS3Om85pABBDRNLkxUkCvAqfP/QMdsYitPI
         wemQ==
X-Gm-Message-State: AOAM533XJu/KPXzlmqlX4zdkzhemTJCNo7INnXMpLnWo2/PkN2i0Zc8E
        sY7sQ+BEYjEAGTIxj98x/ZY8Z4hDL7/sZN0dHajpI51wcMw=
X-Google-Smtp-Source: ABdhPJyxRfMW6NRCYI589d8PdoA0y+Re41zIClMnGwIgTP3GCGEMMmHLctaZH8yt14IL9Xa5GUD3Cegsb3DsGBGuwSw=
X-Received: by 2002:a65:560b:: with SMTP id l11mr27674361pgs.63.1606120307543;
 Mon, 23 Nov 2020 00:31:47 -0800 (PST)
MIME-Version: 1.0
References: <20201120054036.15199-1-ms@dev.tdt.de> <20201120054036.15199-3-ms@dev.tdt.de>
 <CAJht_EONd3+S12upVPk2K3PWvzMLdE3BkzY_7c5gA493NHcGnA@mail.gmail.com>
 <CAJht_EP_oqCDs6mMThBZNtz4sgpbyQgMhKkHeqfS_7JmfEzfQg@mail.gmail.com> <87a620b6a55ea8386bffefca0a1f8b77@dev.tdt.de>
In-Reply-To: <87a620b6a55ea8386bffefca0a1f8b77@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 23 Nov 2020 00:31:36 -0800
Message-ID: <CAJht_EPc8MF1TjznSjWTPyMbsrw3JVqxST5g=eF0yf_zasUdeA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/5] net/lapb: support netdev events
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 10:55 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> No, they aren't independent. The carrier can only be up if the device /
> interface is UP. And as far as I can see a NETDEV_CHANGE event will also
> only be generated on interfaces that are UP.
>
> So you can be sure, that if there is a NETDEV_CHANGE event then the
> device is UP.

OK. Thanks for your explanation!

> I removed the NETDEV_UP handling because I don't think it makes sense
> to implicitly try to establish layer2 (LAPB) if there is no carrier.

As I understand, when the device goes up, the carrier can be either
down or up. Right?

If this is true, when a device goes up and the carrier then goes up
after that, L2 will automatically connect, but if a device goes up and
the carrier is already up, L2 will not automatically connect. I think
it might be better to eliminate this difference in handling. It might
be better to make it automatically connect in both situations, or in
neither situations.

If you want to go with the second way (auto connect in neither
situations), the next (3rd) patch of this series might be also not
needed.

I just want to make the behavior of LAPB more consistent. I think we
should either make LAPB auto-connect in all situations, or make LAPB
wait for L3's instruction to connect in all situations.

> And with the first X.25 connection request on that interface, it will
> be established anyway by x25_transmit_link().
>
> I've tested it here with an HDLC WAN Adapter and it works as expected.
>
> These are also the ideal conditions for the already mentioned "on
> demand" scenario. The only necessary change would be to call
> x25_terminate_link() on an interface after clearing the last X.25
> session.
>
> > On NETDEV_GOING_DOWN, we can also check the carrier status first and
> > if it is down, we don't need to call lapb_disconnect_request.
>
> This is not necessary because lapb_disconnect_request() checks the
> current state. And if the carrier is DOWN then the state should also be
> LAPB_STATE_0 and so lapb_disconnect_request() does nothing.

Yes, I understand. I just thought adding this check might make the
code cleaner. But you are right.
