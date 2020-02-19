Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A95EA1652D9
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgBSW76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:59:58 -0500
Received: from mail-yw1-f49.google.com ([209.85.161.49]:42104 "EHLO
        mail-yw1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbgBSW75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 17:59:57 -0500
Received: by mail-yw1-f49.google.com with SMTP id b81so962430ywe.9
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 14:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uM9wkPObDVoTHhD67VrlBruuVZwMvRvX12Z15lYmKr8=;
        b=JrWNqCZCl1CKhl5f7HXjDcAsL/p7jBSDjNo0qz4EBNoVImJYQcoV18/hwSGLFYakvO
         JWw2ZTzsqenMSUFA6mq1+w2xrdxvxcsAwPE0AfSEop+UrIprZRTzO/nCYDo3ggPlMDMv
         iQusoLwbVEsZkPVNT6l0HSD1z7elII2nT6aTBpQ022/BO8vBwNNrFCBUt06grinR4lMi
         MBIe3RlUMdrn0gBxl5Ryn4WKwKHmdeqSC7+YGjaAi/ubucZVCdDrtaNZ97T2NuUzUa+N
         9sLl4IsZECps/MsVIgkqazOUOoj2kRQYrTc9Qa+dKxjH4Eez6YkcBCtMzFgZKbBmBkOy
         9gmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uM9wkPObDVoTHhD67VrlBruuVZwMvRvX12Z15lYmKr8=;
        b=QZmc06/IvwxKnZMvjYaWrStl3UVpHGTSTBPixsXg9pIIeOadrCVuE7B/ijWxzefH4T
         gou836HmtUei4XVf/Uf9egj8ukEMVis2/+MYzbK4xNAs/DKR2vCFIfCJ+rd+Lza4mUEb
         VjjVtBv8V+psEKogQLpwAwc5WwNGQSaS/+wJfVYBXs/xRkjQi8APHzXDzrryKA33lell
         tl7ubBiL2QkT7aDLYMVE1fc81TTokBhHfJPmmCZSF/PkKj2z+7ndTpBXmAlBYe4q4Qow
         Gjo+PDi6QvB4mfNINc5v9lybpCRbTEyo8wFAgMXPLVaYyNJP6WZtIwAE88NfOSKukdIW
         292w==
X-Gm-Message-State: APjAAAVOV4j4s+ib2prPGh9mB6TO3FSmqHJLZUX6NObsdBEMGnNn1jFi
        zvjPMZAk0BJozZunjxOAnYHhJCQX
X-Google-Smtp-Source: APXvYqxR8pZPv9d6+nxA6BikqBklqUuW04mqB8WJI/UqvoFu8NgzbcOanB53P0KCQWzvqryCiVUcYw==
X-Received: by 2002:a81:8686:: with SMTP id w128mr22469904ywf.15.1582153196356;
        Wed, 19 Feb 2020 14:59:56 -0800 (PST)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id w128sm637178ywf.72.2020.02.19.14.59.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 14:59:55 -0800 (PST)
Received: by mail-yb1-f170.google.com with SMTP id z125so1197631ybf.9
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 14:59:55 -0800 (PST)
X-Received: by 2002:a25:b981:: with SMTP id r1mr27307748ybg.492.1582153193649;
 Wed, 19 Feb 2020 14:59:53 -0800 (PST)
MIME-Version: 1.0
References: <da2b1a2f-b8f7-21de-05c2-9a30636ccf9f@ti.com> <9cfc1bcb-6d67-e966-28d9-a6f290648cb0@ti.com>
In-Reply-To: <9cfc1bcb-6d67-e966-28d9-a6f290648cb0@ti.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 19 Feb 2020 14:59:16 -0800
X-Gmail-Original-Message-ID: <CA+FuTSeSouL4pFFo8kAcU4yZ7m6C2v_6OcGHXHWeEXXNFofzXA@mail.gmail.com>
Message-ID: <CA+FuTSeSouL4pFFo8kAcU4yZ7m6C2v_6OcGHXHWeEXXNFofzXA@mail.gmail.com>
Subject: Re: CHECKSUM_COMPLETE question
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 9:04 AM Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
>
> Hi All,
>
> On 12/02/2020 11:52, Grygorii Strashko wrote:
> > Hi All,
> >
> > I'd like to ask expert opinion and clarify few points about HW RX checksum offload.
> >
> > 1) CHECKSUM_COMPLETE - from description in <linux/skbuff.h>
> >   * CHECKSUM_COMPLETE:
> >   *
> >   *   This is the most generic way. The device supplied checksum of the _whole_
> >   *   packet as seen by netif_rx() and fills out in skb->csum. Meaning, the
> >   *   hardware doesn't need to parse L3/L4 headers to implement this.
> >
> > My understanding from above is that HW, to be fully compatible with Linux, should produce CSUM
> > starting from first byte after EtherType field:
> >   (6 DST_MAC) (6 SRC_MAC) (2 EtherType) (...                   ...)
> >                                          ^                       ^
> >                                          | start csum            | end csum
> > and ending at the last byte of Ethernet frame data.
> > - if packet is VLAN tagged then VLAN TCI and real EtherType included in CSUM,
> >    but first VLAN TPID doesn't
> > - pad bytes may/may not be included in csum

Based on commit 88078d98d1bb ("net: pskb_trim_rcsum() and
CHECKSUM_COMPLETE are friends") these bytes are expected to be covered
by skb->csum.

Not sure about that ipv4 header pull without csum adjust.
