Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED35F4C2DD4
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbiBXOEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235320AbiBXOEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:04:35 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180E720DB1D
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 06:04:02 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id d3so3670765qvb.5
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 06:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1J9QuuECw8l9XYBFc+hTDlCcdTttwd1QyTxrc8My5Mc=;
        b=eE9z+QnJjmryr7iHS18252LzAY3KZHui2IO8G2M2OQR1+ze+Eh5101kkmZgBE96g2R
         doEJBiu7zyPD6XIZLAavp8NN0hkJhyhWwIIXakpHWX5kSNiVd7EOcQj4Y2GHugvvwB4w
         mLGCB+LlDNUDN/xkS8l9qgEikPLiHDS6Tul6k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1J9QuuECw8l9XYBFc+hTDlCcdTttwd1QyTxrc8My5Mc=;
        b=Au2WeVGKON927cOBL8ZgmZjUdf5uk3wHHQGlxbMg9b21Ed8qTcy9oUxwqLoFz1hm22
         PrQnnQJx/p1g41onoNLsJW9anE/BgNYB+nHdqs8Y6/ZmCOAgoRDod2rGlCyiUzbVFuKI
         tkBmivpi69ED2uhvzKjWUm2e5tY+nFCnRUi4OiwUF2t8Rj8HbnL6KvZQba6nzmSGxhJn
         THIGwcB8owq4A90ltnYA1ZjXnITlGX2AMDpDI6rOy5gQB42a/hlMI+ttHnEM5OSXxI9C
         OZjrjdgNa66oGwPh2h93eWpPvR7tnxnRWfAOPxbuaOTHRiP+X8Q0cyELH7HrCGfVbKrC
         IzAA==
X-Gm-Message-State: AOAM531vSoDcuVl77jOVgusYkm1rVeo8PpjP4FsDPepCcSSM09N2ORpT
        PflGr/GrcmOwMw01Ky1GniWQIQ==
X-Google-Smtp-Source: ABdhPJykifWw99WUN3OfZ23Vq6YPYP6skQILQaAbVzWzMizPf/5KHeXWIqFK7expcvzniDuaH9x44A==
X-Received: by 2002:ac8:5ace:0:b0:2c9:f9d2:146 with SMTP id d14-20020ac85ace000000b002c9f9d20146mr2513097qtd.216.1645711441204;
        Thu, 24 Feb 2022 06:04:01 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id t19sm1682306qtx.68.2022.02.24.06.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 06:04:00 -0800 (PST)
Message-ID: <2c768b0f-316f-7227-6d87-2d1e875fcaaf@ieee.org>
Date:   Thu, 24 Feb 2022 08:03:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: linux-next: Tree for Feb 23 (drivers/net/ipa/ipa_power.o)
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>, broonie@kernel.org,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alex Elder <elder@kernel.org>
References: <20220224014440.1397777-1-broonie@kernel.org>
 <23f9d46a-4b33-6918-9c62-f417c624585c@infradead.org>
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <23f9d46a-4b33-6918-9c62-f417c624585c@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/22 12:28 AM, Randy Dunlap wrote:
> 
> 
> On 2/23/22 17:44, broonie@kernel.org wrote:
>> Hi all,
>>
>> Note that today's -next again does not include the akpm tree since it's
>> been a long day and the conflicts especially with the mm code seemed
>> more than it was wise for me to attempt.  I'll have another go tomorrow
>> but no guarantees, I got further today.
>>
>> Changes since 20220222

Thanks, I'll investigate.	-Alex

> 
> on i386:
> 
> ld: drivers/net/ipa/ipa_power.o: in function `ipa_power_retention':
> ipa_power.c:(.text+0x57d): undefined reference to `qmp_send'
> ld: ipa_power.c:(.text+0x5d1): undefined reference to `qmp_send'
> ld: drivers/net/ipa/ipa_power.o: in function `ipa_power_init':
> ipa_power.c:(.text+0x823): undefined reference to `qmp_get'
> ld: drivers/net/ipa/ipa_power.o: in function `ipa_power_exit':
> ipa_power.c:(.text+0x954): undefined reference to `qmp_put'
> 
> 
> Full randconfig file is attached.
> 

