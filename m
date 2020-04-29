Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BC81BD0D4
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 02:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgD2AM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 20:12:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58356 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgD2AM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 20:12:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=w6Nb671ndMc3bO0xMpa2dGWdYRiyD5E+lmZfrv/zSmM=; b=elgAk5fL6P+yFEZsCZrRjUV4sF
        u71FovvOG3ax4aXZsHwz/JMHX14iXDRthLzQmfRSe9qBaxffAUaVZp72K5bOcOdoWtw33ATNcfM7Z
        JFC770jC7kqN2QlY7r42bmzrRtH6RS6cRlCUxTgkcepo4jKNhZDiKh2tD4YordPVMbhw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTaLN-000BQs-P2; Wed, 29 Apr 2020 02:12:53 +0200
Date:   Wed, 29 Apr 2020 02:12:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 4/4] net: phy: bcm54140: add second PHY ID
Message-ID: <20200429001253.GB22077@lunn.ch>
References: <20200428230659.7754-1-michael@walle.cc>
 <20200428230659.7754-4-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428230659.7754-4-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 01:06:59AM +0200, Michael Walle wrote:
> This PHY has two PHY IDs depending on its mode. Adjust the mask so that
> it includes both IDs.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
