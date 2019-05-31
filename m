Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E3430E24
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 14:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfEaMaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 08:30:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44490 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbfEaMaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 08:30:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4shTRJ58XpaIQ3RQM4jr7QOkYGHvDHX2oQ2IafNSUjI=; b=drAV5glucN83mbAziwlfwIkF5D
        yDAXqbnYktz72A94yD3xTg+FZNH6up0CNfsQ2mvIOEu9XOcviB+exlN+tcUTzdwF8barpAsZZKvRa
        YjZS++QaTRa3Wnp/kS63ZImOOgt6xooq7xJOaqzjy0nHXOuVPMDRn0f8eFOUaG0ycjqw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWgfs-0005H7-90; Fri, 31 May 2019 14:30:20 +0200
Date:   Fri, 31 May 2019 14:30:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lucas Stach <l.stach@pengutronix.de>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        linville@redhat.com
Subject: Re: [PATCH 2/2] ethtool: Add 100BaseT1 and 1000BaseT1 link modes
Message-ID: <20190531123020.GC18608@lunn.ch>
References: <20190530180616.1418-1-andrew@lunn.ch>
 <20190530180616.1418-3-andrew@lunn.ch>
 <20190531093029.GD15954@unicorn.suse.cz>
 <20190531115928.GA18608@lunn.ch>
 <1559305305.2557.3.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559305305.2557.3.camel@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> That's not just theory. The Broadcom BCM54811 PHY supports both
> 100/1000baseT, as well as 100baseT1.

Hi Lucus

There does not appear to be a driver for it, which is why i've not
seen it, nor have we had this conversation before.

Do you have a driver to submit?

   Andrew
