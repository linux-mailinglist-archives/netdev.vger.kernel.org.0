Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615DA9EA38
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 15:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfH0N5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 09:57:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34572 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbfH0N5x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 09:57:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ibDprqxGGGkAsR31RiU/73eD4xWaPjFS0Gvom0e0Fnk=; b=O58UjFxUf0TwXfWIf3KNzQpdlD
        PzJu13cvrObDGxzcTsObUaUoS9DVS67tReERL2QbVB63jssToRvdfZijnvWrhZqRrSoPL3/7867k9
        Z4A4OO/iWTh0eoKhN1h7xIhWiTFsZC6szIkKglGPe/SlpaFr1eyI+7WbgLtVRjZMguTc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2byp-0003fp-Bw; Tue, 27 Aug 2019 15:57:51 +0200
Date:   Tue, 27 Aug 2019 15:57:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v5 6/6] net: dsa: mv88e6xxx: fully support
 SERDES on Topaz family
Message-ID: <20190827135751.GN2168@lunn.ch>
References: <20190826213155.14685-1-marek.behun@nic.cz>
 <20190826213155.14685-7-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190826213155.14685-7-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 11:31:55PM +0200, Marek Behún wrote:
> Currently we support SERDES on the Topaz family in a limited way: no
> IRQs and the cmode is not writable, thus the mode is determined by
> strapping pins.
> 
> Marvell's examples though show how to make cmode writable on port 5 and
> support SGMII autonegotiation. It is done by writing hidden registers,
> for which we already have code.
> 
> This patch adds support for making the cmode for the SERDES port
> writable on the Topaz family, via a new chip operation,
> .port_set_cmode_writable, which is called from mv88e6xxx_port_setup_mac
> just before .port_set_cmode.
> 
> SERDES IRQs are also enabled for Topaz.
> 
> Tested on Turris Mox.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
