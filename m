Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9288451F50E
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 09:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbiEIHRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234609AbiEIHDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:03:47 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DC2393D7;
        Sun,  8 May 2022 23:59:54 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id j14so13008230plx.3;
        Sun, 08 May 2022 23:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=ukKPvUkS4+sda6n7hZd5RfiYJTJ8bOEAkMXzOtPmIYQ=;
        b=RkZKGCXUY3WLo3y2zRC0HADNs7mY1Izvrx0xzLpIlB2hf3bjErAGfhwZoj7SpkH506
         P5MGGJJI+9l2PmkcWbIcatsvwBsE5iDuFfT4y96sbiBzxojagNVQSZjHGvfhytDdQMdE
         PO2kSfCjpUsTIvSOLWfa69ZR0857+HjEY2JokReKHoSyhgzfnugX9EjEQQQnKDpejEAh
         tGUx0wD/aGNVaqW5sPkVOeVDSSAfgPrM0lWalyHC7yf85CJuSN4+Qp5dtH6muyBnhHAT
         Fu7nSrpciTO4kz/JsFkAynPJwhmFqcu7SkyPdSmHRE2fk7a1n5ujHMPklFJ7onpRrc+r
         0v2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=ukKPvUkS4+sda6n7hZd5RfiYJTJ8bOEAkMXzOtPmIYQ=;
        b=PE7HbRkKwz+drFlSXurrTk4jcNjIV4svpgZrYSHJVFsPIJYiPYinukTiqgys0ZicY7
         cJafQmhYOUX61mQH34ufPxeU3PrQIb0Lrw+GHC0f3sdlpBBItZDTJTbFdH5P8ygfBjYQ
         zACsWUTGMkFCFZ8tcg9xclZuxHqYUEsBPIi1mTMdpuK4sMnpJa2yl7HiIt+qhhF8Ogse
         l0VUGmue8HQu30+f5uudeo2Vm6ry+V6kJSqOjMImEJJFoTkj71337ROUr7ytiVWfQOZy
         ScwGk4FGCqPhawrUNoWmQ8Dg9Lio3VwPyUM/roUzBsNmLlDT/x5c/Lukik96nTkDRH9I
         eQsQ==
X-Gm-Message-State: AOAM532IAKOxUqpOQP0PF16i/kFe/84plXFHUTR9qccircDTAugrq1Cb
        K/pPSHNUUBFd5jbsx5Xcl6+oQSmIRPw=
X-Google-Smtp-Source: ABdhPJwEWqRa848Y6b0nbhIetgmKuAHRwCdA9NXKfZeIWxhg4L+prw9ifbQbd3A3SFzUkc97mZUjXw==
X-Received: by 2002:a17:90b:4b42:b0:1dc:15f8:821b with SMTP id mi2-20020a17090b4b4200b001dc15f8821bmr25322886pjb.131.1652079593876;
        Sun, 08 May 2022 23:59:53 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-19.three.co.id. [116.206.28.19])
        by smtp.gmail.com with ESMTPSA id a13-20020aa794ad000000b0050dc76281desm7840546pfl.184.2022.05.08.23.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 May 2022 23:59:53 -0700 (PDT)
Message-ID: <4dd26a0e-819d-8414-8b71-1783e263209c@gmail.com>
Date:   Mon, 9 May 2022 13:59:48 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v3] net/core: Rephrase function description of
 __dev_queue_xmit()
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Akira Yokosawa <akiyks@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220507084643.18278-1-bagasdotme@gmail.com>
 <0cf2306a-2218-2cd5-ad54-0d73e25680a7@gmail.com> <Yni6nBTq+0LrBvQN@debian.me>
In-Reply-To: <Yni6nBTq+0LrBvQN@debian.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/22 13:54, Bagas Sanjaya wrote:
> I'm in favor of this patch. Thanks.
> 

Oops, I mean I'm in favor of your patch suggestion.

-- 
An old man doll... just what I always wanted! - Clara
