Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169E81CBFA0
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 11:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgEIJHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 05:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725930AbgEIJHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 05:07:52 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482F9C061A0C
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 02:07:52 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id e26so12619089wmk.5
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 02:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q3oJnA3GF35nLc7kCQp/SleIRKQq1g1v7fqGLOzYBlE=;
        b=ZTRczgLw1Z2mn0KSsyvRbWiwCKD4Nc8r4erhr8Kr/x17miOGGmjj+1lofhIW1HzPtt
         YGmKcxxCDS5M02Xtq/w1wjrdKT2kV/28z+mZvHVlEi1Af8FiDV6L17MZTI88TojS0R8I
         9v6SP+0xTdVZbfzvfkJqWMjinZ//GzUDlQdr2vmXjyYco9mzuq6jNWPEDGEQlMLrxnzh
         tbdG8bWcQ6j41CGfaKw6M3Muw7vCvH69dvUzeRh9ZIO6W5YwQGEL+lERxNOfMh3gOGd7
         zA2n0hZW3V1B14siNsGHsqfLJ26bhbnKYmMIumKjLBNrRuTTHZwvQBjjLBOpr6xomIlJ
         2JEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q3oJnA3GF35nLc7kCQp/SleIRKQq1g1v7fqGLOzYBlE=;
        b=t6rwDPBQRRTj9vGc7+U/lCrdMlyi4wF34aAojn8bX0qVQDHknYikG3dVG1fh5eWtiL
         Y2JA6n2W95VdUkbhe/1eQVncQLxEJE2yBOB1Z+ciGLOV+R9qaMu47wT6v7DVBxSMaKqk
         WujxGCCmW005UwWEEDybz3Oksy7CSB8IYGDKSivv5BlsO8DbZ9YfRyV1PwGS95/0Gb1s
         7FZQI/hq3+JUjBkel0cQ02g6FKiQM2Dpztx0C9+wvyyMiE4Ie7GFgDZ+32WXsPOk0wvI
         0FPQuPd5KL0cUGajE70Yx3E8NYq2SAo8e7I6aX2DS365uKAxkUM2KHf8kkFohPvPa41q
         3RGQ==
X-Gm-Message-State: AGi0PuYW8CaJ5SNDOj96MLmQm9pWBoiC0Er5kLAaGOHxFpdF5USbzt52
        aQfd4+7ovpifJ2GiDUqagw+yb52Z
X-Google-Smtp-Source: APiQypL6SclKhSTOK+Wo/fgdgXWHimwdG6SWEU9DCEE+vZbdDFtTmwRUsNK8SWHoI9gN4RLBfsgOLQ==
X-Received: by 2002:a1c:1d12:: with SMTP id d18mr6954307wmd.109.1589015270826;
        Sat, 09 May 2020 02:07:50 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:d0ff:948c:5554:b2b8? (p200300EA8F285200D0FF948C5554B2B8.dip0.t-ipconnect.de. [2003:ea:8f28:5200:d0ff:948c:5554:b2b8])
        by smtp.googlemail.com with ESMTPSA id w13sm7015238wrm.28.2020.05.09.02.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 02:07:50 -0700 (PDT)
Subject: Re: [PATCH net] r8169: re-establish support for RTL8401 chip version
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <02afcc32-7cf3-d024-10c4-fdc1596f15f6@gmail.com>
 <20200508183837.42465dfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <10fbebcc-a355-7e41-105e-43a9af87978d@gmail.com>
Date:   Sat, 9 May 2020 11:07:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200508183837.42465dfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.05.2020 03:38, Jakub Kicinski wrote:
> On Fri, 8 May 2020 08:24:14 +0200 Heiner Kallweit wrote:
>> r8169 never had native support for the RTL8401, however it reportedly
>> worked with the fallback to RTL8101e [0]. Therefore let's add this
>> as an explicit assignment.
>>
>> [0] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=956868
>>
>> Fixes: b4cc2dcc9c7c ("r8169: remove default chip versions")
>> Reported-by: Camaleón <noelamac@gmail.com>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> Applied, thanks!
> 
>> This fix doesn't apply cleanly on 4.19, let me know whether you can
>> adjust it, or whether I should send a separate patch.
> 
> I don't see b4cc2dcc9c7c in v4.19, looks like it landed in v5.0. No?
> 
Uups, you're right. Even better, then you can ignore the comment.
Thanks for pointing out.
