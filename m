Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2411E8038
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 16:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgE2O3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 10:29:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56826 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbgE2O3x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 10:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=k/LsmBn8OkC7ApnYXMt3CU61fMHpdk7RjDwpBDBoSD4=; b=NnVhRDvYFINJjkqRJKi4YgHoQO
        kAeOXPGjTaUw3SYL/krwmQfIMpWvIGsMiycKOGjBBig67OEdNQcTx1c9XSR5r+oGphk0X1WbMSE8I
        xi3aED7NpRXMuMDkkR7aNagWWTiKMRbvrnOYIAsDwg1IEgzKRelCubQbiL4s6FCOzJzM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeg19-003eV2-RB; Fri, 29 May 2020 16:29:51 +0200
Date:   Fri, 29 May 2020 16:29:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH ethtool 03/21] netlink: fix msgbuff_append() helper
Message-ID: <20200529142951.GE869823@lunn.ch>
References: <cover.1590707335.git.mkubecek@suse.cz>
 <065379b5682ce800f8631bc97bc69b2421d143b7.1590707335.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <065379b5682ce800f8631bc97bc69b2421d143b7.1590707335.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 01:21:22AM +0200, Michal Kubecek wrote:
> As msgbuff_append() only copies protocol payload, i.e. part of the buffer
> without netlink and genetlink header, and mnl_nlmsg_get_payload_len() only
> subtracts netlink header length, we need to subtract genetlink header
> length manually to get correct length of appended data block.
> 
> Fixes: 5050607946b6 ("netlink: message buffer and composition helpers")
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Tested-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
