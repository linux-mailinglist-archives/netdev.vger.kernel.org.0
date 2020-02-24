Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB77616AA89
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgBXPzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:55:54 -0500
Received: from mail-il1-f182.google.com ([209.85.166.182]:44117 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbgBXPzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:55:53 -0500
Received: by mail-il1-f182.google.com with SMTP id s85so8105527ill.11
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 07:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KKfWNDFTR7rcoWk0B8UMnBflJXh6MoKgPtyrqtGM3d8=;
        b=JI8gTsbmueywI009v2e2y3oEPL2PiZtxJyXxhNHIIbJLaad7aDl6Lqg+7QaAJ9BZJ7
         uHXTJjg+WlIEJ70sdhrAL7XS7UPdyM2p2Ae8AgkImzCFe+yybrwwnxdpgP1Msq3bPsqN
         OC6QhpAupX5L9H78CiTliXCa4Pjm6O8w4/QYEYm0c+H2o+T36D1No+XPGpqIHhMcYebW
         Red4GBbb3AAnTsJz0WN7oMmxOBs/KUSOKzBZA27SeIs09IKuupZyN0SG77ppE4B9yDM3
         hgdkQljnCyg9Bc5Qa6MDYWUE+4PNjOmyPJjKbbW1izJHvE+uvq8ffwb/9Y49tN7MH6fb
         PVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KKfWNDFTR7rcoWk0B8UMnBflJXh6MoKgPtyrqtGM3d8=;
        b=NYTHJyINZQc1KZeH9wW5+zW07D1KdHdmroA0nJhvxaDP9rH8VvmR+IvSmagXeRntq9
         OLO2KQBDA95iEEvfJHLOsrqU32rD1TjfX3E3BWtGBtG9sKtM2qQbu2/xnVx/wRDH101g
         zW6DUZXJJ/Ed1nFfSFaofjXFZKC8ZaOrnadhxS0maAGj7MYmWswzmD04ts8g1e0S+Fk9
         oDDHgBeHnvXsObCLM9jJfurm9TysSHCF2fkQm8OjhIQcC3VqAlpVl274mtpkHfAoe36B
         7UnhchbA9d5gOtuVl/jUtUbB8q+Fue34SB9tnF1BHqRP5NAizmjZavaU00lxxd+q27iG
         3mBQ==
X-Gm-Message-State: APjAAAWm2/XV6kFqXVkrFzGNAvcHj9qrEYi8M1P72os1LPzWQiVuZPCJ
        z/buEaqhZFVNmiatceK+ToATmQ==
X-Google-Smtp-Source: APXvYqxJ1Fccof8qydN6K6EOwTv6kr67KX3H3z0Tqa3wx3MqzG4veO4GoDy2N69082sIVRpGUzfI3A==
X-Received: by 2002:a92:4448:: with SMTP id a8mr61004817ilm.256.1582559752900;
        Mon, 24 Feb 2020 07:55:52 -0800 (PST)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id m27sm4421449ilb.53.2020.02.24.07.55.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:55:52 -0800 (PST)
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW stats
 type
To:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, saeedm@mellanox.com, leon@kernel.org,
        michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, xiyou.wangcong@gmail.com,
        pablo@netfilter.org, mlxsw@mellanox.com
References: <20200221095643.6642-1-jiri@resnulli.us>
 <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
 <20200222063829.GB2228@nanopsycho>
 <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
 <20200224131101.GC16270@nanopsycho>
 <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
 <e08c0342-ff79-c249-f59d-1f5ab00b6db1@solarflare.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <7299c4bd-f42b-924e-8bd5-1d16567a8463@mojatatu.com>
Date:   Mon, 24 Feb 2020 10:55:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <e08c0342-ff79-c249-f59d-1f5ab00b6db1@solarflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-24 10:50 a.m., Edward Cree wrote:
> On 24/02/2020 15:45, Jamal Hadi Salim wrote:
>> Going backwards and looking at your example in this stanza:
>> ---
>>    in_hw in_hw_count 2
>>    hw_stats immediate
>>          action order 1: gact action drop
>>           random type none pass val 0
>>           index 1 ref 1 bind 1 installed 14 sec used 7 sec
>>          Action statistics:
>> ----
>>
>> Guessing from "in_hw in_hw_count 2" - 2 is a hw stats table index?
> AIUI in_hw_count is a reference count of hardware devices that have
>   offloaded the rule.  Nothing to do with stats "counters".

ah, ok;->. A more descriptive noun (hw_ref_count) would be nice.

Is it fair to assume that there's some form of stats table which is
indexed? And that the hw table index is accessible to the driver?

cheers,
jamal
