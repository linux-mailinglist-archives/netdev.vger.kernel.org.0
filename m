Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CCB299784
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 20:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbgJZT4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 15:56:16 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38242 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729186AbgJZT4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 15:56:15 -0400
Received: by mail-qk1-f194.google.com with SMTP id j129so5754309qke.5
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 12:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=myi+UgE+tV47/eVLLY42g8vUd6T1A0Z/mO7cLUcXECM=;
        b=i6r8ZOMfy9EV3aUSorPhtI0+PnHO0qI2pDfaa/G1Xx9UuWgZAVtF/9NzEDdUwqRbOH
         RxlyF/YU2gFKn2uGEnPpVfsMqKg+ZEacVbzW+0SXbLag/YXM96XjMpxKzj8K3IEskqjF
         QzGl4ToJNmR6rB2kmU31J3JwdC4Gqv37CB8w7XhZGgDzFYW9lHxLYQp75vpHivGPEJ50
         vLyO5l+wam+cnDBVgq+vYN+yR83Ymy7AuIig56nkOQ69Byvg64tIO8AmKtrSit6/daQi
         KYn/86rhF98HZo/oIoDyIfuSqA8Z21/6BPgCn1+VStx28MuH8+86GIrfHlKmPo6/vOIO
         Oz8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=myi+UgE+tV47/eVLLY42g8vUd6T1A0Z/mO7cLUcXECM=;
        b=d8RxxfOqH0eRR0xdDuyvAMcIhgze+CWZLAMh8qfPu9Oob9IZRa0J0Q6aeMyAxCQEmp
         KqNCpb/gnPgmvCQtarlUTR4vSRLVFr0Y+tkQjbZ+i01S27OP6qzyeEsKOGGbZdxLY44O
         HgLAx9UicmRGHcNZA25hc1BiULrQbNfXpM5H64pvInaOSSPQYsDjeo6xwgsyytWxqHxP
         +e30NzE83fkOXWpFZIVgy69/X8CEcFr+6HE6RT+yb98WieSr17RBNSnF8YqYsxPOvnSE
         oraOpAR91wVkruWELxKK4PtGkp+u+E6dL/cTmzVe7Tp0dBxSrWM1VPFkXueEdgmDq0cz
         hkKg==
X-Gm-Message-State: AOAM530GUi1ax6d2t+AhETqAq45EpkCX78qyvnoKfvSDO5r1mTOj9gZh
        2RqlSCTjRhdFFXlr5LecF2sYHg==
X-Google-Smtp-Source: ABdhPJx475khrTJHxPiQmspqXvzyMozUyLIBjLApkFTNfe1s3vYxxsuTTzvaorU2D4AUKvDi/4C13w==
X-Received: by 2002:a37:a992:: with SMTP id s140mr2531498qke.48.1603742173819;
        Mon, 26 Oct 2020 12:56:13 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id b23sm7258708qkh.68.2020.10.26.12.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 12:56:12 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Vlad Buslov <vlad@buslov.dev>, dsahern@gmail.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        davem@davemloft.net, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
References: <20201016144205.21787-1-vladbu@nvidia.com>
 <20201016144205.21787-3-vladbu@nvidia.com>
 <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com>
 <87a6wm15rz.fsf@buslov.dev>
 <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com>
 <877drn20h3.fsf@buslov.dev>
 <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com>
 <87362a1byb.fsf@buslov.dev>
 <5c79152f-1532-141a-b1d3-729fdd798b3f@mojatatu.com>
 <ygnh8sc03s9u.fsf@nvidia.com>
 <e91b2fe6-e2ca-21c7-0d7e-714e5cccc28c@mojatatu.com>
 <ygnh4kml9kh3.fsf@nvidia.com>
 <89a5434b-06e9-947a-d364-acd2a306fc4d@mojatatu.com>
 <ygnh7drdz0nf.fsf@nvidia.com>
 <370dd8e0-315b-04a5-c137-3b4f3cbd02a0@mojatatu.com>
 <ygnhwnzc6ft5.fsf@nvidia.com>
 <940495a7-d828-7439-a9c3-1e3bde6b02fb@mojatatu.com>
 <ygnhtuug6f02.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <a2bd35e6-b444-a317-e4b3-e383f5ba44c1@mojatatu.com>
Date:   Mon, 26 Oct 2020 15:56:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <ygnhtuug6f02.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-26 2:03 p.m., Vlad Buslov wrote:
> 
> On Mon 26 Oct 2020 at 20:01, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> On 2020-10-26 1:46 p.m., Vlad Buslov wrote:
>>>

>> yeah, something like TCA_ACT_FLAGS_TERSE.
>>
>> new tcf_action_dump_terse() takes one more field which says to
>> include or not the cookies since that is shared code and filters
>> can always include it.
>> The action index is already present in the passed tc_action
>> struct just needs a new TLV.
> 
> Sure, I'll try to find time this week.


Thank you!

cheers,
jamal

