Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6F91C47E9
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 22:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgEDUUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 16:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgEDUUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 16:20:02 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9DFC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 13:20:02 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 18so6136236pfx.6
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 13:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z+lxlMfT45F8oqmDSYrI5f1l6iTL81CBY63GtXA8G1s=;
        b=P5v2uxojTkACsv9kfI/BQcwLJBn01wVnBV43PJ2mE6CJ2L38p+6dZXLgchwl1hXzxc
         Mx41qXSY8pPVQ7xFEbDyTAc9ZxeTJlKJDjG23Pq9yLNM37VzCTTEuFkkUOB1n18gGvB1
         5mp9vvBnyPWanzik5QWg+mr0zg1zErHsof66ycFR/WmBV3UtSfV5h3WoD96yClHFypH2
         ryyrEtOceQEeH/6zskYvQWHCvNfUY6+rur0XRXsl0Bni134VSiaCAVrHzGG1IWu/+lSb
         2eA1Z2GzaoGT2PJLExpm934aWDwCtAzavuJ6HLi2WJn3NHvbN7N7mDcu9bNa0dYi8sWv
         UhQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z+lxlMfT45F8oqmDSYrI5f1l6iTL81CBY63GtXA8G1s=;
        b=JMkTOfGGbObtPpB2NjARVdcpclX9LpkUTn4z47xfue5iulLZh80/qzGf7iXTlQLpvX
         Uuu//OqV6oiF2BygGyMFwasQCJQB8Zh4xX9Y05wVNuge4dVttcYkh99m8mGIbcHVf1qS
         vSA12zzsGb3vqPlvt1/ONSfBE1UMCbTDBPorNf5a2ruR7Gleh8EUUIgDmYb3YbmPmORo
         Rpz+5p6zMCGfZQqfxt4mXI69zZP2jlgEF5wM8vL8sOxSjZTbxHMfKydTXABE5sPbBrUS
         rVn6Nrj+xAEhSwlG/ovoojffXRznOkQEvK3jhZ5vg/0v+AL3RLWOBfOVxAUOpD7mAiH9
         2NoA==
X-Gm-Message-State: AGi0PubhCGflj1yIQqdXzhlB/3LlyQ59pmwkDIdt3zoas7PunMiZvlTM
        D5xmDZ652jxrQp32j3l87BbCMCpK
X-Google-Smtp-Source: APiQypKoYRuAjZSYQdCz4ZbhyRuK+Y6uDN6i8qHGRyTV1dRAvuDtA7PJ48vEEcNIoUF/wEiUsohh+Q==
X-Received: by 2002:a63:1705:: with SMTP id x5mr24566pgl.12.1588623601018;
        Mon, 04 May 2020 13:20:01 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z19sm6186097pgc.21.2020.05.04.13.19.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 13:20:00 -0700 (PDT)
Subject: Re: bgmac-enet driver broken in 5.7
To:     Jonathan Richardson <jonathan.richardson@broadcom.com>,
        zhengdejin5@gmail.com
Cc:     davem@davemloft.net, Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>, netdev@vger.kernel.org
References: <CAHrpVsUFBTEj9VB_aURRB+=w68nybiKxkEX+kO2pe+O9GGyzBg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <87b7e9f5-39d3-5523-83da-71361cf193f5@gmail.com>
Date:   Mon, 4 May 2020 13:19:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAHrpVsUFBTEj9VB_aURRB+=w68nybiKxkEX+kO2pe+O9GGyzBg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 12:32 PM, Jonathan Richardson wrote:
> Hi,
> 
> Commit d7a5502b0bb8b (net: broadcom: convert to
> devm_platform_ioremap_resource_byname()) broke the bgmac-enet driver.
> probe fails with -22. idm_base and nicpm_base were optional. Now they
> are mandatory. Our upstream dtb doesn't have them defined. I'm not
> clear on why this change was made. Can it be reverted?

You don't get a change reverted by just asking for it, you have to
submit a revert to get that done can you do that?
-- 
Florian
