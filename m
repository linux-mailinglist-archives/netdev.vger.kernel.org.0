Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04B996ACA
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbfHTUks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:40:48 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45127 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729887AbfHTUks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 16:40:48 -0400
Received: by mail-ed1-f67.google.com with SMTP id x19so204895eda.12
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 13:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cKjziNb0tm3NBeSrQFCw6/JHoDJddj41c21DoE2dFBM=;
        b=X7HSm46dRO5B4loA32NKE+0XbF0cciYN7nY9M0kWSSZN49VwOkcyAP3QLftfUUArUJ
         wQ5EOXmGCMREBCxBIsaX13fpJk5+NlVSomzAACct0UmjqLOZFx+uVbVNRTmbIvKPF9ft
         t62JpIBH3VqUERMY24exTMKiSskto6I5vN+kheO7XprBNLSD8EuBsNW/to6U0ogTRUG1
         jH9Q1WV1evDlBw98kXuRw2tgD02+cQHIlTwS2dgAK+PpE2KZEPnTa/i20C/YEFGxPxbO
         yIXmaXfU8JF+6L74M5m7VZPd2Psu3l1yFpELsIvV9sE9AwQ++4Xc8XRmU2CbU726xCYZ
         QaoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cKjziNb0tm3NBeSrQFCw6/JHoDJddj41c21DoE2dFBM=;
        b=h5JIl9kz7OudlxVZQM76phX3kEoA2I4ISbkuzm/pRnSGllxN9xjvk5E3SaKBV/dtlt
         x/HrcZX8USV9qmkTJLXg1FMY7bj273Yfuob63h+62ZBCtlx2jQcqHaGKS6vtfc2IQ7ST
         Q76kFOwavJBK7i94b9ymFb82oA0D/lltROA86KV8ew40LR3ls6bvAzQa2u/7qMHCbZ6r
         HpgmMomlmUWL0EraFe+/v5L+2HNS/RGEHS77TCshCkIO6SFgM3WWDOjFUo8OlyJta7K5
         CtrNYPNQKXwMwRzzHH3uccCKdAKyDsyX0C7GMKWa+Jix0+tPKXFqvkTy3Fp+rP89Fn6V
         sSZg==
X-Gm-Message-State: APjAAAWRippyZG0w18nYljDylIcrQWkmCHrH1TezKt2WJb6kTzSw19oR
        4hVYRi1SB9ryJgahhoFRI4d4MtWBihYC6mQZ0Qs=
X-Google-Smtp-Source: APXvYqxwC/tAKp0wh+mKiW0bGVYK6EEjQ2OTac/pDXqxv62jSvkiz3d4XFSg8cRJDLUmj2iGEkkuQjijsr1mw3xYf0g=
X-Received: by 2002:a17:906:f746:: with SMTP id jp6mr27549972ejb.32.1566333646026;
 Tue, 20 Aug 2019 13:40:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190820000002.9776-1-olteanv@gmail.com> <20190820000002.9776-4-olteanv@gmail.com>
 <20190820015138.GB975@t480s.localdomain> <CA+h21hpdDuoR5nj98EC+-W4HoBs35e_rURS1LD1jJWF5pkty9w@mail.gmail.com>
 <20190820135213.GB11752@t480s.localdomain> <c359e0ca-c770-19da-7a3a-a3173d36a12d@gmail.com>
In-Reply-To: <c359e0ca-c770-19da-7a3a-a3173d36a12d@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 20 Aug 2019 23:40:34 +0300
Message-ID: <CA+h21hqdXP1DnCxwuZOCs4H6MtwzjCnjkBf3ibt+JmnZMEFe=g@mail.gmail.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: Delete the VID from the upstream
 port as well
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Tue, 20 Aug 2019 at 22:40, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 8/20/19 10:52 AM, Vivien Didelot wrote:
> > Hi Vladimir,
> >
> > On Tue, 20 Aug 2019 12:54:44 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> >> I can agree that this isn't one of my brightest moments. But at least
> >> we get to see Cunningham's law in action :)
> >> When dsa_8021q is cleaning up the switch's VLAN table for the bridge
> >> to use it, it is good to really clean it up, i.e. not leave any VLAN
> >> installed on the upstream ports.
> >> But I think this is just an academical concern at this point. In
> >> vlan_filtering mode, the CPU port will accept VLAN frames with the
> >> dsa_8021q ID's, but they will eventually get dropped due to no
> >> destination. The real breaker is the pvid change. If something like
> >> patch 4/6 gets accepted I will drop this one.
> >
> > I wish Ward had mentioned to submit such academical concern as RFC :)
> >
> > Please submit smaller series, targeting a single functional problem each,
> > with clear and detailed messages.
>
> Also, I don't think this change set is useful per-se, if we take care of
> removing VLANs on user facing ports, and VLAN filtering is turned on,
> then a frame ingressing an user port with a VLAN that is not part of the
> VLAN table/entries should simply be discarded on ingress, or on egress
> to the CPU port (depending on where the switch performs VID checking),
> so the CPU port cannot possibly receive such a frame, and so removing it
> from the CPU port is correct from a reference counting perspective, but
> useless in practice. Thoughts?

I don't need this patch. I'm not sure what my thought process was at
the time I added it to the patchset.
I'm still interested in getting rid of the vlan bitmap through other
means (picking up your old changeset). Could you take a look at my
questions in that thread? I'm not sure I understand what the user
interaction is supposed to look like for configuring CPU/DSA ports.

> --
> Florian

Thanks,
-Vladimir
