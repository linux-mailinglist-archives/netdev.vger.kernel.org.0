Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F76440EAD
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 14:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhJaNdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 09:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhJaNdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 09:33:21 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCD8C061570
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 06:30:49 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id o12so2876723qtv.4
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 06:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=So1bL0UEa6GDc6fo1EpsF+WgQxYK4sxvh//Ool56LaI=;
        b=W3gwlrjIPop6JTq1nzbnGESzqOA9sFEZC7gD18Sdw9rsgirbs5ViP7esoUR93YvycP
         QdwacRhljAIT7WtH3QKd5yJkr/nPLeUuTI+ZE+KMvy9JWJqU+P1vOuxslEN0ISzaaGUV
         AvlbFK1+RKiMmKaXeD1wSrl1feaMqb18TnvjR6TfII0XEtSufPYm9nIAdBDpeNj/eLgj
         oSIDcxlNl0p13CXZ4yQS8moZt5lVoC1gYx3aHRv5d7wB5aEx0iUGS+iBWkdx2V4FEouN
         j3hHV+AKCeZIp2VrhviioVuk9eKnuJ7UflRvGHMsOUV+682QeY6oI142htnKXHFt/0rn
         aPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=So1bL0UEa6GDc6fo1EpsF+WgQxYK4sxvh//Ool56LaI=;
        b=id89KQ6gSURq19jN2VCcdqg4bpGf4z+YApFUX+LduPu3EadGSHZdAZL3zB5hBgF36E
         RKyw39tCFtApJgGWZLxjLKkYJyuMLnSpYQzEQVcOEWRYnn7Ck7GYS9gPwmBr/v1I3xdQ
         IP8wIlvV30mV99rwsiQEx+7CGt16TSkpWsU39S0PvAOq6ZELTjkFJbCLd2/6J7l9Imz7
         XA/hAxnGC4rpHzbQT/JeuOYpKU6vilPJQDPKpIiksTfB8HDVhLntH9YjfB0GKmvTIISn
         m4D+xJ6mh4DPCZOccvI2ZW3c39TXX9yzZCUhdLaP+ZrAM5qua1AJQ5SxdZs/dmbh6E6n
         T2ig==
X-Gm-Message-State: AOAM533IzIT4WHdNz7JOzP8/VhxGRoJPYKKwtEneVaOFw+/X1jXhKiaJ
        dDuztxjGAO/S4iuUiCbxH7I7zw==
X-Google-Smtp-Source: ABdhPJyT0VI7ZtojSJX3y5u/B5sduO5CnfoCCMUyCs9CrRiC1e1w7YPPOOjamxkiBzdAyLzcvi0xLw==
X-Received: by 2002:ac8:11:: with SMTP id a17mr23025893qtg.276.1635687048535;
        Sun, 31 Oct 2021 06:30:48 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id n3sm5333366qkp.112.2021.10.31.06.30.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 06:30:47 -0700 (PDT)
Message-ID: <d16042e3-bc1e-0a2b-043d-bbb62b1e68d7@mojatatu.com>
Date:   Sun, 31 Oct 2021 09:30:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
 <7147daf1-2546-a6b5-a1ba-78dfb4af408a@mojatatu.com>
 <ygnhfssia7vd.fsf@nvidia.com>
 <DM5PR1301MB21722A85B19EE97EFE27A5BBE7899@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <DM5PR1301MB21722A85B19EE97EFE27A5BBE7899@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-30 22:27, Baowen Zheng wrote:
> Thanks for your review, after some considerarion, I think I understand what you are meaning.
> 

[..]

>>>> I know Jamal suggested to have skip_sw for actions, but it complicates
>>>> the code and I'm still not entirely understand why it is necessary.
>>>
>>> If the hardware can independently accept an action offload then
>>> skip_sw per action makes total sense. BTW, my understanding is
>>
>> Example configuration that seems bizarre to me is when offloaded shared
>> action has skip_sw flag set but filter doesn't. Then behavior of
>> classifier that points to such action diverges between hardware and
>> software (different lists of actions are applied). We always try to make
>> offloaded TC data path behave exactly the same as software and, even
>> though here it would be explicit and deliberate, I don't see any
>> practical use-case for this.
> We add the skip_sw to keep compatible with the filter flags and give the user an
> option to specify if the action should run in software. I understand what you mean,
> maybe our example is not proper, we need to prevent the filter to run in software if the
> actions it applies is skip_sw, so we need to add more validation to check about this.
> Also I think your suggestion makes full sense if there is no use case to specify the action
> should not run in sw and indeed it will make our implement more simple if we omit the
> skip_sw option.
> Jamal, WDYT?


Let me use an example to illustrate my concern:

#add a policer offload it
tc actions add action police skip_sw rate ... index 20
#now add filter1 which is offloaded
tc filter add dev $DEV1 proto ip parent ffff: flower \
     skip_sw ip_proto tcp action police index 20
#add filter2 likewise offloaded
tc filter add dev $DEV1 proto ip parent ffff: flower \
     skip_sw ip_proto udp action police index 20

All good so far...
#Now add a filter3 which is s/w only
tc filter add dev $DEV1 proto ip parent ffff: flower \
     skip_hw ip_proto icmp action police index 20

filter3 should not be allowed.

If we had added the policer without skip_sw and without
skip_hw then i think filter3 should have been legal
(we just need to account for stats in_hw vs in_sw).

Not sure if that makes sense (and addresses Vlad's earlier
comment).


cheers,
jamal
