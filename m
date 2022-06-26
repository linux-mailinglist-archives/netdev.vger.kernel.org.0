Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682FD55B3ED
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 22:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiFZUBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 16:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiFZUBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 16:01:20 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820651159
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 13:01:19 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id cw10so14988264ejb.3
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 13:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/dHdhk9iSqnCzmK8wQDYGABZ8GvQS0ONofRd5NT5Ei4=;
        b=GgfhNWvWw7MYFIu+a9jPtPG2t0BzcvYNpIHFK72XmfTMDjXUeLDWa/QX9bm5Ivx1WQ
         9gBjCy5nNc95xBhXP2U5KgNYU6jHA0HCNzBTCZ+ER/Qo+Iw1/KsXoarIaZ1wLQVP6R72
         BfLjlvgS7wD2XzLcsXTPQ6Xk54ev7jsytuQA20iKSsgz5eW6s2cFUKG6iAvJ38K5vmVi
         BC1Z4JIgoUrlMCXDGsTdyt5YaeRensip/iZSaWdfS0qyquTL5dZi7Dqmxcd7vNOpYvr6
         beGJryK3qiK+wiK2pFaErPZq7XL/6q56xDCJ2agYXvmQ1GJCCXM+OA233kmc65Gxvrzw
         YwFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/dHdhk9iSqnCzmK8wQDYGABZ8GvQS0ONofRd5NT5Ei4=;
        b=YCeswFu30LE0UIpRsE+2xvBD98Ia6mzJRNQIT3pHtCTp6xTXElajZBSfFSD1e03UY7
         Y4BjtK6LXcSgCke+26aOmuxIfCK3vjWPjFt+b9Tk3r4pmfJYZnvZf57WzDsGlo3fxnEc
         dlpx5PNYO4Ss4HeH53EyAyzoh0yBXctgOyEscC4dAF3ub9Xo4m4lF0+HlejoFuvwbqpA
         wTmBLoT5cAZuAt7FMJCHvrZgLesFyRt2CtHdj2nrmslq1YpkfmUBAMgG+TdB24H6xFXx
         LhMIEn2rqGeN7ZwGL6OFmUGkFs5h6kTKNy41vfGJcuFTRLdoNNyZZrf932X3psB0S5be
         OuIQ==
X-Gm-Message-State: AJIora+YdnWqow1pnBNWiy286p0YAYngEF1md2BjK0Z+hJX17olQEq5C
        xtqmsQfQI14T8sVZKQZRpo4zaA==
X-Google-Smtp-Source: AGRyM1t9NeUDMF6za5hKlOFTVIoS0uVollNBtYIZoGH9DQtIvuLwltJirMTqp1+X3zUOea8cICce7g==
X-Received: by 2002:a17:907:1c0b:b0:711:cc52:2920 with SMTP id nc11-20020a1709071c0b00b00711cc522920mr9371914ejc.301.1656273678091;
        Sun, 26 Jun 2022 13:01:18 -0700 (PDT)
Received: from [192.168.0.245] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id q14-20020a1709066ace00b00722e603c39asm4182115ejs.31.2022.06.26.13.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jun 2022 13:01:17 -0700 (PDT)
Message-ID: <6f338cbb-9602-fe28-74ed-98bd8f110c6c@linaro.org>
Date:   Sun, 26 Jun 2022 22:01:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] MAINTAINERS: nfc: drop Charles Gorand from NXP-NCI
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org
References: <20220626200039.4062784-1-michael@walle.cc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220626200039.4062784-1-michael@walle.cc>
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

On 26/06/2022 22:00, Michael Walle wrote:
> Mails to Charles get an auto reply, that he is no longer working at
> Eff'Innov technologies. Drop the entry and mark the driver as orphaned.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
