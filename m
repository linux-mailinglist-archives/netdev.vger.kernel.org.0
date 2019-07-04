Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7DC5FB3F
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 17:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfGDPxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 11:53:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54318 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbfGDPxt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 11:53:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nMGORR3OSTbstKlSpsVFyDFAakghkQRIUL1Kg5fHKJI=; b=sSjON5RzcSeQKMOy5lRCWEK/9M
        9sfRQ7suzwer8JKvoOzXFK7WM1wc1HWJDROkNRx8IVtfaDnf+mlFCxn56m1ikMlEC/3ZfNelR1GlH
        aX1ypy4oWejuGRF6QXJ49JS8lfDl4Xy4rtDtX7hPfILS7by4GHuy4MkzA7FkciKbXhcg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hj43P-0004nB-Di; Thu, 04 Jul 2019 17:53:47 +0200
Date:   Thu, 4 Jul 2019 17:53:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: i.mx6ul with DSA in multi chip addressing mode - no MDIO access
Message-ID: <20190704155347.GJ18473@lunn.ch>
References: <21680b63-2d87-6841-23eb-551e58866719@eks-engel.de>
 <20190703155518.GE18473@lunn.ch>
 <d1181129-ec9d-01c1-3102-e1dc5dec0378@eks-engel.de>
 <20190704132756.GB13859@lunn.ch>
 <00b365da-9c7a-a78a-c10a-f031748e0af7@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00b365da-9c7a-a78a-c10a-f031748e0af7@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> &mdio0 {
>         interrupt-parent = <&gpio1>;
>         interrupts = <3 IRQ_TYPE_LEVEL_HIGH>;
> 
>         switch0: switch0@2 {
>                 compatible = "marvell,mv88e6190";
>                 reg = <2>;
>                 pinctrl-0 = <&pinctrl_gpios>;
>                 reset-gpios = <&gpio4 16 GPIO_ACTIVE_LOW>;
>                 dsa,member = <0 0>;

This is wrong. The interrupt is a switch property, not an MDIO bus
property. So it belongs inside the switch node.

	  Andrew
