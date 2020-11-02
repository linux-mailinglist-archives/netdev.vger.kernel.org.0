Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BDE2A36FF
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgKBXOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:14:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgKBXOD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:14:03 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8950C2225E;
        Mon,  2 Nov 2020 23:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604358842;
        bh=JYSJsk17G/MkDcAF1hgrNHR3iMIcUkYlqTo410ke1SE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e0hNRf4Gy/3O1b/Lg5jPwAWiON9MUDBnK6zdlMK/beuHGOcdtc26eEhvFxfSF54nW
         LmuhX8vY7TmIf5kfAP2Qx9U9i7uFyWC12b53zm+0yI6r+o4wo5IwNPW9WX0CIV2jD1
         RmAuLcQaqrV+EF1mUxUfaCPWOK0TpILmqEfsdiFs=
Date:   Mon, 2 Nov 2020 15:14:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH v3 0/3] add ast2400/2500 phy-handle support
Message-ID: <20201102151401.71fbe7c4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030133707.12099-1-i.mikhaylov@yadro.com>
References: <20201030133707.12099-1-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 16:37:04 +0300 Ivan Mikhaylov wrote:
> This patch introduces ast2400/2500 phy-handle support with an embedded
> MDIO controller. At the current moment it is not possible to set options
> with this format on ast2400/2500:
> 
> mac {
> 	phy-handle = <&phy>;
> 	phy-mode = "rgmii";
> 
> 	mdio {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		phy: ethernet-phy@0 {
> 			compatible = "ethernet-phy-idxxxx.yyyy";
> 			reg = <0>;
> 		};
> 	};
> };
> 
> The patch fixes it and gets possible PHYs and register them with
> of_mdiobus_register.

Applied, thanks!
