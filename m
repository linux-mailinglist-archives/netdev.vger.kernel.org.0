Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AD249119D
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 23:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243564AbiAQWJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 17:09:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41134 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243562AbiAQWJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 17:09:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=z9zTWupN5dysA9jrb8zJ+zQdgVK00kYikj0aRQIrxtg=; b=stgQO+eBQnFLwGrgixoOsMUdR1
        3QTfxTqT18VDu3PqmA2OnW432ZkphqYL/qDXKyYN9PwfZF0pFX7nzlXdrDQUd2sy6zPqsykZp8yL/
        vm8tuw2fHFgO4AApWmj3yZh/d+m/jszgufGCVZcjttDg0XgKq3UiWtD5bV+KxckboMzM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n9aBM-001gOi-LS; Mon, 17 Jan 2022 23:08:56 +0100
Date:   Mon, 17 Jan 2022 23:08:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH RFC] phy: make phy_set_max_speed() *void*
Message-ID: <YeXo+G/roPb2G2rU@lunn.ch>
References: <a2296c4e-884b-334a-570f-901831bfea3c@omp.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2296c4e-884b-334a-570f-901831bfea3c@omp.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 12:18:58AM +0300, Sergey Shtylyov wrote:
> After following the call tree of phy_set_max_speed(), it became clear
> that this function never returns anything but 0, so we can change its
> result type to *void* and drop the result checks from the three drivers
> that actually bothered to do it...
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE static
> analysis tool.
> 
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>

Seems reasonable. net-next is closed at the moment, so please repost
once it opens.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
