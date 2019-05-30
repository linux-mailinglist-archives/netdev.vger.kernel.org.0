Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F172FF5A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 17:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfE3PXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 11:23:22 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41460 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfE3PXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 11:23:22 -0400
Received: by mail-ed1-f65.google.com with SMTP id y15so3692176edo.8;
        Thu, 30 May 2019 08:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RCDLlGYJgL0buQMnh0bUr8c4NmNRLG9BRcbGN/X5h/Q=;
        b=k6nQK2dzl0iWLlYN8CYEqKZE4VFAL46E1jtyi1SUqMGSVtsBy9PB6QAh437YVWIPic
         YURsvfCP5gmmpvZh0xEw3lOUE1RGzJPVwMPFSIdB0RAvMFYIk6M5pmdgKYoMJF8E3CpN
         WSIWRxIiOyScLZvJyQNwRC3tg81OCBGRk9PDisQhJA6aRGu38WUNsTG4JppPVBkvPjIV
         kG5lhKWIIUktk4MzDk7uKLbkCjPwdzhm/jpn55NrVf4RrRC4cGy231AxEDQTmQFEntiF
         KsZlAAkmYYTvUugUAa7kAk4yiM57MLsOjQG5geiy3mDx+23L1dnL4SElNWqMu8CnvdqX
         wrVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RCDLlGYJgL0buQMnh0bUr8c4NmNRLG9BRcbGN/X5h/Q=;
        b=MeOZLx+llBeCXRGg/E86mAVwXjPbysZNsG2NXP4B6jX8tgHN2WsG2OwsfUO52IZS3g
         PJj+O5scQsfuq0yfwTaQbqBSAg6ceA+JJyPbvffs2gDeqZpx9vzhreoTJlCeaHiXBiPA
         Qy4KpzcaeDw19fSOyawgxcIBs+Fv/gVoVfLgR+36n+AbJZt5x3Of0NWoMaFKQe8A1TeH
         5Skzqw724JyGL/RiMl+2VSFV/AWZ4yU8pivAUQGgKjvHOKynu9ND/sEaPOfZ87cTiDRB
         PlGeRj6S9cFZ1IMR6Vo3RMdYqzMjOaM23G7dYSdkx/OE4Ogz71ZWcGcGSCwX/O08sHMW
         +Wgg==
X-Gm-Message-State: APjAAAVHhSt6y9DlHz9SiaUu9kwVsaa4j5r384MgstNknok7gVLL+xel
        h6gjLHlyZYKT6luS1/7r/9FWoDMYgpHlrN6k3EE=
X-Google-Smtp-Source: APXvYqx3aJN/bOOORxGjvfzJUASMDGRGn7cpzALSAmSFcD4ex0V1B0UmE02xxaVGaMkibPxnihjvE3sVUi8INMdkZso=
X-Received: by 2002:aa7:ca47:: with SMTP id j7mr2711085edt.36.1559229800607;
 Thu, 30 May 2019 08:23:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190528235627.1315-1-olteanv@gmail.com> <20190529045207.fzvhuu6d6jf5p65t@localhost>
 <dbe0a38f-8b48-06dd-cc2c-676e92ba0e74@gmail.com> <20190530034555.wv35efen3igwwzjq@localhost>
 <CA+h21hpjsC=ie5G7Gx3EcPpazyxze6X_k+8eC+vw7JBvEO2zNg@mail.gmail.com>
 <20190530143037.iky5kk3h4ssmec3f@localhost> <CA+h21hpp68AEEykxr8bJB=uJ+b0tg881Z7Ao_OfbTAXNxS8WgQ@mail.gmail.com>
 <20190530150557.iur7fruhyf5bs3qw@localhost>
In-Reply-To: <20190530150557.iur7fruhyf5bs3qw@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 30 May 2019 18:23:09 +0300
Message-ID: <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
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

On Thu, 30 May 2019 at 18:06, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Thu, May 30, 2019 at 05:57:30PM +0300, Vladimir Oltean wrote:
> > On Thu, 30 May 2019 at 17:30, Richard Cochran <richardcochran@gmail.com> wrote:
> > >
> > > Not necessarily.  If two frames that arrive at nearly the same time
> > > get their timestamps mixed up, that would be enough to break the time
> > > values but without breaking your state machine.
> > >
> >
> > This doesn't exactly sound like the type of thing I can check for.
>
> And that is why it cannot work.
>
> > The RX and TX timestamps *are* monotonically increasing with time for
> > all frames when I'm printing them in the {rx,tx}tstamp callbacks.
>
> But are the frames received in the same order?  What happens your MAC
> drops a frame?
>

If it drops a normal frame, it carries on.
If it drops a meta frame, it prints "Expected meta frame", resets the
state machine and carries on.
If it drops a timestampable frame, it prints "Unexpected meta frame",
resets the state machine and carries on.
This doesn't happen under correct runtime conditions though.

-Vladimir

> > The driver returns free-running timestamps altered with a timecounter
> > frequency set by adjfine and offset set by adjtime.
>
> That should be correct.
>
> Thanks,
> Richard
