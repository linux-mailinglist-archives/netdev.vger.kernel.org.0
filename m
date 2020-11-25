Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE11C2C35D9
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 02:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgKYA7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 19:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgKYA7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 19:59:09 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66DFC0613D4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 16:59:09 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id t37so806016pga.7
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 16:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PZf5pFz6zPzVCKyjDzkNHS57KQodpAR05/QeZOf2yvE=;
        b=dJl2BcGQlM8RvvCc8H870WphEtqnw1KuN/C9DyUARlOVyS5cyj43ko1Ylpy8J7rFFR
         jhIcCjTp3vABdNhYsu3ouSe36TorgQWm5WcpQfIqaV5RexZN44T/8ahbw4mUlw53QX8c
         ImbkcTik5A0VbEI5nPN5F2bJH2xpT7HaDw1LTjn/lbBG7q9eDstCeOWnpJdIifkanM7i
         mr9O5uXXmE/M+e5DhWLbKG8UgdveBcc+NUq7XqUHdquCpN628ML8YcW79vKIZFW1apsD
         Mo7Bp1EbF7/Tctid7bWvG0ZjPxYRqr2AzrDs2Rdh4vfT8m789lrOOlWV9C7FtBxVK+dW
         o5bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PZf5pFz6zPzVCKyjDzkNHS57KQodpAR05/QeZOf2yvE=;
        b=qkYb3R8TZkHco01T/8Gi1uabyHcVnpHPdXs2RZTu9IiMub4NdG90Ec6YCo9ZaexVQE
         hYpXA88tvDiTk+iiMI6gqQJgvk8gYiJFHe6HWRkGGK6023bzR4jEnJwXMHQ3SCQdmJen
         OOavfWI9zWEaquey5V+esnhPrxqYamlSFg28ZIKNru/Xev5KB+MEDef6DGOp2MfK6Yh4
         7Po8o7saJ5itjfDAwTMSnGrn1O5mdnpNzece46OxgiP/EElD4XvJBb3DPrvr2uq+xiaJ
         JTDa19+wFPVvAn8mLz/NPilbcWsJ8CPFo34SszU5b92lJxRcxpipPJUN7AuA+HaC5jIR
         3ZLA==
X-Gm-Message-State: AOAM533eN53rlkPN1/zwWQSy1eqzhO5byvo33QdTX1B5xJDo5CtFYiRw
        MekmFmQBXEeiJEJYWK2SQOU=
X-Google-Smtp-Source: ABdhPJw6UNkurYrY0G8OePeaG8L1OiUsvSqaeOnFIVudE8DgaJkMd2wfMAERA9DFO4gclYWxeZiZRQ==
X-Received: by 2002:a62:7905:0:b029:197:f300:5a2a with SMTP id u5-20020a6279050000b0290197f3005a2amr846717pfc.30.1606265949360;
        Tue, 24 Nov 2020 16:59:09 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m68sm197742pfm.173.2020.11.24.16.59.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 16:59:08 -0800 (PST)
Subject: Re: [PATCH net] Documentation: netdev-FAQ: suggest how to post
 co-dependent series
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, brouer@redhat.com,
        andrea.mayer@uniroma2.it, dsahern@gmail.com,
        stephen@networkplumber.org
References: <20201124235755.159903-1-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4740d778-fb53-b468-5966-55312e71bbcd@gmail.com>
Date:   Tue, 24 Nov 2020 16:59:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201124235755.159903-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/24/2020 3:57 PM, Jakub Kicinski wrote:
> Make an explicit suggestion how to post user space side of kernel
> patches to avoid reposts when patchwork groups the wrong patches.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

The examples are good, that makes it pretty clear, thanks!
-- 
Florian
