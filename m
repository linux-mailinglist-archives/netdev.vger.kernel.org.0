Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEA04F8A20
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 00:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiDGVSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 17:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbiDGVSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 17:18:02 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12C2188550
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 14:16:00 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id z19so9238630qtw.2
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 14:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :references:from:to:in-reply-to:content-transfer-encoding;
        bh=oeyG19HYe7Mo/vaGJu1xhS27Ep9wslIug5Y1GH6cQZ0=;
        b=wR5pIMW4cYgEMZQV3CQNinOSZjJ/lxBR94lRTGJM8HUMTdIyQFD2rnu5VnaTEIWTWd
         ePlm81/JnpGby1MdC4c+QSLq7Za166xmY1ltNrPjtdWc1SEcpkhh6E587UNruCWZ83I8
         Ft1oNURVTnR9oRXkRjQv3RWM7I6+1dckYf/Gt7K4AJ4YMWuNUY9wLOXHQfe/IsJ4m3Iz
         cKYlo2N/198yAAYfVSf0hiwBqaBxmuIYsexdXL00skJdrm4cknWWknuzerTmOKKGNE8p
         Ot96eyhRoVqxqNJ5/DUma7dRtXLg6jbe9h3A/HFbz4HPx7aIxmOz+tP7hG+fYAslullL
         6TCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:references:from:to:in-reply-to
         :content-transfer-encoding;
        bh=oeyG19HYe7Mo/vaGJu1xhS27Ep9wslIug5Y1GH6cQZ0=;
        b=6yCpQ5hcPkskR7QURfBPbFlMaDB3iUKWglWxJ56Bz66Z8MmTH8XNjKZytTTgUXNRkO
         Oi6XkfdoB/bdkOnx7XKC9g8TIozodsnhlBsMMTIqcc9Vcb9PMJUB5H4kFsqqI3R+l1DR
         wOrLhUnW9p8iqLBmFV4UXjRzZSwTaOJnwvrSH8po2hQzk6wGBv0ZQfF+iaKTtHW8vfvg
         oggJ0AQs72CgNvGQoET1qxM8Isx1WqncwBEamcVWUIAYbGAQNN3FTyuBk3G6/lXoIrSu
         CdISabQVRB12ZpzlNjXICUv2Pd8jrvo98EVTHrrSChGwQOg96LfmLtIFcm4Vbj8tWq8v
         Q45w==
X-Gm-Message-State: AOAM531CEelgT7CcZK+vlncTti6TUP5ECpwJECtkK95vY//pnX2eIQv9
        YpfoKWMVHtIy9czWbUX7YSqQc2Wvg+Q6yg==
X-Google-Smtp-Source: ABdhPJxPSLwE6zsMofB16qi93WB59jYugvry8n+eGI5Oqk5J01Mhc7Ai2V83UhfPh0Hj0m9zz4QnAA==
X-Received: by 2002:ac8:7e81:0:b0:2eb:8e71:93d9 with SMTP id w1-20020ac87e81000000b002eb8e7193d9mr13452733qtj.516.1649366160106;
        Thu, 07 Apr 2022 14:16:00 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-25-174-95-97-66.dsl.bell.ca. [174.95.97.66])
        by smtp.googlemail.com with ESMTPSA id bm1-20020a05620a198100b0047bf910892bsm13892838qkb.65.2022.04.07.14.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 14:15:59 -0700 (PDT)
Message-ID: <8d103ac8-2433-f2ab-522c-9316445e3a31@mojatatu.com>
Date:   Thu, 7 Apr 2022 17:15:58 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 00/14] net/sched: Better error reporting for
 offload failures
Content-Language: en-US
References: <20220407073533.2422896-1-idosch@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     undisclosed-recipients:;
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Excellent work.

Small comment, maybe a better message is:
"Failed to setup offload flow action"?

cheers,
jamal

On 2022-04-07 03:35, Ido Schimmel wrote:
> This patchset improves error reporting to user space when offload fails
> during the flow action setup phase. That is, when failures occur in the
> actions themselves, even before calling device drivers. Requested /
> reported in [1].
> 
> This is done by passing extack to the offload_act_setup() callback and
> making use of it in the various actions.
> 
> Patches #1-#2 change matchall and flower to log error messages to user
> space in accordance with the verbose flag.
> 
> Patch #3 passes extack to the offload_act_setup() callback from the
> various call sites, including matchall and flower.
> 
> Patches #4-#11 make use of extack in the various actions to report
> offload failures.
> 
> Patch #12 adds an error message when the action does not support offload
> at all.
> 
> Patches #13-#14 change matchall and flower to stop overwriting more
> specific error messages.
> 
> [1] https://lore.kernel.org/netdev/20220317185249.5mff5u2x624pjewv@skbuf/
> 
> Ido Schimmel (14):
>    net/sched: matchall: Take verbose flag into account when logging error
>      messages
>    net/sched: flower: Take verbose flag into account when logging error
>      messages
>    net/sched: act_api: Add extack to offload_act_setup() callback
>    net/sched: act_gact: Add extack messages for offload failure
>    net/sched: act_mirred: Add extack message for offload failure
>    net/sched: act_mpls: Add extack messages for offload failure
>    net/sched: act_pedit: Add extack message for offload failure
>    net/sched: act_police: Add extack messages for offload failure
>    net/sched: act_skbedit: Add extack messages for offload failure
>    net/sched: act_tunnel_key: Add extack message for offload failure
>    net/sched: act_vlan: Add extack message for offload failure
>    net/sched: cls_api: Add extack message for unsupported action offload
>    net/sched: matchall: Avoid overwriting error messages
>    net/sched: flower: Avoid overwriting error messages
> 
>   include/net/act_api.h           |  3 ++-
>   include/net/pkt_cls.h           |  6 ++++--
>   include/net/tc_act/tc_gact.h    | 15 +++++++++++++++
>   include/net/tc_act/tc_skbedit.h | 12 ++++++++++++
>   net/sched/act_api.c             |  4 ++--
>   net/sched/act_csum.c            |  3 ++-
>   net/sched/act_ct.c              |  3 ++-
>   net/sched/act_gact.c            | 13 ++++++++++++-
>   net/sched/act_gate.c            |  3 ++-
>   net/sched/act_mirred.c          |  4 +++-
>   net/sched/act_mpls.c            | 10 +++++++++-
>   net/sched/act_pedit.c           |  4 +++-
>   net/sched/act_police.c          | 20 ++++++++++++++++----
>   net/sched/act_sample.c          |  3 ++-
>   net/sched/act_skbedit.c         | 10 +++++++++-
>   net/sched/act_tunnel_key.c      |  4 +++-
>   net/sched/act_vlan.c            |  4 +++-
>   net/sched/cls_api.c             | 22 ++++++++++++++--------
>   net/sched/cls_flower.c          | 14 ++++++--------
>   net/sched/cls_matchall.c        | 19 +++++++------------
>   20 files changed, 128 insertions(+), 48 deletions(-)
> 

