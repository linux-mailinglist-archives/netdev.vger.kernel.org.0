Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D712E6EE8
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 09:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgL2IXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 03:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgL2IXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 03:23:16 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C48C0613D6;
        Tue, 29 Dec 2020 00:22:36 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id 23so29112608lfg.10;
        Tue, 29 Dec 2020 00:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OheNXD0wgSbqafLbNMTZFOg48uYf1GKU5jktV12cxNs=;
        b=ot6ULxg5Zdhx3YVdR8VT0mECT8K8Qyuef1L2VQolfxpzBteg6Bh8D5t2jpZIxacxOe
         H6MV+2N0sMrn46ik3kwceKd+2XjO7tO836EBq1eAnOVK7iPj2ZUxRRkdb9jC2uynn5pQ
         xA7rfVxVYiQ5fHgkjxNRQrAKFq7P2x2Jq8v65xXHVrSiGkMkFRfJPQOgfVBo86fmsqhn
         cknvF/y9miYT6lDm/xCkAJd5GKoc9MCwRoiEGT+8ZuRTOSg2w+qgfj5aDoADA9NvcGKE
         dqcyT0PqnBIRmzaM/gOlN8shegqXIK6hAcfjCFTuc/HAiBqTWF2LOW7BdGVxnfOj9RE9
         RU2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=OheNXD0wgSbqafLbNMTZFOg48uYf1GKU5jktV12cxNs=;
        b=beLkYVTPzyI74w6uzlkoUsmHudKC6ZN9jl6JlIoVhz9zV8oa/+geeWX8rONGY0aL+C
         aCwhQMA0AXWOs+LNhbjBPt1c/qefknLDnp5vgy2liVVoBCTES2eYqozEK2LR7hy8NEYr
         xYJgCRTkoHjZRs/qDfkQzCaJWn8utJW6SScbvSV6gECdnT93e+k4p21MajhEamKJH5o/
         ltjy9fIvlkY0qpPPbkLztO+h18iWGUFgBrEo6awsNsHnDmb+2Qsojt/8AYONqIzJwjBX
         kcqM92bOhywsp++2K+/rSCvA/59GntUYkhEpCalOlc6wouKhYt354LqF02TG+Wm4zUMc
         gUxA==
X-Gm-Message-State: AOAM530j27zUCJfBOrsM1tPGERnKyHOGocrRtMjaoMzzpMfvfrCerpIH
        Wybj8pUbBGvwp0w2xO43KwTL54ZmtyI=
X-Google-Smtp-Source: ABdhPJxfob/vyRWa1EHOk0zaw3j92ax5KEHgynTtQ1/LWvCvASh4UHxvTfq3IQbn3sedT8Zat8xbGQ==
X-Received: by 2002:a19:675d:: with SMTP id e29mr19342796lfj.491.1609230154337;
        Tue, 29 Dec 2020 00:22:34 -0800 (PST)
Received: from [192.168.1.100] ([178.176.78.246])
        by smtp.gmail.com with ESMTPSA id d12sm6744083ljl.111.2020.12.29.00.22.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Dec 2020 00:22:34 -0800 (PST)
Subject: Re: [PATCH 4/4] net: ethernet: ravb: Name the AVB functional clock
 fck
To:     Adam Ford <aford173@gmail.com>, linux-renesas-soc@vger.kernel.org
Cc:     aford@beaconembedded.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201228213121.2331449-1-aford173@gmail.com>
 <20201228213121.2331449-4-aford173@gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <06bd46f2-d57a-a1f8-95e8-d8942fced217@gmail.com>
Date:   Tue, 29 Dec 2020 11:22:27 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201228213121.2331449-4-aford173@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.12.2020 0:31, Adam Ford wrote:

> The bindings have been updated to support two clocks, but the
> original clock now requires the name fck to distinguish it
> from the other.
> 
> Signed-off-by: Adam Ford <aford173@gmail.com>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

MBR, Sergei
