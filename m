Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 227C3351A4
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfFDVHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:07:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54739 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfFDVHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:07:17 -0400
Received: by mail-wm1-f68.google.com with SMTP id g135so154609wme.4
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 14:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=okT8Fp1wjyaD6akdRHXS0V90ovKu5q8DFT+3qvNAGcY=;
        b=tcCB8jfZ7u9e0a3nGpPgMo5lGMpSNMosHBNhOUPTiGOpTfGBhbdVsVXF1xevDatUkb
         2Ud/TAqNTHH99/ox493HXKlcU2wTWrcsWqhBjTXe5NUdDTg7nBbOOrRH1wTvP7/G1FmR
         D2El/TYeZEXvq0wnnOOngIWAReiO6bjy/zF1JYCVSmAzLkwdXCPBwn0gPswjLGTp4hHL
         1IO2WHbqgHDO75fftv55VLLsILYy4Heclac3faBtbo6i5KZjJ9N1UuEaN6Wfm47rdYDg
         TCZUDrnOQA3e4s1f63aHgeNdAnBfIdRL2XXf8TRZCzZ4G9t8cr4tUPV6jvcOKpnF8Qcn
         cd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=okT8Fp1wjyaD6akdRHXS0V90ovKu5q8DFT+3qvNAGcY=;
        b=Fbj/VLyI3OiABgTvVqMMBbyDA/s/gAnRclN5xARtT68uOIYB+s+6q0dUSGDpMxQYAH
         7UBfT0rzeIub1go2PfsBlwKuh5ZIEsNafh56cS+KUJNx8WlMY/YxBFYsXhF1ThJsA3kD
         Klzk0fVZTcE4N+1PWCUoMQRtI5IjKTFlV3Kql52qkbD3cwH6vcuHfkqiczhlPxIo6H/9
         PuwJFqq3tGXS7LxKYN1qCjCv4rnt/Q40pxpZbhep0IK6ap4eMlo7pJ4iFpqG/UMFUq6y
         ZAIkywCnzCu+ThO26fOsn0RAWZycvn+TUjMB3Hpacs7w3nRtPeT1M8iLrXA/gAObk9l3
         arag==
X-Gm-Message-State: APjAAAWPHog0XnZqcf4hMKInNOMQatehNbkqfrpsuGIjfAg95uj6Z2dy
        ANL24RAKApT8R0+OyxA3AFJtGVtA
X-Google-Smtp-Source: APXvYqwZ++/OjUB2zGYWjumCURYK1LWRovnFJlxfB13438zdeoWbisrr39REitwmkx57ThMOrEYOYw==
X-Received: by 2002:a1c:2bc7:: with SMTP id r190mr11784684wmr.174.1559682435511;
        Tue, 04 Jun 2019 14:07:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:cd0d:e1c0:529b:4e2? (p200300EA8BF3BD00CD0DE1C0529B04E2.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:cd0d:e1c0:529b:4e2])
        by smtp.googlemail.com with ESMTPSA id z14sm4642155wre.96.2019.06.04.14.07.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 14:07:14 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: add flag PHY_QUIRK_NO_ESTATEN
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Robert Hancock <hancock@sedsystems.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e5518425-0a62-0790-8203-b011c3db69d3@gmail.com>
 <20190604130049.GA16951@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3b926b01-4473-f070-056f-75bf3cd49a74@gmail.com>
Date:   Tue, 4 Jun 2019 23:07:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190604130049.GA16951@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.06.2019 15:00, Andrew Lunn wrote:
> On Tue, Jun 04, 2019 at 08:10:50AM +0200, Heiner Kallweit wrote:
>> We have a Xilinx GBit PHY that doesn't have BMSR_ESTATEN set
>> (what violates the Clause 22 standard). Instead of having the PHY
>> driver to implement almost identical copies of few generic functions
>> let's add a flag for this quirk to phylib.
> 
> Hi Heiner
> 
> It is a bit of a personal preference, but i would prefer the Xilinx
> driver worked around broken hardware, not scatter quirks in the core.
> Keep the core clean.
> 
> If we had multiple PHYs broken in the same way, then maybe a quirk.
> 
Yes, I was expecting that there may be different opinions on whether
this should be handled in the core or by the driver.
But this is obsolete now anyway after Robert figured out that his
problem actually was another one.

> 	Andrew
> 
Heiner

