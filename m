Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0788C42437B
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 18:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239443AbhJFQ5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 12:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239432AbhJFQ5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 12:57:53 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87D1C061746
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 09:56:01 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 133so3045926pgb.1
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 09:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oSdtPJ+0NThB3ljgCfCy9ufZVSEm9Ls0ZBcL21c8Wss=;
        b=k9UJKjdJDexYf1CU0SY1yyjoImzRIprinHMXAEtcafrEfof6W5EGg3IjUCKuFlJHeU
         DrwwL1CPLLnQlx5l+T7l/D4AijtSmR4AW4RVIbo3f4f23yAu072qt3q+dXKgNvZJXaf0
         w/f44MPT/XO2JApeqA5FeRfVgvHZX1QJ9JD/eRmktT58yDnCv0Ir+8DrEnxm6W74/7sW
         JWZQlo4nsfz0T6CLLqrNZepi1Yk6Dace2vU7qn//xSRzmxzUOb11sJ0yo7IJ2LInH0Uq
         YI35+fFgR6486qxontasShcIqXzhbnXzr6bea8x+5BsupsiFCdZrDt7FiyV0NaqAigj4
         nlxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oSdtPJ+0NThB3ljgCfCy9ufZVSEm9Ls0ZBcL21c8Wss=;
        b=bDF7Ri75rBrEinbH7oN9w3DouYOewSSPbDwvn2oU1aplEKeXUX5DDCRJoN4sbWPfQb
         xvKWDsnA9s7jtzDXnjRIW71Q+v4WWlRxqZz0IDTGhuKoECd0eU7nklLTvHCM9wzv/ZWw
         AyxCUpfAWGKBvWZJtE3wggYYUe17mZY58e/n+r2y/H2Bhw7fr1ONKB2UpOKQ008IS2l2
         eFS+KxVeT3umlfqC6Wewu5tLYzjLjLjjwl4ZbkPId9u8wI/NrNr8LSzJCJtcGlbvDsA8
         Eq/BnBEdZPdjuW72qEXQpC/Zk+oHyRot2L/U7eQgGf+3qDyBC1ahdZcDv3buJgR/Civd
         F3lA==
X-Gm-Message-State: AOAM530I5UNXz6ddLoMMPC9c3dShV0VfEM5VeILNOtJjzjRyJnK6VXVc
        j47u8voHRG/jZjlzTGfZMGUqNQ==
X-Google-Smtp-Source: ABdhPJzK1LS/Ld2yodGuY6nY6DJ4xxz95YeW7AFtUl8KOuJkxCkLau/xjtTm/KsHYPVL2+xqdBDoAg==
X-Received: by 2002:a63:b707:: with SMTP id t7mr21105979pgf.55.1633539361350;
        Wed, 06 Oct 2021 09:56:01 -0700 (PDT)
Received: from [192.168.0.14] ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id o189sm7950613pfd.203.2021.10.06.09.56.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 09:56:00 -0700 (PDT)
Message-ID: <7d33d634-a6ba-e189-b2a0-77cfcd3a8643@pensando.io>
Date:   Wed, 6 Oct 2021 09:55:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.1.2
Subject: Re: [RFC] fwnode: change the return type of mac address helpers
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, saravanak@google.com, mw@semihalf.com,
        jeremy.linton@arm.com
References: <20211006022444.3155482-1-kuba@kernel.org>
 <YV23gINkk3b9m6tb@lunn.ch>
 <20211006084916.2d924104@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <20211006084916.2d924104@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 8:49 AM, Jakub Kicinski wrote:
> On Wed, 6 Oct 2021 16:49:36 +0200 Andrew Lunn wrote:
>>> --- a/drivers/net/ethernet/apm/xgene-v2/main.c
>>> +++ b/drivers/net/ethernet/apm/xgene-v2/main.c
>>> @@ -36,7 +36,7 @@ static int xge_get_resources(struct xge_pdata *pdata)
>>>   		return -ENOMEM;
>>>   	}
>>>   
>>> -	if (!device_get_ethdev_addr(dev, ndev))
>>> +	if (device_get_ethdev_addr(dev, ndev))
>>>   		eth_hw_addr_random(ndev);
>> That is going to be interesting for out of tree drivers.
> Indeed :(  But I think it's worth it - I thought it's only device tree
> that has the usual errno return code but inside eth.c there are also
> helpers for platform and nvmem mac retrieval which also return errno.

As the maintainer of an out-of-tree driver, this kind of change with 
little warning really can ruin my day.

I understand that as Linux kernel developers we really can't spend much 
time coddling the outer fringe, but we can at least give them hints.  
Changing the sense of the non-zero return from good to bad in several 
functions without something else that the compiler can warn on 
needlessly sets up time bombs for the unsuspecting.  Can we find a way 
to break their compile rather than surprise them with a broken runtime?

sln

