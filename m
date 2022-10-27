Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0723C60F8DF
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbiJ0NSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235979AbiJ0NS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:18:28 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807EC8E9BB
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:18:27 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id hh9so1021449qtb.13
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p8HRX97UNjnxVgBS5sb2gwlQVmR3Rfqi4QFT7aLxAp8=;
        b=G+fHHuoEclB6ktgK5Fz+/I9mjHhDrXnhqXzrY76v3D/qLVYIs/uf/l+Pt31fZltxxr
         NIrxDhoXGlVPc6FyB/2pPFaavjvPjBPJbGW4HG80jsVe59fJObJjZ1HaJpMjEje3aZex
         YlzBLygOUv1PoO4u6pta29ps5wgkIu4Ol7Wz0JCy4gtBdv+Or+PO5ChWzorjR9nSBpPW
         F+7uegtQapGw/SgnmCGBJZwkFSSbjBfUwe4XM6RFUumjzexF0M9WI0E1PUSsyQSDvpeZ
         T2C2qE0Zh4hvTu2Nr9aoS+SJaSsIvNORyD8VGbYfqpsIXqk3GLVRhBqWqu0uJwhb6cD6
         CYVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p8HRX97UNjnxVgBS5sb2gwlQVmR3Rfqi4QFT7aLxAp8=;
        b=mXZ9coSKIK9d/rkSBU7xA/GwpZwwcCbjB70TumI8BcgIPsKCmzASV77kYEbvSrvBeo
         xxaO7zm+D4pRj/J91pfsjy1G1MlwEkLSZV9dZ2sm0gindteMRAF8LypYPZW+KUbaa3sZ
         3J/x8cKn/OSianwiJeUWVIeEARXrq/PWlZVHuibsfvSb3VgRjP7dWVFldaTiDJbXQDRF
         1V2UHCm5h0F8XIfyOFS9Ev+6lw6vzNxElp3vh9ZkcMTWMA5ub/CANj5ifGugj3hiURer
         NGYqvmAYAr+oOq2Fl2hJPujhtd+uUkfWrbjw46o5dXe3ZFjk4U1IiSB16HbHPD5dJMTh
         ztAQ==
X-Gm-Message-State: ACrzQf0UyuiGEFShoe6bpACCQl0WgV4thAhZ2sVvc/yWLhMT1pfKal4x
        yLz9v+O1ObnwKEXHnGcACP/seg==
X-Google-Smtp-Source: AMsMyM5u0dBib0JoY8XTTVnb9mEdepIp6NJHhMBv+ApptRYrDOk3nqILBuWDtRM9vT0wyllWBo5/NA==
X-Received: by 2002:ac8:5f52:0:b0:39c:cb1c:9310 with SMTP id y18-20020ac85f52000000b0039ccb1c9310mr41093121qta.177.1666876706632;
        Thu, 27 Oct 2022 06:18:26 -0700 (PDT)
Received: from [192.168.1.11] ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id w7-20020ac84d07000000b0039d02911555sm841430qtv.78.2022.10.27.06.18.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 06:18:26 -0700 (PDT)
Message-ID: <f143c59d-b24a-3ae5-d685-b1f61bf8b4f3@linaro.org>
Date:   Thu, 27 Oct 2022 09:18:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v2] nfc: s3fwrn5: use
 devm_clk_get_optional_enabled() helper
Content-Language: en-US
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Y1o0ahD+AisRA+Qk@google.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <Y1o0ahD+AisRA+Qk@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2022 03:34, Dmitry Torokhov wrote:
> Because we enable the clock immediately after acquiring it in probe,
> we can combine the 2 operations and use devm_clk_get_optional_enabled()
> helper.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

