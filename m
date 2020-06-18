Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BDF1FDA1E
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 02:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgFRAOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 20:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgFRAOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 20:14:10 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C9CC06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 17:14:09 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id v14so2089787pgl.1
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 17:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wKpZKv8zUEmjNMLPCx8grDhOj+T7Hm432vOHDvalgbM=;
        b=HXc8nBBjSDOUhPogSZGOwQHo8ZwLUHrGzXEoheImxdBYHVuPMk2/uGsLrKnksldAgM
         QTAyinNRYppHVYWWxaOlcDGae2CvC69tnvCGEVyPufRcQjMD8tSDbFYsIibLRWpQkEVc
         58t/M65QCEuEDw2UzjKAOM4OCR71vIWgszPlYEzWnm6sOxlSjZJ+B/RUFHIlso7Z7A+m
         hypWkgnUzmKMEkUM+qegplDwhR/Etf2eBEEg2dOgB5CXTCo9h/cfvWqEuMDoMDQRilYZ
         Gl5GNrwhyeA4amXpPPVHebbNOmYdJvyUzPghVUzoTlUtzrY72j5dJvaPdfiHhhy+Bmn0
         0tEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wKpZKv8zUEmjNMLPCx8grDhOj+T7Hm432vOHDvalgbM=;
        b=geP/uXwtvk3/KliEXguxfCbAcaLiaCB13sT1Zljl4JLLsOTHhN8a8TvO5L59AcH56Y
         3JN4ZZlUfXTBX4vWti21wKOdkX5o6MHL4MWDvKB3frFSE0QwC7GWUIEmSn8sU6z+jDTy
         IYXJm/AWNk+O7UHFZ9Ww7QBthKzvY5P/bPqkXELRYPBenGiGdnlyNsC3D3z6B3TzM/pe
         MwO2IpUNbQWDmGTTnpVaH9doiXA0x7xSF1rKrMShPmogxW7a2AiSR/Y29SE0cIT2+gFa
         uBSAtCq2hOvbaqFrWAnhhHc8lL4v/2IfeHR5HvgL+3cgIzwORQovGYZs582UjoBh6N38
         grIA==
X-Gm-Message-State: AOAM533mQMpZloJ8eQNREV34NOQ33EbysgcIQUVSJB3ru016pKu84nRj
        9izp9skx2YxwBf9ZPb40+lE=
X-Google-Smtp-Source: ABdhPJxQcTzR29dPDShfgHCR9b9qNzs781vG1S+zcpSu1UxhEgrmDMMNuBYXycHzfT3TB7KKpVzOgA==
X-Received: by 2002:a62:3301:: with SMTP id z1mr1192913pfz.324.1592439248432;
        Wed, 17 Jun 2020 17:14:08 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l83sm911928pfd.150.2020.06.17.17.14.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 17:14:08 -0700 (PDT)
Subject: Re: [PATCH net-next 1/5] net: tso: double TSO_HEADER_SIZE value
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
References: <20200617184819.49986-1-edumazet@google.com>
 <20200617184819.49986-2-edumazet@google.com>
 <20200617170229.04454d36@kicinski-fedora-PC1C0HJN>
From:   Eric Dumazet <erdnetdev@gmail.com>
Message-ID: <1b5a59d6-ef9c-81e0-9a78-f0eedfc3a40b@gmail.com>
Date:   Wed, 17 Jun 2020 17:14:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200617170229.04454d36@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/17/20 5:02 PM, Jakub Kicinski wrote:
> On Wed, 17 Jun 2020 11:48:15 -0700 Eric Dumazet wrote:
>> Transport header size could be 60 bytes, and network header
>> size can also be 60 bytes. Add the Ethernet header and we
>> are above 128 bytes.
>>
>> Since drivers using net/core/tso.c usually allocates
>> one DMA coherent piece of memory per TX queue, this patch
>> might cause issues if a driver was using too many slots.
>>
>> For 1024 slots, we would need 256 KB of physically
>> contiguous memory instead of 128 KB.
>>
>> Alternative fix would be to add checks in the fast path,
>> but this involves more work in all drivers using net/core/tso.c.
>>
>> Fixes: f9cbe9a556af ("net: define the TSO header size in net/tso.h")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> 
> Some warnings popping up in this series with W=1 C=1:
> 
> drivers/net/ethernet/marvell/octeontx2/af/common.h:65:26: warning: cast truncates bits from constant value (100 becomes 0)
>

Nice, thanks I will take a look.

