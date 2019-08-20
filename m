Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7067964F8
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbfHTPpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:45:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45470 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbfHTPpk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 11:45:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=28WmtNRSVcK+8PRWzoy6f7dmDxlsxc5JHfaU6aqeQDU=; b=LUyNr/dMWIXi7JsIb1OrRsR/nD
        taK5+fttJfhl5pqaiUHEV5GDK68RIwk+0j4vYoBzoqGqqA1R2wZWNzpQmf3Zi4MJoeYVWfHH2Av2D
        953p7sGDsnUO+4z9CIf8NnjNshh3h5rB+CVWw/ORuNFKvb159KDjxbRgmkZLsZVUiIlw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i06KH-0006fY-09; Tue, 20 Aug 2019 17:45:37 +0200
Date:   Tue, 20 Aug 2019 17:45:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Allan W . Nielsen" <allan.nielsen@microchip.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [v3] ocelot_ace: fix action of trap
Message-ID: <20190820154536.GM29991@lunn.ch>
References: <20190820042005.12776-1-yangbo.lu@nxp.com>
 <20190820070518.mypyahquun6t4yjf@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820070518.mypyahquun6t4yjf@lx-anielsen.microsemi.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 09:05:20AM +0200, Allan W . Nielsen wrote:
> Hi,
> 
> This is fixing a bug introduced in b596229448dd2

Hi Allan

You should express that as:

Fixes: b596229448dd ("net: mscc: ocelot: Add support for tcam")

       Andrew
