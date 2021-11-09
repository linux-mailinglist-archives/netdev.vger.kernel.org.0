Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E5E44B4C0
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 22:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245193AbhKIVbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 16:31:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53468 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245187AbhKIVbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 16:31:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UQf8COTFsagdrfbDjGeAFUwNVRG2xJ6sgcNzxAbi2GQ=; b=3vR5thXo5U0rqtVzvGah4Lsl/d
        /b2EEtsaZdO8VlZNYC7oCbh+PbezQOcZoRwCGBddHevqFI03oDQ3v6nOm49kzzNAlayYHgA/NCoQi
        E79jOZ/M8dMmqP7kugNMj1GgfhQghMImI3J6+ZwpMaJ0zkx0zcvQ+7yPUBJ8B7ZuUkBQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkYfS-00D1aM-7h; Tue, 09 Nov 2021 22:28:34 +0100
Date:   Tue, 9 Nov 2021 22:28:34 +0100
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
Subject: Re: [RFC PATCH v3 6/8] leds: trigger: add hardware-phy-activity
 trigger
Message-ID: <YYroAse2JQjLTK4J@lunn.ch>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-7-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109022608.11109-7-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* The attrs will be placed dynamically based on the supported triggers */
> +static struct attribute *phy_activity_attrs[PHY_ACTIVITY_MAX_TRIGGERS + 1];

This cannot be global. I have boards with a mixture of different PHYs
and switches. Each will have their own collection of supported
modes. And some PHYs have different modes per LED. 

       Andrew
