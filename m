Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BB127EC29
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgI3PRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:17:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36078 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbgI3PQ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 11:16:59 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNdqi-00Guql-9X; Wed, 30 Sep 2020 17:16:56 +0200
Date:   Wed, 30 Sep 2020 17:16:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Igor Russkikh <irusskikh@marvell.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: ethtool/phy tunables and extack (was Re: [PATCH net-next 0/3]
 net: atlantic: phy tunables from mac driver)
Message-ID: <20200930151656.GN3996795@lunn.ch>
References: <20200929161307.542-1-irusskikh@marvell.com>
 <20200929170413.GA3996795@lunn.ch>
 <20200930150320.6rluu7ywt5iqj5qj@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930150320.6rluu7ywt5iqj5qj@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Another question is how to allow ethtool ops setting not only the text
> message but also the offending attribute.

For PHY tunables, i don't think it is needed. The current API only
allows a single value to be passed. That seems to be enough, and it
forces us to keep tunables simple. If need be, the core could set the
attribute, since there should only be one containing the value.

	   Andrew
