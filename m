Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB03354E19
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 09:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbhDFHnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 03:43:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50503 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbhDFHnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 03:43:04 -0400
Received: from mail-wm1-f70.google.com ([209.85.128.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lTgMR-0004Xu-Sv
        for netdev@vger.kernel.org; Tue, 06 Apr 2021 07:42:55 +0000
Received: by mail-wm1-f70.google.com with SMTP id a3so105504wmm.0
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 00:42:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=un5YlHzl0BXO6eaQ9eW4dvRNdp9xfJ5KIDYh8hbqnBI=;
        b=EyAigrh9mmRth6TpUFthJUs9Dg32YPl6shswdFDa6nJ5BG9O9+AkGH7T/hkYW4/nEZ
         QBtXxJyvVmg0BFZ7jTnfH61IaTuNx1nykT182nQqnX3GsrPNnUBzuq7kqiwxJFLjI2GH
         vgfvddFbIfNUGHnuSdPflDd+48mngOdJV3WlVjb/4RvR+cxS9YqlYrzPAgZLuKNmMbhJ
         sDn9s3NfoMq8GUzY8QApsOR8JSsM34IQEZabCTxP3Zv/PC3pMK0c/nbdO/bHtJWULV+P
         iV9Z6JSOQQ/NGYxnhChyIqheSTvK+vbvrPL1YEuZdFKs4M5f+OWA10+bb0EutJRwP5zY
         P0Yw==
X-Gm-Message-State: AOAM533IzszxuE+fcs/PR3YLD0YDcAWCWH0DLwN6b/JcS86jX8oN67cU
        o9Yk6cYAez8CSuNkg3MVe3f8+uc0KecLjGeq6f6S/zbkwVprk7OhchF3lJhRgOtjLJF3KbNoD0n
        Cn9IkqGuJOneJCVAxZ4DAs7xJX88r9H4LjQ==
X-Received: by 2002:a05:6000:1acb:: with SMTP id i11mr33901262wry.68.1617694975691;
        Tue, 06 Apr 2021 00:42:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBgJ29Q8kLgm96eyYaDgv9lrgSX6WAUdxiyLTBZQLm0lIymW7kzWKpwg8SwRxbvqmYyS/tzQ==
X-Received: by 2002:a05:6000:1acb:: with SMTP id i11mr33901245wry.68.1617694975481;
        Tue, 06 Apr 2021 00:42:55 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-192-147.adslplus.ch. [188.155.192.147])
        by smtp.gmail.com with ESMTPSA id s5sm15349625wrw.2.2021.04.06.00.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 00:42:54 -0700 (PDT)
Subject: Re: [PATCH v2] nfc: s3fwrn5: remove unnecessary label
To:     samirweng1979 <samirweng1979@163.com>, k.opasiak@samsung.com
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
References: <20210406015954.10988-1-samirweng1979@163.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <07a98473-1e85-cd28-3854-063a73592155@canonical.com>
Date:   Tue, 6 Apr 2021 09:42:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210406015954.10988-1-samirweng1979@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/04/2021 03:59, samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> In function s3fwrn5_nci_post_setup, the variable ret is assigned then
> goto out label, which just return ret, so we use return to replace it.
> Other goto sentences are similar, we use return sentences to replace
> goto sentences and delete out label.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> ---
>  drivers/nfc/s3fwrn5/core.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
