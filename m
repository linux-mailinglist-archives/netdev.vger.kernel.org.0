Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C55C250E81
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 04:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgHYCDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 22:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgHYCDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 22:03:48 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C650C061574;
        Mon, 24 Aug 2020 19:03:48 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id w14so9334696eds.0;
        Mon, 24 Aug 2020 19:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J49ibx7rWGFZBjoDPxKJPcnIgdlw0PGmq9DEe+09t7c=;
        b=pN9KGp8EA4+447mPGfQrOaDsDdt7pZWjGDXrVigq63ADBstrVE4fOEW2XNN419sZMH
         qrlIybKYhkhbScRF+4k6YVcByDAjhpXR2cBtOiAFKY1Uq3BbbJR6bTDt3Xf3RnNH+ZoE
         K44RmSK+ckbJx66/BxCsgM724/s6XOMpEUoDotTBlucFpjk1MvWIRnwYEMekFMX8U+g2
         giteHXA/MzU1lnCfiUuneHY3QQBbOAEEgatGVVgU9IzL2weLqYFKaEmgKYq+8SzR6maA
         53CchjhFIKW5IV+2FdGiHXfym5i4TFLh31PxGMGsX46tTIKKQ86Q/PZHqlhCG57N4It5
         qwhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J49ibx7rWGFZBjoDPxKJPcnIgdlw0PGmq9DEe+09t7c=;
        b=S8GSRMQERfDS20HMaMuVx9Akn2EzzjviwJNxUUaGdBmqLUFbKV66+thLLlJHu/81vl
         /hsDWws5hlc9fJCEE7+WIWd7/jWHnQtwgU+1mkq6W4W4ZhUXVTotdFaTrTiPoEXlpPbk
         F5+gHHlODA34ZwzvoIYcmNpdw+FuKrS28Su7AFMoEASU+R2IZjcsDZWhEcdNoPRvP5ti
         WFq1XjkaXgQdMdlhFgYidzST6LLB541TBGH3R2ufU7YYq4RZ1A/Tkd/q1aX9wG3Wf4AT
         MsM98DCKTDws5FS44yRoRKuw1Y1jjjT0rGhMf5g31R/GW0RtVCBcg3quNFcXzV5YjQhz
         zVkw==
X-Gm-Message-State: AOAM530FfCvaRuogtB6K4hNfBF7EtQazgQNgu3XMpU6tLep79F3NlWeB
        LXi81xglCoNtEQPVldR/aJI=
X-Google-Smtp-Source: ABdhPJz5AHGCH48uQk6CVnq9RWkLV4y4g44m8Lll8usQ+nw4V75nvjb0ik+6WFoTInLpR2ll3p+FAA==
X-Received: by 2002:aa7:cf94:: with SMTP id z20mr2790499edx.247.1598321027020;
        Mon, 24 Aug 2020 19:03:47 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y25sm11925234ejq.36.2020.08.24.19.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 19:03:46 -0700 (PDT)
Subject: Re: [PATCH net-next 0/6] MAINTAINERS: Remove self from PHY LIBRARY
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk
References: <20200822201126.8253-1-f.fainelli@gmail.com>
 <20200824.161937.197785505315942083.davem@davemloft.net>
 <bd8da53d-ebf8-2e2e-124d-f12e614d820a@gmail.com>
 <20200824.182135.131366460578950674.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <824f8432-f40e-79ea-3d09-9be09b54746c@gmail.com>
Date:   Mon, 24 Aug 2020 19:03:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200824.182135.131366460578950674.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/24/2020 6:21 PM, David Miller wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> Date: Mon, 24 Aug 2020 17:43:37 -0700
> 
>>
>>
>> On 8/24/2020 4:19 PM, David Miller wrote:
>>> From: Florian Fainelli <f.fainelli@gmail.com>
>>> Date: Sat, 22 Aug 2020 13:11:20 -0700
>>>
>>>> Hi David, Heiner, Andrew, Russell,
>>>>
>>>> This patch series aims at allowing myself to keep track of the
>>>> Ethernet
>>>> PHY and MDIO bus drivers that I authored or contributed to without
>>>> being listed as a maintainer in the PHY library anymore.
>>>>
>>>> Thank you for the fish, I will still be around.
>>> I applied this to 'net' because I think it's important to MAINTAINERS
>>> information to be as uptodate as possible.
>>
>> Humm sure, however some of the paths defined in patches 4 and 5 assume
>> that Andrew's series that moves PHY/MDIO/PCS to separate
>> directories. I suppose this may be okay for a little while until you
>> merge his patch series?
> 
> Aha, I see.  I think it's ok for now.

I should have probably made it clearer that this depended on Andrew's 
patch series as opposed to simply building on top of it.
-- 
Florian
