Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346C31E8036
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 16:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgE2O3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 10:29:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbgE2O3C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 10:29:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IUGSg4KBn7ED5FXRLcBsKB4n8JH0Ugrv/l8hdihtGFs=; b=cWE2+85zlt5M4SkV/UQwrS5xOZ
        QQGYx6JFLfjoZe6xGLwsWNGrp0YMRs974c5th+cXmFkzs24DCgXioNH4GJ/kLA1hEZGKtCilibEMY
        V9QBEV+ammDMymorLcCTEjYh3dDEmFfbwhyAaSX1Z3AT4YGiPMZFHXa9/2F9nzJNmViY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeg0I-003eUZ-7E; Fri, 29 May 2020 16:28:58 +0200
Date:   Fri, 29 May 2020 16:28:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH ethtool 02/21] netlink: fix nest type grouping in parser
Message-ID: <20200529142858.GD869823@lunn.ch>
References: <cover.1590707335.git.mkubecek@suse.cz>
 <66427ed9d01547b06bc7eb2b853a18108274f3eb.1590707335.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66427ed9d01547b06bc7eb2b853a18108274f3eb.1590707335.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 01:21:17AM +0200, Michal Kubecek wrote:
> Even if we are only interested in one nested attribute when using
> PARSER_GROUP_NEST group type, the temporary buffer must contain proper
> netlink header and have pointer to it and payload set up correctly for
> libmnl composition functions to be able to track current message size.
> 
> Fixes: 9ee9d9517542 ("netlink: add basic command line parsing helpers")
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Tested-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
