Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2AB37EE9F
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348219AbhELV4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:56:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41841 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391829AbhELVcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 17:32:23 -0400
Received: from mail-ua1-f69.google.com ([209.85.222.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lgwRe-0001wG-GJ
        for netdev@vger.kernel.org; Wed, 12 May 2021 21:31:06 +0000
Received: by mail-ua1-f69.google.com with SMTP id g10-20020ab039ca0000b02901f7b6d6a473so3503056uaw.17
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 14:31:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=THR7nK7kAwdY9rO/aRV1zRGsF5kUDEhRB1tNMwQV0/s=;
        b=nYvbjF047ozg6q/Oy9VQjitzYh4fi7DNBti+Tuq2naQ1xvOQzH55EnIQNfUTNj/7CY
         Z8TAuxR5mqMhbXS5P+Wzq6/JHmz3n2rTx2moXrNqnJQK1jFqXdaz03zKsTOjxJbkt86Z
         RUuJVnTvzOpDVZmHDIre260ou4gZSLNLuQ8JKHeQHVzIRzy4M0HtgFIYp2o2jdMPDIV2
         3qppQAq6iDXyaXwZ7q6MAn4Ucq5+fQlbTW8vd37cVlSjs+zTv4JUxY6cCRmRicP+IurC
         sbsEu5JE2jKzVCsbUcJqtU3BVXMwAYWt1fzqE1WeNp8O8z3F1occlGwOj3qEdT9UzDQV
         gk1A==
X-Gm-Message-State: AOAM530ivmCl4knEWahPuGDujK45viGYqoxVmK8Yl1+iWn/pprxsFA+M
        usY0bRbL4Fgdv06bVTknfMo2Aa1z/N/JKBor5ESp4emHjtWGom18xtfhSbNXSmVcPArHpEGEq/8
        FAsNlZE4wzr/1ZoonJEqkchepS2NpsXpdBQ==
X-Received: by 2002:a67:bc5:: with SMTP id 188mr33039895vsl.50.1620855065115;
        Wed, 12 May 2021 14:31:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpqUE6lvffKGeZjMFpQf4nrDaZgY5JFbTilGc9Kdj2kbIfwyy7wHTLB+4d0jgEZKDZulELow==
X-Received: by 2002:a67:bc5:: with SMTP id 188mr33039870vsl.50.1620855064870;
        Wed, 12 May 2021 14:31:04 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.5])
        by smtp.gmail.com with ESMTPSA id k4sm153957vkk.27.2021.05.12.14.31.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 14:31:04 -0700 (PDT)
Subject: Re: [PATCH 1/2] MAINTAINERS: nfc: add Krzysztof Kozlowski as
 maintainer
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
 <162085441038.10928.7471974213298679002.git-patchwork-notify@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <c23ad421-2d8a-16c7-9297-e0df04062a8e@canonical.com>
Date:   Wed, 12 May 2021 17:31:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <162085441038.10928.7471974213298679002.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/05/2021 17:20, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net.git (refs/heads/master):
> 
> On Wed, 12 May 2021 10:43:18 -0400 you wrote:
>> The NFC subsystem is orphaned.  I am happy to spend some cycles to
>> review the patches, send pull requests and in general keep the NFC
>> subsystem running.
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>
>>
>> [...]
> 
> Here is the summary with links:
>   - [1/2] MAINTAINERS: nfc: add Krzysztof Kozlowski as maintainer
>     https://git.kernel.org/netdev/net/c/8aa5713d8b2c
>   - [2/2] MAINTAINERS: nfc: include linux-nfc mailing list
>     https://git.kernel.org/netdev/net/c/4a64541f2ceb


Hi David and Jakub,

Thanks for taking the patches above. Can you share your view (or point
me to the docs) about maintenance process you would like to have?

For example:
1. Do you expect pull requests or only reviews?
2. Shall I update anything on patchwork (or pwbot will take care about
it entirely)?
https://patchwork.kernel.org/project/netdevbpf/list/

Best regards,
Krzysztof
