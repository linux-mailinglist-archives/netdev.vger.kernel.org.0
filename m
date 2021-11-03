Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFF3444333
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhKCOSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbhKCOSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 10:18:41 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D82C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 07:16:04 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id i13so3060188qvm.1
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 07:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=96NMyOf7Xc+DLK0TeMLRjGLyxB8JUgSNfA9KpevCXFM=;
        b=2esqIm8LdDCm0oXUovnNfFFULcE1T5xrMfP5djibtkrUmV7LTc1epBfHTXJengLlw4
         O11150f+huMAMKpIddon7EEoOB9YdOdm392B9T22/zkbqN09fur4pYCCJsF217gTm3fI
         0e13IT3+pSHtTmelCQs2tNMYKe7eMEP15Y2wlGDeVM2BBbdQTJnrMGmVpAQ8kOIXcd2u
         6e3ZF31E7aZ2ZjPh+cRN4FBXnRXvHrIOXfwRmDOsZz6Ttfas9IlF7w+AnArJa79MCpSf
         X1GSB6htRaSL5K8sXj4Z9UBdwx8R8WwT/ubFB8iB0O0vmPEhs8aMpYQtsXqcR3SyKqs0
         Ax2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=96NMyOf7Xc+DLK0TeMLRjGLyxB8JUgSNfA9KpevCXFM=;
        b=3uLlgvNkUrgWf99hVx563fG3/zbk0OmXiHz+sdWtMs2EGoeiH9hsY0e5yK0YdNZ3eW
         GkZbG8Mj52A7qE3Bi/TkK53YeSS26TZnbZ/bDNKla9QJ0EExwmuDACy+eU3Xd4S2qX4m
         wo3Acd8W3t8R3wMHt2crILzH1Hvik4zLZVVx9SoP74DYHfUatoMungJffUt4OaBIOMj3
         LWBE6bjnF2flRh+oILd08GxYjBNlITkF3u33Sf0ji/4x/lehQeAj7Jh7iYXbBtSTcJu0
         x0Mq9JJ7F1OJ7X49SK9ipOAyrCfJRoZtTQQyHLuolILthKrePBH5mcpJ3YBx8So7PWlY
         3uWA==
X-Gm-Message-State: AOAM530f0GLa7qMecWzIVPdCj8tAKFTVNCTKjZtr1PJFqdBYhe5w4D83
        bNn+TXujl/fD+ZXEM94KLxMxcQ==
X-Google-Smtp-Source: ABdhPJyn9Mry059NLfcxfyEQpunCO67H6HDqogAM1i5w3rNfHtpHskMH1Hzv1qEmCYuVG/fxUK5f8Q==
X-Received: by 2002:a05:6214:ccc:: with SMTP id 12mr7128051qvx.8.1635948963768;
        Wed, 03 Nov 2021 07:16:03 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id p16sm1059009qtx.92.2021.11.03.07.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 07:16:03 -0700 (PDT)
Message-ID: <cd624f2b-a693-84eb-d3f4-81d869caad93@mojatatu.com>
Date:   Wed, 3 Nov 2021 10:16:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>,
        Oz Shlomo <ozsh@nvidia.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
 <7147daf1-2546-a6b5-a1ba-78dfb4af408a@mojatatu.com>
 <ygnhfssia7vd.fsf@nvidia.com>
 <DM5PR1301MB21722A85B19EE97EFE27A5BBE7899@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <d16042e3-bc1e-0a2b-043d-bbb62b1e68d7@mojatatu.com>
 <DM5PR1301MB21728931E03CFE4FA45C5DD3E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <ygnhcznk9vgl.fsf@nvidia.com> <20211102123957.GA7266@corigine.com>
 <DM5PR1301MB2172F4949E810BDE380AF800E78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <428057ce-ccbc-3878-71aa-d5926f11248c@mojatatu.com>
 <DM5PR1301MB2172AD191B6A370C39641E3FE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <66f350c5-1fd7-6132-3791-390454c97256@mojatatu.com>
 <10dae364-b649-92f8-11b0-f3628a6f550a@mojatatu.com>
 <DM5PR1301MB2172BFF79D57D28F34DC6A0AE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <DM5PR1301MB2172BFF79D57D28F34DC6A0AE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-03 10:03, Baowen Zheng wrote:
> Thanks for your reply.
> On November 3, 2021 9:34 PM, Jamal Hadi Salim wrote:
>> On 2021-11-03 08:33, Jamal Hadi Salim wrote:
>>> On 2021-11-03 07:30, Baowen Zheng wrote:
>>>> On November 3, 2021 6:14 PM, Jamal Hadi Salim wrote:


[..]

> Sorry for more clarification about another case that Vlad mentioned:
> #add a policer action with skip_hw
> tc actions add action police skip_hw rate ... index 20
> #Now add a  filter5 which has no flag
> tc filter add dev $DEV1 proto ip parent ffff: flower \
>         ip_proto icmp action police index 20
> I think the filter5 could be legal, since it will not run in hardware.
> Driver will check failed when try to offload this filter. So the filter5 will only run in software.
> WDYT?
> 

I think this one also has ambiguity. If the filter doesnt specify 
skip_sw or skip_hw it will run both in s/w and h/w. I am worried if
that looks suprising to someone debugging after because in h/w
there is filter 5 but no policer but in s/w twin we have filter 5
and policer index 20.
It could be design intent, but in my opinion we have priorities
to resolve such ambiguities in policies.

If we use the rule which says the flags have to match exactly then we
can simplify resolving any ambiguity - which will make it illegal, no?

cheers,
jamal
