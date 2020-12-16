Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF1F2DC9B1
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 00:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730790AbgLPXqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 18:46:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58412 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgLPXq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 18:46:29 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kpgUL-00CNnY-V0; Thu, 17 Dec 2020 00:45:45 +0100
Date:   Thu, 17 Dec 2020 00:45:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: Re: [PATCH net-next 0/4] enetc: code cleanups
Message-ID: <20201216234545.GA2943708@lunn.ch>
References: <20201215212200.30915-1-michael@walle.cc>
 <20201216192539.3xfxmhpejrmayfge@skbuf>
 <d5335485b0d62e7c399d342136ac6921@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5335485b0d62e7c399d342136ac6921@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ah, I thought it will be picked up automatically after the merge
> window is closed, no?

Nope. With netdev, if it is not merged in about 3 days, it needs to be
reposted. And it might need a rebased after the merge window closes
and net-next reopens.

	  Andrew
