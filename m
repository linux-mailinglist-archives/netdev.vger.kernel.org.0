Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9B824598B
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 22:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgHPU6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 16:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728831AbgHPU6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 16:58:02 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC20C061385
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 13:58:02 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id f9so6688758pju.4
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 13:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FZMDektohZmJqzhXg/xwZ9LEtjsgk1FSvw2lpGVrxH4=;
        b=iDKIJsdgLz+A1K03q3/IJ7ZgzSnuTaV91Lsx5B7mhlkyOXK64dk8WW/vt8E0/cLcC1
         l/js6QChB8XtaBWe0sK3ryVF8kcLlKtKjryBImjIJJ4MPXBzm5gwYmzzLOggktCINmBy
         o7RXgrVYXrd6MB09CMyMIxnm2o0f3lNbOM/njvmR0qSqVNvOVkQREbm5s3aEPdmymSjP
         QcqmGeMotc2wwrErOjG/SMzXE29SOzp+sbw9j0fksV80HTimrCRfxAtIJB9UgmqjPwxf
         h/abny0DeT4CTbDTobah8aoXgOrs91ze4St6c7bgPkLALnTkBhDiR6260tkZkc1vGSFi
         nJQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FZMDektohZmJqzhXg/xwZ9LEtjsgk1FSvw2lpGVrxH4=;
        b=b7NqZXluCPVNqhSIY+KnwgK0rMjk/Pnh4B1UGlOUhyjQtAZKfwK3+z+h2vY3twuHZx
         wE6g9GwK1Tz4TVknlmafdxLStOvufeeHvZCdCQRxTlogPVvaJsg1nI1fV2w2kOHP3f3P
         eZJ00QsCpkZd1fQxj3gf2sC4cIzHMXQUk5PzLxJ9MMvaDsunxD4R9mRCvGJLehb90Cs2
         2WTBc6IxP32MI7gQH3oFv/x6HM9/sMPoYVZXiSfMohcZyZcUknpC2MmUMECAEgYfifAb
         ww1cikAIrfCWN3omrT86Q1cLVVM1MxIczRMFqpdNeQvmZdAMVFlQ1yzbLDoH0I5j8WYo
         Vz8w==
X-Gm-Message-State: AOAM530pVd1qE8h9NtSkkPbi1mX9yg0dMzyZo4BXqm3lid8APnX+t2bw
        dHfP07SzIQA9sx+sSlXpF8LiwlSPm14=
X-Google-Smtp-Source: ABdhPJxBMU6AlDSlERry3g9pRaYSz7HwO9zfzjmVUfa78lQrrr5Yh1uMKK9OWWkVrV/C2mgbHQod7Q==
X-Received: by 2002:a17:90a:9405:: with SMTP id r5mr10250231pjo.74.1597611481280;
        Sun, 16 Aug 2020 13:58:01 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id d4sm14072026pju.56.2020.08.16.13.57.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2020 13:58:00 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/5] net: mdio: Move MDIO drivers into a new
 subdirectory
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20200816185611.2290056-1-andrew@lunn.ch>
 <20200816185611.2290056-5-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <65416810-cb19-786a-5b4e-9233062e0906@gmail.com>
Date:   Sun, 16 Aug 2020 13:57:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200816185611.2290056-5-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/2020 11:56 AM, Andrew Lunn wrote:
> Move all the MDIO drivers and multiplexers into drivers/net/mdio.  The
> mdio core is however left in the phy directory, due to mutual
> dependencies between the MIOD core and the PHY core.

typo: MIOD vs. MDIO

> 
> Take this opportunity to sort the Kconfig based on the menuconfig
> strings, and move the multiplexers to the end with a separating
> comment.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
