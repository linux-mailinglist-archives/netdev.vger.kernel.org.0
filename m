Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A457327ED04
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgI3Pbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:31:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:50632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbgI3Pbd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 11:31:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BFCF0ADCD;
        Wed, 30 Sep 2020 15:31:32 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5BBA160787; Wed, 30 Sep 2020 17:31:32 +0200 (CEST)
Date:   Wed, 30 Sep 2020 17:31:32 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Igor Russkikh <irusskikh@marvell.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: ethtool/phy tunables and extack (was Re: [PATCH net-next 0/3]
 net: atlantic: phy tunables from mac driver)
Message-ID: <20200930153132.pi3zsomcz63rcsvl@lion.mk-sys.cz>
References: <20200929161307.542-1-irusskikh@marvell.com>
 <20200929170413.GA3996795@lunn.ch>
 <20200930150320.6rluu7ywt5iqj5qj@lion.mk-sys.cz>
 <20200930151656.GN3996795@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930151656.GN3996795@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 05:16:56PM +0200, Andrew Lunn wrote:
> > Another question is how to allow ethtool ops setting not only the text
> > message but also the offending attribute.
> 
> For PHY tunables, i don't think it is needed. The current API only
> allows a single value to be passed. That seems to be enough, and it
> forces us to keep tunables simple. If need be, the core could set the
> attribute, since there should only be one containing the value.

It probably wasn't obvious but I mean the two parts of my e-mail as
independent, i.e. the second part was rather meant as a general thought
on allowing drivers to report errors/warnings via extack, not specific
to PHY tunables.

Michal
