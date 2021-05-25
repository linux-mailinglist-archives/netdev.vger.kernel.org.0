Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6EF39003B
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 13:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhEYLoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 07:44:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48874 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbhEYLoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 07:44:08 -0400
Received: from mail-ua1-f72.google.com ([209.85.222.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1llVSF-0006jX-T5
        for netdev@vger.kernel.org; Tue, 25 May 2021 11:42:35 +0000
Received: by mail-ua1-f72.google.com with SMTP id d30-20020ab007de0000b029020e2f98646dso12917018uaf.5
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 04:42:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VXjoVJRWk5TrrriWnFtDbtKUT3FPojwGMjJKb1jQu0A=;
        b=a6AZobFWoW/6fzHB0ADRUeLGqHbry/H8YRRVBezlR72MDPWTcehxDWSuo5bIsdcL/H
         Jq9bRExVAxX2oJFDapdcf0e5n/nZRZLDPPq+oRSAUyAnRNRgEy2+FWRapS6dqqpekfM7
         hISsr7rNTjJx/gyMIGwOf0GI47LrxYRPPn8UJB2rZE73kBz9pDfMg5Z4mUpL2n+La6Dp
         04MfnLzOf2j/vdjnhD4D+Up+n4k966AHah5P59chnPJsNgSrX6HlaPGv4IGvYZATgnT6
         tdN2OdNg/XVVKm9/gq0qyHA3p/8mTqE9NcNt6pzF+PNBHWT848/cHFdoa3zCgujS4nvn
         twlg==
X-Gm-Message-State: AOAM531RPdLIMyMenTRDwDXiaNbfRHW9rmhKn+6bkRjtPtFilW+ArujQ
        1tQS+tV6dPQUUh1KtIvOnGNXMMG4ymEULieWRW53Gjy3+1evVjmyfoIMsBWKYSeRUQ0DxQVMeUA
        YzgHQf2gQyt0itmNCFrH5jNY1+Axai4N4zQ==
X-Received: by 2002:a67:386:: with SMTP id 128mr25118097vsd.16.1621942955041;
        Tue, 25 May 2021 04:42:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhH2Oy6U2MwqDvTIgHPfHj+dUj4sa4mqqqYZABnajBnsS6pfEVpV2mlZePB62r/vU58NqBIQ==
X-Received: by 2002:a67:386:: with SMTP id 128mr25118092vsd.16.1621942954888;
        Tue, 25 May 2021 04:42:34 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.1])
        by smtp.gmail.com with ESMTPSA id b26sm1555470vsh.23.2021.05.25.04.42.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 04:42:34 -0700 (PDT)
Subject: Re: [PATCH] nfc: st-nci: remove unnecessary labels
To:     samirweng1979 <samirweng1979@163.com>, davem@davemloft.net
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
References: <20210525031254.12196-1-samirweng1979@163.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <93e67699-a0c4-7fe7-6c38-aeff68a3881f@canonical.com>
Date:   Tue, 25 May 2021 07:42:30 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210525031254.12196-1-samirweng1979@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/05/2021 23:12, samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> In some functions, use goto exit statement, which just return r.

This is not parseable. Imperative "use goto" suggest that it's the
change you make.

> and exit label only used once in each funciton, so we use return

Every sentence in English starts with capital letter. They however
cannto start with "and" because it joins two parts of sentences.

s/funciton/use the spellcheck please/

The code looks good, but please spend some time to make the description
understandable. You can also make it very short, to avoid complicated
sentences. Look for examples in Linux kernel how other people wrote it.


Best regards,
Krzysztof
