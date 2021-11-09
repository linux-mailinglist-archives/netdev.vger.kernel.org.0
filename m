Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0C744A693
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 07:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243049AbhKIGGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 01:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243022AbhKIGGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 01:06:23 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B75DC061764;
        Mon,  8 Nov 2021 22:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=OSiVmEctRFAInEF+kuhKPhF8Bk8dgP3Se4G/4Mqpat4=; b=oRz4DQY02uZDr76wG2WIx47pRB
        Tsy1V+HRrYysgIypC3ceMW7IGyo9I/hlrtz/I8UNEQx7zE+ZuTOA0Nbv3oOwCXOHxONW96TBOyZUJ
        br2bGEcykWko3GIkH90XTc6uTHeTomtZsWZfj50VEn0rd/i0ZC+hRuuna+Nxo0qiriG2UfTpo/5xK
        7gVQHBCrK5JZjPksOJa/G4ocW7LhfiQ0aBLfKIbgRGZldBwNMf7J1hlYdL2Agw9MK2rDvvo5XEIiF
        BAyhsJFq2Kvma24P/tP6rkcR9PfnGnvrsXE/7fue4WRNdavyCAtA59gVmT1I8U4GPPZkrxKg/sqbs
        gDKbbHrw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkKEJ-008lkQ-LK; Tue, 09 Nov 2021 06:03:35 +0000
Subject: Re: [RFC PATCH v3 7/8] net: dsa: qca8k: add LEDs support
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
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-8-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2b36fd25-a71e-0902-18d1-73624de169c8@infradead.org>
Date:   Mon, 8 Nov 2021 22:03:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211109022608.11109-8-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/21 6:26 PM, Ansuel Smith wrote:
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
