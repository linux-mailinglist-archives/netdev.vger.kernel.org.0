Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC781574B0A
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 12:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbiGNKqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 06:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238449AbiGNKqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 06:46:00 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2647453D16
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:45:59 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id bn33so1651835ljb.13
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xKqR0FW84/9+NW1iMNlSYSBMe00t6GL0Fr0lVNN1QJg=;
        b=RRzW+U2SyCxJYMSQpmw0Ceda3JSDmQG0VnKypfT2/CnW65baSsZ5BJB0f6/6vuIOeB
         x3rG1OG+f4f1LrcbkVeYtfNKRuZDhFWJhhPCZSutTDuR6n9G3XuO8i9/OMy+KZk6xvQO
         iSdJfmqvsB+eh3CoNGNGXGNXKgQP4ncePzhp7jlfMhrzPvdF+Zfl38FIkCEkOXUx+F7i
         9zhhXKreZ8ku0RERbzdiyiOA/z5uzZV13xvuJvel/+xMlab6eJfVIivddi27qlRN5xkh
         WO0AeTFoSHtGwYSczB3uBQYWpYnmJE7U3HGXdsQK5UvicBcyDqOJOFW3We9OyjSCEOE+
         kPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xKqR0FW84/9+NW1iMNlSYSBMe00t6GL0Fr0lVNN1QJg=;
        b=ust2uLyFxZ4YVhF7D/54vdMEfOTZcrCmK33sx842btDccg15SHu0DpjkqvYgpD8crU
         Bip1n6yj39ttbTyJiruoLkRCf8I5Tkfc/m26zVEMv72rU9Aaepnk+Vila/w7C3FUZuta
         Zr9aXMv3Gx0t2tz4ntxzKZ/IRxkBHMo3dZutZlMbdQO9TMziBcH4jeMrd/XWY7icc64c
         LlnCH+evyUXhS/Bu69gbWYHu6my4CeZAzFJK7MYsO/jE6VXVjYTdtYN9TRSoYPIZ0NUr
         VmMY0u68RuAdeix0A23L1IA14En0K6nnS9In1xsr5Dps70zDKl4P3RSDTb+0c1KsYEt+
         Ggkw==
X-Gm-Message-State: AJIora/WaVwPdQTumt7EZMpmJVV95u3afkfmS0Y5ON5lSHB0b4Vo0Miu
        MkhpX0hbwghoaymuAHgoUrXcnz34fhgeNg==
X-Google-Smtp-Source: AGRyM1vvbcUEPvueAQS7ThaZipg6klecM8/8S5oPfzvcfSzlfkSt7U7OZ3hrAd+Z3nRXH0ypBljh5w==
X-Received: by 2002:a2e:b165:0:b0:25d:8663:4dc8 with SMTP id a5-20020a2eb165000000b0025d86634dc8mr4208649ljm.87.1657795557533;
        Thu, 14 Jul 2022 03:45:57 -0700 (PDT)
Received: from [10.0.0.8] (fwa5da9-171.bb.online.no. [88.93.169.171])
        by smtp.gmail.com with ESMTPSA id 27-20020ac25f5b000000b0047255d210e4sm295643lfz.19.2022.07.14.03.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 03:45:57 -0700 (PDT)
Message-ID: <f2a29c57-be8c-88c2-1c75-f6e5d1164b8f@linaro.org>
Date:   Thu, 14 Jul 2022 12:45:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH net-next 2/9] dt-bindings: net: Expand pcs-handle to
 an array
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-3-sean.anderson@seco.com>
 <ecaf9d0f-6ddb-5842-790e-3d5ee80e2a77@linaro.org>
 <fdd34075-4e5e-a617-696d-15c5ac6e9bfe@seco.com>
 <d84899e7-06f7-1a20-964f-90b6f0ff96fd@linaro.org>
 <Ys2aeRBGGv6ajMZ5@shell.armlinux.org.uk>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <Ys2aeRBGGv6ajMZ5@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/07/2022 17:59, Russell King (Oracle) wrote:
>> However before implementing this, please wait for more feedback. Maybe
>> Rob or net folks will have different opinions.
> 
> We decided on "pcs-handle" for PCS for several drivers, to be consistent
> with the situation for network PHYs (which are "phy-handle", settled on
> after we also had "phy" and "phy-device" and decided to deprecate these
> two.
> 
> Surely we should have consistency within the net code - so either "phy"
> and "pcs" or "phy-handle" and "pcs-handle" but not a mixture of both?

True. Then the new property should be "pcs-handle-names"?

Best regards,
Krzysztof
