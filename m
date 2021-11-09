Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83C644B498
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 22:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245051AbhKIVZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 16:25:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53450 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239453AbhKIVZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 16:25:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ISdBaAAZxQUmmew+eT+xWQieHGeAsJuSmIgOUah8Lms=; b=4IFwaa3MVWpYnj01oTr2Wgr/jm
        IBgAQezGpVubUMmjUSGBPbVJd8QA/VRAfOnOWe9+nnL4Ohr15dF0fIah4JL1msufZx8DZzfDx4nme
        wkia3A2ZLrz3ErWyCk39BCKqOF1KYPpBfttHHgaYvHCFGt1J6Sg4gvmCm5DpYpHh/oPM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkYa1-00D1ZM-1r; Tue, 09 Nov 2021 22:22:57 +0100
Date:   Tue, 9 Nov 2021 22:22:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [RFC PATCH v3 7/8] net: dsa: qca8k: add LEDs support
Message-ID: <YYrmselghIy+qtn8@lunn.ch>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-8-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109022608.11109-8-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int
> +qca8k_parse_netdev(unsigned long rules, u32 *offload_trigger, u32 *mask)

This is a rather oddly named function, given that it is not actually
passed a netdev. netdev has a very well defined meaning in the network
stack, struct net_device.

       Andrew
