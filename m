Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311E21E00C4
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 18:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387801AbgEXQwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 12:52:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47088 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387559AbgEXQwg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 12:52:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6Y+2xtbXK5az5id6LzhRANfNx2LA7ASiLkT4fWqMtXA=; b=Ql5EjaYEy0tDScBct5GQhjrEUn
        KcXEAMhZAYri/5iOdUk97QoAa65dvXyiEU84gPeCOn29mmiggcOW0qP5wBJy456YnygSBeYq9x893
        Tf5hFu0hPttiMqs6u4Abt8LskqWrO7ocjndRcF3ltQgjPheaNLiUdrnD8qRHvaCTISXo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jctrU-0038L1-Lc; Sun, 24 May 2020 18:52:32 +0200
Date:   Sun, 24 May 2020 18:52:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH v2 net-next 6/6] net : phy: marvell: Speedup TDR data
 retrieval by only changing page once
Message-ID: <20200524165232.GA746862@lunn.ch>
References: <20200524152747.745893-1-andrew@lunn.ch>
 <20200524152747.745893-7-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524152747.745893-7-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 05:27:46PM +0200, Andrew Lunn wrote:
> Getting the TDR data requires a large number of MDIO bus
> transactions. The number can however be reduced if the page is only
> changed once. Add the needed locking to allow this, and make use of
> unlocked read/write methods where needed.

I've somehow squashed two patches together to from this patch. Which
then explains the 7/6 patch.

Please review the rest of the patches, i will collect comments, and
then repost with this fixed.

     Andrew
