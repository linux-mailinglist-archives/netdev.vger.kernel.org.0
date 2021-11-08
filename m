Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C39F447895
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 03:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbhKHC3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 21:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236327AbhKHC27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 21:28:59 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FAEC061570;
        Sun,  7 Nov 2021 18:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=a7MOawtGg9i5nZII6P2Ie8CmqVA3XG+KbtxOuMforEQ=; b=HrlGF6fu5kimMloUUndF7EbFKv
        bX4pmQS9LsTdallxeQKSc4HDBeC2r4BuI9XlJ2X/8qMk3qm5bt9I0iQaxl8NWHqYinZ/+eWl7Zb33
        i7pSrhSXteZhcJTg/vLjqAH2mEj3QZNJB+0pX2SXbKqKb5CqfnaatpaWz1StS3rwTirRJJ3gDEC/a
        r8/w5RfEXJjprU8qA+vFyX1vRmtT1/3mJTZpbSBvWqJGjHfS8IOZ5nxinti+ZWTnywMf9q4QD73r5
        CPRXvxsoYZKRQXcMmZl+AwE5d28niTv3riV+vroXRYNfGHDzYl6Hs/RxTjtoRXZwj1trTFN369Iwa
        RRlLFF5A==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mjuMQ-008fRF-6Q; Mon, 08 Nov 2021 02:26:14 +0000
Subject: Re: [RFC PATCH v2 4/5] net: dsa: qca8k: add LEDs support
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
 <20211108002500.19115-5-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <733ca0f1-549c-207d-d3e8-cb5d5f41594a@infradead.org>
Date:   Sun, 7 Nov 2021 18:26:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211108002500.19115-5-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/21 4:24 PM, Ansuel Smith wrote:
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
