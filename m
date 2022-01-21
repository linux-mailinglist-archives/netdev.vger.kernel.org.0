Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF7C496507
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 19:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382076AbiAUS3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 13:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351379AbiAUS3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 13:29:53 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC36C06173B;
        Fri, 21 Jan 2022 10:29:53 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id m9so285060oia.12;
        Fri, 21 Jan 2022 10:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x2Yau9KhhmJsWECpvG2VAEJBSBjdTIUlCrVpzfy1CjA=;
        b=eOB/snb09fSjsY4aGZAHsVT29ophgRCM5gLd7P0tYngBFs3VBXCQtTNKbJg6r8+abH
         5sbe83nJG6eTJnFSoABrzUMtKEfmbFAdGND2+f7Jdjd8iIE2N7X42gh94rLQcpfj/UuA
         MitfKnCCFHrijEVawyEqJhOfWoIZT/o4d5yBJQX/E05J8l8Lp0RwQpH0dQJMmcejMbzO
         6kRMxLR/x4/UoozAO7Dk+SnyHuyHtb22H2SesKA0NvEAO1A0HCSkysD3KsBQbAiszP4l
         8XLzeD74WeIbxlj3jXxnBOp4FrIjd0KSHzLmLTLLCqmTIAX5IJ3pv65QbKT7RLkKXL5g
         LYbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x2Yau9KhhmJsWECpvG2VAEJBSBjdTIUlCrVpzfy1CjA=;
        b=RsvtNGud83AFQE0bMFvu3XMRgL9oxmoVBlJcddTNVamNUIahtnvJIPn176NZo7fc9j
         KjxBXNt+fQL3aWYmBeAB/vx4/z6arXD7oUw+CmaN+lf2B29dKVO0KbVWj512Re39/HnH
         KMVzYKbmalVaNhKOI+x2pRRKf2l/c4AxOG9KibdwpNH232JnDvk19pv/HfUjsRk0y2Hj
         +NJ7Ee4vrE+HoAdPH7l6IbQh4SJE0MlV461YBn3W+dBepw2yLBC9732sCqBmAqyg8l10
         82foEO3Tale7zqMm4+vUEj8IeI2bLOcSmRMoCjWCQ1FxJKPh/yhr2GaO+RZnk/k+Al6R
         zOQg==
X-Gm-Message-State: AOAM530/hLOn4M9sQRQ3IYGqJuLpFX7KlBSHp/OwDupQtGy/F5g4nm9I
        r3PhDfN6FsWiFaS1BuROG8g=
X-Google-Smtp-Source: ABdhPJzWxll/pJbZ7sne7zBQ7BFG5Ym3Eruq9I4UxL6UEJ+NAOOgqsfPPydyFHuqHlXUKA5RhX8mTw==
X-Received: by 2002:aca:aa05:: with SMTP id t5mr1580768oie.143.1642789792508;
        Fri, 21 Jan 2022 10:29:52 -0800 (PST)
Received: from [10.62.118.101] (cpe-24-31-246-181.kc.res.rr.com. [24.31.246.181])
        by smtp.gmail.com with ESMTPSA id bq9sm1657342oib.28.2022.01.21.10.29.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jan 2022 10:29:51 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <d12bede2-4b76-fcdf-60c1-38616fab7ded@lwfinger.net>
Date:   Fri, 21 Jan 2022 12:29:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 19/31] net: realtek: changing LED_* from enum
 led_brightness to actual value
Content-Language: en-US
To:     htl10@users.sourceforge.net, Luiz Sampaio <sampaio.ime@gmail.com>,
        Herton Ronaldo Krzesinski <herton@canonical.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <1735835679.1273895.1642785160493.ref@mail.yahoo.com>
 <1735835679.1273895.1642785160493@mail.yahoo.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1735835679.1273895.1642785160493@mail.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/21/22 11:12, Hin-Tak Leung wrote:
>> -        if (brightness == LED_FULL) {
>> +        if (brightness == 255) {
> 
>> -        if (brightness == LED_OFF) {
>> +        if (brightness == 0) {
> 
> NAKed. I haven't received the other 30 patches in this series so I don't know the full context, but I don't think replacing meaningful enum names with numerical values is an improvement. If the ENUMs are gone from a common include (and why is the ENUM removed, if drivers use them??), and the realtek driver still have such a functionality, it probably should be defined in one of the rtl818*.h as RTL818X_LED_FULL and RTL818X_LED_OFF .
> 
> My $0.02, based on this one only of the 31.

I agree. Substituting magic numbers for enum names should not be done. NACK.

Larry

