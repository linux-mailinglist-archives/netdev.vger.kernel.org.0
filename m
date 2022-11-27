Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B40639D31
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 22:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiK0VP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 16:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiK0VPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 16:15:23 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303CBBC8B
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 13:15:22 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id r12so14667178lfp.1
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 13:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xMfZ7ojzEusZSXOR1+4lvLHDxR9DG6QpHq+z2MT/mFo=;
        b=xjEG5ymX6soPm4/RckNuDvvkf2RtsoVsi0vqpsP0yCJRBDIFRaaksS2wAx/gfPr8Uc
         ndJuBLLmLHbk5gSWzZZ6sfvK32WD7j+VI3gMZrdapz6rLNkK+6bYYdd69BsGlAay0Ujk
         x5gZu0g98SfMRWr9Wgc3ZTk0r5+iLz87/gi7AyUDLVAd1T5ZZuFkwecykVJARdxTYs9D
         YPZYEQNfYaqOHQawnAH8NZIBixcAbHkSzWnz/jKHE/JIvd8OCadeWGv5eCLOwEnqn8vi
         N5nnNy05XHb0zRFkThjhlSbGwl8KQz6bUmTWaEv8AIi3QhY/+Odu6hZ2r752i/di3jEj
         fIqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xMfZ7ojzEusZSXOR1+4lvLHDxR9DG6QpHq+z2MT/mFo=;
        b=OMkYmFjY9/UUTpLJ2Na+JfqxMQIOLBxlclIY+0MMyQCUexmLR1dVOzoENFIX7TcXso
         f/+Fz2OGgrtS6SMEXhcfoaJm9weVuq8PWGHFQ5L7ENfK0Jl5u20RZdkiApLqqrqxvrOK
         iAJwgmwI0ZvEjxQPi7qr2E4233NsjHsgO6zFii6/KeINlyZ06JV20UPTQilW15njrnDE
         RIrDTfFdeeu0s86fzlFO5icmC9LfDeZAFG3u8d3x1bVFPuVH+i9xAwf8nidozvnNXMV5
         GPJ19OmIS8T4x/JvDDOSZ9AQgVXIicAtv4aektjrRAemDBxpMnqz9rzkxwOndTsk/pH8
         QDaw==
X-Gm-Message-State: ANoB5pksCfrtYSUhnKlLkO9wAalStE8h6APOM+i9KtgHJX3+z4pUk5hW
        g5XXFEmF14xPRTZC2ogux04u1g==
X-Google-Smtp-Source: AA0mqf4x1iSF+BS5FUF+PRtHJp/BUnje4H5BmmpwQhj0HY0pf7BnAAnNlJfsqzE/ove2zGOv/18oRw==
X-Received: by 2002:a19:f010:0:b0:4a2:2e81:9be5 with SMTP id p16-20020a19f010000000b004a22e819be5mr16932099lfc.486.1669583720587;
        Sun, 27 Nov 2022 13:15:20 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id c13-20020a2e9d8d000000b0026dd4be2290sm1044112ljj.90.2022.11.27.13.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Nov 2022 13:15:20 -0800 (PST)
Message-ID: <9ec77e6e-55c0-4331-ad62-9ab001273652@linaro.org>
Date:   Sun, 27 Nov 2022 22:15:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v2 1/7] Revert "dt-bindings: marvell,prestera:
 Add description for device-tree bindings"
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Marcin Wojtas <mw@semihalf.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Rob Herring <robh@kernel.org>
References: <20221124111556.264647-1-miquel.raynal@bootlin.com>
 <20221124111556.264647-2-miquel.raynal@bootlin.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221124111556.264647-2-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/11/2022 12:15, Miquel Raynal wrote:
> This reverts commit 40acc05271abc2852c32622edbebd75698736b9b.
> 
> marvell,prestera.txt is an old file describing the old Alleycat3
> standalone switches. The commit mentioned above actually hacked these
> bindings to add support for a device tree property for a more modern
> version of the IP connected over PCI, using only the generic compatible
> in order to retrieve the device node from the prestera driver to read
> one static property.
> 
> The problematic property discussed here is "base-mac-provider". The
> original intent was to point to a nvmem device which could produce the
> relevant nvmem-cell. This property has never been acked by DT
> maintainers and fails all the layering that has been brought with the nvmem

It's funnier - it was never sent to DT maintainers nor to the
devicetree@ list. :(

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

