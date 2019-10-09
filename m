Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DC5D120E
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 17:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731450AbfJIPGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 11:06:51 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:33657 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731255AbfJIPGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 11:06:51 -0400
Received: by mail-yw1-f68.google.com with SMTP id w140so942346ywd.0
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 08:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IG7v+1ZHa01+Gy7zrBdYoLje6Z9dV8ig0/mxlKiup8U=;
        b=ZBb0mn6VmBJa7OHlcbpgakXBiVDmfRbCONVnIRcyryRnMjPBZmrOWr1BwDdzk5H9rs
         EIoIa5GPT6jMjvaypxoLgIkkA5POZTUesBXCzGGxyT+2MKEN2YfdEkDU4WFL/3laxdga
         yNvpCeBqSrBcyrMYmXjxeD6luLBZCHIQ3lKzTmhl4BRqY1DwH+gsO8udIj6anrwrOZ0l
         t3/H3ll5GasgYwc2EuBqGzJn8BKp5u9kkaVBfWPhDxUE84QgqG6Q57vxZmqC86Kap1Wc
         xXHQryYUlggSa3wLzQyAhEu+JDB+fKYChq9XscQexDPD6ClrMwwTz+4x8M9GAcWaTbsB
         Ziiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IG7v+1ZHa01+Gy7zrBdYoLje6Z9dV8ig0/mxlKiup8U=;
        b=ctLE4dmL1m9TiaArkqrK8jNPCv2iW3hNnR+wpPeoFB6AvNa1ROsuzonsxm1dbCRCdB
         t3Ad6RFqPEpf7Lh/ur7p7OQiAepu+Oc7w3OZ9SlhvIGYhIv3Ztb4gEQm5sAnq4Y4YjXS
         7clT4UGDnOcnC5H0nAn/5LUZ5NlzMyjikYtvUgn4lO5yukCoZugKr2NNid27+cTmZ1+x
         YBBTV5PiSMFnhywXa+dtPV1OzsXXs7PNUjEsmu5OvRFI7UotFpZFeIwjyWzQyrA/Unar
         eMYCUmzGQFOhnMIzuRqyWkJL/rKvKPyGoX+uXlGqIHS3XM8Pg2ZUYNJcCCIrwJQWIpJH
         DbFw==
X-Gm-Message-State: APjAAAWPO4c1sMiq3LsNnqED74IpagN13BbZ63ceyH5/bFkZzywfZMnR
        +HbZyvo7v6L63HCZS8ssmtSMFCB4
X-Google-Smtp-Source: APXvYqxw+HuRyt0eESZnSx5asmHtxA145IFvBDLgwialqDqZUJ5ryA12bYITSeGaCnuSJ/8dJwmWNQ==
X-Received: by 2002:a81:928f:: with SMTP id j137mr2893846ywg.450.1570633610001;
        Wed, 09 Oct 2019 08:06:50 -0700 (PDT)
Received: from mail-yw1-f48.google.com (mail-yw1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id v204sm593988ywb.23.2019.10.09.08.06.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 08:06:49 -0700 (PDT)
Received: by mail-yw1-f48.google.com with SMTP id m13so915272ywa.11
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 08:06:48 -0700 (PDT)
X-Received: by 2002:a0d:f8c6:: with SMTP id i189mr2959506ywf.411.1570633608372;
 Wed, 09 Oct 2019 08:06:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <1da8fb9d3af8dcee1948903ae816438578365e51.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc_L_2sGSvSOtF2t6rKFenNp+L-0YBjqhTT6_NZBS9XJQ@mail.gmail.com> <20191009133840.GC17712@martin-VirtualBox>
In-Reply-To: <20191009133840.GC17712@martin-VirtualBox>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 9 Oct 2019 11:06:11 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeqwDS_W4K6jtbPFF14iL+OAEN-fvom8Ls-j3inzmhVqQ@mail.gmail.com>
Message-ID: <CA+FuTSeqwDS_W4K6jtbPFF14iL+OAEN-fvom8Ls-j3inzmhVqQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] Special handling for IP & MPLS.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 9:39 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Tue, Oct 08, 2019 at 12:09:49PM -0400, Willem de Bruijn wrote:
> > On Tue, Oct 8, 2019 at 5:52 AM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > From: Martin <martin.varghese@nokia.com>
> > >
> >
> > This commit would need a commit message.
> >
> > > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> > >
> > > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> > > ---
> > >  Documentation/networking/bareudp.txt | 18 ++++++++
> > >  drivers/net/bareudp.c                | 82 +++++++++++++++++++++++++++++++++---
> > >  include/net/bareudp.h                |  1 +
> > >  include/uapi/linux/if_link.h         |  1 +
> > >  4 files changed, 95 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/Documentation/networking/bareudp.txt b/Documentation/networking/bareudp.txt
> > > index d2530e2..4de1022 100644
> > > --- a/Documentation/networking/bareudp.txt
> > > +++ b/Documentation/networking/bareudp.txt
> > > @@ -9,6 +9,15 @@ The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
> > >  support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
> > >  a UDP tunnel.
> > >
> > > +Special Handling
> > > +----------------
> > > +The bareudp device supports special handling for MPLS & IP as they can have
> > > +multiple ethertypes.
> >
> > Special in what way?
> >
> The bareudp device associates a L3 protocol (ethertype) with a UDP port.
> For some protocols like MPLS,IP there exists multiplle ethertypes.
> IPV6 and IPV4 ethertypes for IP and MPLS unicast & Multicast ethertypes for
> MPLS. There coud be use cases where both MPLS unicast and multicast traffic
> need to be tunnelled using the same bareudp device.Similarly for ipv4 and ipv6.

IP is already solved. I would focus on MPLS.

Also, the days where IPv6 is optional (and needs IPv4 enabled) are
behind us, really.

Maybe just let the admin explicitly specify MPLS unicast, multicast or
both, instead of defining a new extended label.
