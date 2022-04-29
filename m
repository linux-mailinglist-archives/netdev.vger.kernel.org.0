Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A5551434E
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 09:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355181AbiD2Hdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 03:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345193AbiD2Hdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 03:33:36 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D4B388F
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 00:30:18 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id y3so13736363ejo.12
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 00:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JCaCl/ii5hJZDEi4S5k0LHa9uAnkQqqgZzG+NgNS+m4=;
        b=c5bZlPiQMCkfzlKqVDm77gHjAT7wocnL/6GwcsuyROS0EUlmNVGKzzbQA5z6leD7Zi
         NIChzlAK3KitGUPrklro3Tzedt+6/2T0EMbAshQILAgoxwfY+wYgz7kpNtvkoyHZIdwL
         3cavGwnLOBUzEQl4SS+2BXWfDqbCr6wLciJI7ZQ3iNy4gon86a4UPSfRvgsWJXyhmfbB
         Hnlifw9k0EgjYfUrpsNx4IJOYOzqHs0JGG06mpKSRGqD6c7v26j6QiLt7IzT31Lg4XR5
         jox4PZC3lYozHefyKk1/0E6O7q8f5lRcdV69NMh1P5q1NbYGpLT8D+FYnqyXs2AR0XNB
         pJJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JCaCl/ii5hJZDEi4S5k0LHa9uAnkQqqgZzG+NgNS+m4=;
        b=SvNTikD9sgWia+RtM6J0TbSRB6yw4lpg3o3SPK3+l9o/SdamNRT9P3cyy1lCCT8Fs5
         7tHxohoqGvEs4Izfn3Ki1IAn0/eZ5vJxs+byOBGpdfTxVT4ygEL7jSaOrMInXE7kWDuL
         2hPY4VccE4BQvI9IMRWJ2XdVZQhzyWq5tvwnSpw+yExTqgOMnxTRcl1+eCkUG2LKOIqp
         zqCiK5rlYzUm2e6LfCWtWx/Bw5eHx1zaaPyr7Iisq/EbpRKyqR5HUkokY3MB3Mq+welm
         2/FRa/iYwB4c9t9yIzHQxmB/va8HJtZjr6U86dBxXrbI86mqXSVrDB+5rRkbg6rR1E4i
         e+UQ==
X-Gm-Message-State: AOAM532Dsi77FmACFOMseCFcKqMvQFwZHQauklFPrMZ7LG1DrLjC9l2x
        JG4x5rG2thLseLnhrWmHhEc17HonfQQ2RA==
X-Google-Smtp-Source: ABdhPJzNas25oPwivazkWKxPEhqwdRLHyF+hNe4pfYgdaHvmcf+3BVXH3rWskERonv9LqKbl5VEC3w==
X-Received: by 2002:a17:907:7248:b0:6f3:6e33:cd8e with SMTP id ds8-20020a170907724800b006f36e33cd8emr29286201ejc.198.1651217416969;
        Fri, 29 Apr 2022 00:30:16 -0700 (PDT)
Received: from [192.168.0.169] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id u5-20020a056402064500b0042617ba63a0sm2659283edx.42.2022.04.29.00.30.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 00:30:16 -0700 (PDT)
Message-ID: <8439cce0-72c4-c029-6cef-1df67950393c@linaro.org>
Date:   Fri, 29 Apr 2022 09:30:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] NFC: Add error mapping for Directed Advertising
 DISCOVERY_TEAR_DOWN
Content-Language: en-US
To:     Meng Tang <tangmeng@uniontech.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220429015640.32537-1-tangmeng@uniontech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220429015640.32537-1-tangmeng@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2022 03:56, Meng Tang wrote:
> When a DISCOVERY_TEAR_DOWN occurs. Since the operation is analogous
> to conventional connection creation map this to the usual ENOLINK
> error.
> 
> Signed-off-by: Meng Tang <tangmeng@uniontech.com>
> ---
>  net/nfc/nci/lib.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/nfc/nci/lib.c b/net/nfc/nci/lib.c
> index 473323f8067b..873854c5d180 100644
> --- a/net/nfc/nci/lib.c
> +++ b/net/nfc/nci/lib.c
> @@ -57,6 +57,9 @@ int nci_to_errno(__u8 code)
>  	case NCI_STATUS_NFCEE_INTERFACE_ACTIVATION_FAILED:
>  		return -ECONNREFUSED;
>  
> +	case  NCI_STATUS_DISCOVERY_TEAR_DOWN:

This define is not used. At least I could not find it, so maybe instead
it should be entirely dropped.


Best regards,
Krzysztof
