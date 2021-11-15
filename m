Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62284514C4
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 21:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349495AbhKOUM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 15:12:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34148 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347617AbhKOT51 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 14:57:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RsGuekoHyVQ4L/u/h+ZvgcCwmUZRxx8WixvmrQ+kYe8=; b=GrOcTMPRVUiwOn7I6AyfWhseZt
        WZOyoWt3gP7WKXyFkaSWYszNyFakJQi72N9eAMMr4HSorwvDH9IuRHzrEg94VxXiDfCRm5D9VSrPN
        fcCyv56r4ya6f1/vYAp6/AcyyU6eHzBSgy4C9YkCAq7uYWUjDR725+7PjbZi+2jY9rkw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mmi3f-00DWi0-Mz; Mon, 15 Nov 2021 20:54:27 +0100
Date:   Mon, 15 Nov 2021 20:54:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phylink: add generic validate
 implementation
Message-ID: <YZK6863Q8m5RgY9D@lunn.ch>
References: <YZIvnerLwnMkxx3p@shell.armlinux.org.uk>
 <E1mmYmp-006nOe-Gs@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1mmYmp-006nOe-Gs@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell

> +	case PHY_INTERFACE_MODE_TBI:
> +	case PHY_INTERFACE_MODE_MOCA:
> +	case PHY_INTERFACE_MODE_RTBI:

For some reason, i think one of these can do 2.5G. But i cannot
remember where i have seen this. Maybe b53?

	 Andrew
