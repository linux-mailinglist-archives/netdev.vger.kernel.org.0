Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3536E606424
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 17:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiJTPRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 11:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiJTPQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 11:16:49 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7437717F299;
        Thu, 20 Oct 2022 08:16:34 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id bp11so35069574wrb.9;
        Thu, 20 Oct 2022 08:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=prI78vDY9tKuN/2No1ope25ekPhZy7nt6y/7SOt0Y5A=;
        b=i59W8rawHhkGC4ctbjvoHStpw132Mix2JtxoIRcrmXyIoZfWYPmlqEddJS0ddm+qp4
         ia5LR3ndIw+++jUmWWzClqu/UBEk3iavDXs/HXcHNKx0Vo9E2DPmUrmRPMFKGAT6Op5P
         pE0nymV5jZhRrmRJHSCmj7QXvwZoIxmn1llv7LJgc41u3fAqQMn+uyuVSYyDLYqVqpUw
         gggBV0m/Ry+ud7kkXeMkedKMVhMlAIv+W4qDF8H0HS/66YBJ2zPy2SA/s8ENpxjLE1OB
         WLC03QVnik0XkwM0QFT5bW3OfvkbDEkSFBeLgJ2CHIY5wowAFcyz1X/B2r2pVoJu3sEs
         S6FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=prI78vDY9tKuN/2No1ope25ekPhZy7nt6y/7SOt0Y5A=;
        b=AwRrYfhTW5m309d0SbzarsnccOYzx9eGmCIgFXL8ZdIUodxb/SSWTXuWWoNEe8D8Xr
         e0tXxgLR1lOl3OUZDqg5pQx4tS31Nj0YmuW+QOrRpkYg72EyvGXrngYUbSVEyZSnYovq
         XCe9DUn8XmV00RUuumPJ17lJZLXJ2sSzT7/TDbAIRHml5K7RH4TvxUREIiMpgBLIywIh
         op2BvbJ77x9e1pu9Ag0HYv+PcXFfHKtb6jEGte3VkFvvabN/8/dEh/k9tM/BIcbB1Ze+
         /ui6MG9aSCwABK6tbOLVpztAKif17ZCFTg1PwMfNvptG9GZOrJnonCnVUwPXHaY4QAw+
         3ddA==
X-Gm-Message-State: ACrzQf1Pc50LduCWEFigQRXAnsscNLmMRvYmP5tAHsj9ep37+M83iuVf
        WZcxI8Rk/jwUtVf1+qqcssEhAjzr0YrLy3Lh
X-Google-Smtp-Source: AMsMyM5tKPbTrSSLMIbkmJR4GnRPaujGdo8mtTwMKNP9rw/TP5a1CBmNygsUVNt/J7VcGnngYFjm7Q==
X-Received: by 2002:adf:ef82:0:b0:234:ef87:dc8d with SMTP id d2-20020adfef82000000b00234ef87dc8dmr4025604wro.297.1666278993761;
        Thu, 20 Oct 2022 08:16:33 -0700 (PDT)
Received: from [192.168.0.210] (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.googlemail.com with ESMTPSA id n37-20020a05600c502500b003a531c7aa66sm126182wmr.1.2022.10.20.08.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 08:16:33 -0700 (PDT)
Message-ID: <e1fc572c-2a02-26e7-ab3f-54133636462d@gmail.com>
Date:   Thu, 20 Oct 2022 16:16:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: wifi: rt2x00: add TX LOFT calibration for MT7620
Content-Language: en-US
To:     Stanislaw Gruszka <stf_xl@wp.pl>
Cc:     =?UTF-8?Q?Tomislav_Po=c5=beega?= <pozega.tomislav@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <01410678-ab7d-1733-8d5a-e06d1a4b6c9e@gmail.com>
 <20221020151522.GA99236@wp.pl>
From:   "Colin King (gmail)" <colin.i.king@gmail.com>
In-Reply-To: <20221020151522.GA99236@wp.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/10/2022 16:15, Stanislaw Gruszka wrote:
> On Thu, Oct 20, 2022 at 02:45:22PM +0100, Colin King (gmail) wrote:
>> I noticed a signed / unsigned comparison warning when building linux-next
>> with clang. I believe it was introduced in the following commit:
>>
>> commit dab902fe1d29dc0fa1dccc8d13dc89ffbf633881
>> Author: Tomislav Požega <pozega.tomislav@gmail.com>
>> Date:   Sat Sep 17 21:28:43 2022 +0100
>>
>>      wifi: rt2x00: add TX LOFT calibration for MT7620
>>
>>
>> The warning is as follows:
>>
>> drivers/net/wireless/ralink/rt2x00/rt2800lib.c:9472:15: warning: result of
>> comparison of constant -7 with expression of type 'char' is always false
>> [-Wtautological-constant-out-of-range-compare]
>>          gerr = (gerr < -0x07) ? -0x07 : (gerr > 0x05) ? 0x05 : gerr;
> 
> This was very currently addressed:
> https://lore.kernel.org/linux-wireless/20221019155541.3410813-1-Jason@zx2c4.com/

Awesome. Thanks!

Colin
> 
> Regards
> Stanislaw

