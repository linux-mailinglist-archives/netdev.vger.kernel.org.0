Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F5026E784
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 23:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgIQVms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 17:42:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41558 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbgIQVmr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 17:42:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJ1ft-00F8jM-Uo; Thu, 17 Sep 2020 23:42:41 +0200
Date:   Thu, 17 Sep 2020 23:42:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ethtool: add and use message type for tunnel info
 reply
Message-ID: <20200917214241.GC3598897@lunn.ch>
References: <20200916230410.34FCE6074F@lion.mk-sys.cz>
 <20200917014151.GK3463198@lunn.ch>
 <20200917212919.3n6f3zdegjeyhfud@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917212919.3n6f3zdegjeyhfud@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On the other hand, the enums are part of userspace API so I better take
> a closer look to make sure we don't run into some trouble there.

Hi Michal

Yes, that is what i was thinking about. But i guess you can pass a
tagged enum to a function expecting an int and the compiler will
silently cast it. Which is what we should have at the moment. So i'm
expecting it to be O.K.

	  Andrew
