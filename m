Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEC3407EE3
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 19:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbhILRQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 13:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhILRQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 13:16:52 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A36C061574
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 10:15:38 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id y3-20020a4ab403000000b00290e2a52c71so2567779oon.2
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 10:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t5Z2zN6lvch9uxMkhwTFZ/jJJj9yF4sotHrirTL5YDY=;
        b=ikl6i9DgUrXkhs4RkoUN7OcwyFyRnAx9JlPz86DGsyML5pLg8yVuhoB5tKL5rpQxTG
         ftLveSL52ScWeM9cTlh9kZH1mtNpwiaif/HZo8xjXITOREtNqAbfVwiULVU8XVUw5jOW
         Qzl4COTsTtUduKwnmgKP2MvlIJ8sZLbhb5jN1oC84orQxrmqrDyFqglfclXHowRsIdMe
         pIRrzvHQmz5H3D1YsMiZmfWq5C53ky51ewQXL5oGDpvyrDrYHnka2lkoURZiTf6T4nQG
         RnVeLeDGW/KpXvYoqhKh+qBWlS6wUI0Afbspjs3NJ2/Xip4hzlGMMWvVQ7smtDGv+YVK
         edyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t5Z2zN6lvch9uxMkhwTFZ/jJJj9yF4sotHrirTL5YDY=;
        b=rAPaHc8WlrTyTsRnmOFknv4GuWF/XqQSZ5ADa//ek6rDwtp0bNxoEcuCWGEkLgPy8D
         ObCa4AC7qvBvWP53KIWg/9JXW1gHHU0S2a5R3oitPaQ75QwfcrRaEO+JHqoQbmTpnTcT
         gN4Z2uKcfIDKmCGHVcz3Ud/tHfctzFWRPpaZSczfZ9e9xWjDW2/ozIa/dubUotZuuVEK
         EP200HbrQYHsbfX+AcnxShKc4Pk/t15DEQtyjLhk4svEYlTmXFeCKbxRC56RpkgsQPVm
         9OLs5qpBjngIchORbpsIVdyG2T2gh1+iHkMfw9goREG1SYve6S859cSbDRp3aNWRikfd
         88Bw==
X-Gm-Message-State: AOAM530Aqz0xw55bEsbtHgvLCGZ7SbTZF7fmTqBkaTSuM1Jwvj/yKmnp
        7T4VFJyFRyeARuOTzCyii2A=
X-Google-Smtp-Source: ABdhPJz777w58ujzZ4YrbW7ooL6Qkicg38wQPoesnNQDm2azalyLzfnWJLLd48ri1ZZJK5weINonQA==
X-Received: by 2002:a4a:d814:: with SMTP id f20mr6111701oov.51.1631466937689;
        Sun, 12 Sep 2021 10:15:37 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id y24sm1272449oto.40.2021.09.12.10.15.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 10:15:37 -0700 (PDT)
Subject: Re: [PATCH iproute2] man: ip-macsec: fix gcm-aes-256 formatting issue
To:     Lennert Buytenhek <buytenh@wantstofly.org>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org,
        Pete Morici <pmorici@dev295.com>
References: <YTUOTGy8vaj45bBA@wantstofly.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0a61fee0-9648-a35d-ed63-28b0c62604e3@gmail.com>
Date:   Sun, 12 Sep 2021 11:15:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YTUOTGy8vaj45bBA@wantstofly.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/5/21 12:37 PM, Lennert Buytenhek wrote:
> The 'ip link add' invocation template at the top of the ip-macsec man
> page formats with a pair of extra double quotes:
> 
>    ip  link  add  link DEVICE name NAME type macsec [ [ address <lladdr> ]
>    port PORT | sci <u64> ]  [  cipher  {  default  |  gcm-aes-128  |  gcm-
>    aes-256"}][" icvlen ICVLEN ] [ encrypt { on | off } ] [ send_sci { on |
> 
> This is due to missing whitespace around the gcm-aes-256 identifier
> in the source file.
> 
> Fixes: b16f525323357 ("Add support for configuring MACsec gcm-aes-256 cipher type.")
> Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
> ---
>  man/man8/ip-macsec.8 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

applied. Thank you

