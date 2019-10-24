Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE12E2B38
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 09:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408652AbfJXHgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 03:36:02 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37246 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727635AbfJXHgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 03:36:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id q130so1308567wme.2
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 00:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MP0k9oqLKo2MXql7ty87azfN4eOTLFzoHZI7hoeMdvc=;
        b=NNSejzb4eR3GHLC/JNZuQcBQ/Zlm4fcxufJee63HiZHqvByCDVrSYX6ynmJUS1Vlri
         swepfXtEx0dUmpUFu2U0HjfILEI/FnJX3O/D0lwJqRocpKTCty58EpxyqSTYQeQDmp3U
         gQxwJrMeqdVorPsAyRRok/cZPSgBaSMFR4geWheyRAo9LSqUvVTS/grH0wR4hdfs3GhK
         BU7aPby03zHrdw/uGY206JyEqdVcvgtdBF7ui5AZsaH4M4YE9edRHYTqUb7QyvDrqmRG
         4v6WmdPD1jEXuJhPhunIIRDkNQ5dboU/0KF9VxN6Eby4aVw+cmwR1lFIf03UVpxDxWgC
         NZfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MP0k9oqLKo2MXql7ty87azfN4eOTLFzoHZI7hoeMdvc=;
        b=l+WJ80JzjzywGHbimwCLZvEMX2V60pJJXhmDCXGBP7XMpIFH4+omoxvB7jPLCx14CH
         ohQwBC6FkwliT5c8DWLqXE6Cn9U1RMrARejxS4gLsQvAVhHWfFqjjRxpg+ZuXnRusyD6
         3WoG18ZsBW8IRLp/+B8/wGFTVMa794vN38AwIvX1aquy641vrPngnywOAwocyBzBW16P
         8/xEsEMjm/LJuxcnmrxSQqheGwSNVXxpR5JmRIO7xy2wL7ORkFoTEQlR95QdzIAEvXOD
         i36CMXLaI8PJiX+DBq88zZ2A66sJjcqYA/c84gBt8PXBXjcrjDg/hpAqdlyIY93DUIxn
         AnRQ==
X-Gm-Message-State: APjAAAXc/WbJ62Us7NTWtb3Xvuzj6QdQDFIZBofU74bbUPYzDo4ll7py
        inWHWVxS7L3H81UN2F5m5BZ1UQ==
X-Google-Smtp-Source: APXvYqz6LFfaxH3Sx7spSVp+Q0/tgPv2uBUnZshbDHE6mTa2V5f/oY0BwjHCivTkwwv0VuqXfNKNOQ==
X-Received: by 2002:a1c:4d14:: with SMTP id o20mr3626561wmh.7.1571902558417;
        Thu, 24 Oct 2019 00:35:58 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o25sm15633338wro.21.2019.10.24.00.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 00:35:57 -0700 (PDT)
Date:   Thu, 24 Oct 2019 09:35:57 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Message-ID: <20191024073557.GB2233@nanopsycho.orion>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 23, 2019 at 04:21:51PM CEST, jhs@mojatatu.com wrote:
>On 2019-10-23 9:04 a.m., Vlad Buslov wrote:
>> 
>> On Wed 23 Oct 2019 at 15:49, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> > Hi Vlad,
>> > 
>
>> > I understand your use case being different since it is for h/w
>> > offload. If you have time can you test with batching many actions
>> > and seeing the before/after improvement?
>> 
>> Will do.
>
>Thanks.
>
>I think you may have published number before, but would be interesting
>to see the before and after of adding the action first and measuring the
>filter improvement without caring about the allocator.
>
>> 
>> > 
>> > Note: even for h/w offload it makes sense to first create the actions
>> > then bind to filters (in my world thats what we end up doing).
>> > If we can improve the first phase it is a win for both s/w and hw use
>> > cases.
>> > 
>> > Question:
>> > Given TCA_ACT_FLAGS_FAST_INIT is common to all actions would it make
>> > sense to use Could you have used a TLV in the namespace of TCA_ACT_MAX
>> > (outer TLV)? You will have to pass a param to ->init().
>> 
>> It is not common for all actions. I omitted modifying actions that are
>> not offloaded and some actions don't user percpu allocator at all
>> (pedit, for example) and have no use for this flag at the moment.
>
>pedit just never got updated (its simple to update). There is
>value in the software to have _all_ the actions use per cpu stats.
>It improves fast path performance.
>
>Jiri complains constantly about all these new per-action TLVs
>which are generic. He promised to "fix it all" someday. Jiri i notice
>your ack here, what happened? ;->

Correct, it would be great. However not sure how exactly to do that now.
Do you have some ideas.

But basically this patchset does what was done many many times in the
past. I think it was a mistake in the original design not to have some
"common attrs" :/ Lesson learned for next interfaces.
