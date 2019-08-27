Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 847489E862
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 14:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbfH0Mvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 08:51:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34212 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbfH0Mvs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 08:51:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DBTatqI3H5K1xCSN2ZBvs+q+QhJcXdjDafQvqeHpr2U=; b=lfYa0GwTEentODawKHL8fO8k/H
        ouE/T5kbz1FOFHXtvOIMnRvr99SAxzlbdx0IE/AnnmY9NXH4jnhGfohJrMrDNb04OYzQ99UwVsV+d
        FrqIY88r7AaPALwwIzhVWubRm0W9ZvBkGQLzqIQDR7wkcvqhTziMafYtbkUJKEVeiMDA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2awh-00039D-J6; Tue, 27 Aug 2019 14:51:35 +0200
Date:   Tue, 27 Aug 2019 14:51:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Razvan Stefanescu <razvan.stefanescu@microchip.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] net: dsa: microchip: fix interrupt mask
Message-ID: <20190827125135.GA11471@lunn.ch>
References: <20190827093110.14957-1-razvan.stefanescu@microchip.com>
 <20190827093110.14957-4-razvan.stefanescu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827093110.14957-4-razvan.stefanescu@microchip.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 12:31:09PM +0300, Razvan Stefanescu wrote:
> Global Interrupt Mask Register comprises of Lookup Engine (LUE) Interrupt
> Mask (bit 31) and GPIO Pin Output Trigger and Timestamp Unit Interrupt
> Mask (bit 29).
> 
> This corrects LUE bit.

Hi Razvan

Is this a fix? Something that should be back ported to old kernels?

Thanks
	Andrew
