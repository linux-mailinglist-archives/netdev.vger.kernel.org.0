Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211EA66E4B4
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbjAQRTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbjAQRSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:18:43 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C13B4C6D3
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 09:17:19 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id q8so11026179wmo.5
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 09:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lXEyJ2X6rGfdOKW5qM0q38LFr2vC2nCxI1LiAbhcwlE=;
        b=mkrhw+EgBumeZa5W7IRyvBvt6Ds5avbeD1zVHrB85huZO27Bm0rtvhKogWdoWLXvKU
         CV9+OyaplC4a9OjTJuO0Cd3BXNWKggVAkejbbKiL/eny0WZ/ME59nesm/LQW5cDIw54A
         o3KuT5dfpDfHiExSvjbmjHu943vicXkFJvd7v/KwH0SCdTzRii8EVmA0bf/isc/oka2U
         Y/HNcofjLUWzUWA2dXuX9KtupRjPu1f9OGqp9L2Vn1xmtVjhBjwuxJg6YYkJjSUTFgzQ
         1J8hfnwwW+ZDhdpYaLrkU550/XMyR94+K5j0zfICxkjt7iYRD4MFVuA1PYDtl20ikhjf
         2anw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lXEyJ2X6rGfdOKW5qM0q38LFr2vC2nCxI1LiAbhcwlE=;
        b=IXeRhM3ouB2avIFJGCv9lnfEFvHr5bBnVg09A1zqGb4rH2UC0gYeHmuK4jC8QBcvBg
         GhvYudMST6iqIcahq2MkkrbQshlieaxpJGLE/cvNKHcFvKwp4GvuaoN/zl/vAz2EWWWC
         nqu786LGrYOx2nynmrdQyRSvOrqGvAfv+ylp9PGjS9dYXyEJ5imZqP8/DFDhbIum+G6g
         FeSM/Dv/b7tHGCTi/mONL0G66gcFT+RAzjQDedlDE2t4FQCCzYj7P8Db+zMTa/qb+4MB
         Cbre1WSfmvsedN1e7HgRiTCR2TJEiQvzEm8icDfSpKO8TagxauOU1OLU8wBo9xhU9lCA
         xUgg==
X-Gm-Message-State: AFqh2kq2wATps0Ch9mQQx2yap1uwJKibOv6Z4dGfu5CJC9jcKl+HugAN
        hkXjuthIWuHoirbx53zJmWTosA==
X-Google-Smtp-Source: AMrXdXurqfnbqcoIe8a16qGha8SHgdc+aYwzhZClZ8OTQiGYOiD8X3mOAeLbuMnFBYGbSn+9yIRh0g==
X-Received: by 2002:a05:600c:4e93:b0:3db:d3f:a91f with SMTP id f19-20020a05600c4e9300b003db0d3fa91fmr1468349wmq.23.1673975838219;
        Tue, 17 Jan 2023 09:17:18 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id k9-20020a05600c1c8900b003dafbd859a6sm7671033wms.43.2023.01.17.09.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 09:17:17 -0800 (PST)
Message-ID: <a3349dd8-6e1b-30bc-8247-5021f3733faf@linaro.org>
Date:   Tue, 17 Jan 2023 18:17:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v6 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss:
 Add J721e CPSW9G support
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux@armlinux.org.uk,
        vladimir.oltean@nxp.com, vigneshr@ti.com, nsekhar@ti.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
References: <20230104103432.1126403-1-s-vadapalli@ti.com>
 <20230104103432.1126403-2-s-vadapalli@ti.com>
 <CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/01/2023 14:45, Geert Uytterhoeven wrote:
> Hi Siddharth,
> 
> On Wed, Jan 4, 2023 at 11:37 AM Siddharth Vadapalli <s-vadapalli@ti.com> wrote:
>> Update bindings for TI K3 J721e SoC which contains 9 ports (8 external
>> ports) CPSW9G module and add compatible for it.
>>
>> Changes made:
>>     - Add new compatible ti,j721e-cpswxg-nuss for CPSW9G.
>>     - Extend pattern properties for new compatible.
>>     - Change maximum number of CPSW ports to 8 for new compatible.
>>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>> Reviewed-by: Rob Herring <robh@kernel.org>
> 
> Thanks for your patch, which is now commit c85b53e32c8ecfe6
> ("dt-bindings: net: ti: k3-am654-cpsw-nuss: Add J721e CPSW9G
> support") in net-next.
> 
> You forgot to document the presence of the new optional
> "serdes-phy" PHY.

I think we should start rejecting most of bindings without DTS, because
submitters really like to forget to make complete bindings. Having a DTS
with such undocumented property gives a bit bigger chance it will get an
attention. :(

Best regards,
Krzysztof

