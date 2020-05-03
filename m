Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCBA1C300C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 00:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgECWaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 18:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729183AbgECWa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 18:30:29 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2F7C061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 15:30:29 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id s20so6044726plp.6
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 15:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jDE3l+IcfG70T6tnve55nYY0CziZrsvxcq61TZmpBrY=;
        b=tUrHDwe7VkDhcRGtc/cbfiHQ7L4NCf3bJa+feNM51gIlMFHuB3zqcS5hMD3LnCcta6
         dYHnHJjSjjqf8icTxmwOphR5pOUrU6TrEeh7G8xekBe5r6+5bao9VHl2wb7XytMFyV9d
         sr9yYYVz32d8fNoE6AVdhQGBgIzf43c53xC63RrYo/6zLFl4Sxxyda7ASM4Nh/SldiGc
         e2ib7K96NENP65xR/6dOH217UVDuUllPXnf9mMVTEfyuBrARKMLEZClEaUYYRCNuqDaD
         ntFbAtI73C44/ocRHWbQP0v1AkQlPiw0Ul1DoN3eUKDT6ee/JWuqOxRZSv3yk5+hv7X/
         FI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jDE3l+IcfG70T6tnve55nYY0CziZrsvxcq61TZmpBrY=;
        b=rPlY+RIcBvp3/IrYXm76N4MRDRGEDFvW9Hgdm3vD5U5l1ZpEJ5jMTClQBGxypbP52v
         8Z2PprUBAl4B1ftsKk2taqEEsjmLIzTy9vSDwf90RoPcReDK7MZEygupQp9QtYtcjpq5
         EWcAaOrye+2mjAsGMkz5fpwkY+F/D+J12WwTbv5NwlnjfGBka2FzsSsFgytZSA/R9Oai
         6AQV65T0dTk7eqHL1BPAo0lsEiAZYmk6dyrIO82orlET9kwn9o1gGhKDdVBGsWy9c3Gz
         B2tr6Y1oiEIEkUdk9Cspm2383GMd4AeHZQfHUIEjUtj1VIjCOrdtodLyQckIT5NaGSAI
         aQNA==
X-Gm-Message-State: AGi0Pubm1PZYtgxYvgeeHGprnEAmMzoLa/Cam1wmqRWkU62a/oSA30wh
        S62BqAkS6Nm2bvBchFA58nE=
X-Google-Smtp-Source: APiQypJpgQAhoZQMprhjaLDBIuBoiaxfLLY56MwTyUT1EgHeGtiqmZfQVkMIWhwZlhHmHI/+j4CzNw==
X-Received: by 2002:a17:902:6b85:: with SMTP id p5mr15145129plk.315.1588545029065;
        Sun, 03 May 2020 15:30:29 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v1sm4992787pjs.36.2020.05.03.15.30.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2020 15:30:28 -0700 (PDT)
Subject: Re: [PATCH net 2/2] net: mscc: ocelot: ANA_AUTOAGE_AGE_PERIOD holds a
 value in seconds, not ms
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     idosch@idosch.org, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        claudiu.manoil@nxp.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com, jiri@mellanox.com,
        kuba@kernel.org
References: <20200503222027.12991-1-olteanv@gmail.com>
 <20200503222027.12991-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <292d750a-e85d-b266-cbe4-1951f0428eb7@gmail.com>
Date:   Sun, 3 May 2020 15:30:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200503222027.12991-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2020 3:20 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> One may notice that automatically-learnt entries 'never' expire, even
> though the bridge configures the address age period at 300 seconds.
> 
> Actually the value written to hardware corresponds to a time interval
> 1000 times higher than intended, i.e. 83 hours.
> 
> Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Faineli <f.fainelli@gmail.com>
-- 
Florian
