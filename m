Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E5C8DC2A
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbfHNRrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:47:31 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:43035 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbfHNRra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:47:30 -0400
Received: by mail-pf1-f178.google.com with SMTP id v12so6213746pfn.10;
        Wed, 14 Aug 2019 10:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CCSrBSX7IQ2xxBVP3hmlei8pJXx43OzdA6dFKjJ2gHU=;
        b=u8hTQDywSt89aTs/QwC9DaOHMlSKvwhLozmjlU41t8YDFprKEWWarY2xStTo/0YXgW
         0AGEIqqBIhCOYR3txYPORce7cXecJWQ3C65glTyA51/Dz+x2KDpHIGCEUkWuIcqRMVPh
         jDBqAGqBFvpLJ1PDO4GaA4g30VbpxvG3H8brE6rxT/RkVuNzT+girw/O97arUcG0YPGA
         rwNzJlfTDfGXiRoH1fqKSeQwIaB0uidO0rU1AAVDUjMV7PKU1RM6PNxtKQ8OJc8q6hoA
         euvtFAiSt5zK9vviufuPiwr2kdXEO40JBNSwhDwbwTq3anOxZvihNlKiJKnh9QH/jyQ5
         92uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CCSrBSX7IQ2xxBVP3hmlei8pJXx43OzdA6dFKjJ2gHU=;
        b=W/cdBWbPQoBCObFtNEHRK5MKSPIzVyJiqhfFFE0ydvJk2Jv2s1kUSf+v7N+6Fd7CI0
         KiW0+u4u4wD7gbIYjCZUP2oTOJlAbad88TGlD3cw9tkAolpsTqM4KY0fxmlT0TMBS6AN
         0C8AponwCwv4iqzrM6QtSFeI4nq7HvmKkV7xIdk0RiEoF1R+jfGtFEk9Vi+uQSBZyeTZ
         Kkp2Yzb4NZIUD504OY/ohUNavmEsQbtzJR9EluRA2HvYHCOPzRDrUwtY3RiTr6PHiL+g
         /1gRMJr1E4wuCOtNBAlupqup7qjlqVfLeshONl2VCQp4m2wrH1SA+KTKbsYfcylwW+8k
         Lp9A==
X-Gm-Message-State: APjAAAUQfmSVBgNY9IbRs+SGLXvaDXrUt4qWc8dkezdeTmm4Su+yNq2j
        UNnVs3A89dI9d9Dh+jFOjhw=
X-Google-Smtp-Source: APXvYqzKsieWLirBEkQptXH2tQ5lBWKzQqGdQYuYBNU2y56nrw4EPOGJQz5bPTV4Ki//Sk2Ezj2FkA==
X-Received: by 2002:a63:3006:: with SMTP id w6mr313117pgw.440.1565804849676;
        Wed, 14 Aug 2019 10:47:29 -0700 (PDT)
Received: from [10.69.78.41] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 10sm499867pfv.63.2019.08.14.10.47.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 10:47:28 -0700 (PDT)
Subject: Re: [PATCH v4 01/14] net: phy: adin: add support for Analog Devices
 PHYs
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        hkallweit1@gmail.com, andrew@lunn.ch
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
 <20190812112350.15242-2-alexandru.ardelean@analog.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <06de7e05-e3b5-6003-acc5-63f45d8ce9e8@gmail.com>
Date:   Wed, 14 Aug 2019 10:47:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812112350.15242-2-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/2019 4:23 AM, Alexandru Ardelean wrote:
> This change adds support for Analog Devices Industrial Ethernet PHYs.
> Particularly the PHYs this driver adds support for:
>  * ADIN1200 - Robust, Industrial, Low Power 10/100 Ethernet PHY
>  * ADIN1300 - Robust, Industrial, Low Latency 10/100/1000 Gigabit
>    Ethernet PHY
> 
> The 2 chips are register compatible with one another. The main difference
> being that ADIN1200 doesn't operate in gigabit mode.
> 
> The chips can be operated by the Generic PHY driver as well via the
> standard IEEE PHY registers (0x0000 - 0x000F) which are supported by the
> kernel as well. This assumes that configuration of the PHY has been done
> completely in HW, according to spec.
> 
> Configuration can also be done via registers, which will be supported by
> this driver.
> 
> Datasheets:
>   https://www.analog.com/media/en/technical-documentation/data-sheets/ADIN1300.pdf
>   https://www.analog.com/media/en/technical-documentation/data-sheets/ADIN1200.pdf
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
