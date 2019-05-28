Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8BC2CDB4
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 19:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfE1Rfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 13:35:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36158 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfE1Rfd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 13:35:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/sDHNkreaiokSCQawvYTzF63R7CsKODbhkGPPJJxGN0=; b=qfNx8/NGeQ3CDfj/IKWsxJL5/F
        sfy2ZhsLXIYEY06kN8i3wT+LSOD/g9DghxPDPzbAChsof6iRlEUgC3xZBRJWOSzZjsl/Skpo7n+Qz
        w2t7XwRRM/YD0n9XNKvE6hdLpj4ba2HTev+f4X5Od62KUxZeIiMGS+N8FzFMSvu/0pzI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVg0V-0001aS-RM; Tue, 28 May 2019 19:35:27 +0200
Date:   Tue, 28 May 2019 19:35:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: remove 1000/Half from supported modes
Message-ID: <20190528173527.GT18059@lunn.ch>
References: <ac29e5b9-2d8a-f68d-db1b-cdb3d3110922@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac29e5b9-2d8a-f68d-db1b-cdb3d3110922@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 06:43:46PM +0200, Heiner Kallweit wrote:
> MAC on the GBit versions supports 1000/Full only, however the PHY
> partially claims to support 1000/Half. So let's explicitly remove
> this mode.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
