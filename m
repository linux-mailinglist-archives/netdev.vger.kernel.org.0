Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5299D2CE566
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 02:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgLDBur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 20:50:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37692 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbgLDBur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 20:50:47 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kl0EP-00A8RT-Kt; Fri, 04 Dec 2020 02:49:57 +0100
Date:   Fri, 4 Dec 2020 02:49:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aleksander Jan Bajkowski <A.Bajkowski@stud.elka.pw.edu.pl>
Subject: Re: [PATCH 1/2] net: dsa: lantiq: allow to use all GPHYs on xRX300
 and xRX330
Message-ID: <20201204014957.GB2414548@lunn.ch>
References: <20201203220347.13691-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203220347.13691-1-olek2@wp.pl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static const struct of_device_id gswip_of_match[] = {
>  	{ .compatible = "lantiq,xrx200-gswip", .data = &gswip_xrx200 },
> +	{ .compatible = "lantiq,xrx300-gswip", .data = &gswip_xrx300 },
> +	{ .compatible = "lantiq,xrx330-gswip", .data = &gswip_xrx300 },
>  	{},

Is there an ID register which allows you to ask the silicon what it
is?

It would be good to verify the compatible string against the hardware,
if that is possible.

   Andrew
