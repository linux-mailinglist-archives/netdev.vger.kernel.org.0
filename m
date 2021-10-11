Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35A74284F2
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 04:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbhJKCDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 22:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbhJKCDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 22:03:13 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CF4C061570;
        Sun, 10 Oct 2021 19:01:14 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id i1so13950176qtr.6;
        Sun, 10 Oct 2021 19:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=IgVcBedZFvU6rFnvf0HN+oIcpc5+WAW7LeBytaWhFpU=;
        b=O1MJ3jeGJpw6fwqEzPN7gjAHkmqZHww/LLBwt4mvrCi/5szqMPLTjFovLseonI99Hd
         Q3R3mmHHDNI3MT/Lnrmc6JveRkqMxm9so5ODfaQa1VX8X2262BN3dJbd1g/EhOpGt23Y
         q5NzTXIMar0xifj+DJXZa4A7X96fnouVpZTpbWNQSzHyzgPPKe35OBKPUZVopXquU7Mr
         ab3BkGN/cMBznm2OEHlaETWwpag6Ph9meQJ58q9gg0MvZpSi3MBuvR5roIy50GW8qQ14
         vLpxrxCQUZxZ9i+AK/SwILkaHdCjQ5YFTFX7OYXEgm+OY0G9/H8FcMrPJPLG1mohr4ut
         X3bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IgVcBedZFvU6rFnvf0HN+oIcpc5+WAW7LeBytaWhFpU=;
        b=xy3p1eWzcDyfCHnT/6JB/KGsSfpXw7yF4ccYratM8hz1p7Kbp4i0x7iHumnr3k9Zai
         chhuU6g2yvSTOwZ2S0Fitdbn0+rI8bUbsODsCNPoXkaYlG4i/+1sFPSf87ePQ7iYo0vr
         DtxXduFyzK3oe0gTO1OlXlzgpEADjvNBg8h9lKtulVZzHpA+lhAhV4qIpchLXhCdraoq
         DhWk4yrO4zild3UxYKbMhB9cqhQp3HOF6KDYZ2JwDHTFNAv1qTjcRRGhzvcXzjz93VfX
         nby7EwSBqrYLefL0tNZVUt8aEu2doh0HYvNBFh6pJIym/dUenDxO97xo6cWr4rdsWYEo
         vU2g==
X-Gm-Message-State: AOAM533apwZO5xDIzpIHPXNpwL7A4ke4Kgec654vJp2nko/d3vwZ4wXs
        BVhI6++I0Rb9ZIska29kP4EzlwntCkw=
X-Google-Smtp-Source: ABdhPJwFGwokKA58MHbnnpZjUkQgxhcttivremxZY8CzKAekTh7AvePXM62LBk/9VR53sYk4IGqvkA==
X-Received: by 2002:ac8:4111:: with SMTP id q17mr12133380qtl.407.1633917673910;
        Sun, 10 Oct 2021 19:01:13 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:802c:b332:26e0:e0aa? ([2600:1700:dfe0:49f0:802c:b332:26e0:e0aa])
        by smtp.gmail.com with ESMTPSA id s203sm3548881qke.21.2021.10.10.19.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 19:01:13 -0700 (PDT)
Message-ID: <0e1cc25d-b1d4-2b86-ab01-02c5e0013311@gmail.com>
Date:   Sun, 10 Oct 2021 19:01:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [net-next PATCH v5 05/14] drivers: net: dsa: qca8k: add support
 for cpu port 6
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211011013024.569-1-ansuelsmth@gmail.com>
 <20211011013024.569-6-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211011013024.569-6-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For consistency with other patch subjects, drop the "drivers: " prefix.

On 10/10/2021 6:30 PM, Ansuel Smith wrote:
> Currently CPU port is always hardcoded to port 0. This switch have 2 CPU
> port. 

Plural: ports.

The original intention of this driver seems to be use the
> mac06_exchange bit to swap MAC0 with MAC6 in the strange configuration
> where device have connected only the CPU port 6. To skip the
> introduction of a new binding, rework the driver to address the
> secondary CPU port as primary and drop any reference of hardcoded port.
> With configuration of mac06 exchange, just skip the definition of port0
> and define the CPU port as a secondary. The driver will autoconfigure
> the switch to use that as the primary CPU port.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>   drivers/net/dsa/qca8k.c | 50 +++++++++++++++++++++++++++++------------
>   drivers/net/dsa/qca8k.h |  2 --
>   2 files changed, 36 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index e335a4cfcb75..de50116d483e 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -977,6 +977,22 @@ qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
>   	return ret;
>   }
>   
> +static int qca8k_find_cpu_port(struct dsa_switch *ds)
> +{
> +	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;

For new functions please avoid the cast from void * which is unnecessary.

With those comments addressed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
