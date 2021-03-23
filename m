Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A24346C12
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 23:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhCWWSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 18:18:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43606 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233825AbhCWWSE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 18:18:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lOpLY-00CfAd-RD; Tue, 23 Mar 2021 23:17:56 +0100
Date:   Tue, 23 Mar 2021 23:17:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Don Bollinger <don@thebollingers.org>
Cc:     'Moshe Shemesh' <moshe@nvidia.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Adrian Pop' <pop.adrian61@gmail.com>,
        'Michal Kubecek' <mkubecek@suse.cz>, netdev@vger.kernel.org,
        'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
Subject: Re: [RFC PATCH V4 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
Message-ID: <YFppFFGK55gm4s7J@lunn.ch>
References: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
 <1616433075-27051-2-git-send-email-moshe@nvidia.com>
 <006801d71f47$a61f09b0$f25d1d10$@thebollingers.org>
 <YFk13y19yMC0rr04@lunn.ch>
 <007b01d71f83$2e0538f0$8a0faad0$@thebollingers.org>
 <YFlMjO4ZMBCcJqQ7@lunn.ch>
 <008901d7200c$8a59db40$9f0d91c0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008901d7200c$8a59db40$9f0d91c0$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The spec is clear that the lower half is the same for all pages.  If the SFP
> gives you rubbish you should throw the device in the rubbish.

Sometimes you don't get the choice. You have to use the GPON SFP the
ISP sent you, if you want FTTH. And they tend to be cheap and broken
with respect to the spec.

    Andrew
