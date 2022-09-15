Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4717D5BA1B5
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 22:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiIOUEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 16:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIOUEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 16:04:43 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A03D959B
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 13:04:42 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id a20so11838481qtw.10
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 13:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Rh0LZFvow1B/VQTabMmDXRFEjewa915+n9jDCWqsxNI=;
        b=f3VdQKlWyJFmet5M1PbdmUMADfRbETOWz+GkiJqIvNA5sLKVq/TTCf7FeRMvENEiFs
         WIv1VIyiEn0vehm/NI+Gh/hYhOUsJYdEG4a/NK7GMSzBwKxVJXsXc0hSprMj5zj+m162
         0xCDrgXG/7D3yRJSrNEN+IRD+XHy7KVAISBedU34g5xc4sa0v17+s1qxrjnroLmz4Ib1
         +hdEeCUJSB8atIennLbN/ccC9qa02/qjI0mmeQQfbcAAuxJuryeNzinmJ1VShqA5UGg4
         zqMmDn5eqCDtfnbj6YKtNLOnDpXZC4OUn72BlYwQ6aZi95z8wHGKkfFK0Esmz1y4ThGL
         7wsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Rh0LZFvow1B/VQTabMmDXRFEjewa915+n9jDCWqsxNI=;
        b=di7OpxjriPx8b3BZIAPHEhh1EmtrWBTFFHmXACFadcYa2Ot2Bru/r0K82WkPipIgcA
         PydcweLgq8khvQx7t/s/G2nnc42623XPeiayEG7VplT2/PdUxplFM/eBNz83opBfD1V3
         UG5/Z2HcRLOIsrb0je0XPSWGHXJmzb5o9T/35w+csfKBGCi8EWcwjxJGcvHIE6kx2cJA
         0VKoqcxztmsawewMGudd9c00eBUt6mFZweGHslxZnl4lldDxMTfx71PTB2mDCbkO0VAS
         yRmb81zOCycdxMMafqOap/u3tYzFMhCHWOhJepklO6C9YPAbFM7ULLwBiok5dMT4YJ6O
         6X9A==
X-Gm-Message-State: ACrzQf3suTbNTubVpm0JyzFYUQyk1IgkuZBP5z2OSm0nbrE+TF+1kBJD
        2ezLjNVQ0W49emtuLHHcmfM=
X-Google-Smtp-Source: AMsMyM6P5fL1MeOa3716lGIAe7nV2wYa3dAAuS4sKbGC8WDgcBH1MG7SpGPE1RT3ddViO0wxaYkNYQ==
X-Received: by 2002:a05:622a:1a21:b0:35c:4a24:e9ba with SMTP id f33-20020a05622a1a2100b0035c4a24e9bamr1567352qtb.622.1663272281485;
        Thu, 15 Sep 2022 13:04:41 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id de42-20020a05620a372a00b006b945519488sm4898199qkb.88.2022.09.15.13.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Sep 2022 13:04:40 -0700 (PDT)
Message-ID: <e6d346cb-06ae-6acb-c47b-38ab83087716@gmail.com>
Date:   Thu, 15 Sep 2022 13:04:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v12 1/6] net: dsa: mv88e6xxx: Add RMU enable for
 select switches.
Content-Language: en-US
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
References: <20220915143658.3377139-1-mattias.forsblad@gmail.com>
 <20220915143658.3377139-2-mattias.forsblad@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220915143658.3377139-2-mattias.forsblad@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/22 07:36, Mattias Forsblad wrote:
> Add RMU enable functionality for some Marvell SOHO switches.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
