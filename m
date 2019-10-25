Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85156E50C5
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 18:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504016AbfJYQGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 12:06:13 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39322 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729004AbfJYQGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 12:06:13 -0400
Received: by mail-io1-f65.google.com with SMTP id y12so3017432ioa.6
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 09:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MaGqyIzCtt/ebql6HId0L1yRJIIFsMXkS/FqCE/23v0=;
        b=GZlQGr4o7O+HUfzHe2Tz/W18Ci/ktLY3dM/bePcnhzFje1F074o5r7UVcpt7C3eLhx
         SaPU3u8z4LrzLOGhtvDvq5Ewbf+36FJX/6p2YGT5G48j1lSvqXba/ROkTDKMUtXRDxXe
         Xqs+h3CkBPWg0jL0VqQ3xlUa5A+61yAOMFwgjmAhIIyDpaMEP12yp1ABzgx/e116MAYZ
         YyBZX7zxlXQyTpKELbW8fnr92pggft4gqfdBRRo1ck0t7cwWABjCpL8h7lIpFVqR4OT4
         o/UG5WL2mTzvmc+RctMwav1Vnf+qscRFgSj6z470CE6bzbXd39baoThxq3FpiJ4tgTOQ
         iRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MaGqyIzCtt/ebql6HId0L1yRJIIFsMXkS/FqCE/23v0=;
        b=WMhE0av21SaWQ3/8oqm+KcgzABKMA1YFib/YR68jNqV6einkhNplFAStcuOMtQyViX
         HvVYRMM6fG6srL43NSYHBwhiO2O/urN3lUwWA3+hjMYR1dQSVVD7fWdki8dyXPGjwBgC
         uGHAhVC6mPvRcw9YoC4zqtUk7Dfcz3wnmqEElZfZOyGMt4m2iPVJuXCYYKwCCKH1GGUx
         O41a9L0MfIuqQglCX4Oj0OSquosC8ZbqRVI/6LkbIFOFKeTgZ4ByEn4bms9omKuS6FJI
         aQ+cjKNvM18P7OhywdZAwci4+bBDOO8x1lieMBVLhzDedTx/jKZPUeLzwSEhkWQJ1ei/
         RsTQ==
X-Gm-Message-State: APjAAAX6jV7Tk2wzxgxBLym2drapWbVtrqI4M8AjvOsZi/FO/hWFjYAl
        2bQYTI+MWKlidHVVH6vtojSDeQ==
X-Google-Smtp-Source: APXvYqx+FqYVCoLx2xg7vFZyQeEwvrMFsgmy097yJ2JXoD3XM7KAt6twKr73IpLi2T5wOHwe1XOIFQ==
X-Received: by 2002:a5d:8415:: with SMTP id i21mr4501679ion.44.1572019572062;
        Fri, 25 Oct 2019 09:06:12 -0700 (PDT)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id d6sm296531ioo.83.2019.10.25.09.06.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 09:06:09 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbftv7wuciu.fsf@mellanox.com>
 <fab8fd1a-319c-0e9a-935d-a26c535acc47@mojatatu.com>
 <48a75bf9-d496-b265-bdb7-025dd2e5f9f9@mojatatu.com>
 <vbfsgngua3p.fsf@mellanox.com>
 <7488b589-4e34-d94e-e8e1-aa8ab773891e@mojatatu.com>
Message-ID: <43d4c598-88eb-27b3-a4bd-c777143acf89@mojatatu.com>
Date:   Fri, 25 Oct 2019 12:06:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <7488b589-4e34-d94e-e8e1-aa8ab773891e@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-25 11:43 a.m., Jamal Hadi Salim wrote:
> On 2019-10-25 11:18 a.m., Vlad Buslov wrote:
>>
> 
>> The problem with this approach is that it only works when actions are
>> created through act API, and not when they are created together with
>> filter by cls API which doesn't expect or parse TCA_ROOT. That is why I
>> wanted to have something in tcf_action_init_1() which is called by both
>> of them.
>>
> 
> Aha. So the call path for tcf_action_init_1() via cls_api also needs
> to have this infra. I think i understand better what you wanted
> to do earlier with changing those enums.
> 

Hold on. Looking more at the code, direct call for tcf_action_init_1()
from the cls code path is for backward compat of old policer approach.
I think even modern iproute2 doesnt support that kind of call
anymore. So you can pass NULL there for the *flags.

But: for direct call to tcf_action_init() we would have
to extract the flag from the TLV.
The TLV already has TCA_ROOT_FLAGS in it.


cheers,
jamal
