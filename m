Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B67F3E507E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 03:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbhHJBD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 21:03:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41086 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234936AbhHJBD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 21:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=a2skypItMYjxMf7QKPuae9KVAaduAHgtSU/HE4kbpHw=; b=zLSVpYJQbrvn6u2i8ma2hSvnVE
        otL4Y2y6Gdlv04LxWqnLPEVzzyN9xQ9VKtvrPIOV0knHdgKcIOpxoLcsjuQpftOFjYcIDrb0RcgMd
        zYTdtLIajXD36msaJmihVjZNFIGvjnDLJZocowXAIufuCq5dzIKnDhEsh4RL8Z+uf/FY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDGAZ-00Go4K-FK; Tue, 10 Aug 2021 03:03:03 +0200
Date:   Tue, 10 Aug 2021 03:03:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
Subject: Re: [RFC PATCH net-next 2/4] net: dsa: create a helper which
 allocates space for EtherType DSA headers
Message-ID: <YRHQRyzVp22triyD@lunn.ch>
References: <20210809115722.351383-1-vladimir.oltean@nxp.com>
 <20210809115722.351383-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809115722.351383-3-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 02:57:20PM +0300, Vladimir Oltean wrote:
> Hide away the memmove used by DSA EtherType header taggers to shift the
> MAC SA and DA to the left to make room for the header, after they've
> called skb_push(). The call to skb_push() is still left explicit in
> drivers, to be symmetric with dsa_strip_etype_header, and because not
> all callers can be refactored to do it (for example, brcm_tag_xmit_ll
> has common code for a pre-Ethernet DSA tag and an EtherType DSA tag).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
