Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E7349E831
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbiA0Q5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbiA0Q5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:57:00 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CAEC061714;
        Thu, 27 Jan 2022 08:57:00 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u11so2953873plh.13;
        Thu, 27 Jan 2022 08:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=K2ryLiPw0f3HO1t7MT6zwvdBxUr+KQHraSm4FGIljLw=;
        b=p1m3yph0IFwGYG+qvwbu3BuzV/FWCYPSe4tQ4iehPjJV1Jc90u9r3opclXrUWUbqlj
         FoSa2f7wyU3d8105VT1GZEspL8Jvh7+iiit0N5TnivEuOqR+hF0kohuMp+AEVMD4uYzI
         +L5BH52+5EbxdWTUQ8fb8yvdp7hMAB+fE343OyR7GCsQfqw9+PmGVWb0Dsn3rY0ly3ea
         ZDUUPpuTG1mYnijs0loMADbOkJBrJi9xgTNA1mASu6L4ZZhATlA3THq3kS/44+eyYIOh
         X6jZg8QMxPntsluEMbmPXI3XM/BHCmlh3QHR3iI1h7EYlBdjz3Q5Kz9KhmxcQMpu1n1C
         DHWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K2ryLiPw0f3HO1t7MT6zwvdBxUr+KQHraSm4FGIljLw=;
        b=5fbT9HH+m3/jQg4BrvH5dXAGzFEZjHauDgu6l4XRgjTYTBHEvuAcLgdsxcqZ8xArMZ
         s+cMuBNwtgypBLAx6QKiy6fMwnewpVck8b4u9qvSWz1WB/tKQ7oQEpkSGOrt0cvm+3lO
         V+KoaynTComIrBwt26ghqsSKYdues1dmm7VT2olRgQyQRrYb/+78+rsNEOJdeSoxBiXh
         OxUZLixJ+WYdvmNdkOQ1DgA1VNoO2EPre2YoHNE0qEu74qjJEH5q6XIValu4w0AryMzD
         Z1yKHSX6vqSfmAi40obnWEovvYqRB6yS9F1u3PuAcThVzeT0qGv2Fd3JPMiL4raXC/25
         iPNQ==
X-Gm-Message-State: AOAM532W8WXRF+yUhE9Mct7twldS1095vJKj8liuGbI9LRVDFiC9JVcK
        bEkG4MBzx+LZhyX1qCGAMJA=
X-Google-Smtp-Source: ABdhPJynfGvqVAY3jd2LeS6XZEB92UxktZFObY5DfPm1FG6t8tJGtHAM1YsYs6TD9qa1Dc7Fqvaabw==
X-Received: by 2002:a17:90a:c302:: with SMTP id g2mr5092815pjt.0.1643302620223;
        Thu, 27 Jan 2022 08:57:00 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a1sm19701203pgm.83.2022.01.27.08.56.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 08:56:59 -0800 (PST)
Message-ID: <49177c5a-8cfd-2ef8-b8bc-46bd6f492a29@gmail.com>
Date:   Thu, 27 Jan 2022 08:56:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 1/2] net: dsa: microchip: Document property to
 disable reference clock
Content-Language: en-US
To:     Robert Hancock <robert.hancock@calian.com>, netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        marex@denx.de, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
References: <20220127164156.3677856-1-robert.hancock@calian.com>
 <20220127164156.3677856-2-robert.hancock@calian.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220127164156.3677856-2-robert.hancock@calian.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2022 8:41 AM, Robert Hancock wrote:
> Document the new microchip,synclko-disable property which can be
> specified to disable the reference clock output from the device if not
> required by the board design.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> Acked-by: Rob Herring <robh@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
