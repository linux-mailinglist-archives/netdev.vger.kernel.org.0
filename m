Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54E211F486
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 14:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfEOMgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 08:36:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36173 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbfEOMgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 08:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nqJ792hNsRF5B4mdwxz/MaOPie08EiN/LWwWI0jLcv4=; b=MT2vZP11EJmyuCzBiJh6cAKKoJ
        P7K18Gn5DtjyxbKKEo4eGzl8a1KHPXP9oAZRCzKAMqLWhEA/pFVD62QD5zG9kEqqAZJ9E5Yo+K/k+
        J+zNZJZuP/pXo/BatjzgKkx6MdfeErFcO5pwUls1stepfex4INiqrbIrkrXGeJuQQIlM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hQt95-0006P0-Ny; Wed, 15 May 2019 14:36:31 +0200
Date:   Wed, 15 May 2019 14:36:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Madalin-cristian Bucur <madalin.bucur@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: FW: [PATCH] net: phy: aquantia: readd XGMII support for AQR107
Message-ID: <20190515123631.GC23276@lunn.ch>
References: <VI1PR04MB5567F06E7A9B5CC8B2E4854CEC090@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <VI1PR04MB5567FAF88B84E9C77B93A40EEC090@VI1PR04MB5567.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB5567FAF88B84E9C77B93A40EEC090@VI1PR04MB5567.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 08:46:26AM +0000, Madalin-cristian Bucur wrote:
> XGMII interface mode no longer works on AQR107 after the recent changes,
> adding back support.

Hi Madalin

Please provide a Fixes: tag for fixes like this:

Fixes: 570c8a7d5303 ("net: phy: aquantia: check for supported interface modes in config_init")

I will let Heiner actually review it.

  Andrew
