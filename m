Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A95456070
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhKRQbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:31:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40876 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233086AbhKRQba (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 11:31:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=x603Vuqb2uS1SkS33VlV1KTm/fLVAqr9BnN2fGUMqFw=; b=Wt
        FZXNxeh6yZp2heucYEpg12tKhBBLhF0bhQCsVvN8uXz3qjBkisCiur2MACWdkJlGQlDBe3jWNmyOC
        Pgh2EdgHjNkRinu9NAkGdxzEY/2d6vjXa0tw7gc8LUac7t45ClV/d+G8WRTfj9XGyIFguwJuvwAWO
        QMABUG1rnZkV6rk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mnkGx-00E09Q-E8; Thu, 18 Nov 2021 17:28:27 +0100
Date:   Thu, 18 Nov 2021 17:28:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 2/8] net: Update documentation for
 *_get_phy_mode() functions
Message-ID: <YZZ/Kxm+IurAoDPi@lunn.ch>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211117225050.18395-3-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 11:50:44PM +0100, Marek Behún wrote:
> Now that the `phy-mode` DT property can be an array of strings instead
> of just one string, update the documentation for of_get_phy_mode(),
> fwnode_get_phy_mode() and device_get_phy_mode() saying that if multiple
> strings are present, the first one is returned.
> 
> Conventionally the property was used to represent the mode we want the
> PHY to operate in, but we extended this to mean the list of all
> supported modes by that PHY on that particular board.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
