Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FA54A6A5F
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 03:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243898AbiBBC41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 21:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbiBBC41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 21:56:27 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1359BC061714;
        Tue,  1 Feb 2022 18:56:27 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id s16so17035799pgs.13;
        Tue, 01 Feb 2022 18:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=2yRKNHx/xauWYxpu2ZUp2GgoA37uc6+7VJXoeQh4hxw=;
        b=oNLA3acQKFhjApXA7fzgIJG9m1bapEGdW5Gv9rueazwKOh2w7dwXCH+Vd3iENhTrRg
         Vimo8PafHwxPGgxiDNvPlWdn0Q3Pm+poNGl67dIsPK4mnj8/l1ObcDcAr8n6Q6TgyhJY
         LaQnlF2xkMGThr1tGBihfFihJd6Z64eQvS1Qifbe7Qi8U4cOWzr4/NDn5vt8MYm0RsRa
         sybCagL+YCIljnVbZvhMfu5XG4HFg3eTUChxrL33/54wwOWyi7wjVouIm+BmKk2JmAHh
         DzFd0s7m84Gl6J5in3IlIoIodpakxaiVgcx0zd0excLrxFqufhxVin2dnTDbtzfD3QrK
         YY9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2yRKNHx/xauWYxpu2ZUp2GgoA37uc6+7VJXoeQh4hxw=;
        b=idfEP+PzdfCOKgz/6S8OHXhNvrzFH+9jPSEEpXJTolY5QTgD1zRvxaqnWdl58ySlUq
         Lj0TP4ea2W18eOS5zkyBPMyatnMbgv6cHVXo4J7skuoRdvGcV1IxFk5qNXubOCXvOgNd
         OJwTJpgi0uDIydbm0VRIebHDA4QgxDs5xwFh5fTR5Afw44QOKQCnOu+3h3NM4BqlDYQj
         PBPljamWdkKzWRjbJTRAgY9pwjHvo8ZmrEq2bMAM2aDzs6+kXui479X8+uIBliH3lYLe
         y0ZyL16UbYe05m11UBn3uEIojA5VYxhC32qYV8P04DxHaiJDtG56ed+QYdDfZUY/LeA+
         Gwlw==
X-Gm-Message-State: AOAM531uwAf9iVxT8kevbfbxPeln/q2nqytETm3ab3Nt2ezkxzEnr7mM
        MzxGNNIDJIVJMSQ5K2Xt2Og=
X-Google-Smtp-Source: ABdhPJxdJGab9trExuG/ZnBYd3JkMFrqPFD+MpbcZqjInkaoyhDSWWZsxrbZd6dhbzSeCXhA5hVPag==
X-Received: by 2002:aa7:8a05:: with SMTP id m5mr27599412pfa.40.1643770586235;
        Tue, 01 Feb 2022 18:56:26 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:a52e:6781:7ca4:b203? ([2600:8802:b00:4a48:a52e:6781:7ca4:b203])
        by smtp.gmail.com with ESMTPSA id k13sm25122249pfc.176.2022.02.01.18.56.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 18:56:25 -0800 (PST)
Message-ID: <b7176bb1-d36f-4b22-56cf-fcd14ea769ba@gmail.com>
Date:   Tue, 1 Feb 2022 18:56:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [net-next PATCH v8 07/16] net: dsa: tag_qca: add define for
 handling MIB packet
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
 <20220202000335.19296-8-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220202000335.19296-8-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/1/2022 4:03 PM, Ansuel Smith wrote:
> Add struct to correctly parse a mib Ethernet packet.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>   include/linux/dsa/tag_qca.h | 10 ++++++++++
>   net/dsa/tag_qca.c           |  4 ++++
>   2 files changed, 14 insertions(+)
> 
> diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
> index f366422ab7a0..1fff57f2937b 100644
> --- a/include/linux/dsa/tag_qca.h
> +++ b/include/linux/dsa/tag_qca.h
> @@ -62,4 +62,14 @@ struct qca_mgmt_ethhdr {
>   	__be16 hdr;		/* qca hdr */
>   } __packed;
>   
> +enum mdio_cmd {
> +	MDIO_WRITE = 0x0,
> +	MDIO_READ
> +};
> +
> +struct mib_ethhdr {
> +	u32 data[3];		/* first 3 mib counter */
> +	__be16 hdr;		/* qca hdr */
> +} __packed;

For consistency with patch 7, you might want to name this structure 
qca_mib_ethhdr?

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
