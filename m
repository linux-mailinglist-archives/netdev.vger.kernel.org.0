Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177F54741F7
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbhLNMDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbhLNMDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 07:03:48 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B88EC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 04:03:48 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id i12so17007619qvh.11
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 04:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UumhFm7++mBZjjAQ0qrzJ8KHKZjkhzN3MNl1yll+l04=;
        b=ve5yb88BLUAPLDhb/0Qf0Rt+x5CpGe5jPHmACFSxBzWkaEnQo+x9VxZEoV1GUGGOa3
         Rs5bbhITZkuQ2CZmoUDJrQQWGGvO9V5Wy7aYggZgp9joMWiWR/px75l4pgO5V7tjjJtY
         SEZYAq8wqLXWaTS/kjS7FJkyoYyerwEYe6XGsx0f3D0rDgagJjgiMQi9GiSOYdBD8Zzr
         4zSG46wbbP38CHvV9JLo4SPPmgoD4VEy7eXbOHsyoW+ZXFn9UtLucrkm3FQMgaBu+0MM
         2bIBS1B+wMg6hKcpqleaXEoCx2C6gqbsT+mN67cE2ddoO4/idWqiJli04mGlJJgallGt
         e9Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UumhFm7++mBZjjAQ0qrzJ8KHKZjkhzN3MNl1yll+l04=;
        b=5E1yAWp8i4YgZyDSeYuJk2+Yc+RUTUFqqBOKeVlp9bNPXrZ/41BYokzC/ncWLA3BQG
         I13Kek0k88OY/DNLAJZ9QVAHnF84nSqqpis4puANBtbgS+YojpTV33t1e8lnmkKxcMLA
         KJAFy/tSq2vGG7bUgxB0mUI7wEV0LAAy4sfoSmto14Bv+Wy5VpVar2gcPDJDx6SzaYoy
         Njqyj5RwOfXrA3GON9Bt6BVHRu3GiCmg+tlBVam80oeFKqJiNEvFq2FqBu62az21LL92
         lVmAnsRYIrEUojI0MsACTAdwGI6WgKqdKlvOrEl+x6LtcvexKBu7He1k2uM8/abI+s49
         fcQA==
X-Gm-Message-State: AOAM530EKy0wvJt0AxIru/r/Z1LFXF8Ct2qP3s9j3cjKy6w89TFRIjc7
        stlZPPzuCmPFJ29F4uHzE/Rm6A==
X-Google-Smtp-Source: ABdhPJxEq66gsLS0j5h5N9YHE2ZTyevGPS8ibJ9IXAyzfICmN17I8pcfXQJ/C2Ojw3LAvYlxpNeZBg==
X-Received: by 2002:ad4:5f0f:: with SMTP id fo15mr4909139qvb.129.1639483427694;
        Tue, 14 Dec 2021 04:03:47 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id az14sm7570458qkb.97.2021.12.14.04.03.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 04:03:47 -0800 (PST)
Message-ID: <6301cf08-b370-665e-5509-146f4cd692a2@mojatatu.com>
Date:   Tue, 14 Dec 2021 07:03:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 net-next 06/12] flow_offload: allow user to offload tc
 action to net device
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <20211209092806.12336-7-simon.horman@corigine.com>
 <a262c1ba-27e4-25cb-460c-c168a938f70e@mojatatu.com>
 <DM5PR1301MB2172DE0606380ADBFE6FCCE2E7739@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <DM5PR1301MB2172DE0606380ADBFE6FCCE2E7739@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-12 04:22, Baowen Zheng wrote:
> On December 12, 2021 3:42 AM, Jamal Hadi Salim wrote:
>> On 2021-12-09 04:28, Simon Horman wrote:
>>> From: Baowen Zheng <baowen.zheng@corigine.com>
>>
>>
>>>
>>>    /* These structures hold the attributes of bpf state that are being
>>> passed diff --git a/include/net/flow_offload.h
>>> b/include/net/flow_offload.h index f6970213497a..15662cad5bca 100644
>>> --- a/include/net/flow_offload.h
>>> +++ b/include/net/flow_offload.h
>>> @@ -551,6 +551,23 @@ struct flow_cls_offload {
>>>    	u32 classid;
>>>    };
>>>
>>> +enum flow_act_command {
>>
>> Readability:
>> flow_offload_act_command?
> Ok, we will make the change.
> maybe it is more proper for "offload_act_command " as we discussed in previous patch?

Ok.


>>
>> mention offload somewhere there?
> For this function of tcf_action_cleanup, it is not only related to offload process, it will also recycle resource for the software action.
> So it is better to keep it as it is now?

make sense - agreed with what you say.


cheers,
jamal
