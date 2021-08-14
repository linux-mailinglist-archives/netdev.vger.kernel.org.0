Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CD33EC3BA
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 18:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbhHNQIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 12:08:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50110 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235606AbhHNQIE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 12:08:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mRuVnCBvgkjat6fg3RT68ieG2C3wY5S3qtuLXhgeGyE=; b=Z+4OIwvYcDqmkKBXDPuHAMGjIa
        ONjEW2KASWd3vTREt+5P9FB061FvregAdClfVSfdB+cDklKJ4NKI99uu9Dv9g1hFZ+SF8935BWa6L
        nnNm1iLL5dQPW/lN9o4Hv7m3v5c2KMDDXWVV+qUm6SbKIY9hFJF9vKG+knFHUUrU7Cwk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mEwBx-0005BJ-5b; Sat, 14 Aug 2021 18:07:25 +0200
Date:   Sat, 14 Aug 2021 18:07:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Song Yoong Siang <yoong.siang.song@intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: phy: marvell: Add WAKE_PHY support to
 WOL event
Message-ID: <YRfqPSHLKNTQjYif@lunn.ch>
References: <20210813084508.182333-1-yoong.siang.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813084508.182333-1-yoong.siang.song@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 04:45:08PM +0800, Song Yoong Siang wrote:
> Add Wake-on-PHY feature support by enabling the Link Up Event.
> 
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
