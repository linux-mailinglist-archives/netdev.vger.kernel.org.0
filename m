Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B5F1DA234
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 22:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgESUDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 16:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgESUDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 16:03:45 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351BBC08C5C0;
        Tue, 19 May 2020 13:03:45 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z26so392101pfk.12;
        Tue, 19 May 2020 13:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VClIq2B9DplbSOKi1zTCsffgA/r+9JDCQ+/Oexq2Kbk=;
        b=KZIPUfQXpnCxNG32pxX147DeR6D91Kdr+r0m2x4aGxjDVGgQTL2+v1HSt2ZL67zpC3
         /tW2rHERtgL/AQMlVG1VQcmUqJwvPy36j/pfpUBJ5dc5nAbx6nAmH5MkkxyAMFKmvJhx
         0D0rzfdpdd2CPak1QIt70MAUD8tSVnzLf4Yo28Ijwy34ZtiSTHbFGaJWBQS4TKbFJQ4n
         AaHerd7Ug/YPmUEA62/AIZOqtuE8w5pDQwofasje25X9FH4ut4nLAGutvpfBwjHH4rrg
         Beqeuj18UmQ4vCgONCQcAwiG0lTFx6bMnRArEfqzym9uID+meL/sPOIZ4uyergWaPz+9
         OI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VClIq2B9DplbSOKi1zTCsffgA/r+9JDCQ+/Oexq2Kbk=;
        b=cPo0Xw18P8kGMn/pdFmNz/KLgsuo1aqCqQjGqCIdXHp6vBYat3xXug8d7YV4DHueGQ
         QABZQz2MX20b2ulre3/B7im5Jj9ZA9Ynsdk519dSo23qyI6R5O8rPM46OfL1s0Lg5OgB
         uKNYmPr4efbOBTB5wsgUZM+KwdkrfYTaaF5FnURpUmzR23/YBlOVRMb7+c5rcNw0Z7nd
         sUl1cePWWDUqgd4SxtDYKWWfz7NoaGa3fEG4sCkgPH3cjcoSyXdnw3cywXv41gAIJNd0
         dxT4EbInSbfH5xS6VY1w5GT051CYkcX/dp1FIqNmREEBm3BXVBp/rtI5NLLoRs4imXpx
         l9IQ==
X-Gm-Message-State: AOAM533b4kuBzVnCLnSb8Qqf+vr4p9oMgRBdaxyhZJ8c18xr+I6U0+Fd
        jUECmhplYC8WgOh/gDBPSpFY5WKD
X-Google-Smtp-Source: ABdhPJy9ijc7fEmAwfNBZJGPHO63gmZjhFXdGzWAQS6rK1iFl0YpaplVO/GUwUsLu9q/nrTUCnEltQ==
X-Received: by 2002:a63:dd11:: with SMTP id t17mr856548pgg.348.1589918624178;
        Tue, 19 May 2020 13:03:44 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z29sm268534pff.120.2020.05.19.13.03.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 13:03:43 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net: phy: dp83869: Update port-mirroring to
 read straps
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20200519141813.28167-1-dmurphy@ti.com>
 <20200519141813.28167-2-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fad928ae-93cb-2ce8-98ab-68acb7bb02b8@gmail.com>
Date:   Tue, 19 May 2020 13:03:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519141813.28167-2-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/2020 7:18 AM, Dan Murphy wrote:
> The device tree may not have the property set for port mirroring
> because the hardware may have it strapped. If the property is not in the
> DT then check the straps and set the port mirroring bit appropriately.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
