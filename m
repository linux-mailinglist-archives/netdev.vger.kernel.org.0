Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0385F447655
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 23:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbhKGWmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 17:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhKGWmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 17:42:02 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE8CC061570;
        Sun,  7 Nov 2021 14:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=PmwYb1Y+0nrcqzDdt9kSR5YkjpQULhtxa7MT6E4cwBg=; b=DPjn4iD+6Q6K84USIrkCgk32Vk
        uEuMl9WP+HKtzZlvcHg4KxZ/Tkk2rZ0y3CasXVLCh2Fq/zpqxIT3xktBJQ9eArO6a5V7rhvRdyzBe
        9hsCOW8NIlWeW5d93vaRRm8Dhuh8sa5jaj98rceu61bblu8Y7GnvnGBDeBxl0RBIsIbbOqMXYv5Fq
        1KMaR8VuGdaeTvF5ih2BeR1CNlR1+t/i9yjC4OVfYCsOvXRe2luZiYLdMXPiFnNPtbfEVgSy8XaeM
        gA60auQIu/kufb8m5I+rE+XJaG/SVUCM7wnyJK83qwp3hDOab2C6SH/MlQcvJKHrA/txrlx2FXreb
        xGx+7wuQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mjqoh-008erC-7Z; Sun, 07 Nov 2021 22:39:11 +0000
Subject: Re: [RFC PATCH 5/6] net: dsa: qca8k: add LEDs support
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
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
 <20211107175718.9151-6-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <12246333-e183-cf6b-fe02-7a028b517951@infradead.org>
Date:   Sun, 7 Nov 2021 14:39:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211107175718.9151-6-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/21 9:57 AM, Ansuel Smith wrote:
> diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
> index 7b1457a6e327..89e36f3a8195 100644
> --- a/drivers/net/dsa/Kconfig
> +++ b/drivers/net/dsa/Kconfig
> @@ -67,6 +67,15 @@ config NET_DSA_QCA8K
>   	  This enables support for the Qualcomm Atheros QCA8K Ethernet
>   	  switch chips.
>   
> +config NET_DSA_QCA8K_LEDS_SUPPORT
> +	tristate "Qualcomm Atheros QCA8K Ethernet switch family LEDs support"
> +	select NET_DSA_QCA8K
> +	select LEDS_OFFLOAD_TRIGGERS
> +	help
> +	  Thsi enabled support for LEDs present on the Qualcomm Atheros

	  This enables

> +	  QCA8K Ethernet switch chips. This require the LEDs offload

	                                    requires

> +	  triggers support as it can run in offload mode.


-- 
~Randy
