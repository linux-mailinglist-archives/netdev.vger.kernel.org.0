Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D0B270BD
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfEVUUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:20:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35867 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729691AbfEVUUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:20:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id j187so3514194wmj.1;
        Wed, 22 May 2019 13:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qEdYjTYoNFLzgjswFP5rYpGuwvua1MCnzFrarxrCXWA=;
        b=K8YyCNy5HX/WRPqd7CgLqOZ28JUGIDkcdWIz5NGTKZNjxBZMiNG7dcmilplatXA8FU
         r5L6EhAVGeJ44hifVIr1gtnO/rU7ZTtNW5xWe2IHltp6awrxGB33pxsOkeGtqjmhDtAw
         S2Odlf/qP9I0mpKPunk+1/30rurxz3pINnhw2YQ2vDBYSGNeRkgJteT2Sc3exe2mMnMs
         une2ePVr4NEExEd9FQzfwRW3jB4yPJ3YekxqWXqpLuxrtTz6KjHhSV6GABR36en/8iq8
         LS76obD+wrrpryjBVhlnbb9SEbXapOagZoJKmBsb1ACCYFQPeYGOyR9azi0CrvVwvnm7
         KAuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qEdYjTYoNFLzgjswFP5rYpGuwvua1MCnzFrarxrCXWA=;
        b=LtlciGeZE9qxMkB1ujpDDxP/vmZ194HfRv0Yke19IA3Z648GDeXViE4LTZ/Q+cdTIY
         5/UP986zJICfVW1wH+H8Fhv99ZSrMh5On9M/Bz6GtE1lkCN0vneirZxkevMZ3Yfgm+Pl
         imAdgCTeop0DA76THW7vUHQcxGH+3VCfgobFx6H2lZXh3k/0xDhs0AqyBeyryA8/mYMi
         olZQBGQcatCjNiWl0qx1BhIr640MImC+4JNQ3ytjAXUlmceMlQ4Ca7Ogen6GT7Ec7XLq
         r2j+ER4Ap8XcKoiefuo6RXA8akpneulDKBDFY17+ibF5d71DlxYxhCY7xOpZvtQtq4Kn
         6A0g==
X-Gm-Message-State: APjAAAVzqcnaBK7t5/bm6in6ramSGaxpOVyZ+i/c7/uJomZ2OD23+mXR
        fUTR6PgtnGevlgdRFqJ9Q/uwM+b1
X-Google-Smtp-Source: APXvYqygQlSb/ahi64ZRhl2M6lSR3aaHbFN1pQ3r9VzMRnBBkifgwpXTevDJ1hTCyZVOiRKL6uT8bg==
X-Received: by 2002:a1c:a982:: with SMTP id s124mr6924275wme.143.1558556411044;
        Wed, 22 May 2019 13:20:11 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:3029:8954:1431:dc1e? (p200300EA8BD45700302989541431DC1E.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:3029:8954:1431:dc1e])
        by smtp.googlemail.com with ESMTPSA id s62sm1411819wmf.24.2019.05.22.13.20.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 13:20:10 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: phy: add interface mode
 PHY_INTERFACE_MODE_USXGMII
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <110a1e45-56a7-a646-7b63-f39fe3083c28@gmail.com>
 <aca070f6-f56b-1b1f-180a-ddf52af91ecb@gmail.com>
 <d736f2d8-5c2a-e624-e372-cc2dd7b29f3c@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <101b6cff-797b-1d06-17d3-045d56aa0de3@gmail.com>
Date:   Wed, 22 May 2019 22:20:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d736f2d8-5c2a-e624-e372-cc2dd7b29f3c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.05.2019 22:06, Florian Fainelli wrote:
> On 5/22/19 12:57 PM, Heiner Kallweit wrote:
>> Add support for interface mode PHY_INTERFACE_MODE_USXGMII.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> If you update Documentation/devicetree/bindings/net/ethernet.txt, then
> this is:
> 
Indeed, that's missing. Thanks for the hint.

> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 

