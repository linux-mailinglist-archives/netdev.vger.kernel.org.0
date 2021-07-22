Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E513D2574
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbhGVNfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:35:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40438 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232388AbhGVNeO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 09:34:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qFeeUQkr8zfksguLuRh3bK07OGK8cMlhPlcYMUoCyTw=; b=UrT/QE7wfZoUcW8S8Fln3bWdg1
        nKl8gyRCYYqhtRcmtUA8kFjfV+CEgkuP7eZwym3wiFFWYvMzLR8ZQvb2tohyzFkxVItGivSW50rVB
        Dk4YxQwOOlI6G1yiDRaqQPJb1F+l3NWFq69iJrI6JMXa/Ln3chw8C6xggU/lVwU8yHcw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6ZTF-00EL7p-1v; Thu, 22 Jul 2021 16:14:41 +0200
Date:   Thu, 22 Jul 2021 16:14:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: dsa: ensure linearized SKBs in case of tail
 taggers
Message-ID: <YPl9UX52nfvLzIFy@lunn.ch>
References: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
 <20210721215642.19866-2-LinoSanfilippo@gmx.de>
 <20210721233549.mhqlrt3l2bbyaawr@skbuf>
 <8460fa10-6db7-273c-a2c2-9b54cc660d9a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8460fa10-6db7-273c-a2c2-9b54cc660d9a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Agreed, with those fixed:
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Hi Florian, Vladimir

I would suggest stop adding Reviewed-by: when you actual want changes
made. The bot does not seem to be reading the actual emails, it just
looks for tags. And when there are sufficient tags, it merges,
independent of requests for change, open questions, etc.

	    Andrew
