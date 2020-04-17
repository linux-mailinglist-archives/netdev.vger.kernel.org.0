Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC1E1AE8C3
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 01:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgDQXym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 19:54:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45522 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbgDQXyc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 19:54:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=J1vo0AGaXBzBFlKv+bt0P96FJZcfRzVVqZSrTg/altA=; b=qCk39G4fwlKOe3+5F0zD7iEWAp
        J9AFuV+7oK82eETmnrClIGZh58X97tjfRCPeLmCsjwXTP1Mw2+PyWsaQQuIrTMTWZEkNNHaQ3mnU4
        95hj9/dSzkn57P0eTAd8gTjuO1L0TyGqFwPTHnzRPKzzo4/85t8iTUqxxiof1MmLvHjE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPaoY-003NFa-6N; Sat, 18 Apr 2020 01:54:30 +0200
Date:   Sat, 18 Apr 2020 01:54:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: Add testing sysfs attribute
Message-ID: <20200417235430.GA802899@lunn.ch>
References: <20200417230350.802675-1-andrew@lunn.ch>
 <20200417230350.802675-3-andrew@lunn.ch>
 <cbecabd6-391c-88e4-6d4e-2ec7b43650fa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbecabd6-391c-88e4-6d4e-2ec7b43650fa@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 04:49:23PM -0700, Florian Fainelli wrote:
> 
> 
> On 4/17/2020 4:03 PM, Andrew Lunn wrote:
> > Similar to speed, duplex and dorment, report the testing status
> > in sysfs.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >   Documentation/ABI/testing/sysfs-class-net | 13 +++++++++++++
> >   net/core/net-sysfs.c                      | 15 ++++++++++++++-
> >   2 files changed, 27 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/ABI/testing/sysfs-class-net
> > index 664a8f6a634f..5e8b09743e04 100644
> > --- a/Documentation/ABI/testing/sysfs-class-net
> > +++ b/Documentation/ABI/testing/sysfs-class-net
> > @@ -124,6 +124,19 @@ Description:
> >   		authentication is performed (e.g: 802.1x). 'link_mode' attribute
> >   		will also reflect the dormant state.
> > +What:		/sys/class/net/<iface>/testing
> > +Date:		Jun 2019
> > +KernelVersion:	5.2
> 
> This should probably be 5.8 now, other than that:

Ah, yes. Shows how long this has been sat in my tree.

> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks
	Andrew
