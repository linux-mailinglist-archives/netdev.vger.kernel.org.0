Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D9E1BCE94
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgD1VXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:23:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58030 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbgD1VXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 17:23:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YmK8L9VXWlkEG6vOmZW/CX7dwLlmCRiuHG5KvM+JjLE=; b=ipbi3Lf0/1ygcsSNIRx+OEXHCA
        DUxYXuJdC+0O0m64mQNcOxmbJ93ZlJwF2XCyFzmn3a0OaE18mHOvpsXft6TmnLbmAmNd3oRlOp6wu
        mTc3c/R5AjvtuJdJNZGvpu4qQZYAIDHNK0bvv6WJLMnnuEGMKURnEBPm8LTgnX6ShLQA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTXh9-000A7b-0Q; Tue, 28 Apr 2020 23:23:11 +0200
Date:   Tue, 28 Apr 2020 23:23:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 3/4] net: phy: bcm54140: apply the workaround on
 b0 chips
Message-ID: <20200428212311.GD30459@lunn.ch>
References: <20200428210854.28088-1-michael@walle.cc>
 <20200428210854.28088-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428210854.28088-3-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:08:53PM +0200, Michael Walle wrote:
> The lower three bits of the phy_id specifies the chip stepping. The
> workaround is specifically for the B0 stepping. Apply it only on these
> chips.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
