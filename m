Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4B144B461
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 21:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244808AbhKIVBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 16:01:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53386 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240544AbhKIVBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 16:01:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Knm+1fWLBsxLEW41OBuptUN5iX3Ypk6GGtGuApg2Lwg=; b=wxMjZEwFBPrYee0kuYW/+Z9L6G
        gZCtp1/tutHLV44lg973zw8Z6C4TQd3yd9YcdcSrhCNXpC+JSZr3xQMzWAL+SedrvmxZq6IGlZ7i9
        NoqtU2kPqC/SlQVi/m3QE1Bmajrt8b9jvyC+VzdHj1gFXbyKKkYFSFCsKUnqYxSEUYFA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkYCJ-00D1Tq-2t; Tue, 09 Nov 2021 21:58:27 +0100
Date:   Tue, 9 Nov 2021 21:58:27 +0100
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
Subject: Re: [RFC PATCH v3 4/8] leds: trigger: netdev: rename and expose
 NETDEV trigger enum modes
Message-ID: <YYrg870zccL13+Mk@lunn.ch>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109022608.11109-5-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 03:26:04AM +0100, Ansuel Smith wrote:
> Rename NETDEV trigger enum modes to a more simbolic name and move them

symbolic. Randy is slipping :-)

> in leds.h to make them accessible by any user.

any user? I would be more specific than that. Other triggers dealing
with netdev states?

> +++ b/include/linux/leds.h
> @@ -548,6 +548,13 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
>  
>  #endif /* CONFIG_LEDS_TRIGGERS */
>  
> +/* Trigger specific enum */

You probably want netdev in the comment above. Things could get
interesting if other ledtrig-*.c started using them.

> +enum led_trigger_netdev_modes {
> +	TRIGGER_NETDEV_LINK,
> +	TRIGGER_NETDEV_TX,
> +	TRIGGER_NETDEV_RX,
> +};
> +
>  /* Trigger specific functions */
>  #ifdef CONFIG_LEDS_TRIGGER_DISK
>  void ledtrig_disk_activity(bool write);
> -- 
> 2.32.0
> 
