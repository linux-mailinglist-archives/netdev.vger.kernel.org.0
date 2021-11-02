Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E9F443448
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 18:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhKBRIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 13:08:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43602 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229806AbhKBRIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 13:08:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AOqjbBh/BD17suyYJOyKmg91M89/wFt3IOmGx9TZplw=; b=XbIrEyjJWLr0GG1Qd1ikr8/f6O
        OU6YKf7YID/5SSPapNJCAAKrh+nGMP/AlcbGU3VOqYriTtcynK7XZBblJoAC3K5QwLfd3vyE83ypA
        N2S1zqC6+yFo25v27fd7GGisTO/rbzp4PwP8sv9tpLU8RewRjY0HEMCEZoXr/jV/FSyY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mhxE0-00CQHB-7u; Tue, 02 Nov 2021 18:05:28 +0100
Date:   Tue, 2 Nov 2021 18:05:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nisar.sayed@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [net-next] net: phy: microchip_t1: add
 lan87xx_config_rgmii_delay for lan87xx phy
Message-ID: <YYFv2LCg93wvRRQb@lunn.ch>
References: <20211101162119.29275-1-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101162119.29275-1-yuiko.oshino@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 12:21:19PM -0400, Yuiko Oshino wrote:
> Add a function to initialize phy rgmii delay according to phydev->interface.
> 
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
