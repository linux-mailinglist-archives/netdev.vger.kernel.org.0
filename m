Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79CB99946D
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 15:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388815AbfHVNEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 09:04:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51780 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731563AbfHVNEE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 09:04:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jnpNpXdI0fKtKkHegx+vid4Cb9TjBr0Ag+rV4MY0CUw=; b=0BRlV9BdCT9zuh3ZrFuxdBW9du
        F4rmilc7CrH2ckPQnQYylETOglHMX90ydKkclK0rXGm0/A7NaOfmrfyCubXZbA4vexj2P8YB80A8W
        2+5tLixXkQ55UiD26c1RIwCH82o7Ccl1mHDDkB83GqW+U/FBrjnPZlMjspnFhm0ox8l8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i0ml1-0003lg-Im; Thu, 22 Aug 2019 15:04:03 +0200
Date:   Thu, 22 Aug 2019 15:04:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 03/10] net: dsa: mv88e6xxx: move hidden
 registers operations in own file
Message-ID: <20190822130403.GD13020@lunn.ch>
References: <20190821232724.1544-1-marek.behun@nic.cz>
 <20190821232724.1544-4-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190821232724.1544-4-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 01:27:17AM +0200, Marek Behún wrote:
> This patch moves the functions operating on the hidden debug registers
> into it's own file, hidden.c.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
