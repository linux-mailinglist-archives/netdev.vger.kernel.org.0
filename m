Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AA144CFFC
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 03:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbhKKCWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 21:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbhKKCWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 21:22:18 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D31C061766;
        Wed, 10 Nov 2021 18:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=8I7+4VLsEcy4md/FRNT12XUMaX6lslqCReTPDpGTn1E=; b=rVUgj3BA/MEeUAa977/8WxiqBi
        ps8ww31QjbfcsvfLkftrIVBEogaUg7W6FOv+yQRXyi+0/8QJIyrG56eY+xbf0DUpexBIM7MmmTfv5
        MRIll38HWK4MhVayoSmRQFZfTpMOjS5eCFvC5jO0Gi5nJB0oG3n/MHupaK2N1vdN/FG9CTLKwnEF1
        b15bPAuizqtZwE20Mu9lmf+df1AEGTi7gYd+lFWF9zX2V8ofsUFvbLFt9P/1llKFhUHPUzhw1+QVh
        YuLlYuRwbhCDR1RQjOGlWAZNqGqwNrrrAOV+yUJXhjcSoejEzW0FDZG6Ynd32VV0+ARw7etu259tT
        EB3gDRNQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkzgX-006pXE-Bu; Thu, 11 Nov 2021 02:19:29 +0000
Subject: Re: [RFC PATCH v4 7/8] net: dsa: qca8k: add LEDs support
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
References: <20211111013500.13882-1-ansuelsmth@gmail.com>
 <20211111013500.13882-8-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <4862f4a9-dcaa-e422-f086-619c42adc747@infradead.org>
Date:   Wed, 10 Nov 2021 18:19:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211111013500.13882-8-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/21 5:34 PM, Ansuel Smith wrote:
> diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
> index 7b1457a6e327..9f4bae5cc43d 100644
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
> +	  This enables support for LEDs present on the Qualcomm Atheros
> +	  QCA8K Ethernet switch chips. This require the LEDs offload

	                               This requires

> +	  triggers support as it can run in offload mode.


-- 
~Randy
