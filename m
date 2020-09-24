Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B698276651
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 04:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgIXCTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 22:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgIXCTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 22:19:13 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7D6C0613CE;
        Wed, 23 Sep 2020 19:19:13 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id e23so1729524otk.7;
        Wed, 23 Sep 2020 19:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wDEJhsl4Doe66f24GWnBXVwBWwh1i3I3Xt29k/zmNPc=;
        b=QziewrNMiwkoK2xtNAy2cdnKBqTjiKavvaW5XgS6o8LzTpLn4TJArJ/95ktolDW+WH
         U+fgDmQbqks2sGei9Udu32e/JMSG5/VyiKNPzOYVd8wSYQm1b8l8JeNLhlslQ5dcm4O0
         G/QEe7ByNNQkQE6Nr7FOgHRnW1E+vP1oxyXiOkFe+TyphvA8xDUg+2KZqTxZwGaJsQ/s
         Y42RfjsQpACciM51xadKG/lCuxqKCjNWRobZsfhf3CC5tCJD31hF5863Dl6btGs626u8
         qI703LohDFO1qqbkiJwk8VGtA4USaFziUV1enqRmdSF3QjTTlobh7UzpN2qchYkg/6av
         YIWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wDEJhsl4Doe66f24GWnBXVwBWwh1i3I3Xt29k/zmNPc=;
        b=fff+CI92/0otJPwF8m6ylYWNcHBRV5WJ0+4Qx4sj7Jew624MAqWOMcyhBDADGZLRIA
         Nk6G30Wr44tiroWwCAXyMKcPKEvs9aSmddUV1V6Ii5lHp0K9nmXj+B+Xtafov9/1CaKu
         sfrDhZZCRWkLY9S1cCVDTasqW2ZnydahP4KAHcBj3VmBBb/RBEEz5dBRORElVwPeOF21
         kdnqdhpO6MHU829Kt7C+mPk6JgcGQngqBauJ/vLhPuFnxINSTX1J/4RdKqhyeGsQNX4J
         G3cvTj4byTj66gJuXsus+aMHHP+ihH4UC7/rapZs3pcdi+n5s5wWHuQ/56zr//bwIyRL
         627w==
X-Gm-Message-State: AOAM530JaG3ZiSSNSzvh9AzqLaCYzfnDOEmuefJk6Pgqn6dDYlDMpEKY
        uVez7OjhTzVJYFtHD8h63p0=
X-Google-Smtp-Source: ABdhPJwd0A0Jq8w7Rg+2kKFAH5FRPRgE74e1V40h4IWsgALMcu7vXYQFmpj1fMQbwLuBjaOTM2KPNw==
X-Received: by 2002:a9d:621a:: with SMTP id g26mr1748958otj.209.1600913952684;
        Wed, 23 Sep 2020 19:19:12 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:b155:90bc:6427:b416])
        by smtp.googlemail.com with ESMTPSA id z20sm464787oor.3.2020.09.23.19.19.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 19:19:11 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Add bpf_ktime_get_real_ns
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        bimmy.pujari@intel.com
Cc:     bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        mchehab@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, ashkan.nikravesh@intel.com
References: <20200924000326.8913-1-bimmy.pujari@intel.com>
 <CANP3RGf-rDPkf2=YoLEn=jcHyFEDcrNrQO27RdZRCoa_xi8-4Q@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <00f4c72b-37ee-1fbc-21f6-612bbe037036@gmail.com>
Date:   Wed, 23 Sep 2020 20:19:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CANP3RGf-rDPkf2=YoLEn=jcHyFEDcrNrQO27RdZRCoa_xi8-4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/20 7:19 PM, Maciej Żenczykowski wrote:
>> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
>> index 5cc7425ee476..776ff58f969d 100644
>> --- a/kernel/bpf/helpers.c
>> +++ b/kernel/bpf/helpers.c
>> @@ -155,6 +155,17 @@ const struct bpf_func_proto bpf_ktime_get_ns_proto = {
>>         .ret_type       = RET_INTEGER,
>>  };
>>
>> +BPF_CALL_0(bpf_ktime_get_real_ns)
>> +{
>> +       /* NMI safe access to clock realtime */
>> +       return ktime_get_real_fast_ns();
>> +}
>> +
>> +const struct bpf_func_proto bpf_ktime_get_real_ns_proto = {
>> +       .func           = bpf_ktime_get_real_ns,
>> +       .gpl_only       = true,
> 
> imho should be false, this is normally accessible to userspace code
> via syscall, no reason why it should be gpl only for bpf
> 

agreed, no reason for the bpf hook to be gpl_only.

Glad to see the v2 of this patch; I wondered what happened to this helper.
