Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67DA36C60E
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 14:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbhD0M3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 08:29:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42982 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235410AbhD0M3a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 08:29:30 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lbMpY-001MXU-M6; Tue, 27 Apr 2021 14:28:44 +0200
Date:   Tue, 27 Apr 2021 14:28:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next] icmp: standardize naming of RFC 8335 PROBE
 constants
Message-ID: <YIgDfGZrSqQXjy54@lunn.ch>
References: <20210427034002.291543-1-andreas.a.roeseler@gmail.com>
 <20210426205434.248bed86@hermes.local>
 <c522ffcadf479c3f1a46c401e38ad01bf3f3331c.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c522ffcadf479c3f1a46c401e38ad01bf3f3331c.camel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > You can't just remove the old constants. They have to stay there.
> > The #defines are part of the Linux API by now.
> 
> Even in the case where these constants were added less than a month ago
> (3/30/2021) and are not used elsewhere in the kernel? I agree with your
> statement in the general sense, but I thought I could get ahead of it
> in this case and update them.
> 
> For reference, they were added in commit
> 2b246b2569cd2ac6ff700d0dce56b8bae29b1842
 
You need to make this very clear in the commit message, that the code
you are changing is currently only in net-next, no released Kernels
are using these symbols, and you are not break the API.

    Andrew
