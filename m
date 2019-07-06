Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220A761227
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 18:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfGFQVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 12:21:38 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40702 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfGFQVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 12:21:38 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so12409686wmj.5
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 09:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=PrFKzR5QjZfT0ElLH8h9hZJ57dHDh8iwbBvqIiGc5gU=;
        b=Dz7qLx0dUgJaUHrfqrUut8lSK2gsbiC73QqWuBz9neUt0TaRs9kVX0w0jSxoXnVJaM
         Ww/BgNfKYoshxLQ6M/BC6Md/w2OwPoHslBi5BEPrTAnXB9GU3ian1VhIiwsxfOzzZJqZ
         hFrEulX40ml3ftDO1TzKyJzA5bQANhQEEAUp/pUHzSBiMkfRTabaLbQ3VnNuo5/VIy1r
         oGCOEz4fRq8ZKmVPyopV9aqPrbqNt5ihxAYZBCNUCrxxHNoCSzS4M+HpGrA20jMdLU2A
         nucrAtJeWPNMlDdurIm9Rd5xKyeqgD5rnlp4ZS3Am8BJSBJIfEe3QaABlW4S6dHTeCPA
         2k/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=PrFKzR5QjZfT0ElLH8h9hZJ57dHDh8iwbBvqIiGc5gU=;
        b=qZLpEq2jN7XcHyJyZ1u2WwQvPfJ7gJKmcrUbOUDEEunKKve5csxlE3RiBbWUKzcjHz
         AA2uAa8PN/ebVBjsRVG/kI8BVrcSaBjbqKPuyc4llmPkTsLPXUizBnaO3H0IPa/X3sCR
         Ex28j3aorViwbvM1CNHCuUlb7iqlPXHYKBHevbKB6bgfppEnOawXqj9VptCH/QpPyxX/
         337fZ9N6OAnOHDNjNSuy0XlYKc82+gXxKLu70vWrWTUfxmW4nqqLRM+5jt+QYtRk5TAR
         Mbo37CWAnCT0entMdV0cPHvKGqDXuiZDyBoAqGN/xo2rtkKspnMo74mP58WytMPQi7Mb
         IKqQ==
X-Gm-Message-State: APjAAAWGGzBLENvFlrJK/pXFVdvpz/wz3DC9vKOi+2mAdktG0EZzT+2M
        C6x44Lhae/Uf8Sg19wp0oZqg+27rgMIJwg==
X-Google-Smtp-Source: APXvYqxq50ZlLLF3KgkkKUASo5RDtX3N94ZdqrtSJuPLWqUUKAkVdxRfTtroVRtYOQv2T7j7ajQI5w==
X-Received: by 2002:a1c:f914:: with SMTP id x20mr8866588wmh.142.1562430095991;
        Sat, 06 Jul 2019 09:21:35 -0700 (PDT)
Received: from [192.168.2.163] (p4FDE22F7.dip0.t-ipconnect.de. [79.222.34.247])
        by smtp.gmail.com with ESMTPSA id w20sm33178445wra.96.2019.07.06.09.21.35
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 09:21:35 -0700 (PDT)
Subject: Re: [PATCH 3/4] net: mvmdio: print warning when orion-mdio has too
 many clocks
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
References: <20190706151900.14355-1-josua@solid-run.com>
 <20190706151900.14355-4-josua@solid-run.com> <20190706160925.GI4428@lunn.ch>
From:   Josua Mayer <josua@solid-run.com>
Message-ID: <8d24d716-2f64-37d3-a7f2-1725d48c7d5f@solid-run.com>
Date:   Sat, 6 Jul 2019 18:21:34 +0200
MIME-Version: 1.0
In-Reply-To: <20190706160925.GI4428@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Am 06.07.19 um 18:09 schrieb Andrew Lunn:
> On Sat, Jul 06, 2019 at 05:18:59PM +0200, josua@solid-run.com wrote:
>> From: Josua Mayer <josua@solid-run.com>
>>
>> Print a warning when device tree specifies more than the maximum of four
>> clocks supported by orion-mdio. Because reading from mdio can lock up
>> the Armada 8k when a required clock is not initialized, it is important
>> to notify the user when a specified clock is ignored.
>>
>> Signed-off-by: Josua Mayer <josua@solid-run.com>
>> ---
>>  drivers/net/ethernet/marvell/mvmdio.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
>> index e17d563e97a6..89a99bf8e87b 100644
>> --- a/drivers/net/ethernet/marvell/mvmdio.c
>> +++ b/drivers/net/ethernet/marvell/mvmdio.c
>> @@ -326,6 +326,10 @@ static int orion_mdio_probe(struct platform_device *pdev)
>>  		clk_prepare_enable(dev->clk[i]);
>>  	}
>>  
>> +	if (!IS_ERR(of_clk_get(pdev->dev.of_node, i)))
>> +		dev_warn(dev, "unsupported number of clocks, limiting to the first "
>> +			 __stringify(ARRAY_SIZE(dev->clk)) "\n");
>> +
> Hi Josua
>
> Humm. Say getting clock 0 returned -EINVAL, or some other error code.
> We break out of the loop, since such errors are being ignored. We then
> hit this new code. Getting clock 1 works, and then we incorrectly
> print this message.

Good point about breaking out of the loop! I did indeed not take the
break condition of the loop into account.

I can not exactly follow your example though. The first failure of
of_clk_get will trigger break and exit the loop,
and then we would indeed print the wrong message ... .

>
> Rather than getting the i'th clock, get ARRAY_SIZE(dev->clk)'th clock.
I will gladly make the change in a v2.
>        Andrew

-
Josua

