Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEAD28253B
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 17:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgJCPz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 11:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgJCPz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 11:55:57 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B14C0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 08:55:56 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g18so805332pgd.5
        for <netdev@vger.kernel.org>; Sat, 03 Oct 2020 08:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F0oSqiqqBtEtjzZl4uORpE9uEuEb8qGZGut6L+oT/Mg=;
        b=btnx26RYTZI9MYyOg0Zl+Wpm49/3kjWnUMuG390hDvjVaB88GRy6KszxeCNkVJiD+3
         KH1ymNpv6QppZayRzOmml+podaP/sGMCYvyiasPgqb8FvP0s0+beyvRiaqFOJZ3ZsF/V
         WsPWpIoC1dfTbwCF4xMR9mgaQ8MsduWKL6FKwdVGwndfZkk4Fn6kKHE416FNLMnr/A/X
         Jv6VH/mGK9Jdy6R0Dp7udQq6Z9i071qAuN1Kqi5AhhKj0PabX/Py6znkYwCp/Y29wYyO
         ca/LzoocfT75e+yaNAJv31Op/UvmuKobHrxNCii5pXrb+DbZXHI7q6bGaweTTxUApFhP
         +3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F0oSqiqqBtEtjzZl4uORpE9uEuEb8qGZGut6L+oT/Mg=;
        b=B8ULNWOK0MHxkRi0UceYYL4ttHaPK2ROO502Fpv3dNVfd6SadJDWQDa49wQZnFZBGB
         3y5Vd7C0c8gSLpFfjMQ+YlHRMOwaLg4I5sl1yoDJwyZLDSdT3T6izHIsbwo7LsprqAKB
         0MNjdAFO/B2t+sHBMoJwz19TONgY3IKZMpkQBVvO7ybbVV+WMnPJPtfTPZxcL9reaICE
         uyZl8H4oDEl1giWgolZzGZOf4Rn4vlXsmbd529Lul4ikHyFWT9LRt0uirD1JBxZ7GxH5
         XCcI4zDxvOCfCLJf+7KHGqxJ+KgCgkzAHCnhv34YIAgB1cAZ4fGQfnTD48Rqn5Sv1Amb
         NNBQ==
X-Gm-Message-State: AOAM5319bPcbbFjuy7POyhta3fxS37tW6h3Id7qZ6OGHFPeRqW4qvWkT
        Q0p2hWqdvKLrNe2orIyTkQWCg9lVTE2GsA==
X-Google-Smtp-Source: ABdhPJzEfZUIaGpvM8Ku3CQi4wMZv9xVELRGGruAeFJrbX5osYoG8ZUZ2exw6U4PaZvH6hG5o8VjCw==
X-Received: by 2002:aa7:9409:0:b029:142:2501:3989 with SMTP id x9-20020aa794090000b029014225013989mr8320798pfo.78.1601740554908;
        Sat, 03 Oct 2020 08:55:54 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id r19sm5032763pjz.23.2020.10.03.08.55.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 08:55:54 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dsa: b53: Specify unit
 address in hex
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org
References: <20201003093051.7242-1-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1f2dd021-003b-4407-3f91-32973c402165@gmail.com>
Date:   Sat, 3 Oct 2020 08:55:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201003093051.7242-1-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/3/2020 2:30 AM, Kurt Kanzenbach wrote:
> The unit address should be 1e, because the unit address is supposed
> to be in hexadecimal.
> 
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
