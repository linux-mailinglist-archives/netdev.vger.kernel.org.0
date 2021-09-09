Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B69A40425C
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 02:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348817AbhIIApM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 20:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236691AbhIIApL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 20:45:11 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F5CC061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 17:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=ew5QYPbPJ/o4pTFTg2ayebJJPbb2Gmw8UMiGKe9CjCI=; b=PFXcVGZxkaqsFhEpWZHX5U8uR0
        SJsQugjmrhVjyAdvY7p4neLMPv/uDZPe72qFB15VVpr89XPY/UeO7uWYv3WyXy3+ImJpFacH6oXa5
        j90+59DIsg2TcWo43NTwjciS6V9D4iQImeBwVYL0/N2tw01O6yOLf4YDW4PkBZuWuAULPb+nMTqdD
        MkXGWAFafm+amEK15h+e+k5UX0AJrZbp81SPsv8aA4+emZf1Vw+aiPUd41N/uUkrc9goo7mKdXV19
        rblCrdw3cfCHqo6Ii3VQULpiwVcSYVQS41VK2tLpJp8g0DVUzHBdwTE0EOhBLTpblbQYGE6MrZmbq
        a8hyF5OA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mO8Ac-007s10-1F; Thu, 09 Sep 2021 00:44:02 +0000
Subject: Re: [RFC PATCH net 1/2] net: dsa: sja1105: split out the probing code
 into a separate driver
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20210909001736.3769910-1-vladimir.oltean@nxp.com>
 <20210909001736.3769910-2-vladimir.oltean@nxp.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <325e1baa-194a-9aa6-adfb-845b1e65bd60@infradead.org>
Date:   Wed, 8 Sep 2021 17:44:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210909001736.3769910-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/21 5:17 PM, Vladimir Oltean wrote:
> diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
> index 1291bba3f3b6..33f948d9ea18 100644
> --- a/drivers/net/dsa/sja1105/Kconfig
> +++ b/drivers/net/dsa/sja1105/Kconfig
> @@ -23,6 +23,10 @@ tristate "NXP SJA1105 Ethernet switch family support"
>   	    - SJA1110C (Gen. 3, SGMII, TT-Ethernet, 100base-TX PHY, 7 ports)
>   	    - SJA1110D (Gen. 3, SGMII, TT-Ethernet, no 100base-TX PHY, 7 ports)
>   
> +config NET_DSA_SJA1105_PROBE
> +tristate "Actual driver that probes the hardware"

Missing a tab before "tristate".

> +	depends on NET_DSA_SJA1105
> +


-- 
~Randy

