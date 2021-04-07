Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538B835605E
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241755AbhDGAdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:33:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37200 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232798AbhDGAdq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:33:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTw8V-00FDnl-9n; Wed, 07 Apr 2021 02:33:35 +0200
Date:   Wed, 7 Apr 2021 02:33:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next] ethtool: document PHY tunable callbacks
Message-ID: <YGz93w4BwHwoTvJN@lunn.ch>
References: <20210407002359.1860770-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407002359.1860770-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 05:23:59PM -0700, Jakub Kicinski wrote:
> Add missing kdoc for phy tunable callbacks.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
