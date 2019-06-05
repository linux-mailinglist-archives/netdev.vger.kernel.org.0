Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1D536387
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 20:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfFESrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 14:47:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58926 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbfFESrZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 14:47:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=la0R5ezIHlgwQHPGw+iIQ0xWeX72WN8h/IOAyDQTieU=; b=2fcLxo0Oder1V17d5Cd5ZWrfEA
        TXauDjbQ9HgdPLX7dp8yZFPaCbn1IltKlRg3bq/+HhPXP8MpxhnPDrdxDJKpYAAmNffBavtrjlFfc
        dFOglStCudIE6WCLd8hl546drhKGeThsDAskX8cDOiMCiaKXXktsCb+sHbF95VokHD2c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYawW-0006qk-9N; Wed, 05 Jun 2019 20:47:24 +0200
Date:   Wed, 5 Jun 2019 20:47:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA with MV88E6321 and imx28
Message-ID: <20190605184724.GB19590@lunn.ch>
References: <8812014c-1105-5fb6-bc20-bad0f86d33ea@eks-engel.de>
 <20190604135000.GD16951@lunn.ch>
 <854a0d9c-17a2-c502-458d-4d02a2cd90bb@eks-engel.de>
 <20190605122404.GH16951@lunn.ch>
 <414bd616-9383-073d-b3f3-6b6138c8b163@eks-engel.de>
 <20190605133102.GF19627@lunn.ch>
 <20907497-526d-67b2-c100-37047fa1f0d8@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20907497-526d-67b2-c100-37047fa1f0d8@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I removed all phy-handle for the internal ports and in the mdio part 
> is only port 2 and 6 by now. But the Serdes ports are still not be
> recognized. So maybe there is still something wrong?

What do you mean by SERDES? Do you mean they are connected to an SFP
cage? If so, you need to add an SFP node. Take a look at
vf610-zii-dev-rev-c.dts for an example.

	Andrew
