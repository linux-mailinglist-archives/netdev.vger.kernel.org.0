Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B1320B27C
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 15:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgFZN2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 09:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgFZN2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 09:28:12 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C73C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 06:28:12 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id m8so256893qvk.7
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 06:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0EXd1vhnNtrSwXMMNlWHuNp7c+1ntiJGP1iRQU299gU=;
        b=Mvvrj24jfH5QmISu+fVAnHEZ4UZfa5swKApGEbK0SvSLKciMZg8UOQIPPF5lg9BXB+
         UNg37aMUhRFv/V+RNUYfpGodsz/5CCRzlIddf5u88FlP/OhxPyuQHjfaxhXXrpkAYqZR
         RPvfxFgOj6PO/MmHalHuO+iF9GbWGT7JTaSZZRRiJAy5xpcC6tN3qj8XhCRSF9YqLPWc
         P8FBEE5kfbOmLSGPRDNlNC/mEp4qZYcKx/Mv0jCziLbhPQoZgzba6zmt26TTY7OIGzef
         w9rfIdPwEyk7fseZrlgSeMsahvsn8NaaRjK2antdsxLY01ZS+nS3xH4oSMnO8tV18ILE
         XGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0EXd1vhnNtrSwXMMNlWHuNp7c+1ntiJGP1iRQU299gU=;
        b=WIt1qiKpA+s+2b/p++HAy3MnDY0N6311EnZlc5w3Cp3hf/0Y4NhK5bfVMRCPZuiQay
         iz2ecID5QRBoFE6bbN8hOYAoKA/N9E7D90jNMzmxUNrUPLm53vgXVpj2y6FTG57m+7A7
         kqcvIzPVkZ1rtMU1+27ANSIgMHw1DPractAxbRNceNuyv4PMtl0fKqUs4LkP5TBqWBA9
         x4ljNwh6JInXGUH6SCppx6qykaMtl0imHvJWE4Kd2zL/UQD1pnDmLVGe+vYOkS5Ff6Zr
         cgzs/rXZ8FN+zcw9EBob5uo8MM+hkgFHXxalkJEdZBfo7XztMi4OyXiBj0siFCRJnLTf
         9+UQ==
X-Gm-Message-State: AOAM5319FtYSr4b9YvviKYI2PioLc6PT/+qS2MQa0G8tbspQWElYCrVm
        LrpwqdryrsVJHiIe7KOA98KBRw==
X-Google-Smtp-Source: ABdhPJwwOoQhWPWx/VE3yv1GabHdfJhr3DZnb0oYKrL1gpTpCsPwqMSuLOa3IL7sbsM4AbM53+K/LQ==
X-Received: by 2002:a0c:8583:: with SMTP id o3mr446203qva.108.1593178091324;
        Fri, 26 Jun 2020 06:28:11 -0700 (PDT)
Received: from [192.168.1.117] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id r76sm7850870qka.30.2020.06.26.06.28.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 06:28:10 -0700 (PDT)
Subject: Re: [v1,net-next 3/4] net: qos: police action add index for tc flower
 offloading
To:     Po Liu <po.liu@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>
Cc:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "vlad@buslov.dev" <vlad@buslov.dev>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Edward Cree <ecree@solarflare.com>
References: <VE1PR04MB6496E5275AD00A8A65095DD192920@VE1PR04MB6496.eurprd04.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <05d6df9a-4e84-0e8d-0c4c-7f04cb18bb6a@mojatatu.com>
Date:   Fri, 26 Jun 2020 09:28:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <VE1PR04MB6496E5275AD00A8A65095DD192920@VE1PR04MB6496.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-24 8:34 p.m., Po Liu wrote:
> 
> 
>> -----Original Message-----

>> That is the point i was trying to get to. Basically:
>> You have a counter table which is referenced by "index"
>> You also have a meter/policer table which is referenced by "index".
> 
> They should be one same group and same meaning.
> 

Didnt follow. You mean the index is the same for both the
stat and policer?

>>
>> For policers, they maintain their own stats. So when i say:
>> tc ... flower ... action police ... index 5 The index referred to is in the
>> policer table
>>
> 
> Sure. Means police with No. 5 entry.
> 
>> But for other actions, example when i say:
>> tc ... flower ... action drop index 10
> 
> Still the question, does gact action drop could bind with index? It doesn't meanful.
> 

Depends on your hardware. From this discussion i am
trying to understand where the constraint is for your case.
Whether it is your h/w or the TSN spec.
For a sample counting which is flexible see here:
https://p4.org/p4-spec/docs/PSA.html#sec-counters

That concept is not specific to P4 but rather to
newer flow-based hardware.

More context:
The assumption these days is we can have a _lot_ of flows with a lot
of actions.
Then you want to be able to collect the stats separately, possibly one
counter entry for each action of interest.
Why is this important?f For analytics uses cases,
when you are retrieving the stats you want to reduce the amount of
data being retrieved. Typically these stats are polled every X seconds.
For starters, you dont dump filters (which in your case seems to be
the only way to get the stats).
In current tc, you dump the actions. But that could be improved so
you can just dump the stats. The mapping of stats index to actions
is known to the entity doing the dump.

Does that make sense?

>> The index is in the counter/stats table.
>> It is not exactly "10" in hardware, the driver magically hides it from the
>> user - so it could be hw counter index 1234
> 
> Not exactly. Current flower offloading stats means get the chain index for that flow filter. The other actions should bind to that chain index.
 >

So if i read correctly: You have an index per filter pointing to the
counter table.
Is this something _you_ decided to do in software or is it how the
hardware works? (note i referred to this as "legacy ACL" approach
earlier. It worked like that in old hardware because the main use
case was to have one action on a match (drop/accept kind).

>Like IEEE802.1Qci, what I am doing is bind gate action to filter chain(mandatory). And also police action as optional.

I cant seem to find this spec online. Is it freely available?
Also, if i understand you correctly you are saying according to this
spec you can only have the following type of policy:
tc .. filter match-spec-here .. \
action gate gate-action-attributes \
action police ...

That "action gate" MUST always be present
but "action police" is optional?

> There is stream counter table which summary the counters pass gate action entry and police action entry for that chain index(there is a bit different if two chain sharing same action list).
> One chain counter which tc show stats get counter source:
> struct psfp_streamfilter_counters {
>          u64 matching_frames_count;
>          u64 passing_frames_count;
>          u64 not_passing_frames_count;
>          u64 passing_sdu_count;
>          u64 not_passing_sdu_count;
>          u64 red_frames_count;
> };
>

Assuming psfp is something defined in IEEE802.1Qci and the spec will
describe these?
Is the filter  "index" pointing to one of those in some counter table?


> When pass to the user space, summarize as:
>          stats.pkts = counters.matching_frames_count +  counters.not_passing_sdu_count - filter->stats.pkts;
 >
>          stats.drops = counters.not_passing_frames_count + counters.not_passing_sdu_count +   counters.red_frames_count - filter->stats.drops;
>

Thanks for the explanation.
What is filter->stats?
The rest of those counters seem related to the gate action.
How do you account for policing actions?

cheers,
jamal

