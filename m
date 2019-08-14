Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E9A8DC63
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbfHNRxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:53:05 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34384 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbfHNRxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:53:04 -0400
Received: by mail-pl1-f195.google.com with SMTP id i2so51047963plt.1;
        Wed, 14 Aug 2019 10:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8iaIY5u6ArQsWMUMgAKvaicK4w7/20OGfodEGmYtcUE=;
        b=gMLz/CMJHxHnu9kURNWBHopTjtSGFQkI0UvIZEhG10utbfLh0zkvsGOqxU7JWPeE0O
         xK9PsjzElrAvEuywaUaulrnl1mJVQ2sr/aoAAJnKqg20lw/TFcHYkiTRjxVQGISwVOVj
         cwEmkM1Be9Mgm1pTHnmScBxX8Vj/rP4bpepVjtvIkYoEupRqylv8G2e8BNjQ3lL/CYpQ
         obbyf3z4iaGanKXbDCrcuBmQ85L6jyVTNPC3MWlhBEynTxXdaywg+Im+E1Z+xr+ji/Vx
         dnvvpAU4PsOI8aaOKarAdTQxh7doNq7/DK6rAP3tkm9XGJsjK2c2B8fmC77TrbKYu6KW
         A7dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8iaIY5u6ArQsWMUMgAKvaicK4w7/20OGfodEGmYtcUE=;
        b=qY1XrvCXdTwQO8DayCTxdVR0cEIbV8MQtNDfX5QSscalM1Ash2Enw7ZfgqrzBcUs1o
         nPUgg+ywdmUKu7cUBf1sx2p51NZCBE4grI7ymD4lGQQf7UbOPmXo+P0kUv+WYAbLEmrL
         w8NMRNjrMxnfRS8j/kRdl5cDsDE3m+2tq/1zRKQ37BFmbsaqewZykpzhMZoCyIj0Pt90
         ijCg6SmNem5ITGgcnbzK+MDaQ7CWQ/OpN/7iAUAFXT5XVBnjzmC6NAcF57KMQcS7lVHU
         gl5Xlht8OGZNuufRtVok3PNO8tLIGFqYcfeQFA13XlN9xTL1xPaRdyc1ihfK00o6RJ3p
         lGSw==
X-Gm-Message-State: APjAAAWEa6aC04I8rnJsSqMS4yRdDnr25qO4890N7sbSapKgtEIRRXeO
        g/iko59pRkLE5yy4O99R8OQ=
X-Google-Smtp-Source: APXvYqw5LTP7Fy7PGJx5niJbiwCJNXnJ2iWZFQ1B7+V3zYYIX8nPxCRjG4cQ8wcnSNqzcjWQd8/vvg==
X-Received: by 2002:a17:902:9a8d:: with SMTP id w13mr537132plp.157.1565805184076;
        Wed, 14 Aug 2019 10:53:04 -0700 (PDT)
Received: from [10.69.78.41] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u128sm448046pfu.48.2019.08.14.10.53.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 10:53:03 -0700 (PDT)
Subject: Re: [PATCH v4 07/14] net: phy: adin: make RMII fifo depth
 configurable
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        hkallweit1@gmail.com, andrew@lunn.ch
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
 <20190812112350.15242-8-alexandru.ardelean@analog.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <653e9be4-dde0-4d50-b2d1-fc7b5c5118b9@gmail.com>
Date:   Wed, 14 Aug 2019 10:53:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812112350.15242-8-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/2019 4:23 AM, Alexandru Ardelean wrote:
> The FIFO depth can be configured for the RMII mode. This change adds
> support for doing this via device-tree (or ACPI).
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
