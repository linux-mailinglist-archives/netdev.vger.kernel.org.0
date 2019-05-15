Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFAC1FA32
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 20:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfEOSoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 14:44:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36507 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbfEOSoS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 14:44:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KGUkxnvujTr8z52Es8wMOJtpOUPkjdoTMOM8b7GH1pE=; b=HfEdtfVYgwjL/3vGqZXATy0kcG
        KQ4KThaD04m+43z7HkcS5hcGzNTl0X87jwlMLyqJmvATPSsXU02ud6jkNDz9yswjngMkthS+tNerr
        GQQXH2YH58O0lpFUlcMrh+Yl3uqDQlhmDlTXtwnluBSm0+oCwg1sggkKa06COUn9hmdg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hQysu-0001GO-9F; Wed, 15 May 2019 20:44:12 +0200
Date:   Wed, 15 May 2019 20:44:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v2] net: phy: aquantia: readd XGMII support for AQR107
Message-ID: <20190515184412.GD24455@lunn.ch>
References: <VI1PR04MB556702627553CF4C8B65EE9FEC090@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <a7ba6f22-066e-5ab0-c42f-c275db579f32@gmail.com>
 <459eba93-e499-a78b-4318-907748033ccf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <459eba93-e499-a78b-4318-907748033ccf@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 07:25:14PM +0200, Heiner Kallweit wrote:
> On 15.05.2019 18:19, Florian Fainelli wrote:
> > On 5/15/19 8:07 AM, Madalin-cristian Bucur wrote:
> >> XGMII interface mode no longer works on AQR107 after the recent changes,
> >> adding back support.
> >>
> >> Fixes: 570c8a7d5303 ("net: phy: aquantia: check for supported interface modes in config_init")
> >>
> >> Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
> > 
> > Just so you know for future submissions, there is no need for a newline
> > between your Fixes: and Signed-off-by: tag, it's just a normal tag.
> > 
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > 
> I checked the datasheet and AQR107 doesn't support XGMII. It supports USXGMII,
> maybe XGMII is used as workaround because phy_interface_t doesn't cover
> USXGMII yet. If it makes the board work again, I think using XGMII is fine for
> now. But we should add USXGMII and the remove this workaround.

Hi Heiner

We should add USXGMII anyway. But that is net-next material, if it is
not the fix we go with.

    Andrew
