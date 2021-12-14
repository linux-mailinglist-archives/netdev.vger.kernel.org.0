Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D124741EA
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhLNMBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbhLNMBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 07:01:19 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FD3C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 04:01:19 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id n15so18161877qta.0
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 04:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fIsbWftcK0jDxDvnpupyfQncuRa23RnCR/Pwuc1Ujr8=;
        b=KBGYX2AoPBkFJsxb12MikbkeyLy9OgFWQSJWJJihvnUJTJKABgZLFk9HCYUTdLlkqK
         rNDuvmfurtWmTt3eLuKolX1gIFkZ1j9S7RC9RY1lngkSm7Wl168yjT3AM4CJz+4j7aNp
         mXkapKwHuVNpNA2pqeI38L7gx7z8ExxiY++W+nuwcyWvjL5kIBQhJ32mwZH1pDf3SU7s
         wKzW8DFB3wcMia1D7kcwxss/0lFpemLGYXLeHFS/TsZcFWfkn6Gqua2xAwOCec82Fu/I
         1UrPW31XsD3BIgYOOO2xNMBKnFShvOWuvp3KzipcaKOmH7AOqZSYZv7O9I9zPNjQ01cA
         0QcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fIsbWftcK0jDxDvnpupyfQncuRa23RnCR/Pwuc1Ujr8=;
        b=oFjAI3AAT6GRpnNWJf5ym+PrFCIGpJ41m0/XyfUU4GYKOUA+i8ss1Uvq27l8op5SKF
         3tNZhrIPnKkg4fnj0pHdUN73gkF7tLFyBA2GJYtKtIw06xYWd9CZCZRJZOxYgA3Ixu+o
         HIQ4th5McdU2GItvowyYwzSbiQM+f2H3V6pcmzT3MI2sDG2PaqiCQ3IfFuLyNPjUEC74
         13J95Jfvhd04w+Y3FQJXseSenMKUdVLc76e7lrM98AHFbp/02HcE7ovWt8DoxvRBzv41
         1LDYl3PnufhqroHyuyBACYbPjWLFI1yqA6ANQD98HW27lxIOGr+2UWVhYlQoxyVCy5Lx
         3Mjw==
X-Gm-Message-State: AOAM532nEr4ZNm/C/X5QuL07ZvJv5YbO+PGTKsczKMCTUkbADIoaIS0t
        MsQ3wVfVDfKzyUGYfNVFFduRyA==
X-Google-Smtp-Source: ABdhPJy8FOspNCWPJk/fPKfZwt/1tqOGd6dh7vbZzzpE9grlsx/1RjRqRe4ow6AjLSkrydp7gumzNQ==
X-Received: by 2002:ac8:5a0b:: with SMTP id n11mr5230642qta.485.1639483277920;
        Tue, 14 Dec 2021 04:01:17 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id y20sm7769141qkj.24.2021.12.14.04.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 04:01:17 -0800 (PST)
Message-ID: <4a909bf2-a7a1-67f9-2d62-d6858d3553b9@mojatatu.com>
Date:   Tue, 14 Dec 2021 07:01:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 net-next 08/12] flow_offload: add process to update
 action stats from hardware
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
 <20211209092806.12336-9-simon.horman@corigine.com>
 <c03a786e-6d21-1d93-2b97-9bf9a13250ef@mojatatu.com>
 <DM5PR1301MB2172002C966B5CC41EA6537AE7739@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <DM5PR1301MB2172002C966B5CC41EA6537AE7739@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-12 04:00, Baowen Zheng wrote:
> On December 12, 2021 3:52 AM, Jamal Hadi Salim wrote:
>> On 2021-12-09 04:28, Simon Horman wrote:
>>> include/net/act_api.h |  1 +
>>>    include/net/pkt_cls.h | 18 ++++++++++--------
>>>    net/sched/act_api.c   | 34 ++++++++++++++++++++++++++++++++++
>>>    3 files changed, 45 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/include/net/act_api.h b/include/net/act_api.h index
>>> 7e4e79b50216..ce094e79f722 100644
>>> --- a/include/net/act_api.h
>>> +++ b/include/net/act_api.h
>>> @@ -253,6 +253,7 @@ void tcf_action_update_stats(struct tc_action *a,
>> u64 bytes, u64 packets,
>>>    			     u64 drops, bool hw);
>>>    int tcf_action_copy_stats(struct sk_buff *, struct tc_action *,
>>> int);
>>>
>>> +int tcf_action_update_hw_stats(struct tc_action *action);
>>>    int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
>>>    			     struct tcf_chain **handle,
>>>    			     struct netlink_ext_ack *newchain); diff --git
>>> a/include/net/pkt_cls.h b/include/net/pkt_cls.h index
>>> 13f0e4a3a136..1942fe72b3e3 100644
>>> --- a/include/net/pkt_cls.h
>>> +++ b/include/net/pkt_cls.h
>>> @@ -269,18 +269,20 @@ tcf_exts_stats_update(const struct tcf_exts *exts,
>>>    #ifdef CONFIG_NET_CLS_ACT
>>>    	int i;
>>>
>>> -	preempt_disable();
>>> -
>>>    	for (i = 0; i < exts->nr_actions; i++) {
>>>    		struct tc_action *a = exts->actions[i];
>>>
>>> -		tcf_action_stats_update(a, bytes, packets, drops,
>>> -					lastuse, true);
>>> -		a->used_hw_stats = used_hw_stats;
>>> -		a->used_hw_stats_valid = used_hw_stats_valid;
>>> -	}
>>> +		/* if stats from hw, just skip */
>>> +		if (tcf_action_update_hw_stats(a)) {
>>> +			preempt_disable();
>>> +			tcf_action_stats_update(a, bytes, packets, drops,
>>> +						lastuse, true);
>>> +			preempt_enable();
>>>
>>> -	preempt_enable();
>>> +			a->used_hw_stats = used_hw_stats;
>>> +			a->used_hw_stats_valid = used_hw_stats_valid;
>>> +		}
>>> +	}
>>>    #endif
>>>    }
>>
>> Sorry - didnt quiet follow this one even after reading to the end.
>> I may have missed the obvious in the equivalence:
>> In the old code we did the preempt first then collect. The changed version only
>> does it if tcf_action_update_hw_stats() is true.
> Hi Jamal, for this change, this is because for the function of tcf_action_update_hw_stats, it will try to retrieve hw stats fron hardware. But in he process of retrieving stats information, the driver may have
> Lock or other sleeping function. So we should not call tcf_action_update_hw_stats function in context of preempt_disable.

Still confused probably because this is one of those functions that
are badly named. Initially i thought that it was useful to call this
function for both offloaded vs non-offloaded stats. But it seems it is
only useful for hw offloaded stats? If so, please consider a patch for
renaming this appropriately for readability.

Regardless, two things:

1) In the old code the last two lines
+			a->used_hw_stats = used_hw_stats;
+			a->used_hw_stats_valid = used_hw_stats_valid;
inside the preempt check and with this they are outside.

This is fine if the only reason we have this function is for h/w
offload.

2) You introduced tcf_action_update_hw_stats() which also does preempt
disable/enable and seems to repeat some of the things you are doing
as well in this function?

> Actually, since there is no vendor to support update single action stats from hardware, so it is not obvious, we will post our implement support after these patches set.
> Do you think if it make sense?

Since you plan to have more patches:
If it doesnt affect your current goals then i would suggest you
leave it to later. The question is, with what you already have
in this patchset, do we get something functional and standalone?

cheers,
jamal





>> cheers,
>> jamal

