Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16089751C5
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 16:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388298AbfGYOuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 10:50:00 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36135 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388201AbfGYOuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 10:50:00 -0400
Received: by mail-lj1-f194.google.com with SMTP id i21so48313736ljj.3
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 07:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6wnAGGabQ71U78o4knoiSKA6pj8ghCt55D9V1wo+T0U=;
        b=B2IYRqLxUH1+yV5JsUcKz1/ZA+iccTO0ufD34R4byQxZe7CXU3NbtHo9tyPuLSiW87
         /jfTp7pPZqqDJkeWd7NyZU0KqqbvGv12Qr+Nb9kyskTiZuABrjsxV9cKcmjF0e72KdSm
         MssRnvOCrLO36PJWr1KlgMV24aABKeJpQy0F7bW9yGhdrOwRAVhl/oeVFZ1SMIa1hpVr
         kvMyCUIgqACnih1DZJmdmeCYCDSKcrIfvcmSb+yusMcEKryJ4A3mSswtgNW/useWALsE
         owKKVrwkAuaR26qlCtSEa6R2rjFuZUqYzF0Azr5MdIJgXbtKRAwEu2UBb7m5rSvJ9ibc
         vxQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6wnAGGabQ71U78o4knoiSKA6pj8ghCt55D9V1wo+T0U=;
        b=JJbNYfWQ3lxxIThrPXaNk+4yGVB4NETh82qDaAZv5R6AZi5tXDBzrx0TLun4j+Gwx/
         ZNN4wHz47DESWH3YLDygjHwahzCaonodJLTIAUt8BB7jQ6o6BfhEoaj5qcpGVdLH7Wc4
         TtF/k1kLj99NLI6oDNZji1qKnWBLLG+lFLm9cG/Cuj/pBs6ZWIzakt9xni4xDKR3+8lP
         qOZssv/kk5a1HZKB7j6+b1+5DLIYbk5Vjyf2hXKJgb9w7yOC8+qTAA4qb7DrzHPmvzHp
         G/QEAlcY15w7Ie3Gk0VT2XK1iHbPQIzo3d9e6goxH2kIgaNesesxRBtELyKJNM6Jag3K
         B6BA==
X-Gm-Message-State: APjAAAVoP9Nv8cdKvTfCdAKyq30dS9p6Tx2grTjtRvj35nSo0MfFV0Nw
        MUC7zSvzNkgNUZcp0z2UJbRYKw==
X-Google-Smtp-Source: APXvYqwrCKqf4m+8KV0D4fmENaffy3HRKJJq6mh6Y4FyQ1BPvI6qdmY0bGVRwsAXaiGfVrkPGRJQrw==
X-Received: by 2002:a2e:a415:: with SMTP id p21mr46282699ljn.111.1564066197927;
        Thu, 25 Jul 2019 07:49:57 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:669:e7fc:391:1b4e:d17c:23d6])
        by smtp.gmail.com with ESMTPSA id z25sm7546587lfi.51.2019.07.25.07.49.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 07:49:57 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: fsl: enetc: Add
 bindings for the central MDIO PCIe endpoint
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     andrew@lunn.ch, Rob Herring <robh+dt@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, alexandru.marginean@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1564053568-20522-1-git-send-email-claudiu.manoil@nxp.com>
 <1564053568-20522-4-git-send-email-claudiu.manoil@nxp.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <927717df-1a74-3253-f905-6a2f742fda63@cogentembedded.com>
Date:   Thu, 25 Jul 2019 17:49:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <1564053568-20522-4-git-send-email-claudiu.manoil@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 07/25/2019 02:19 PM, Claudiu Manoil wrote:

> The on-chip PCIe root complex that integrates the ENETC ethernet
> controllers also integrates a PCIe enpoint for the MDIO controller
> provinding for cetralized control of the ENETC mdio bus.

   Providing, centralized.

> Add bindings for this "central" MDIO Integrated PCIe Endpoit.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---
> v1 - none
> v2 - none
> 
>  .../devicetree/bindings/net/fsl-enetc.txt     | 42 +++++++++++++++++--
>  1 file changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/fsl-enetc.txt b/Documentation/devicetree/bindings/net/fsl-enetc.txt
> index 25fc687419db..c090f6df7a39 100644
> --- a/Documentation/devicetree/bindings/net/fsl-enetc.txt
> +++ b/Documentation/devicetree/bindings/net/fsl-enetc.txt
[...]
> @@ -47,8 +49,42 @@ Example:
>  		};
>  	};
>  
> -2) The ENETC port is an internal port or has a fixed-link external
> -connection:
> +1.2. Using the central MDIO PCIe enpoint device

   Endpoint. -ETOOMANYTYPOS. :-)

[...]

MBR, Sergei
