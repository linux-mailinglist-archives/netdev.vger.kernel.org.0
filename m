Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23BD2E6EDD
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 09:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgL2IRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 03:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgL2IRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 03:17:51 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A0AC0613D6;
        Tue, 29 Dec 2020 00:17:11 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id 23so29087878lfg.10;
        Tue, 29 Dec 2020 00:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8yoRVgdzslZ2s5VNKQ7c0EICKigH3eQ9ghrStUXwk4g=;
        b=NAXzB5SEXKT2bdZhaJkeCOkkfpKiPGJBBASxeYQOSpuat0xf42fmQCDnSwxSBPCWrh
         2jFqaAMVDjwhpqvLkqvaAHUjh1AKm0Y6j3+PWZMuoVRtshT8nnuNM3EVkQCFTdQbo5/k
         k2TkqTCZfQfb0nVfkP+r0Tbq2K9Wzc0l+NdO9x1GS+HfUFW/WCJzSSG/5cm51cubJrak
         jwLpgut8CURr+wpKmoAOwYaNa1KDQ7fMv4GFHmkkW3d5tgRL0jER429lsliDYUG7B9Fh
         A3lTxYrbbrA8C7qGq4PAZ3U3PrvXW4K4dIdS6wCCXu1Tndl3KPSpMIjumF+l6pGv3Ahc
         hYzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8yoRVgdzslZ2s5VNKQ7c0EICKigH3eQ9ghrStUXwk4g=;
        b=a4x0iYhvLQWm1PU2aF69o4K94pxIEP8xueIeUQ94i4F1HJO1ZTFDklUfYc1GGDaR9a
         z5vQmCWgSZ4EgqmkwTx3+JGStLYshKQKYkMY6heAScwXR5v2mC1lM7myPZ91SJLF2EVu
         KAEFtiKAiMrYmZXVgvGVz1CGyZ8ppi+MPbcPMvok6ZTs3A/dhjLQ1UUoyK0496RiMmiL
         nq32WXaP3bjIMiPTQfmwLN1nd3MMPUQFgD6k05DNrurzS7fEQq6VImmOaGhFvgrgdnGM
         65rrXY8fPlLtelwg8DwHdvFpMT7cEw3sl5AP2tjcY3ti7QZl6ubMT+EPaiu0mimOyZ7G
         Fbkw==
X-Gm-Message-State: AOAM53272ZsMdStBke1kNsJ/FN0oRYdPKD7heOpyPWIS6doni/GLszF/
        60reyDokhxp1NTCZjF3pVedE4ujv+I4=
X-Google-Smtp-Source: ABdhPJwI4Qk5tmYMi5kKb5Z0GK99s9dL1UCkByjF5rAXM5cHmVOfPpXmRZYHrusB374Mi/s3hM8iwQ==
X-Received: by 2002:a19:9d8:: with SMTP id 207mr20532632lfj.581.1609229829361;
        Tue, 29 Dec 2020 00:17:09 -0800 (PST)
Received: from [192.168.1.100] ([178.176.78.246])
        by smtp.gmail.com with ESMTPSA id u14sm6875979ljo.72.2020.12.29.00.17.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Dec 2020 00:17:08 -0800 (PST)
Subject: Re: [PATCH 1/4] dt-bindings: net: renesas,etheravb: Add additional
 clocks
To:     Adam Ford <aford173@gmail.com>, linux-renesas-soc@vger.kernel.org
Cc:     aford@beaconembedded.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201228213121.2331449-1-aford173@gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <7b271d36-3178-0338-7bfb-558115cb2516@gmail.com>
Date:   Tue, 29 Dec 2020 11:17:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201228213121.2331449-1-aford173@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 29.12.2020 0:31, Adam Ford wrote:

> The AVB driver assumes there is an external clock, but it could
> be driven by an external clock.

     Driver can be driven by external clock? :-)

> In order to enable a programmable
> clock, it needs to be added to the clocks list and enabled in the
> driver.  Since there currently only one clock, there is no
                       ^ is
> clock-names list either.
> 
> Update bindings to add the additional optional clock, and explicitly
> name both of them.
> 
> Signed-off-by: Adam Ford <aford173@gmail.com>
[...]

MBR, Sergei
