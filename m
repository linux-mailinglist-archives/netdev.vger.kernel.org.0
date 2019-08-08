Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C82AB86AA4
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390202AbfHHThr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:37:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45420 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390163AbfHHThr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 15:37:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KLpK00Mcv8+qXUUehynfuZR0Q5UntzX7YFQyAfRP4Qs=; b=wGXEV/76eQ84DT1QBZJRmM4OT3
        oZF/exW1KVMcjnHN6mXmzc3Jyl7eD0oIiVO+0V/tzd0E5TWZV16gaqme8HizLSsKVi8rw6Ng8bly8
        8nC3xLg7Bsypw9FbnQlL7a5CCjcPh95P4ssHGIxe9HGmYKvDtc5wBV7r1+hJtfJkeiHk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvoEJ-0005YJ-Ig; Thu, 08 Aug 2019 21:37:43 +0200
Date:   Thu, 8 Aug 2019 21:37:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: phy: realtek: add support for the
 2.5Gbps PHY in RTL8125
Message-ID: <20190808193743.GL27917@lunn.ch>
References: <ddbf28b9-f32e-7399-10a6-27b79ca0aaf9@gmail.com>
 <64769c3d-42b6-8eb8-26e4-722869408986@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64769c3d-42b6-8eb8-26e4-722869408986@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 09:05:54PM +0200, Heiner Kallweit wrote:
> This adds support for the integrated 2.5Gbps PHY in Realtek RTL8125.
> Advertisement of 2.5Gbps mode is done via a vendor-specific register.
> Same applies to reading NBase-T link partner advertisement.
> Unfortunately this 2.5Gbps PHY shares the PHY ID with the integrated
> 1Gbps PHY's in other Realtek network chips and so far no method is
> known to differentiate them.

That is not nice.

Do you have any contacts in Realtek who can provide us with
information? Maybe there is another undocumented vendor specific
register?

	Andrew
