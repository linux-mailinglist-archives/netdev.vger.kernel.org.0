Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F939181C33
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 16:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbgCKPVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 11:21:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57498 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729408AbgCKPVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 11:21:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=R87389nZ5I+pSSD5pQawLESnhnmnDOrPTdCHWjE6Fjk=; b=xKnXXNr6sV5YslaJWh0EK7lxkf
        xBF9z5yb1zVnYUb8jIjM41rCktshHTmSpVxC7LqilocQu06Adj8v4TyZTq7+on+njO3+SINnkua8l
        1+J1/r+yvnVjAJzk6bPGa9Xzmf23QFvIRmKRC/ayDeIx6D6JOfjF5nz9iQn53h/mXo80=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jC3Aq-0004fZ-6B; Wed, 11 Mar 2020 16:21:32 +0100
Date:   Wed, 11 Mar 2020 16:21:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Darell Tan <darell.tan@gmail.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net
Subject: Re: [PATCH] net: phy: Fix marvell_set_downshift() from clobbering
 MSCR register
Message-ID: <20200311152132.GH11247@lunn.ch>
References: <20200311224138.1b98ca46f948789a0eec7ecf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311224138.1b98ca46f948789a0eec7ecf@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 10:41:38PM +0800, Darell Tan wrote:
> Fix marvell_set_downshift() from clobbering MSCR register.
> 
> A typo in marvell_set_downshift() clobbers the MSCR register. This
> register also shares settings with the auto MDI-X detection, set by
> marvell_set_polarity(). In the 1116R init, downshift is set after
> polarity, causing the polarity settings to be clobbered.
> 
> This bug is present on the 5.4 series and was introduced in commit
> 6ef05eb73c8f ("net: phy: marvell: Refactor setting downshift into a
> helper"). This patch need not be forward-ported to 5.5 because the
> functions were rewritten.
> 
> Signed-off-by: Darell Tan <darell.tan@gmail.com>

Hi Darell

You should put net into the subject line: [patch net] ...  to indicate
this is a fix. But you have a bit of a special case here. Also, you
should indicate what it fixes:

Fixes: 6ef05eb73c8f ("net: phy: marvell: Refactor setting downshift into a helper")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
