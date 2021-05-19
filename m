Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63081389329
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 17:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355064AbhESQA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 12:00:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35264 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355063AbhESQAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 12:00:43 -0400
Received: from mail-qk1-f198.google.com ([209.85.222.198])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1ljObT-0007Ea-7n
        for netdev@vger.kernel.org; Wed, 19 May 2021 15:59:23 +0000
Received: by mail-qk1-f198.google.com with SMTP id a24-20020a05620a1038b02902fa6ba180ffso10189755qkk.0
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 08:59:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PnooPKSwa6SmA/H8X8W7wHWC0547PfU+gn/DWorwdGQ=;
        b=gC5BTW9peh83rVNtol/CtFvrZUDmX4HAed9XZHiit2etZFOCGlk2MvS39Ho6X/lBZo
         UZkrGoXvDpWE4ePvE5QCoXK+/SLXiQ0WgGhOHB7vjFrTxhb4mr80go2THfrjBWBtQWgW
         9BFRwhvcQwwqUz+OQch50Jq0JBoixHJ8xuDKuaokAwZ/ajdrzj4c/pMo2+HrmW0JB/oT
         9qZ2r/4k9ZBUaWhGv1vGXTNJipf4jLtFYHwOOgJWYQPsFukeEJAF198t73furOLulc7d
         6V87mQL/i56TH7ZT19gtJx4rx7C4bdydSlHgGa9wnhbyoFyJIXFNmneTdhglzckcHBIv
         ZvWg==
X-Gm-Message-State: AOAM532qqdkTOjBodqu7iYGMJEFRHQJpbSWUVAFm//FuW8j8i/CDjzs/
        LAcEUcC0oIpy9/ticSG2hKnJqtJfXZDGEFEWdvNJlCTnm9Do1tWJS63r4yksDHzjxF6ltuU8lwu
        NYp8/PrsJjUPE5wPXwuJ9umwjNnc4MFw2+A==
X-Received: by 2002:ac8:5dce:: with SMTP id e14mr77863qtx.183.1621439962420;
        Wed, 19 May 2021 08:59:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGwuwn46qYHy7r79lyImK37z9ZMvzPgbLiPqex86I0vyobhhsRXb3Fod9XlHot7MGdUrlG5A==
X-Received: by 2002:ac8:5dce:: with SMTP id e14mr77836qtx.183.1621439962143;
        Wed, 19 May 2021 08:59:22 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id g15sm72470qka.49.2021.05.19.08.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 08:59:21 -0700 (PDT)
Subject: Re: [linux-nfc] [PATCH v2 1/2] dt-bindings: net: nfc: s3fwrn5: Add
 optional clock
To:     Stephan Gerhold <stephan@gerhold.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        ~postmarketos/upstreaming@lists.sr.ht
References: <20210519091613.7343-1-stephan@gerhold.net>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <c1f02515-a86a-7293-b884-52c388ea70e3@canonical.com>
Date:   Wed, 19 May 2021 11:59:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210519091613.7343-1-stephan@gerhold.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/2021 05:16, Stephan Gerhold wrote:
> On some systems, S3FWRN5 depends on having an external clock enabled
> to function correctly. Allow declaring that clock in the device tree.
> 
> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> ---
> Changes in v2: Minor change in commit message only
> v1: https://lore.kernel.org/netdev/20210518133935.571298-1-stephan@gerhold.net/
> ---
>  .../devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml         | 5 +++++
>  1 file changed, 5 insertions(+)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
