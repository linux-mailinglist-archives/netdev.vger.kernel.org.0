Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102111C0220
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgD3QTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726405AbgD3QTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 12:19:09 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE1DC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 09:19:09 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id n143so6280603qkn.8
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 09:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DyuTfttfAZVr+elPD24XIUIiMXz9L0FLGiaMFrIn8Kg=;
        b=ZSBPlx2UVuwJl0X6mMe+aJKKOcumdILZUnrOoS7uzDXbp74IMkN+Yk4U9NKLQYQr13
         fHG14RMciK6BCnSXtA4wrr2sDPdeS9fCCHmOwIlf9qsVmiHnCKlqXMcVv65STtHUxh7B
         Ni9BT+b9112X5DBAJ+hjrSKKtvmM7JSqkkNHeMlGf3C4IeWK5NjaG9M2EqOn2uyaLJmB
         4lhGuFU0O0PDh3eDnt9Y3HvNsLdHJXiFwv2TOZtiZJThvUqA4mxtN53rAGC4VEU05xZL
         Xlm55zIq6sp+bvCegmUdkADMISWv7BDMEQW1kSBtDIekTAb1gzy2y7RPlmXRTz+lYNkB
         4rvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DyuTfttfAZVr+elPD24XIUIiMXz9L0FLGiaMFrIn8Kg=;
        b=JZ3xAfBXEx4OGKB6zaUKn6eV/D0R40SPiu389pwmdgiI+J8yvKS9a9liROBRIlAt4M
         T8aPlvtABZUVQvJUE95GkRmxOFnLenDFIVfAzemfgc7Kt6jc6oJ2Uyseu+kdBVqKZqpc
         B47GWZsJIsO5TUxpETgAkgLSzzgMUltH+RY7CQq5dsyvkoAV86IRe4owTBP7og0M5Qfn
         98aRYwBnqHboYMtbOLMhdy4RWIbHaW1awo3t6RHXxR1fZZVfoYj6rgpymxQ5GGJc86hy
         diA07jbQKJ5IRlo+s7ijSUJjH0sw/wZzUlpXpYD3dIlBPY8w5GryxyJGKYgzyDOkZj1W
         /EDw==
X-Gm-Message-State: AGi0PuYZU7BNOZ3miTIFPrGkuggBhV3MQ8EEP6sUTJ3/rd7P00hOk1YR
        tP8gElv7iM1kvxipIyLiZXg=
X-Google-Smtp-Source: APiQypKIKrAuLyT+Cshfp8HRtWrGaCH85wI4Clc0wcdGVm/DICH0cAtqrS+oo87D++8q++fdgY2agg==
X-Received: by 2002:a37:4d8f:: with SMTP id a137mr4237926qkb.274.1588263548490;
        Thu, 30 Apr 2020 09:19:08 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b01c:ec8e:d8ff:35b1? ([2601:282:803:7700:b01c:ec8e:d8ff:35b1])
        by smtp.googlemail.com with ESMTPSA id v3sm82891qtq.19.2020.04.30.09.19.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 09:19:07 -0700 (PDT)
Subject: Re: [PATCHv4 iproute2-next 2/7] iproute_lwtunnel: add options support
 for vxlan metadata
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1587983178.git.lucien.xin@gmail.com>
 <a06922f5bd35b674caee4bd5919186ea1323202a.1587983178.git.lucien.xin@gmail.com>
 <838c55576eabd17db407a95bc6609c05bf5e174b.1587983178.git.lucien.xin@gmail.com>
 <1cd96ed3-b2ec-6cc7-8737-0cc2ecd38f72@gmail.com>
 <CADvbK_cSTXakVS9qkiESu6swXPsEZyDvfPggQp1cWXYHg6hC5Q@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3896333e-1c2b-8f9e-c41a-48662b2d60b6@gmail.com>
Date:   Thu, 30 Apr 2020 10:19:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CADvbK_cSTXakVS9qkiESu6swXPsEZyDvfPggQp1cWXYHg6hC5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/20 11:12 PM, Xin Long wrote:
>>
>> gdp? should that be 'gbp'?
> Right, should be 'gbp'. Sorry.
> The same mistake also exists in:
> 
>   [PATCHv4 iproute2-next 4/7] tc: m_tunnel_key: add options support for vxlan

yep, saw that.

> 
> Any other comments? Otherwise, I will post v5 with the fix.
> 

LGTM. I can just edit the patches and fix before applying.
