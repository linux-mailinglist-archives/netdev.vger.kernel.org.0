Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575432184A4
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 12:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgGHKF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 06:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgGHKF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 06:05:28 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671D4C08C5DC;
        Wed,  8 Jul 2020 03:05:28 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id e8so19192876ljb.0;
        Wed, 08 Jul 2020 03:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4AhtWJmTt0k+SbSm8EpR4JpdwLD+1n7WbwjJUPNQsBo=;
        b=VFiCq8eMmhTdX0ZTUz458pNxVywlXyrH4ItXqTEB6A+prYRH8TlD1UesUiyO+IutfF
         hY7kWGI4yr5qLvEcLQQrtkBhkJkrsixI5XHeo3t9z5HbtAz4aINQpmjk6W3KKsOR6bQM
         ysahLY9gFcTVHpNAc/Z9qvnxlMDK4jpcVt3LzhCL6RG49lDE2pOexK5woTA8wrUZpCe9
         x6axZpPdDwMYDECpb7It3UohI7NLNTsLo359lqxX9iS041x5QO+i8wzrBBUPXllpjGpy
         3FfSMLZOdnoR761HQZFWcLCkjo30zrYxDzlEgUP7gvpFH67xMgf5cSlnMBJcN7EhxdAN
         XvhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4AhtWJmTt0k+SbSm8EpR4JpdwLD+1n7WbwjJUPNQsBo=;
        b=GrZvL9sqU2vlclGhFQQ7weWwdVbtAtZ8M2ONuuHJFgxi24JVYaiJCjVEWbo/Xi9Ver
         ZIfe0YsTect1AGrJtCxhL9TQOaLKYRAm1B4iTbrPq9NFGlGQcG/qo6rvpoBrjUY03KI5
         5/+CnWfGQjbmrWnnaqROACguDFjBgQFpL9kfxh9iDPiODQ6hTUY6y7ct2gpQZWJucoah
         Zu5lSwtvTlNz8rEL4FjDc7cDwMTCzdlNp011LlfwbDpyfAZ52QkaiULKkP6FxJQTk0ak
         kuzmBN5hrRilYdCJPN97Z94CV1Z4QmgSqANsz3tNK90oLieI82x1NGlnyK3nTM8mBtRK
         QEBw==
X-Gm-Message-State: AOAM532U/K+BQEWMCWe++oYDODLmQXrMLZ6f6q/hzWnz+mzBlit7owzn
        Vz2asW9agUqR+zR4QRgUc9QABGBhfks=
X-Google-Smtp-Source: ABdhPJySCWcAWtZMXy9awCRDK0stHeq8pfcH5Y7hvZXAxTZspwn8HUBvgcQWHPyaGpe+r+RDoYGQ9w==
X-Received: by 2002:a2e:85ce:: with SMTP id h14mr21629655ljj.356.1594202726667;
        Wed, 08 Jul 2020 03:05:26 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:4297:b781:8ad:e985:513e:5609? ([2a00:1fa0:4297:b781:8ad:e985:513e:5609])
        by smtp.gmail.com with ESMTPSA id w5sm483270lji.49.2020.07.08.03.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 03:05:26 -0700 (PDT)
Subject: Re: [PATCH v2 2/7] dt-bindings: net: renesas,ravb: Document internal
 clock delay properties
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20200706143529.18306-1-geert+renesas@glider.be>
 <20200706143529.18306-3-geert+renesas@glider.be>
 <df4affe7-922c-968d-6aa9-b92072aade4f@gmail.com>
Organization: Brain-dead Software
Message-ID: <7290209a-a2e4-e663-6029-937eb8fa56a8@gmail.com>
Date:   Wed, 8 Jul 2020 13:05:18 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <df4affe7-922c-968d-6aa9-b92072aade4f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.07.2020 13:03, Sergei Shtylyov wrote:
>> Some EtherAVB variants support internal clock delay configuration, which
>> can add larger delays than the delays that are typically supported by
>> the PHY (using an "rgmii-*id" PHY mode, and/or "[rt]xc-skew-ps"
>> properties).
>>
>> Add properties for configuring the internal MAC delays.
>> These properties are mandatory, even when specified as zero, to
>> distinguish between old and new DTBs.
>>
>> Update the (bogus) example accordingly.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

    Oops!

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

> [...]

MBR, Sergei
