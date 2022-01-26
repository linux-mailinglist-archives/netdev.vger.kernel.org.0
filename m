Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D2549CB1B
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240816AbiAZNoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:44:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55482 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240712AbiAZNn4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 08:43:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YYEvJBocUH/KLpNMMfu5AW4l7LUPPfrRaUH1KkNvP44=; b=Z2ThnmSkqkecPo5Gid0gtGL1kg
        gltfJooULn+qIFK5WyZoXRsrmJm/U1Dx7Ldi897dPkqm33oV6b/jPM4NCNhDXum3kaKGsz4z2+gn/
        j9fBJykJ1LTKrb9rQktm6PMnATo8wzYwH/WmyBlsc3dGgaxw39TOaVmlu+a6viKcz9Yk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nCiaZ-002oXq-Ac; Wed, 26 Jan 2022 14:43:55 +0100
Date:   Wed, 26 Jan 2022 14:43:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, danieller@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [PATCH net-next 4/9] mlxsw: spectrum_ethtool: Add support for
 two new link modes
Message-ID: <YfFQG7iuOdhvaRw/@lunn.ch>
References: <20220126103037.234986-1-idosch@nvidia.com>
 <20220126103037.234986-5-idosch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126103037.234986-5-idosch@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 12:30:32PM +0200, Ido Schimmel wrote:
> From: Danielle Ratson <danieller@nvidia.com>
> 
> As part of a process for supporting a new system with RJ45 connectors,
> 100BaseT and 1000BaseT link modes need to be supported.

I'm surprised you don't have 2500BaseT, 5000baseT and 10000BaseT?

    Andrew
