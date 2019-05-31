Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8183E31211
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfEaQQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:16:32 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42486 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfEaQQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:16:32 -0400
Received: by mail-ed1-f67.google.com with SMTP id g24so5697956eds.9;
        Fri, 31 May 2019 09:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ppoLqKJDwMX/G3QhRlPCGM9RObcFV44Iy8KgicrJiXs=;
        b=SpLk15XghWHHC7Bi5S3Uj5v4i/8WjSxU/ADXUgS2+JgBy2zYReu66dUfkDGSax9+S6
         I0zYKj/KTJ4f+N6yq31qAeZpBbv3kkocg2y/+V2yG9BnV2WSCLy4w7jh+kkjsOrDhd2K
         1S71iB8jk6cI8aUofw5p0eqGamNz36G39EA2uU7T3HzpJZvsBffqRkgurmjIu9l70Dyx
         utoqiduKY9VXwsX21gyErybse9IcZNOC9gA8QmmdkXRRkhj7rvvNWMiaxJdr3UPZyyCe
         S/kFdDQHQxbqFQbOG8++UHPHwfaUfFLswi1d385CfnK9q+3QzkQWU4G0/GwEPhoUouCQ
         1zlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ppoLqKJDwMX/G3QhRlPCGM9RObcFV44Iy8KgicrJiXs=;
        b=C3fkIM+vbKijOp3jrM7QzkMbbnAK6h0PdHWFfAOJ9D/AejBfKus/ip44mX605JtL2h
         RUhBrFpK9TUO6o4Emx10m41e4vq4Lb25vJeIVT4m3fc4ByjIxc46COYaFqjAgUaWlB/I
         DtsvE10Hi73YPc6OnzXS05qiMJtglZ3+IRoj8/CGUk5ltJYzsJQ33oCP1YXn904DVr7X
         wpS4CpMk7Azzx2LMpdpwGTwndjxAbZYfNBIQvn9C+YG7yqm+lEDD8DZ+P+TKLB4DtDpl
         +1jXDaKY9jtcnY39qi5yTa1keyoUmkKJORUjhyRAw1kP01Y1pm4vRtGJTyS2YVT6BvWu
         vZEQ==
X-Gm-Message-State: APjAAAUBJRK264nJAqzwKoW6mEHeUgBu5QKjbNwYRFGEeKiKVnGDdbjt
        RUlOZezCmE3kFvDHtjx4Byj/yN5rVC0xHwI9xJs=
X-Google-Smtp-Source: APXvYqxi6b0K6tTVfA1e0P5XeyJhKW3LdF7NuYrIjBe58v9itIap09JseWXs29+ym3u4i5kdCNQnCDnTjBdfDOxf3ws=
X-Received: by 2002:a50:fd0a:: with SMTP id i10mr12161284eds.117.1559319389427;
 Fri, 31 May 2019 09:16:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190530143037.iky5kk3h4ssmec3f@localhost> <CA+h21hpp68AEEykxr8bJB=uJ+b0tg881Z7Ao_OfbTAXNxS8WgQ@mail.gmail.com>
 <20190530150557.iur7fruhyf5bs3qw@localhost> <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
 <20190531043417.6phscbpmo6krvxam@localhost> <CA+h21hp9DfW3wFy4YbHMU31rBHyrnUTdF4kKwX36h9vHOW2COw@mail.gmail.com>
 <20190531140841.j4f72rlojmaayqr5@localhost> <CA+h21hroywaij3gyO0u6v+GFVO2Fv_dP_a+L3oMGpQH8mQgJ5g@mail.gmail.com>
 <20190531151151.k3a2wdf5f334qmqh@localhost> <CA+h21hpHKbTc8toPZf0iprW1b4v6ErnRaSM=C6vk-GCiXM8NvA@mail.gmail.com>
 <20190531160909.jh43saqvichukv7p@localhost>
In-Reply-To: <20190531160909.jh43saqvichukv7p@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 31 May 2019 19:16:17 +0300
Message-ID: <CA+h21hpVrVNJTFj4DHHV+zphs2MjyRO-XZsM3D-STra+BYYHtw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] PTP support for the SJA1105 DSA driver
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 May 2019 at 19:09, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Fri, May 31, 2019 at 06:23:34PM +0300, Vladimir Oltean wrote:
> > You mean to queue it and subvert DSA's own RX timestamping callback?
>
> No, use the callback.
>
> > Why would I do that? Just so as not to introduce my .can_timestamp
> > callback?
>
> Right, the .can_timestamp is unneeded, AFAICT.
>
> > > Now I'm starting to understand your series.  I think it can be done in
> > > simpler way...
> > >
> > > sja1105_rcv_meta_state_machine - can and should be at the driver level
> > > and not at the port level.
> > >
> >
> > Can: yes. Should: why?
>
> To keep it simple and robust.
>
> > One important aspect makes this need be a little bit more complicated:
> > reconstructing these RX timestamps.
> > You see, there is a mutex on the SPI bus, so in practice I do need the
> > sja1105_port_rxtstamp_work for exactly this purpose - to read the
> > timestamping clock over SPI.
>
> Sure.  But you schedule the work after a META frame.  And no busy
> waiting is needed.

Ok, I suppose this could work.
But now comes the question on what to do on error cases - the meta
frame didn't arrive. Should I just drop the skb waiting for it? Right
now I "goto rcv_anyway" - which linuxptp doesn't like btw.

>
> Thanks,
> Richard
