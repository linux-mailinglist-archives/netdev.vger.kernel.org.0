Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7496945B951
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 12:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241716AbhKXLmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 06:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241385AbhKXLmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 06:42:54 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E708C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 03:39:45 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id bu11so1559855qvb.0
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 03:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=W/yd4ZOY6HbEIY7UuAweiX85Z+lJfJ7BwSdkDyzkQnA=;
        b=qcfepXIavtSG0i4zNuMQaLdreCEOJW3bVBc6XLRMOqGm/2aoDRoiPYI7p57lfzsQok
         Hkh3nfgBBZ2BTt8mV6nVfXQIyYRYDu3H1ciDCRskonqycb9115FXILGi3ajsDLZMX92p
         lkZBgBpykWwcYksxnH3mG0jC+y4MJaIrVV6B0JFDoPk7ncfy4IHOy80sk63w+aoGDkeM
         mh9TdV/BXl+OsAxunUPFR9aSVCcHqXH2YGdTcyYACbYOY6Pvu/5i6yGZPJox+fTpniO6
         fdo39JLCrldAiF/easV3Bn7I2b8+gcPV75q5g2AT5RLbgBh8NnUH8rZ+HnlG/O8LCGNm
         CW9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W/yd4ZOY6HbEIY7UuAweiX85Z+lJfJ7BwSdkDyzkQnA=;
        b=j18H8ta5Ff6f8/Z/Abkl0tcwVrv2TEPVJdLoXEzLCbjjsIJ9+JXuuB8kAHPIoyx787
         qTcJ9WYQZl31uFZul2xLu4H1SM8xjW/K025RARh4SCYyfUPishmz82D1J4TMN8SUhmz0
         mN/vEmy4o6yUVNvF0iD7wxWUcrBiNZw/BHzpAK3/DJ2hMkUJKaakf9Cq4wE7ARRXxDQ6
         gOzL4CPnhqzDFbSguq1+IYyzXzSEi1PKmHKOzggrWYOSd9ddUmuFAU+1/KS/Tgc6j3bY
         okDOoiLZElOqZZ7eo2f/28J+dZNJEecfkWcoEBgkdh5RN5vWFLVfAkoN7JrqrIyawg/8
         5B8Q==
X-Gm-Message-State: AOAM530lmqiGgtXIDNGJtEBzyW6DW5oOPhNSgCHPD1yFoTEtIFL5u3Ei
        +Dgmdp+455DFGGumR86mGENs1Q==
X-Google-Smtp-Source: ABdhPJxZd8952aJI5MtfaLaOiQZZLUvEVbb9W8hNOMRKcgsmI722JbE0TnJ5CU0ieZHbuEpEn27EPQ==
X-Received: by 2002:a05:6214:f6c:: with SMTP id iy12mr6433750qvb.29.1637753984459;
        Wed, 24 Nov 2021 03:39:44 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id s20sm7808134qtc.75.2021.11.24.03.39.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 03:39:44 -0800 (PST)
Message-ID: <a899b3b5-c30b-2b91-be6a-24ec596bc786@mojatatu.com>
Date:   Wed, 24 Nov 2021 06:39:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v4 04/10] flow_offload: allow user to offload tc action to
 net device
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
 <20211118130805.23897-5-simon.horman@corigine.com>
 <cf194dc4-a7c9-5221-628b-ab26ceca9583@mojatatu.com>
 <DM5PR1301MB2172EFE3AC44E84D89D3D081E7609@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <404a4871-0e12-3cdc-e8c7-b0c85e068c53@mojatatu.com>
 <DM5PR1301MB21725BE79994CD548CEA0CC4E7619@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <DM5PR1301MB2172ED85399FCC4B89F70792E7619@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <DM5PR1301MB2172ED85399FCC4B89F70792E7619@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-23 21:59, Baowen Zheng wrote:
> Sorry for reply this message again.
> On November 24, 2021 10:11 AM, Baowen Zheng wrote:
>> On November 24, 2021 3:04 AM, Jamal Hadi Salim wrote:

[..]

>>>
>>> BTW: shouldnt extack be used here instead of returning just -EINVAL?
>>> I didnt stare long enough but it seems extack is not passed when
>>> deleting from hardware? I saw a NULL being passed in one of the patches.
> Maybe I misunderstand what you mean previously, when I look through the implement in
> flow_action_init, I did not found we use the extack to make a log before return -EINVAL.
> So could you please figure it out? Maybe I miss something or misunderstand again.

I mean there are maybe 1-2 places where you called that function
flow_action_init() with extack being NULL but the others with
legitimate extack.
I pointed to offload delete as an example. This may have existed
before your changes (but it is hard to tell from just eyeballing
patches); regardless it is a problem for debugging incase some
delete offload fails, no?

BTW:
now that i am looking at the patches again - small details:
struct flow_offload_action is sometimes initialized and sometimes
not (and sometimes allocated and sometimes off the stack). Maybe
to be consistent pick one style and stick with it.

cheers,
jamal
