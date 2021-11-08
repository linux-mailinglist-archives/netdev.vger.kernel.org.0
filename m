Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEB3447890
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 03:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhKHC1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 21:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236349AbhKHC1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 21:27:49 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2192C061570;
        Sun,  7 Nov 2021 18:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=fXq7+MPtzIJaHy2u5Sla+LxJHB+7hwlQh6EuB/DXOcE=; b=nfdpIMcKnxJmCRj/alHgM4rBdx
        +lRosgdUbAH2qS4k9JA8Os9CfC8FYJgUbAUfynhdFHqyTtF6wLWTaguJs3mbBw+bEUncZ2UVfLItE
        QZUZ+ZN69hbJ8bJnyEGkZ95C0/5/gLtCo6kADpPtEsGs++P0OsQHLdvwMeXhM+ctZ0HdSWl467jX5
        5MaeT1JwBQnVQYV+TVVkFF2Z30AWCzZ/PQ/fiEWzrwer8EPOAwaUxnajIcy69TN6Yobj0IEZbFfJc
        XsGue80NTSf5ra77qz60CfUU5LcQzfLNWLinKYRDsfWV3VCtAPNMSEP4lwSYBjAvGJzKLKZqoP4/7
        QkVXOpzg==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mjuLG-008fQY-Nt; Mon, 08 Nov 2021 02:25:03 +0000
Subject: Re: [RFC PATCH v2 3/5] leds: trigger: add offload-phy-activity
 trigger
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
 <20211108002500.19115-4-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <72114aa0-3154-2027-0eae-36d08003e436@infradead.org>
Date:   Sun, 7 Nov 2021 18:24:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211108002500.19115-4-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/21 4:24 PM, Ansuel Smith wrote:
> diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
> index 33aba8defeab..14023e160ba1 100644
> --- a/drivers/leds/trigger/Kconfig
> +++ b/drivers/leds/trigger/Kconfig
> @@ -164,4 +164,33 @@ config LEDS_TRIGGER_TTY
>   
>   	  When build as a module this driver will be called ledtrig-tty.
>   
> +config LEDS_OFFLOAD_TRIGGER_PHY_ACTIVITY
> +	tristate "LED Offload Trigger for PHY Activity"
> +	depends on LEDS_OFFLOAD_TRIGGERS
> +	help
> +	  This allows LEDs to be configured to run by hardware and offloaded

	                                    to be run

> +	  based on some rules. The LED will blink or be on based on the PHY

Could "on" be changed to ON or "on" or 'on' here:    be ON based on the PHY

> +	  Activity for example on packet receive or based on the link speed.


-- 
~Randy
