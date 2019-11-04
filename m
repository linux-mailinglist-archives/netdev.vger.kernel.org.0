Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F445EDAA4
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 09:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfKDIiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 03:38:11 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46306 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbfKDIiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 03:38:10 -0500
Received: by mail-lf1-f68.google.com with SMTP id 19so6400239lft.13
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 00:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aAvLvQnBn2etU9QWbHrMgTtrty/V9iZf2pUKjOUNug8=;
        b=CRqPRRvMc4CiyGWwN0n+HhobnmdoLfjL+0AzezW7ETOIFz5sHfNHH5JNGG6YI+/403
         MsQNEzWz0NSvbA0uWvsbCgqAT3tGi1qsOO0oSW4TRw1r9cIbKDUlQ9wzYhXtlrQDdRZs
         PV5CVnB5sUcQ4tEXqmk5O+Wt9y6sGHLcWmnV4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aAvLvQnBn2etU9QWbHrMgTtrty/V9iZf2pUKjOUNug8=;
        b=YJfJLkEFt/A3KZnCcJh1mvBzxYKHjpfXjBTN4pW05fI+KLF89b5FiZjvEf1iD6sHsv
         IKXjgWYS76eu/cj/HKjBG8vnBQrnZ/p4vk8IylcWdm7yLd4Sk8RgxvJFECJSf1WYH50b
         UC6Wamuse6RlC6QRYIBCFxpVcyS3/H9481rCAyIF5y9M76waNhg1WHi5XQWyHlFN1cCw
         NXS4UJ29chQOVRjXTy2YwLjkbe/bponaaB5m7C2slOj1O2+bux2KTysTbyjHR+rim7ND
         WJqO1WGu2jvkXsGccxe2B+rZhSrEQuXiAF2bcbtqqzl1ioqUxB+nqLGO2x1XvvEdS+bd
         xrXA==
X-Gm-Message-State: APjAAAXb1u61n6lVNDw2Bey9XnX4Kn5AoOT/j063jR4eiHwZB1Lff7DY
        8P/h/aC3251uUh2BFPncRQ9yMF1d+oCHSg==
X-Google-Smtp-Source: APXvYqzGJdH19phuRzqBS1a9feyj40vilK5OuKVvLX9t8OwmcbQ9em9T2maQ71sFqH2o8LzrUCr3gg==
X-Received: by 2002:ac2:549a:: with SMTP id t26mr15512173lfk.25.1572856688914;
        Mon, 04 Nov 2019 00:38:08 -0800 (PST)
Received: from [172.16.11.28] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id u11sm8744096lfq.54.2019.11.04.00.38.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Nov 2019 00:38:08 -0800 (PST)
Subject: Re: [PATCH v3 35/36] net/wan: make FSL_UCC_HDLC explicitly depend on
 PPC32
To:     Leo Li <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Qiang Zhao <qiang.zhao@nxp.com>
Cc:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Scott Wood <oss@buserror.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191018125234.21825-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-36-linux@rasmusvillemoes.dk>
 <4e2ac670-2bf4-fb47-2130-c0120bcf0111@c-s.fr>
 <VE1PR04MB6687D4620E32176BDC120DBA8F620@VE1PR04MB6687.eurprd04.prod.outlook.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <24ea27b6-adea-cc74-f480-b68de163f531@rasmusvillemoes.dk>
Date:   Mon, 4 Nov 2019 09:38:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <VE1PR04MB6687D4620E32176BDC120DBA8F620@VE1PR04MB6687.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/11/2019 23.31, Leo Li wrote:
> 
> 
>> -----Original Message-----
>> From: Christophe Leroy <christophe.leroy@c-s.fr>
>> Sent: Friday, November 1, 2019 11:30 AM
>> To: Rasmus Villemoes <linux@rasmusvillemoes.dk>; Qiang Zhao
>> <qiang.zhao@nxp.com>; Leo Li <leoyang.li@nxp.com>
>> Cc: linuxppc-dev@lists.ozlabs.org; linux-arm-kernel@lists.infradead.org;
>> linux-kernel@vger.kernel.org; Scott Wood <oss@buserror.net>;
>> netdev@vger.kernel.org
>> Subject: Re: [PATCH v3 35/36] net/wan: make FSL_UCC_HDLC explicitly
>> depend on PPC32
>>
>>
>>
>> Le 01/11/2019 à 13:42, Rasmus Villemoes a écrit :
>>> Currently, FSL_UCC_HDLC depends on QUICC_ENGINE, which in turn
>> depends
>>> on PPC32. As preparation for removing the latter and thus allowing the
>>> core QE code to be built for other architectures, make FSL_UCC_HDLC
>>> explicitly depend on PPC32.
>>
>> Is that really powerpc specific ? Can't the ARM QE perform HDLC on UCC ?

I think the driver would build on ARM. Whether it works I don't know. I
know it does not build on 64 bit hosts (see kbuild report for v2,23/23).

> No.  Actually the HDLC and TDM are the major reason to integrate a QE on the ARM based Layerscape SoCs.

[citation needed].

> Since Rasmus doesn't have the hardware to test this feature Qiang Zhao probably can help verify the functionality of TDM and we can drop this patch.

No, this patch cannot be dropped. Please see the kbuild complaints for
v2,23/23 about use of IS_ERR_VALUE on not-sizeof(long) entities. I see
kbuild has complained about the same thing for v3 since apparently the
same thing appears in ucc_slow.c. So I'll fix that.

Moreover, as you say and know, I do not have the hardware to test it, so
I'm not going to even attempt to fix up fsl_ucc_hdlc.c. If Qiang Zhao or
somebody else can verify that it works just fine on ARM and fixes the
allmodconfig problem(s), he/she is more than welcome to sign off on a
patch that removes the CONFIG_PPC32 dependency or replaces it with
something else.

Rasmus
