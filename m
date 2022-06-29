Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5E955FBBD
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbiF2JVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiF2JVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:21:34 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1703B369CE
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:21:33 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id cf14so21304190edb.8
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pnMRKilWNlAu7873VFaFlK0hNBIHlTBOyKkOKC5rhcg=;
        b=RHgCCOWVYiUr4mFZYHlJl3xoQlwmsZleH4Rn+4lQHL85R+wedzxgBEXinM7ZKrpNxp
         S1J64FLsZQj11uL1G8rrUKj5ghgyZGUlWfyaknhgHYS19sokZlSbH+bTM2j0EbstjXVA
         7NmYWYAj8+hH51Lxp2/mXT1th0tyyI7tC+HvHe7s8BSD+c3NRr31vHNu03lBlDBljFEE
         VYjGfvEgvXBlvfBkxBGkJl4hjC6xfDlxa1oZdxGUt0DVXArRebuD+OYXrCRHoekuAb45
         ZHWHsk7lOMSKQKDhL3ZWuacU3f1NFVxqxX+1afaYYdfKxLnf+hVxeOaNUje9ncqkNKnn
         dMAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pnMRKilWNlAu7873VFaFlK0hNBIHlTBOyKkOKC5rhcg=;
        b=JClPLBaTNVBj1oUxYa4L+Blep/w34f3Oq5fzughMtDiRgZ3fy17+pEqP4hN0/PKS6W
         XWXM15SAw/yfSVpioMcZbUqVMypVAgHbf6KH1ieQwK1oxaZ/CWSiR3SD6ium5AKfaHCZ
         jb6rSazvztt3VwN6B+bjZLLoLqqBCHwgwIYK34tsn6MPLuINbW/w9Yq8vZM4Mxiv3It4
         GWs1NxVnYo07SsdV/Y4KQ4CGeeYVBpT1YB7+XQ2T/ZkxFhqBWDtOZPRHJ6NCVTfG9o+F
         TeidGDlfFRaOVxvR7oyb1CHwUjqaFKWRuf3RuPnWyC0HbnOcy53KewW52ejUZvEDEQg9
         9Lxg==
X-Gm-Message-State: AJIora/r8qztahyfc3L/4t/r2n0oyRmrx3x9HnGEZYEd9ZlPO4aQ1q0L
        XDiSum4sN+lVXpCSfTpYXWiYCZ9zd3gMDg==
X-Google-Smtp-Source: AGRyM1uhhoawHmkEy8UOafBQlOcWUDgmphxib0zUjuNZ/HcZ5Eu7QMkJt4f6rtk8lrnS8fgVD513fw==
X-Received: by 2002:a50:ce4a:0:b0:435:c543:87e8 with SMTP id k10-20020a50ce4a000000b00435c54387e8mr2886466edj.295.1656494491708;
        Wed, 29 Jun 2022 02:21:31 -0700 (PDT)
Received: from [192.168.0.183] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id i21-20020a508715000000b004357558a243sm11077558edb.55.2022.06.29.02.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 02:21:30 -0700 (PDT)
Message-ID: <33def8ba-2ca3-c2a3-57ff-9b20dbc2337c@linaro.org>
Date:   Wed, 29 Jun 2022 11:21:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 2/2] NFC: nxp-nci: don't print header length mismatch
 on i2c error
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>
Cc:     =?UTF-8?Q?Cl=c3=a9ment_Perrochaud?= <clement.perrochaud@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220627170643.98239-1-michael@walle.cc>
 <20220627170643.98239-2-michael@walle.cc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220627170643.98239-2-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/06/2022 19:06, Michael Walle wrote:
> Don't print a misleading header length mismatch error if the i2c call
> returns an error. Instead just return the error code without any error
> message.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> changes since v1:
>  - reworded commit message
>  - removed fixes tag
>  - removed nfc_err() call, as it is done elsewhere in this driver
>  - nxp_nci_i2c_fw_read() has the same issue. also handle it there
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
