Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B28E5E07
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 18:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfJZQGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 12:06:47 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:41298 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbfJZQGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 12:06:46 -0400
Received: by mail-il1-f196.google.com with SMTP id z10so4437125ilo.8
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 09:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XbAlVrQ1JACbQeQAS/KFKRh8j9Pjo5OIo+Yf4ivKFWk=;
        b=coms5gp1JAQG8QfJpzYaZEHkAs1yvvfPN0SEgUYVmkHu2S7rOmSWudge4/P3Zx5fP2
         7hGOTyCWH8S8BG6rSdFvloKB3wsc0zBm9BS4n+qbHBNzgHggRXqtg8X7DUYI2UUH3wdo
         6xx2eXgxwaXUnx+tPsPDWz7GfwP00oNwKVr/vUG4W3HHSUblPTS6x5abZ8bskGfduGwi
         LM1A/rvqsScFO3HSFFyRJNNO5rzc8LNZ6vwGIL2ownFXlX6/ht1ElqP3ibeTJTXy8swj
         boEuQLYsvZTIr2UrIp/7dXMrlKGxHWEaw70fOl8uODwLkWfZQlEf7glbdUKuzNYpE4Da
         HxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XbAlVrQ1JACbQeQAS/KFKRh8j9Pjo5OIo+Yf4ivKFWk=;
        b=rt3hQ0aogUjRcwlrcBjO4fIlEy+ks6yy47O1dsQ28fskBENLfRsTRe1uMQS31LOy0w
         HZGOi4K+32vUDODOuznAfNuiHsRPrCsBPgcnQ92orr+F5UpjUCL+vKxXvXmbuahK7tTs
         KNMYqihCP0LpZHjNShAGCsoRTtetkbIerRwTRxI9OJz2D2N8G7OiiuQ6whe1+CAkg2tE
         Oeq9Ng+zOn/bnoxGWFbk2mVNu0/rRrbXkTAczYy2+v5+9Cr3YA9ZcHP4wRQf/3x6Hh11
         FAeW3UJy3o7JhAZhtkCyK/m2qK/AkArQjtFNnOSnaKdpjlE4+9rBv0GLLzpkiT5yW4u9
         ZMVA==
X-Gm-Message-State: APjAAAWUYGU5cWNnodR0DSx4Uhi2wC4BFYzBCLSTcVNIUFnAfTx6ndFb
        SjNzCwUxfVgFhcPSZU8JBTZxTg==
X-Google-Smtp-Source: APXvYqzWVa9Z2fY72NMQcbyeUcemZoR5L1lK9wL40DVqadFeFp/cK4c4z3J5Tho33cyeK8v4iUzlIQ==
X-Received: by 2002:a92:9843:: with SMTP id l64mr10247874ili.154.1572106005996;
        Sat, 26 Oct 2019 09:06:45 -0700 (PDT)
Received: from [192.168.0.124] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id c83sm399183iof.48.2019.10.26.09.06.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Oct 2019 09:06:44 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbftv7wuciu.fsf@mellanox.com>
 <fab8fd1a-319c-0e9a-935d-a26c535acc47@mojatatu.com>
 <48a75bf9-d496-b265-bdb7-025dd2e5f9f9@mojatatu.com>
 <vbfsgngua3p.fsf@mellanox.com>
 <7488b589-4e34-d94e-e8e1-aa8ab773891e@mojatatu.com>
 <43d4c598-88eb-27b3-a4bd-c777143acf89@mojatatu.com>
 <vbfpniku7pr.fsf@mellanox.com>
 <07a6ceec-3a87-44cb-f92d-6a6d9d9bef81@mojatatu.com>
 <vbfmudou5qp.fsf@mellanox.com>
 <894e7d98-83b0-2eaf-000e-0df379e2d1f4@mojatatu.com>
 <d2ec62c3-afab-8a55-9329-555fc3ff23f0@mojatatu.com>
 <710bf705-6a58-c158-4fdc-9158dfa34ed3@mojatatu.com>
 <fcd34a45-13ac-18d2-b01a-b0e51663f95d@mojatatu.com>
 <vbflft7u9hy.fsf@mellanox.com>
 <517f26b9-89cc-df14-c903-e750c96d5713@mojatatu.com>
 <85eeyzk185.fsf@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <2e0f829f-0059-a5c6-08dc-a4a717187e1a@mojatatu.com>
Date:   Sat, 26 Oct 2019 12:06:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <85eeyzk185.fsf@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-26 10:52 a.m., Roman Mashak wrote:
[..]
> 
> But why do we need to have two attributes, one at the root level
> TCA_ROOT_FLAGS and the other at the inner TCA_ACT_* level, but in fact
> serving the same purpose -- passing flags for optimizations?
> 
 >
> The whole nest of action attributes including root ones is passed as 3rd
> argument of tcf_exts_validate(), so it can be validated and extracted at
> that level and passed to tcf_action_init_1() as pointer to 32-bit flag,
> admittedly it's ugly given the growing number of arguments to
> tcf_action_init_1(). With old iproute2 the pointer will always be NULL,
> so I think backward compatibilty will be preserved.

Note: we only call tcf_action_init_1() at that level for very
old policer api for backward compatibility reasons. I think what
would make sense is to be able to call tcf_action_init()(the else
statement in tcf_exts_validate()) from that level with a global flag
but for that we would need to introduce something like TCA_ROOT_FLAGS
under this space:
---
enum {
         TCA_UNSPEC,
         TCA_KIND,
         TCA_OPTIONS,
         TCA_STATS,
         TCA_XSTATS,
         TCA_RATE,
         TCA_FCNT,
         TCA_STATS2,
         TCA_STAB,
         TCA_PAD,
         TCA_DUMP_INVISIBLE,
         TCA_CHAIN,
         TCA_HW_OFFLOAD,
         TCA_INGRESS_BLOCK,
         TCA_EGRESS_BLOCK,
         __TCA_MAX
};
---

which would be a cleaner solution but would require
_a lot more code_ both in user/kernel.
Thats why i feel Vlad's suggestion is a reasonable compromise
because it gets rid of the original issue of per-specific-action
TLVs.

On optimization:
The current suggestion from Vlad is a bit inefficient,
example, if was trying to batch 100 actions i now have 1200
bytes of overhead instead of 12 bytes.

cheers,
jamal
