Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D178DC49
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbfHNRua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:50:30 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38438 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728219AbfHNRua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:50:30 -0400
Received: by mail-pl1-f193.google.com with SMTP id m12so12379269plt.5;
        Wed, 14 Aug 2019 10:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cPPXcezte5J0eaSao439eMYqgR4inJLP+9pvE5yjm4o=;
        b=uduD3FeKBvIwGYgcRV3hRfISLAL1i4qHvuwL4xThb4ypw0BTuvfysPEDKUODV/+t0K
         ehfTG5mteQUziX1VUrOUgO8oENoOEPsByM/ppqZRmF9mBkuCvlTT0W82+6gYiuW53Lh8
         hVOvA5s2f9Sidjq13oyCUCgJrNDD84R9R2NNt7aOj0GCY7X8ut+ZIxNFQB0nBL2GK53R
         hkzvQBEmQUf9DJyj18FcGDDQZTPsJxuprKS+pIddag1ENaTEL+8/zNgdvz3WLqhq6Gf3
         +a+zO01afpe9HRLt3bwODEVS8f2zFueCvhBrdCCd9ilCiyYPgHGyr564SGfUamB9O2Eq
         O9pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cPPXcezte5J0eaSao439eMYqgR4inJLP+9pvE5yjm4o=;
        b=FVT4t6mYhy+YqW5KoiUGE0nfH+T8dizNu46np/v/AMKRa8oW7SeFqvdWVk5TGFJMgv
         0fY0sDOu+53TGeOe1NgLS4Pq0bEA2esTsn9qyJ5cAkuRLJqexAMakgV9JMGHMGKA3cQ+
         /te0I0WgsPmigNHA8/Lv1CnQJEi6m3jylFSC9p0KDgoKYnYACmn6oZNvxtueea8wKpyh
         GAORur0tjz2OVQu6pqTpjuZCkIpf5F1BuNxXOVBX02MGsnTWO0d9B56M6nsj+EE743Mu
         BRC43s8NI2Rz8mla1nq+12jkt6seFBoQCidxZbyMGMreI1+nTspcBspIjBhOQ41xi+Y7
         rnOA==
X-Gm-Message-State: APjAAAXh6vEhk6nlNQ2ZiH9pVC4r67kKKrivvDx9J7Q0xsEM7igw+wb+
        xfjE8g6wkP0qJmHndSvvG3o=
X-Google-Smtp-Source: APXvYqxOw7iHWldtvgP/DorSQg3oy0V3p3xUXm5xjAhphCmrE95TnNW19JwY+YkI7PP55sxNiCswnA==
X-Received: by 2002:a17:902:740a:: with SMTP id g10mr598842pll.82.1565805029186;
        Wed, 14 Aug 2019 10:50:29 -0700 (PDT)
Received: from [10.69.78.41] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e26sm467961pfd.14.2019.08.14.10.50.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 10:50:28 -0700 (PDT)
Subject: Re: [PATCH v4 05/14] net: phy: adin: configure RGMII/RMII/MII modes
 on config
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        hkallweit1@gmail.com, andrew@lunn.ch
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
 <20190812112350.15242-6-alexandru.ardelean@analog.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <ef79d47f-9d93-1c95-4359-cbd9a95b8964@gmail.com>
Date:   Wed, 14 Aug 2019 10:50:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812112350.15242-6-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/2019 4:23 AM, Alexandru Ardelean wrote:
> The ADIN1300 chip supports RGMII, RMII & MII modes. Default (if
> unconfigured) is RGMII.
> This change adds support for configuring these modes via the device
> registers.
> 
> For RGMII with internal delays (modes RGMII_ID,RGMII_TXID, RGMII_RXID),
> the default delay is 2 ns. This can be configurable and will be done in
> a subsequent change.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
