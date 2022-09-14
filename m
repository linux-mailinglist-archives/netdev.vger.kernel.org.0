Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2685B8670
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 12:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiINKcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 06:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiINKcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 06:32:04 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4730C140A4;
        Wed, 14 Sep 2022 03:32:03 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id c2-20020a1c3502000000b003b2973dafb7so15179487wma.2;
        Wed, 14 Sep 2022 03:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=TixnnDkfAdwmVKKrUxcM3/TP+fbQLkVyvqytLP4yNv0=;
        b=mPvMeXrnTyNdlwd9H4I/hVX4LZfYGJBrKnCTzDtaCEZv0TTdMM+iIklvoIplBrljMn
         cjdoaz7tQUJSBhTqO86ge0Url/8o/FnAoZtyQrIf1/bvNCQUTsZfjpAX2Ff5gJz1jJBH
         eKkTa8aXfQAc6FqulskV1dGSAqihHOdbqVeVDHAf8nQBEB8D+hioVMlrKkr9la8fNaPq
         ig6oYDublxUaFUv+FVrbtbVkyCiu4YUnBNQAMm2liKz4aw9KtR9mR1RogM7lhTeiHO1t
         eM97U+Kc0+2EToYDL6ofeeYQ5Wq5e2x52elrVBWFXFa2SA8KcMOZnV+nREpjm0ZmY3A3
         To0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=TixnnDkfAdwmVKKrUxcM3/TP+fbQLkVyvqytLP4yNv0=;
        b=inXLZCoQvNQk4ww+vfPioAcuh5qFYLf9/z3DIBozSrAXjc+QdRsXxI27jjx1Hv93Zz
         yPjcXUAGCQMrt/tdvN1kiFYlqNn3sSPSDJ3Om8cE6HRa845zQr3YJKmE4lGr/d26UFAE
         CoC1Ai4sXSac4HP3i59Pcs+LiUqgqEsY8ypXzuDT7p0ox+3TuQrTJV8UW0MIByPjGtcH
         IjAchgHb2N3aI2OfSX0dvXdvLlqgDaGXxm+v81gQZd0vGVaBfW7jgtiqHZe0axq/1cPa
         faBopvEgMJ9quq5oDkiqE3/eK2aeoqT2rdYhZQjDUlaNVXk8EGCzxtueN2um71srC8v7
         5Q6A==
X-Gm-Message-State: ACgBeo0Jt+uFNPFs60vwY4v5rPR96pyVny1ISJgOjPrYKy+rGkeNke2r
        hXRWpGjQjiTLWm9gcTAC+CM=
X-Google-Smtp-Source: AA6agR5OPOwDJE58ao9jv+pZdNJUMi9M9aDfB2J3DaGFdNUym5v8tv8Wlg/AO5CDPBdTDGPqVqniLg==
X-Received: by 2002:a05:600c:a147:b0:3b4:86e7:4315 with SMTP id ib7-20020a05600ca14700b003b486e74315mr2614355wmb.156.1663151521693;
        Wed, 14 Sep 2022 03:32:01 -0700 (PDT)
Received: from [10.176.68.61] ([192.19.148.250])
        by smtp.gmail.com with ESMTPSA id x5-20020a05600c21c500b003b4727d199asm14036718wmj.15.2022.09.14.03.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 03:32:01 -0700 (PDT)
Message-ID: <8879d059-e6db-39ac-e48a-d07a08f5d33b@gmail.com>
Date:   Wed, 14 Sep 2022 12:31:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH wireless-next v2 0/12] Add support for bcm4378 on Apple
 platforms
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc:     Alyssa Rosenzweig <alyssa@rosenzweig.io>, asahi@lists.linux.dev,
        brcm80211-dev-list.pdl@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        SHA-cyfmac-dev-list@infineon.com, Sven Peter <sven@svenpeter.dev>,
        van Spriel <arend@broadcom.com>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
From:   Arend Van Spriel <aspriel@gmail.com>
In-Reply-To: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/2022 11:52 AM, Russell King (Oracle) wrote:
> Hi,
> 
> This series adds support for bcm4378 found on Apple platforms, and has
> been tested on the Apple Mac Mini. It is a re-posting of a subset of
> Hector's previous 38 patch series, and it is believed that the comments
> from that review were addressed.
> 
> (I'm just the middle man; please don't complain if something has been
> missed.)

Hi Russell,

I reviewed this series (or actually the 30+ series) a couple of times 
and actually thought it was already applied. Anyway, I will go over 
these once more.

Regards,
Arend
