Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B56BC2C79D
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 15:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfE1NRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 09:17:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35298 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbfE1NRH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 09:17:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Nx0WFg4JylqUNt6U67rRi03CoJBZleoy9G/HYXkdG0c=; b=pRy6/dc07bb4YZ1Ckru5uOPf2D
        OjE003XRHfF7Fei62CvOJYwmwev3JuuRXvDfsqb0DeA1/+02LW49VGz4I29TgOOr43CsHtwopzw3A
        yMih1COR8IZAz8ZHnoZ7/TZ+ea0ot5+nJmXoOd8gay5OdXhBwjWj637O5lcEaE+VyMY0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVbyT-0006DR-UV; Tue, 28 May 2019 15:17:05 +0200
Date:   Tue, 28 May 2019 15:17:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Greg Ungerer <gerg@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Set correct interface mode for
 CPU/DSA ports
Message-ID: <20190528131705.GB18059@lunn.ch>
References: <e27eeebb-44fb-ae42-d43d-b42b47510f76@kernel.org>
 <20190524134412.GE2979@lunn.ch>
 <f83b9083-4f2e-5520-b452-e11667c5c1cd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f83b9083-4f2e-5520-b452-e11667c5c1cd@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> My hardware has the CPU port on 9, and it is SGMII. The existing working
> devicetree setup I used is:
> 
>                        port@9 {
>                                 reg = <9>;
>                                 label = "cpu";
>                                 ethernet = <&eth0>;
>                                 fixed-link {
>                                         speed = <1000>;
>                                         full-duplex;
>                                 };
>                         };

Hi Greg

You might need to set the phy-mode to SGMII. I'm surprised you are
using SGMII, not 1000Base-X. Do you have a PHY connected?

      Andrew
