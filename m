Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67439149E17
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 02:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgA0BRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 20:17:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55126 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgA0BRk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 20:17:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DDA+RXKnEaa+Mv9aXDVKsI3Z9KlPY04g56w9sbOncNg=; b=p5WIm7lIoX+9G2zeYhlFv51BxR
        nEpeVGfq42S6i2ObTv/7q/RRwSP9s0ygo+EmPlgCFqEKvtPcMzfDhS8IrVU+57/BgJlf0rQvRJjXe
        +cylJwzXGajdwTfv+Lkv4sc9Nx+h1WaPpuGg6jfK9B/zKUExT2ppnlugx5oKsLv65LDk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ivt1w-0003qj-SS; Mon, 27 Jan 2020 02:17:32 +0100
Date:   Mon, 27 Jan 2020 02:17:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/7] ethtool: add DEBUG_NTF notification
Message-ID: <20200127011732.GE12816@lunn.ch>
References: <cover.1580075977.git.mkubecek@suse.cz>
 <a6a0f4b5e3667e977be016dfada4ae64dae84f6e.1580075977.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6a0f4b5e3667e977be016dfada4ae64dae84f6e.1580075977.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 11:11:10PM +0100, Michal Kubecek wrote:
> Send ETHTOOL_MSG_DEBUG_NTF notification message whenever debugging message
> mask for a device are modified using ETHTOOL_MSG_DEBUG_SET netlink message
> or ETHTOOL_SMSGLVL ioctl request.
> 
> The notification message has the same format as reply to DEBUG_GET request.
> As with other ethtool notifications, netlink requests only trigger the
> notification if the mask is actually changed while ioctl request trigger it
> whenever the request results in calling the ethtool_ops handler.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
