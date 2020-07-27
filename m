Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020D822F4FF
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 18:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729063AbgG0QZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 12:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728446AbgG0QZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 12:25:25 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B37C061794;
        Mon, 27 Jul 2020 09:25:23 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id s190so3250339ooa.13;
        Mon, 27 Jul 2020 09:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kLEwg/GwaUFP5MTtIx9yELTFjI7/3rn3DIkXhvdqZaU=;
        b=SL2Gkjqb+X2fjcvF1VHGdaS4g0KaJfv9brxRvotYAOF1r4cxXgKvQvQvss5Th8BGtI
         BvrBRUT/gBIbrq7cbH/atelEM7n5eli33tySTmotJQEKTO+DN0DwQnpzzWaf4ck8U+ae
         IdzzufDV5OI+9mPMzdnwrUS98zsYNZ2a2r5QJHSsh/XdlbWYHHPx9mtprdADuemYo5FY
         ogap3CWrKEO5FJLugFi++ZdTyfU3JVL99dA2tMhXP2DNaU5iB4wkGYGIg+X5H7JhADGV
         SJmK7HolDBy8mhHbZ1m3kfBMMZJGS/MliDs+suuBCQRPI/OotD8pSsDKpRTi2YLj8ohq
         LI6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kLEwg/GwaUFP5MTtIx9yELTFjI7/3rn3DIkXhvdqZaU=;
        b=gteji0Kvr85QaN82DXaRK+HpQ3sMqp81sxhsJuO0NK66tWRzPwlxtpPLslQ7NmBpGT
         3bFzYvTmy5hMVIvfwChyRAyW0idi3LTlzxdew8r5bqJXOWdpTwuOSdKo0rq+VZ/yNDtd
         hylmDrONYUX3nIhy4mKylSWcl36qAWI5AU6SycnFiT+Bnm4jHBF8ndsteZyxx2nFSnvU
         uDAL0OOtMw8yXTzvh5/5VllIKfrlvzjuljFiOj2R1xhYgUSp0Rmf7b0m6tYbOx27/8H5
         ULpewjAMPFGvlPdR+GV2X59XBMqPq03pIS2S3Qr/QGIiwT3GrH2nd9HwPMUKZOSEntCt
         EKzA==
X-Gm-Message-State: AOAM532EkkYlv4vr0vFc7DhJ/Gofk58kvJ5jyAEASfbG6GM5Sugd9gh/
        ATv5hW6dSAwjpaQfWqP1R7Mjl6Ck
X-Google-Smtp-Source: ABdhPJyNKM4sqOTOSrrgLKu7GyOOBqYh9EpoiC0V0A3UviX3MIkXfMB0DJbeKjOQp9wN+auzOr4t2Q==
X-Received: by 2002:a4a:ae07:: with SMTP id z7mr20059296oom.25.1595867122954;
        Mon, 27 Jul 2020 09:25:22 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id g2sm3594103otr.72.2020.07.27.09.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 09:25:22 -0700 (PDT)
Subject: Re: [PATCH 2/6] rtlwifi: Remove unnecessary parenthese in rtl_dbg
 uses
To:     Joe Perches <joe@perches.com>, Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
References: <cover.1595706419.git.joe@perches.com>
 <9b2eaedb7ea123ea766a379459b20a9486d1cd41.1595706420.git.joe@perches.com>
 <1595830034.12227.7.camel@realtek.com>
 <ae9d562ec9ef765dddd1491d4cfb5f6d18f7025f.camel@perches.com>
 <1595840670.17671.4.camel@realtek.com>
 <6e0c07bc3d2f48d4a62a9e270366c536cfe56783.camel@perches.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <374359f9-8199-f4b9-0596-adc41c8c664f@lwfinger.net>
Date:   Mon, 27 Jul 2020 11:25:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6e0c07bc3d2f48d4a62a9e270366c536cfe56783.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/20 9:52 AM, Joe Perches wrote:
> On Mon, 2020-07-27 at 09:04 +0000, Pkshih wrote:
>> So, I think you would like to have parenthesis intentionally.
>> If so,
>> test1 ? : (test2 ? :)
>> would be better.
>>
>>
>> If not,
>> test1 ? : test2 ? :
>> may be what you want (without any parenthesis).
> 
> Use whatever style you like, it's unimportant to me
> and it's not worth spending any real time on it.

If you are so busy, why did you jump in with patches that you knew I was already 
working on? You knew because you critiqued my first submission.

@Kalle: Please drop my contributions in the sequence "PATCH v2 00/15] rtlwifi: 
Change RT_TRACE into rtl_dbg for all drivers".

Larry

