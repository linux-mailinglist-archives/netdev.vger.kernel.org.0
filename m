Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6A11EC514
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 00:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgFBWdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 18:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727898AbgFBWdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 18:33:52 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCE0C08C5C0;
        Tue,  2 Jun 2020 15:33:52 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l10so254752wrr.10;
        Tue, 02 Jun 2020 15:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PtGVXqcTc64CdaV++HlXk2NwJAsozYe6VtwS/wGydGk=;
        b=JNnm978m2Tjes/vaXxc4gWPaS+ByDpoLLejQREPLD0TzRnBxR8wT78FibPzf06wSju
         VgIM6ZjOySipXtBVR8wmqgrJiS9CsaLbCjSjfgnCbO6i5A99avCGuWRVz9/+lkjLz7b0
         eOOmMATIQaA/RdsKvOKOewhOjXLHkeQlxG5AOdeQ2niJq8PnROq9Xvq5hhdlXO/LLkVU
         1OP2gr7729buJQOtcXAFp87gKtUXJqcEvp25B1c8J9g66CIH58d/ujdHPDfFH/86HoA3
         4IHh4wgq9sgeM52xfVQVr5YAGldvlwk4mVCF/MKv0hjcCsVf0UMFl/M6sF7ygphqWrg9
         9lbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PtGVXqcTc64CdaV++HlXk2NwJAsozYe6VtwS/wGydGk=;
        b=UryGCMm7/sOYGnt8X2E8wduzBC6x3MGLQmApHbYPi9AvpUATr/mvp45CGUY35xnOgp
         b+YaJCnkksmRvnIA5ovzldcqUXNBMYvwflYFHuxvhnySzXCLXh5oFXwGGluxOy6258Q2
         II7GBHHF/dwdnnSlAU8A7JgQgc3azpMcCE+0UtKZkxJyHKHqmpaUOQBXFaGHMFpy16sX
         xI0JNkJ/JjyX2kr/VBLohgzyfW376mE5G8sF498OZir9B59wvFHzqy9OUWHNUUKZPm6D
         uEUhqPUoV8md0FrxQxnDRBRtowPA/Ncu8gCo8r48ffLUUY18EMGH9yO2XOKFlEvHqJ+g
         FBNg==
X-Gm-Message-State: AOAM530kwQ5TloQoZEVNpiuQbc6unbBcw+INtOLkyQXYNJJPtZ9R7Hez
        qjjvPsmp034e7BRB3QkFn7qAat5b
X-Google-Smtp-Source: ABdhPJyIwCcPTPmX4Qo+4ikBX6m+r7Scb6XSJ0eeoHam69b347gB6Irc45DPlt4yAoAxuE90OM0IXA==
X-Received: by 2002:adf:82cf:: with SMTP id 73mr26888381wrc.382.1591137230357;
        Tue, 02 Jun 2020 15:33:50 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id c140sm313375wmd.18.2020.06.02.15.33.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 15:33:49 -0700 (PDT)
Subject: Re: [PATCH net-next v5 4/4] net: dp83869: Add RGMII internal delay
 configuration
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, robh@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20200602164522.3276-1-dmurphy@ti.com>
 <20200602164522.3276-5-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c3c68dcd-ccf1-25fd-fc4c-4c30608a1cc8@gmail.com>
Date:   Tue, 2 Jun 2020 15:33:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200602164522.3276-5-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/2/2020 9:45 AM, Dan Murphy wrote:
> Add RGMII internal delay configuration for Rx and Tx.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---

[snip]

> +
>  enum {
>  	DP83869_PORT_MIRRORING_KEEP,
>  	DP83869_PORT_MIRRORING_EN,
> @@ -108,6 +113,8 @@ enum {
>  struct dp83869_private {
>  	int tx_fifo_depth;
>  	int rx_fifo_depth;
> +	s32 rx_id_delay;
> +	s32 tx_id_delay;
>  	int io_impedance;
>  	int port_mirroring;
>  	bool rxctrl_strap_quirk;
> @@ -232,6 +239,22 @@ static int dp83869_of_init(struct phy_device *phydev)
>  				 &dp83869->tx_fifo_depth))
>  		dp83869->tx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
>  
> +	ret = of_property_read_u32(of_node, "rx-internal-delay-ps",
> +				   &dp83869->rx_id_delay);
> +	if (ret) {
> +		dp83869->rx_id_delay =
> +				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
> +		ret = 0;
> +	}
> +
> +	ret = of_property_read_u32(of_node, "tx-internal-delay-ps",
> +				   &dp83869->tx_id_delay);
> +	if (ret) {
> +		dp83869->tx_id_delay =
> +				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
> +		ret = 0;
> +	}

It is still not clear to me why is not the parsing being done by the PHY
library helper directly?
-- 
Florian
