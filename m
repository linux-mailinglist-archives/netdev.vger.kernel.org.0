Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E87010CC84
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 17:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfK1QM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 11:12:58 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32936 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfK1QM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 11:12:57 -0500
Received: by mail-pg1-f194.google.com with SMTP id 6so8563703pgk.0
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 08:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=v8X09G/jn0hNe8F4x3GVXBnyoHtLvjm3S2FCZ4SQSVw=;
        b=A/+bWOxqqk22bq6wUmCw9XM4IG7vtDKpUHxJgRShr2+8IyUTVjKPyvsBT1reMD0bZz
         OV4ELGxiYdKYkSUa0Z4oqzkOTFXRs8slptiaY0363h6t8gsn4SjdljeTQ0Hl+aAzAPko
         yo4yRLmh3X5A3RY51A1wZazENTigiwgvpjLYgFovf30MlV4V5w6ariiZu/DaIP8XJ33b
         S0o4j84PXXJ4iJaDjfuicT15raafMs25LxlyqA+r6/vSaBpJkoSdEP2pe4c605fRFyuN
         z3DWsMW3+LtqMslB1kvYqlwN3Yk9NabYcCA3hJ59ukZzv6xLa0sCaIDKGMAqEgtzegf+
         dPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=v8X09G/jn0hNe8F4x3GVXBnyoHtLvjm3S2FCZ4SQSVw=;
        b=oeqfnycqE4h5/8AqZIo7uDbz9uqDcsynhIN4E4y1OS3miXMgSZDRksnMnh9oM80r3R
         YcJi2wVyB71EG0np1NTBnVL1AtiktJKk6qyLZ4Cz8XHiUNQHj2ZR8GGMdtDMB2JyQtZb
         +4kt9qziSPC8v91NT+LYZdj/WiJ3dRmWoTOH9odX5SQ9B77QBFEWqC0ktRhszNwBBBnc
         5/8HyZNNWRQgUZe1WBRLkt9G+VMefcd2sVvnQcgzwK5dyrMgG2ChWJFb8cqpLy66Hq6v
         2uUM09QelGgBE2UEBRirfQSuyLdc1cr4vec6kpVk6D2GogzZ19KI4F/FsvgSdNicAeiM
         PZ6g==
X-Gm-Message-State: APjAAAVC8TFUZ9ZRcJSwqaEpGyADxrSjTv/NClL9TnEDoOJ494rQ1WLm
        v/8X0xO8lJ1o0fK414gFJZE=
X-Google-Smtp-Source: APXvYqwfdlxlhPKXFUdc5mnKiXguH8uau9UhhxzpQzBOCWbljFHVNu+mXL7xcCDSFbknTx6rDtj4nw==
X-Received: by 2002:a62:1a16:: with SMTP id a22mr1600979pfa.34.1574957577339;
        Thu, 28 Nov 2019 08:12:57 -0800 (PST)
Received: from martin-VirtualBox ([42.109.141.206])
        by smtp.gmail.com with ESMTPSA id x13sm4653681pfc.171.2019.11.28.08.12.56
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 28 Nov 2019 08:12:56 -0800 (PST)
Date:   Thu, 28 Nov 2019 21:42:43 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Subject: Re: [PATCH v3 net-next 2/2] Special handling for IP & MPLS.
Message-ID: <20191128161243.GA2633@martin-VirtualBox>
References: <cover.1573872263.git.martin.varghese@nokia.com>
 <24ec93937d65fa2afc636a2887c78ae48736a649.1573872264.git.martin.varghese@nokia.com>
 <CA+FuTSeHsZnHMUiZmHugCT=83g6EA8OJVWd9VdV-LqbA94xVqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSeHsZnHMUiZmHugCT=83g6EA8OJVWd9VdV-LqbA94xVqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 12:30:11PM -0500, Willem de Bruijn wrote:
> On Sat, Nov 16, 2019 at 12:45 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > From: Martin Varghese <martin.varghese@nokia.com>
> >
> > Special handling is needed in bareudp module for IP & MPLS as they support
> > more than one ethertypes.
> >
> > MPLS has 2 ethertypes. 0x8847 for MPLS unicast and 0x8848 for MPLS multicast.
> > While decapsulating MPLS packet from UDP packet the tunnel destination IP
> > address is checked to determine the ethertype. The ethertype of the packet
> > will be set to 0x8848 if the  tunnel destination IP address is a multicast
> > IP address. The ethertype of the packet will be set to 0x8847 if the
> > tunnel destination IP address is a unicast IP address.
> >
> > IP has 2 ethertypes.0x0800 for IPV4 and 0x86dd for IPv6. The version field
> > of the IP header tunnelled will be checked to determine the ethertype.
> 
> If using ipv6 dual stack, it might make more sense to use extended
> mode with the ipv6 device instead of the ipv4 device.
>
ipv6 dual stack (v6 socket) is for the tunnel.the ethertype mentioned above
is for the inner protocol being tunnelled


 
> Also, the term extended mode is not self describing. Dual stack as
> term would be, but is not relevant to MPLS. Maybe "dual_proto"?
>
multi_proto ?

> > diff --git a/Documentation/networking/bareudp.rst b/Documentation/networking/bareudp.rst
> > index 2828521..1f01dfd 100644
> > --- a/Documentation/networking/bareudp.rst
> > +++ b/Documentation/networking/bareudp.rst
> > @@ -12,6 +12,15 @@ The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
> >  support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
> >  a UDP tunnel.
> >
> > +Special Handling
> > +----------------
> > +The bareudp device supports special handling for MPLS & IP as they can have
> > +multiple ethertypes.
> > +MPLS procotcol can have ethertypes ETH_P_MPLS_UC  (unicast) & ETH_P_MPLS_MC (multicast).
> > +IP proctocol can have ethertypes ETH_P_IP (v4) & ETH_P_IPV6 (v6).
> 
> proctocol -> protocol

Noted.

Thanks for your time
