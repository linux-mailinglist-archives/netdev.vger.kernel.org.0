Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59EEE27456
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 04:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfEWCZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 22:25:46 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46826 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfEWCZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 22:25:45 -0400
Received: by mail-pg1-f194.google.com with SMTP id o11so2073876pgm.13
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 19:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1FUtOQUkAe9SwSHxIj17EFEPI5EFcuvMwLUUt1nouzE=;
        b=MyB4Yph/hxGGbBF5ZyofzcpRV4qb5460OfV2BSiTlRSXxnY7TVFr7vMNLSgQTyGNKt
         g1/+59ULdQWDnRCbBFH6nct+U5Bx0wf8P2FbNHFRQ7oYl3IxEEU5lGMxdMMr3OkdO5bE
         /xTY5E5vhZ1mioT4/GpJjfFd/ujVJ7aryoslBYbUCb3SYCi/xf41+Z5R/6eEaMwxqlgb
         BmKbM1gE5kWN2tOYPbUYOT+sn8MB/Qx+inD3iPma+DK9tQ7SGhXQEiq864Sy05vXp3AX
         8T7MdtOQAOLr5xT1m1ZtiOTFeHJcIoMRdJxYhjaAijSTO9txS61L5l9CwVPrjHkLK4Mm
         IzHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1FUtOQUkAe9SwSHxIj17EFEPI5EFcuvMwLUUt1nouzE=;
        b=lDCtkvACbAgnbZHuMjwZpcud2VfQCMxMb6lrakQeKnfHQyHb16umNoH8ZzYHAUNxkS
         B5wstcLgo4MG3Nua3K1aYOOuAChE3ZXo7TE1pBdOvzXyQjk4Kdk5o5IKCoTs11cPL2V7
         LylRwLrbwlbn6HeyY1mqp7m31PCxS5znX/MyiuynxvJSR39q7RHavp4vUmpUPR0Li0jz
         aDcCRAi7UfTyzZxUrmqymwHQi83sBkr7aNdo81h4f+A2bpXmUI5pRwi2F09M4yYDPzwj
         UZm48vPjBWA9caR2FkVgt2atVr3AZVBhGdIS3b1wPHSJk/m6P1Qc4CM8aTpGmmrXMI1M
         /VAw==
X-Gm-Message-State: APjAAAWiaU6wcL+fyzGKj4OzqBlZMqklaaYWF+gus4kwLAH7NYF/lqHj
        EUUk0EVykj7f5Fqai3zTK9o=
X-Google-Smtp-Source: APXvYqxx3zwqT2J+ex8aIQ5QocW9W6vMtazpwAIuQ1U4sAAEq/Yu6Q/j+YYrG0lWClPOpVQxR4Un3Q==
X-Received: by 2002:a62:5487:: with SMTP id i129mr98659090pfb.68.1558578344994;
        Wed, 22 May 2019 19:25:44 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm23516090pfk.54.2019.05.22.19.25.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 19:25:43 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 5/9] net: phylink: Add phylink_create_raw
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-6-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <c2712523-f1b9-47f8-672b-d35e62bf35ea@gmail.com>
Date:   Wed, 22 May 2019 19:25:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523011958.14944-6-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/2019 6:20 PM, Ioana Ciornei wrote:
> This adds a new entry point to PHYLINK that does not require a
> net_device structure.
> 
> The main intended use are DSA ports that do not have net devices
> registered for them (mainly because doing so would be redundant - see
> Documentation/networking/dsa/dsa.rst for details). So far DSA has been
> using PHYLIB fixed PHYs for these ports, driven manually with genphy
> instead of starting a full PHY state machine, but this does not scale
> well when there are actual PHYs that need a driver on those ports, or
> when a fixed-link is requested in DT that has a speed unsupported by the
> fixed PHY C22 emulation (such as SGMII-2500).
> 
> The proposed solution comes in the form of a notifier chain owned by the
> PHYLINK instance, and the passing of phylink_notifier_info structures
> back to the driver through a blocking notifier call.
> 
> The event API exposed by the new notifier mechanism is a 1:1 mapping to
> the existing PHYLINK mac_ops, plus the PHYLINK fixed-link callback.
> 
> Both the standard phylink_create() function, as well as its raw variant,
> call the same underlying function which initializes either the netdev
> field or the notifier block of the PHYLINK instance.
> 
> All PHYLINK driver callbacks have been extended to call the notifier
> chain in case the instance is a raw one.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---

[snip]

> +	struct phylink_notifier_info info = {
> +		.link_an_mode = pl->link_an_mode,
> +		/* Discard const pointer */
> +		.state = (struct phylink_link_state *)state,
> +	};
> +
>  	netdev_dbg(pl->netdev,
>  		   "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
>  		   __func__, phylink_an_mode_str(pl->link_an_mode),
> @@ -299,7 +317,12 @@ static void phylink_mac_config(struct phylink *pl,
>  		   __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
>  		   state->pause, state->link, state->an_enabled);

Don't you need to guard that netdev_dbg() with an if (pl->ops) to avoid
de-referencing a NULL net_device?

Another possibility could be to change the signature of the
phylink_mac_ops to take an opaque pointer and in the case where we
called phylink_create() and passed down a net_device pointer, we somehow
remember that for doing any operation that requires a net_device
(printing, setting carrier). We lose strict typing in doing that, but
we'd have fewer places to patch for a blocking notifier call.
-- 
Florian
