Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FAD40DA96
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbhIPNFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:05:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44110 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239126AbhIPNFE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 09:05:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8B+OSG6AvJiUOcpkuo1so2J3WnuBg527X2nenttNjoQ=; b=tbWQib1AOzPx+m/HjVbjSuSgUi
        Qxlvem8kHDl1TyqR2BDJ3v0G+DT9TAPKn6aLSsbMZjzTgYgt+MAVvaGZwt/ag13NgTiwnZiE+UMoU
        2u52dsesIOKGU8Xl3sEv/8ymrNU61aUbYQe8+6R3J+c/eWXM+mF3AEPSmmwmxxn76678=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mQr3C-006uNJ-0a; Thu, 16 Sep 2021 15:03:38 +0200
Date:   Thu, 16 Sep 2021 15:03:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net: macb: add support for mii on rgmii
Message-ID: <YUNAqSz3sUPqoGx6@lunn.ch>
References: <20210915064721.5530-1-claudiu.beznea@microchip.com>
 <20210915064721.5530-4-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915064721.5530-4-claudiu.beznea@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 09:47:21AM +0300, Claudiu Beznea wrote:
> Cadence IP has option to enable MII support on RGMII interface. This
> could be selected though bit 28 of network control register. This option
> is not enabled on all the IP versions thus add a software capability to
> be selected by the proper implementation of this IP.

Hi Claudiu

You are adding a feature without a user. That is generally not
accepted. Could you please also extend one of the macb_config structs
to make use of this?

Thanks
	Andrew
