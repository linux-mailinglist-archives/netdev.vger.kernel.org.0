Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F7546AF27
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344261AbhLGAbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:31:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41890 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344456AbhLGAbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 19:31:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BG39yg9jjM7mxyQqjPwzkxPeHCFgyGi8lRO1d5pkm1o=; b=YfXaRMwE/rwhLOX9J9g/aHMacj
        jU9xXqTMu9wdn/BvU37rDwren/MniJJHiax62v2Sx4uWDcuIgYpukpQ+VSVlkFoxgfqxJABa3+J2E
        9p8pJNfjadxd9othNiKDRfuRznwRQq+g9RZYg/8xTGgCyZaRHmmEg2UaHjC1ORDPKm9E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1muOKZ-00Fitm-5d; Tue, 07 Dec 2021 01:27:39 +0100
Date:   Tue, 7 Dec 2021 01:27:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH v3 net-next 00/23] net: add preliminary netdev refcount
 tracking
Message-ID: <Ya6qewYtxoRn7BTo@lunn.ch>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <Ya6bj2nplJ57JPml@lunn.ch>
 <CANn89iLPSianJ7TjzrpOw+a0PTgX_rpQmiNYbgxbn2K-PNouFg@mail.gmail.com>
 <Ya6kJhUtJt5c8tEk@lunn.ch>
 <CANn89iL4nVf+N1R=XV5VRSm4193CcU1N8XTNZzpBV9-mS3vxig@mail.gmail.com>
 <Ya6m1kIqVo52FkLV@lunn.ch>
 <CANn89i+b_6R820Om9ZjK-E5DyvnNUKXxYODpmt1B6UHM1q7eoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+b_6R820Om9ZjK-E5DyvnNUKXxYODpmt1B6UHM1q7eoQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 04:17:11PM -0800, Eric Dumazet wrote:
> On Mon, Dec 6, 2021 at 4:12 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> >
> > Hard to say. It looks like some sort of race condition. Sometimes when
> > i shut down the GNS3 simulation, i get the issues, sometimes not. I
> > don't have a good enough feeling to say either way, is it an existing
> > problem, or it is my code which is triggering it.
> 
> OK got it.
> 
> I think it might be premature to use ref_tracker yet, until we also
> have the netns one.

There is a lot of netns going on with GNS3. So it does sound too
early.

Could i get access to the full set of patches and try them out?

Thanks
	Andrew
