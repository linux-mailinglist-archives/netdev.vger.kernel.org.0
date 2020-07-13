Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360D621D856
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgGMOZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:25:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60864 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729776AbgGMOZD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 10:25:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1juzO8-004sIR-MW; Mon, 13 Jul 2020 16:25:00 +0200
Date:   Mon, 13 Jul 2020 16:25:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 01/10] net: atlantic: media detect
Message-ID: <20200713142500.GB1078057@lunn.ch>
References: <20200713114233.436-1-irusskikh@marvell.com>
 <20200713114233.436-2-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713114233.436-2-irusskikh@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 02:42:24PM +0300, Igor Russkikh wrote:
> This patch adds support for low-power autoneg in PHY (media detect).
> This is a custom feature of AQC107 builtin PHY, but configuration is only
> done through MAC management firmware.

Hi Igor

Do the standalone PHYs also support this? It would be nice to have the
same user space API for both.

There is no reason why phy tuneables cannot be implemented by the MAC
driver. It just needs another ethtool op and some plumbing in
net/ethtool. That would give a more uniform solution.

	     Andrew
