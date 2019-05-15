Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F45D1F94D
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 19:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfEORZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 13:25:26 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37515 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfEORZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 13:25:25 -0400
Received: by mail-wr1-f66.google.com with SMTP id e15so395835wrs.4
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 10:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Mnbgsvv0+v3ed1ICCYvV1mQaTOqWRaKNioYBw4eCU5c=;
        b=pkQ/V/4b04/QyosPJRnZjR9u95Ty2dqBhXWf8Q/8z15MuNlNC1EEvB8m8WLg0DMyok
         2MsSIZrc4IlhtXI9AV3GhN1nLx4bphNdylK3CAEJwc8jIHvXaR5g3AtnqekaYg2dB9Ht
         zgMhR6UB49QzXQNE5o0oyjoORXsfhQ3fVhr+d8sC+HRMa2z+3byyDZ7x1u4i49k9iqyS
         3XDYTlbotS7rFrBSkxBlul1cO0cldlYBJRqOm7+CUJ9G66pxD99vj/lGqPX9dj2obIGF
         jTAvkQtpSNHP6RRi30W5FrmlVqmWvOrWN0QBXS3TfBwkU7tjUZmul3UYycZMeSdcoErm
         KUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mnbgsvv0+v3ed1ICCYvV1mQaTOqWRaKNioYBw4eCU5c=;
        b=FS08PCuAvLIXBf6TLj6IgAPoUgwmZ+xnJ7J1pgWeRpNRQKMlrLrlz+FlF4cSXC+ngW
         9ZAv1bHq5CPnHHOHyzn95O+GvkKnpVuh6TeOWrVY7fzVIc2MGfwnHemH0bCAI/Ef8jRh
         4puv8Zpx+o9yQD00Hz+9NSFfFMZ4t0UVh3pN06Ng9Axd3qE7EZZn8YfoSAQLbonHnr2F
         kNhst3tlfT5B+5Wp/cnX0bWW3eMZMPDM1yKbdF+5ZsQs0ojqOJD5OnwM25rgjEZT8GY5
         aeRw078xYi4HOi52XpHhefml6SN1E2aLW+10ZmRM07s3rAeA6t2PmArJOC69ruz37Q+3
         JeDQ==
X-Gm-Message-State: APjAAAX8SZUc7P99+IlnVUpQGwFdT9HPh70JAI2v9WRXalahVXduDD31
        JYTuNr/GQJpxgAGJcDTX7I4=
X-Google-Smtp-Source: APXvYqwsuoAeujTaDWQYfkALXVWYY8auSt7pswK6ot8j6YyTvAvrWjttdSzp3HVx2NbYI80/iSfMbA==
X-Received: by 2002:adf:d4c8:: with SMTP id w8mr20379992wrk.2.1557941124136;
        Wed, 15 May 2019 10:25:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:19b8:f19b:746e:bed2? (p200300EA8BD4570019B8F19B746EBED2.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:19b8:f19b:746e:bed2])
        by smtp.googlemail.com with ESMTPSA id l12sm2083295wmj.0.2019.05.15.10.25.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 10:25:23 -0700 (PDT)
Subject: Re: [PATCH v2] net: phy: aquantia: readd XGMII support for AQR107
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <VI1PR04MB556702627553CF4C8B65EE9FEC090@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <a7ba6f22-066e-5ab0-c42f-c275db579f32@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <459eba93-e499-a78b-4318-907748033ccf@gmail.com>
Date:   Wed, 15 May 2019 19:25:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a7ba6f22-066e-5ab0-c42f-c275db579f32@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.05.2019 18:19, Florian Fainelli wrote:
> On 5/15/19 8:07 AM, Madalin-cristian Bucur wrote:
>> XGMII interface mode no longer works on AQR107 after the recent changes,
>> adding back support.
>>
>> Fixes: 570c8a7d5303 ("net: phy: aquantia: check for supported interface modes in config_init")
>>
>> Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
> 
> Just so you know for future submissions, there is no need for a newline
> between your Fixes: and Signed-off-by: tag, it's just a normal tag.
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
I checked the datasheet and AQR107 doesn't support XGMII. It supports USXGMII,
maybe XGMII is used as workaround because phy_interface_t doesn't cover
USXGMII yet. If it makes the board work again, I think using XGMII is fine for
now. But we should add USXGMII and the remove this workaround.
