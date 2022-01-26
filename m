Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9361B49C92E
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 12:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241017AbiAZL5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 06:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241026AbiAZL5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 06:57:34 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F865C061748
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 03:57:34 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id i4so12419615qtr.0
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 03:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YAwQtKA79rQJUW89ZblO4hKHiJutd6h5fRt1Ubl5c9U=;
        b=yN3xe/GzP/3eIn7fmkjw8cKK6ZNAHkOAN2y8VfGHNi7lf8dVYxi57u99kg6w9yu4nn
         DDeX5CqMg+QJXIpEiMFa6P8VSZGe2PtHyrW4s06ud8z4+M50+H+5ZHoevi9jTwQ0kYuK
         ag1m46C5hUmLZGNsMC9D07jIsyNtQpQfLkENqb7RCrNlJ58EtWtcIGf6RjMYVBrvPU4K
         nmbrucMx0qBf6ZIbu2trzKPKLnhq1LmnkbKzNuVLsnCUGxJKlPOw5JQfrtajiJSSO9FY
         KNSvSEcnzGtEumUtmuF3GoutVh8jketeq03FFv87hQmi+NbWewDYfH0KQn4hRTcS3/qc
         CwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YAwQtKA79rQJUW89ZblO4hKHiJutd6h5fRt1Ubl5c9U=;
        b=JnsBr/1/crdHD2KBouIHHv2bbzavU9BpjqRZ5RtpXW04nmrFzV57ltBdYh4PQHRQMa
         x1JUFvrvZ9tVcGnAl71DoIxYfQ1r3kSe5S/4OxvqGX8oBAkLwl+vGGHP2xD8YcdHKBfK
         iBBoC6vtqtfm2ZGUMEt41dyqsP8WQ/bDfiESCgm/zXqidbw4yjn8bltTwQZTio8Aoben
         jDBDSNsoJN2BpL6yhAQHG6qhTqhYnqJDszqSi4CFx+03DSD7aT3vuUOSUSiVr7wUYC0W
         rJiK0/GR0gcf3oFgPB3lKZ6aNSZnaZhOCB5Uhw0ZCuwar3dcId6mcGvgkCdZmzXbjl98
         mdcg==
X-Gm-Message-State: AOAM530WyGWazAOrYa9rn0K/mP+/jNvYNYToJ2oCME01L/lSpjNfjxmW
        fZwL/B+r8bUOPgfbnL32290ic9jRsDUIUw==
X-Google-Smtp-Source: ABdhPJw6GezwAbjN/Px6w1tehS1JAvcB1d8sA6LNyl4urJXthg28LFyKxSO38YdlIbtm26oLEiy6FQ==
X-Received: by 2002:a05:622a:113:: with SMTP id u19mr19968292qtw.475.1643198253782;
        Wed, 26 Jan 2022 03:57:33 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id y15sm11024149qko.95.2022.01.26.03.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 03:57:33 -0800 (PST)
Message-ID: <450375bd-6985-202c-7ad2-c11c97fe5b0c@mojatatu.com>
Date:   Wed, 26 Jan 2022 06:57:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH iproute2-next v1] tc: add skip_hw and skip_sw to control
 action offload
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Victor Nogueira <victor@mojatatu.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
References: <1643106363-20246-1-git-send-email-baowen.zheng@corigine.com>
 <CA+NMeC_BK65Oej=tL0ooyBhhEk6wK73HOaV5LR3QQkzXpbzNgQ@mail.gmail.com>
 <CY4PR1301MB2167AFCA2EC627B6789BFB6DE7209@CY4PR1301MB2167.namprd13.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <CY4PR1301MB2167AFCA2EC627B6789BFB6DE7209@CY4PR1301MB2167.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Baowen,
I didnt follow what "next patch" means because just prior to this
email you sent a v2.

As a general rule:
You have to run the tdc tests and if your iproute2 patch is breaking
something that was working fine before your patch then it needs to be
fixed first. Perhaps thats what you meant is your v2 fixes the vlan
breakage.

cheers,
jamal

On 2022-01-26 03:14, Baowen Zheng wrote:
> Hi Victor, thanks very much to bring this issue to us, we will make a check and fix this issue in next patch.
> 
> On Tuesday, January 25, 2022 11:23 PM, Victor wrote:
>> Hi Baowen,
>>
>> I applied your patch, ran tdc.sh and in particular the vlan tests broke.
>>
>> cheers,
>> Victor
