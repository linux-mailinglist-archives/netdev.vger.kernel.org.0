Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F1910E19
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfEAUe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:34:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51518 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfEAUe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 16:34:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=anpigxOwIwddSG/fcQFoDrOiRrwt8CgBQMkZf2HjGkw=; b=zyp7s14Vl52N3woGBlL0DI9sjW
        YwzwnMY1uWWC9wPIFh5LojgtGYPBTe9fT0KGN5DxPqw5nHBn+krzZMqFOCxM57kq3YMOfOiGKkzXl
        7/NNvbFyoAkfz6gdKN+sJBKIKpodHyXTDnSD6CJT95nDz0DAgFWseLBZvhuoxrN8jX5U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLvvs-0008TL-7Q; Wed, 01 May 2019 22:34:24 +0200
Date:   Wed, 1 May 2019 22:34:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: improve resuming from hibernation
Message-ID: <20190501203424.GG19809@lunn.ch>
References: <1b6fc016-b4cd-a27a-216b-d17441072809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b6fc016-b4cd-a27a-216b-d17441072809@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 01, 2019 at 10:14:21PM +0200, Heiner Kallweit wrote:
> I got an interesting report [0] that after resuming from hibernation
> the link has 100Mbps instead of 1Gbps. Reason is that another OS has
> been used whilst Linux was hibernated. And this OS speeds down the link
> due to WoL. Therefore, when resuming, we shouldn't expect that what
> the PHY advertises is what it did when hibernating.
> Easiest way to do this is removing state PHY_RESUMING. Instead always
> go via PHY_UP that configures PHY advertisement.

Hi Heiner

Going via PHY_UP is reasonable. I'm doing the same in my WIP cable
test code, to restore the PHY after it finishes the test.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
