Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9545F4284E6
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbhJKBwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbhJKBwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:52:42 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02995C061570;
        Sun, 10 Oct 2021 18:50:43 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id bl14so1823085qkb.4;
        Sun, 10 Oct 2021 18:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=3+OC4xhRP45CHXbnS16n8nN54Hi9RmgBz9jGrzKhd7s=;
        b=XHg3bh33BNDd2FLoxxrP64EVAuqbnGc4LVvtKknReUZTPJ9YubeviiS0vWEbz2Y3dJ
         7xc/22OqXKqbmonOT7flrhAs960KsneR7RpUj6tWo9NHZFiyHL3J5SH+yFCH8kwXdpBR
         JtVva9FFAeKPQCLqdn95szssoel1i0cbdwnUX1f/tqpx2m3RWWUHmNeun5ChdKfMedCt
         HndTjAcawdO87QIW63rA6RmKuAh01HeSsVB7J9023d0kPvRkxWE5VugNDWhDkxECdoOq
         J+BATqExUv49+eJuCz/3iTaA9W8SMJrsyjBDTUb6idYQHLUg42bs1rCH/RQEHtMN+6FD
         1x5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3+OC4xhRP45CHXbnS16n8nN54Hi9RmgBz9jGrzKhd7s=;
        b=nR8rpMHgC5Gd8Y6p8tf1o1wu/N72gNC+7EY0AzM/1CPpAskgE2YE2pPoCe7/IOvjxt
         IFGdGRkMiVge01nnFsC7YzKMBIUx7IQuxLfRmjwoiP5oSIEO3rSDasFANoZgVOfdJlZn
         sgBlIAKDrfzJ53rjzhazp+X6955Ys8JWAD+jRxUzOaWtTtRAuFomu1tU7q8nHHHlqsA1
         AyF+gG80GIWdae3YXSm0GDfRxstzYhryDKUTePLXcuWPtuzU/BB+gK3cqC3CvR0jI/4c
         npxdoxaBVlL5ELMMCOWVoL6dxKfwYKEc0t6Lw11YIou5Z2EgVbL0dF7m6t0MRcRkfj0b
         eW6A==
X-Gm-Message-State: AOAM532rDwBAwUKRnBp80+DQvT/KWB8ZKxWw6sh7gOIycaz6V5tUzGRw
        SQkvc/HhwmaevQqIGVjWNm0=
X-Google-Smtp-Source: ABdhPJyrl4fbrbeDzij5LXtZ5UKxV34Etygr8uwg7YrGWoeYU4qzp/VJKWzTMizqbEfrCszM1aU2Gg==
X-Received: by 2002:a37:a9c2:: with SMTP id s185mr12699543qke.508.1633917042140;
        Sun, 10 Oct 2021 18:50:42 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:802c:b332:26e0:e0aa? ([2600:1700:dfe0:49f0:802c:b332:26e0:e0aa])
        by smtp.gmail.com with ESMTPSA id m5sm4054705qtk.88.2021.10.10.18.50.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 18:50:41 -0700 (PDT)
Message-ID: <16d2a19b-5092-763b-230c-5b0a6237d852@gmail.com>
Date:   Sun, 10 Oct 2021 18:50:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [net-next PATCH v5 04/14] dt-bindings: net: dsa: qca8k: Document
 support for CPU port 6
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
 <20211011013024.569-5-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211011013024.569-5-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/10/2021 6:30 PM, Ansuel Smith wrote:
> The switch now support CPU port to be set 6 instead of be hardcoded to
> 0. Document support for it and describe logic selection.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>   Documentation/devicetree/bindings/net/dsa/qca8k.txt | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> index cc214e655442..aeb206556f54 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> @@ -29,7 +29,11 @@ the mdio MASTER is used as communication.
>   Don't use mixed external and internal mdio-bus configurations, as this is
>   not supported by the hardware.
>   
> -The CPU port of this switch is always port 0.
> +This switch support 2 CPU port. 

Plural: ports.

> Normally and advised configuration is with
> +CPU port set to port 0. It is also possible to set the CPU port to port 6
> +if the device requires it. The driver will configure the switch to the defined
> +port. With both CPU port declared the first CPU port is selected as primary
> +and the secondary CPU ignored.

Is this universally supported by all models that this binding covers? If 
not, you might want to explain that?
-- 
Florian
