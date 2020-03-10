Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16833180BA4
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgCJWeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:34:36 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39070 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgCJWef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:34:35 -0400
Received: by mail-qt1-f195.google.com with SMTP id e13so180115qts.6;
        Tue, 10 Mar 2020 15:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YSxID0kX3bC1b3w0Sg3Xa0CKPJNgWfyLpSTsnQfgRFM=;
        b=RwuHZ6e/LEGZBHVQQrIKU4Bs+BCJrUihr8pYHkFI11hGRrZ1O8ducLJQLvecI7G1DF
         uEOYsBRwJXNavy8olCebLK9320WDFuhxal1tSSclwMHpY500Ylw8MqE47T3rLaQVRAu6
         94J+qUrDSQT29b4WTgu3L3FkdF4kzUdhMNO2PCxL/YhC6/Zm7Fku/Q1uOdK/SGADEl6G
         WmZtK/fPNIcNZIkYyUVPg+kEHPhDNvtyuOTA18FuJQ4TAjtKDvDghpXKrhbBYFjMUX24
         VZMnNSaghZN84u6Onj/DBcjL3iUdf6GK1+xw457ItkMPBsA9lzAMWaXy+j8aQp68lwb3
         RkIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YSxID0kX3bC1b3w0Sg3Xa0CKPJNgWfyLpSTsnQfgRFM=;
        b=oRduizE6ly4+CoI9R5TJybDJo7OiIxjQf2DFshbkKvVlUZKpXLcDVL+mydg65/qCSk
         40nwzXrbnFwWygqdP62VC3rOWOD4hzgARr9e9AzpO1DfGoFlcqn4VVDHiiGXH9HxBMBH
         e8IhcO4wIIJeYyMyGBxLc9S3Ulvp2XA8ElcoqPiqPjQ7UF+sh6SZ0wZ4d+qPlL1Jcqkk
         XRHH/bwyfoxJaDp7Sy2NQimm9we06IUBROXweU9/PWebhCZY7c8AdQOH89VMlSG3obsZ
         UVgJnqcaeSL4tzkRWW5FmlFCpA26QBM8cLMsKXKHhHc/tOp3ZxA4VRl9NLPa3UEfO8vO
         TklQ==
X-Gm-Message-State: ANhLgQ1nFxK2tFRaJRbKWXxdEBErm2AtDYzS8JnM9JjjWeczV59DoB9l
        S4oEQhgjOBEnMLirVNmMd4E=
X-Google-Smtp-Source: ADFU+vvfjeD3AbUyfTO5V9xree1iypXjvaxyxdA8UoTTbv/mAO6oWR6Gq4fF60KxsiOVb+A+sIjJkA==
X-Received: by 2002:ac8:16b8:: with SMTP id r53mr188708qtj.7.1583879672690;
        Tue, 10 Mar 2020 15:34:32 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d1::111b? ([2620:10d:c091:480::fee])
        by smtp.gmail.com with ESMTPSA id j1sm21787091qtd.66.2020.03.10.15.34.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 15:34:32 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH][next] zd1211rw/zd_usb.h: Replace zero-length array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Joe Perches <joe@perches.com>, Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
References: <20200305111216.GA24982@embeddedor>
 <87k13yq2jo.fsf@kamboji.qca.qualcomm.com>
 <256881484c5db07e47c611a56550642a6f6bd8e9.camel@perches.com>
 <87blpapyu5.fsf@kamboji.qca.qualcomm.com>
 <1bb7270f-545b-23ca-aa27-5b3c52fba1be@embeddedor.com>
 <87r1y0nwip.fsf@kamboji.qca.qualcomm.com>
 <48ff1333-0a14-36d8-9565-a7f13a06c974@embeddedor.com>
 <021d1125-3ffd-39ef-395a-b796c527bde4@gmail.com>
 <fb3395d7-e932-10ac-1feb-ab2ceb63424e@embeddedor.com>
 <361da904-5adf-eb0c-e937-c5d2f69ac8be@gmail.com>
 <e4cfda6c-37f0-3c28-f50b-32200a67d856@embeddedor.com>
Message-ID: <9700b2c9-1029-60b0-c5d2-684bdcede354@gmail.com>
Date:   Tue, 10 Mar 2020 18:34:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <e4cfda6c-37f0-3c28-f50b-32200a67d856@embeddedor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/20 6:31 PM, Gustavo A. R. Silva wrote:
> 
> 
> On 3/10/20 5:20 PM, Jes Sorensen wrote:
>> On 3/10/20 6:13 PM, Gustavo A. R. Silva wrote:
>>>
>>>
>>> On 3/10/20 5:07 PM, Jes Sorensen wrote:
>>>> As I stated in my previous answer, this seems more code churn than an
>>>> actual fix. If this is a real problem, shouldn't the work be put into
>>>> fixing the compiler to handle foo[0] instead? It seems that is where the
>>>> real value would be.
>>>
>>> Yeah. But, unfortunately, I'm not a compiler guy, so I'm not able to fix the
>>> compiler as you suggest. And I honestly don't see what is so annoying/disturbing
>>> about applying a patch that removes the 0 from foo[0] when it brings benefit
>>> to the whole codebase.
>>
>> My point is that it adds what seems like unnecessary churn, which is not
>> a benefit, and it doesn't improve the generated code.
>>
> 
> As an example of one of the benefits of this is that the compiler won't trigger
> a warning in the following case:
> 
> struct boo {
> 	int stuff;
> 	struct foo array[0];
> 	int morestuff;
> };
> 
> The result of the code above is an undefined behavior.
> 
> On the other hand in the case below, the compiles does trigger a warning:
> 
> struct boo {
> 	int stuff;
> 	struct foo array[];
> 	int morestuff;
> };

Right, this just underlines my prior argument, that this should be fixed
in the compiler.

Jes

