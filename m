Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D4288325
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfHITJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:09:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48666 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbfHITJR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 15:09:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Q5q7h/h6gMKxax56bTeUbDX88H7oObytyE0dX5lQpuU=; b=039KBrr1ZzDrJcbgUiDbO6HkTG
        Tb/v8y4Tb7jRbQwHk7XF3cWw9jG3n6yQMoAyPSK3cxRu3kNx+BevBx661G8S0HWLCveSpWNv90Mvo
        NlHIxgYDtlQufsgU2CtF8ZAcGz4u+dc2iFUPOV6Z6iP4yavJOK9G8uuOlduI/67wTn3g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwAGJ-00041A-4p; Fri, 09 Aug 2019 21:09:15 +0200
Date:   Fri, 9 Aug 2019 21:09:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/4] net: phy: add phy_modify_paged_changed
Message-ID: <20190809190915.GY27917@lunn.ch>
References: <755b2bc9-22cb-f529-4188-0f4b6e48efbd@gmail.com>
 <741a9493-e9a1-be4e-a2e9-e15294362005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <741a9493-e9a1-be4e-a2e9-e15294362005@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 09, 2019 at 08:44:22PM +0200, Heiner Kallweit wrote:
> Add helper function phy_modify_paged_changed, behavios is the same
> as for phy_modify_changed.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
