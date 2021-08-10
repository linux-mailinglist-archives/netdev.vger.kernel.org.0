Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D93E3E5078
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 03:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237162AbhHJBCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 21:02:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41066 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231794AbhHJBCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 21:02:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oZlisjSXuLzF82l3rD5s0dG345HxqNcBHG713OQ5Gpg=; b=WqJcT56oPyMvO6LHHLvMGkBABH
        1diHM0aef9twuviGCGi1+jP2J4EHeCb5FnB/fkrImEjRjM9dIaYoV/axzSzocM/jA0KroPbhLcbrn
        SMz+FjQX+bYbxMlOn7tmyccXWKIQzjcYwyZ5PTxh0J1bziDJ5THuLRvBYoFyFnBmny8s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDG9A-00Go2n-Ml; Tue, 10 Aug 2021 03:01:36 +0200
Date:   Tue, 10 Aug 2021 03:01:36 +0200
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
Subject: Re: [RFC PATCH net-next 1/4] net: dsa: create a helper that strips
 EtherType DSA headers on RX
Message-ID: <YRHP8M5HRy2viBV+@lunn.ch>
References: <20210809115722.351383-1-vladimir.oltean@nxp.com>
 <20210809115722.351383-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809115722.351383-2-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 02:57:19PM +0300, Vladimir Oltean wrote:
> All header taggers open-code a memmove that is fairly not all that
> obvious, and we can hide the details behind a helper function, since the
> only thing specific to the driver is the length of the header tag.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
