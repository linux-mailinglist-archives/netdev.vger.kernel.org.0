Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5F0391955
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 15:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbhEZN61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 09:58:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58862 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbhEZN55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 09:57:57 -0400
Received: from mail-ua1-f70.google.com ([209.85.222.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1llu1J-000675-J7
        for netdev@vger.kernel.org; Wed, 26 May 2021 13:56:25 +0000
Received: by mail-ua1-f70.google.com with SMTP id c27-20020ab0079b0000b0290217cf59726cso801637uaf.10
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:56:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wk3UlUCfkCL6QN9YaFyZimOXVt4iG+84u/Humu+3uZw=;
        b=hX/o74r4jlJ1mgoswPvO/Hkk14MdHczQ9upPMvGn+zP7uQ6cmYijuyHb4VL5BGSTNZ
         NQGBDw/t8zMISE9fSiGdNxh+KpF1kRew2fsBfgFCOrgwXiwZjGMTsG4L61D8GgsPTDnc
         uJTzLyrOof+An7pfgaEadNZDnL0fePFn9mg+vnI7UPa5X+mgUqxXKl07MyQdfKrBq/XL
         6hCL5tFImNSW5qD/Ss2u0FLSYp8uhfP+SVadxbnyRVS5GIOrFfNy/sVEvMJhJqtxnezp
         IQ5X1rQOYvPiI55DrpNoZ1nlQdPvSqKArtzrinCxh2f7mVihN3eoT9qgPWAh9CM5w6/N
         jsZw==
X-Gm-Message-State: AOAM5329yoqdtdkTjyqE0ns/mkR7/9OLFwXI+kRuaj/Vu63boKHZHS3F
        isDreQwxllKEX5x76Ml1R/skBWAhiMYcs3FI/S8O9pvrcQfw+BEXpAdIUVNh+lteFrKs1dBFBpl
        gr/N7q7TLMB+iUobuzKRvk42fvoABzeh48w==
X-Received: by 2002:a67:b919:: with SMTP id q25mr31366093vsn.17.1622037384735;
        Wed, 26 May 2021 06:56:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxinuLNMn5s0odgmLxRBXmJbtLvoYFepINUvv6jG+v4e1LdZ3aCTN15rHZ6f5RTZ6en80fFWA==
X-Received: by 2002:a67:b919:: with SMTP id q25mr31366076vsn.17.1622037384616;
        Wed, 26 May 2021 06:56:24 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.6])
        by smtp.gmail.com with ESMTPSA id b26sm2113090vsh.23.2021.05.26.06.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 06:56:24 -0700 (PDT)
Subject: Re: [PATCH v2] nfc: st-nci: remove unnecessary labels
To:     samirweng1979 <samirweng1979@163.com>, davem@davemloft.net
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
References: <20210526011624.11204-1-samirweng1979@163.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <dcb14fe3-4907-43f6-d79f-27599f1be249@canonical.com>
Date:   Wed, 26 May 2021 09:56:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210526011624.11204-1-samirweng1979@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/05/2021 21:16, samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> Some labels are only used once, so we delete them and use the
> return statement instead of the goto statement.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> ---
>  drivers/nfc/st-nci/vendor_cmds.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Best regards,
Krzysztof
