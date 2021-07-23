Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D423D403F
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 20:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhGWRpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 13:45:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43174 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229450AbhGWRo7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 13:44:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oY2FNzclhIrz3vI2UoQazNFY7UHToJcCYzU96z1FM8U=; b=UsAykoDu8b31wyB8cEhTTom9Sv
        yjkJJq3xe2cVf2N8Al2LkKv0TJ/ILHuOzrE35HugnUy02VXtbwSa0bW9lvnElG6s99VAb+aNBB6q/
        fBi0W01oY0Bab6p8G3qkzU6v4NseoRl0UvBWqnZlqJ3Fop/eV6J6tzNX9s15xcC0n0xA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6zrY-00EXDI-0y; Fri, 23 Jul 2021 20:25:32 +0200
Date:   Fri, 23 Jul 2021 20:25:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dario Alcocer <dalcocer@helixd.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
Message-ID: <YPsJnLCKVzEUV5cb@lunn.ch>
References: <6a70869d-d8d5-4647-0640-4e95866a0392@helixd.com>
 <YPrHJe+zJGJ7oezW@lunn.ch>
 <0188e53d-1535-658a-4134-a5f05f214bef@helixd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0188e53d-1535-658a-4134-a5f05f214bef@helixd.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > You probably don't want both ends of the link in rgmii-id mode. That
> > will give you twice the delay.
> 
> Ok, I'll change phy-mode to "rgmii" for both ends. It's a little confusing
> that there's a reference to phy-mode at all, though, given the actual
> connection is SERDES. My understanding is SERDES is a digital, PHY-less
> connection.

Is it even RGMII? You say SERDES, so 1000BaseX seems more likely.

   Andrew

