Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938DC3135E2
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhBHPBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhBHPA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 10:00:59 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3DFC061786;
        Mon,  8 Feb 2021 07:00:18 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id i9so13509835wmq.1;
        Mon, 08 Feb 2021 07:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h8Cx/neO60Ocbq24OfI9K0XrTPhqeM971HOf5KAOHHk=;
        b=f67KrLymqfByXthVOZEWC+UgqfSgERAEOh93dgfWOdCMYvjYuaJ5YYG0yLhK6zN1Ux
         bQPqDnGzWT+GYKo7Ks9jobnZcKHbFd178tmyCvjGeuxKk0nvIsDGufLLmXl+pEkNmQ8+
         hOj6o8AJhN7gjAniRMImHClkYpRPsr8cTQ1//1Q2Z4iDDDv10SF9Yu9Q5jun/EjceyYN
         jgw2UP1woocTVf//L2XWFRYJXN2Au9uNgoCNzxpjWgNCFdL77hv6I2x9ZHanguvDwrK4
         hLuCtUKm0MLR1RISlIT9jxyyKs8W02kOj4yfRZbMtG4EH1TnnhldWPCVQIiQkXrrdg7o
         Vkxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h8Cx/neO60Ocbq24OfI9K0XrTPhqeM971HOf5KAOHHk=;
        b=UO0jSDKnAK9EUot5QEgNaTCNLuItYFKUvbQiJzY7vusaRU9Z0YuzfrbEaz+owRz1u6
         yZS8+SKRp9gJyy3VkkFgkPgGNyzzN3y12X9pV1pvgvfRoDqkLcCU34zw8jJhD0mDJfYb
         8AjAXJxik7zCPmV1dVajcRqSwpWjfRvqeA6kSsME54a27kKiewz4mCTUfvXjKN0y7FjI
         wk8dzQq3FEq2j+U0vljGV3VnT8MXn9Be7TpGHMSHP3uznBQBf99E1ANeJwEknK3anyHu
         hYpD/ujuq5QypIqs3B7MmdYoWDbXFYjMebKkOBCeKlwPnmxKzFotYh3qTJUHV7pWLZoY
         lWqg==
X-Gm-Message-State: AOAM531GaXW9ljrFwWXhaEbim32Oi7kd3AvqaN3O8W9QWWLGmKGfkHTg
        mq1ueDRCve+iKwKUWZfUNlw=
X-Google-Smtp-Source: ABdhPJz+wAjF91HZYk26zCEVfuRejFfN4IfiNIOwXt842af/wGajmxgzcs6tg+8nlksTpUyKxSBXgA==
X-Received: by 2002:a05:600c:4c11:: with SMTP id d17mr2941199wmp.86.1612796403609;
        Mon, 08 Feb 2021 07:00:03 -0800 (PST)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id b138sm20677258wmb.35.2021.02.08.07.00.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 07:00:02 -0800 (PST)
Subject: Re: [PATCH] drivers: net: ethernet: sun: Fix couple of spells in the
 file sunhme.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, rppt@kernel.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
References: <20210205124741.1397457-1-unixbhaskar@gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <4134afc4-31d6-1b49-9b73-195a6d559953@gmail.com>
Date:   Mon, 8 Feb 2021 15:00:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210205124741.1397457-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/02/2021 12:47, Bhaskar Chowdhury wrote:
> 
> 
> s/fuck/mess/
> s/fucking/soooo/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Right or wrong, these are not "spelling fixes".
Please do not misrepresent your patch in your Subject: line.
(Also, subsystem prefix should probably just be "net: sunhme:".)

-ed
