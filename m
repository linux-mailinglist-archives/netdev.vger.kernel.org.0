Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953844F1668
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358707AbiDDNtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358512AbiDDNsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:48:41 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BB03E5DC
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 06:46:45 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bg10so20086373ejb.4
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 06:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vfQJmcM0qrYi49vcCG2B2KxC0x5r/jsGZIFrh4niQZc=;
        b=sfdjINLCI7yuAvcOi9KAnb6V86j9QN3KifvcftXLDut+PGBdMIQThW4FvRrmxJqLmd
         QFcTxZRQ3/UbrId+SsClV+HVS1KzpmLCM2iKMQm+JCVEAxQeVapEVO9WQ+rT8ObVNev7
         KfCdHN00ZjbcQy9yqhVrf3I2SJ/F+dmwz3zIFy0oqzrcW71CB/ivFoNuFmhqUffhA/tF
         RSYMJEB6NKp33l3dBxF5Sj1vhQ7Ooe9UViHI7cN2Aihf9Jxvww4j0ktZo9tacyj/mqbn
         p0hwt93y85vKyrVBkxArcMZb04g9v7UAG9oFrpm5lZHdMCgdetLR7WnUUFPuG30IBR7W
         Ye7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vfQJmcM0qrYi49vcCG2B2KxC0x5r/jsGZIFrh4niQZc=;
        b=2LDjDzSKNKR6/x8C2l6r/8FJmK6cBazhJj8k1ZwU9c5iq3z7VKiA0NOJysSAjfyq3V
         Z2bT1lBdTg87P0SbSURhzA5hrT7qn2MVY+arEiPHvTeHSN9SJyyCpVWLUJ54RYEyFONt
         qeXqkVD4I5s8Gbdu8xO4rXgUO4NgtUei744f8bACln3SRlypAsg0TcTgU7pSHAnu25ah
         3mQgzT+j1+WG755zLZ7bKvpDzlbI1WN8Bi/+NMqXjnIx3C5q/Y4D/j7Ig37/GXPfYvB2
         sRxppMrMvLKz0iGCaxBTEuA+c3bybH2cwemWbje7/XHeZ26lnSAXe101YSHlgIxqQS8W
         CaWg==
X-Gm-Message-State: AOAM531YMEGYiMZknEdJGrRvaPYZ8AMhqs54Fa8aqdPbaTRPVKz6HvA1
        HsytkSDV13eLh+SRs74NIQu6cQ==
X-Google-Smtp-Source: ABdhPJz/Fl/ycPt27uPD1jfBCnT7L/KvY41FuL5OomKqLLI6JcbOroETTemTgVbLNByEEPw/1Ty4xQ==
X-Received: by 2002:a17:907:6d11:b0:6df:f38b:b698 with SMTP id sa17-20020a1709076d1100b006dff38bb698mr48232ejc.711.1649079999583;
        Mon, 04 Apr 2022 06:46:39 -0700 (PDT)
Received: from [192.168.0.176] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id ke11-20020a17090798eb00b006e7fbf53398sm697669ejc.129.2022.04.04.06.46.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 06:46:39 -0700 (PDT)
Message-ID: <d470dd28-8084-2cda-10b4-006bb90c552a@linaro.org>
Date:   Mon, 4 Apr 2022 15:46:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 0/2] MAINTAINERS/dt-bindings: changes to my emails
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org
Cc:     Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
References: <20220330074016.12896-1-krzysztof.kozlowski@linaro.org>
 <164907989905.809631.16161802401962719876.b4-ty@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <164907989905.809631.16161802401962719876.b4-ty@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/04/2022 15:45, Krzysztof Kozlowski wrote:
> On Wed, 30 Mar 2022 09:40:14 +0200, Krzysztof Kozlowski wrote:
>> From: Krzysztof Kozlowski <krzk@kernel.org>
>>
>> Hi,
>>
>> I can take both patches via my Samsung SoC tree, if that's ok.
>>
>> Best regards,
>> Krzysztof
>>
>> [...]
> 
> Applied, thanks!

Applied to fixes, as Rob asked for.


Best regards,
Krzysztof
