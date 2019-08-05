Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1BBB81EBA
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbfHEOKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:10:46 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42113 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfHEOKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 10:10:46 -0400
Received: by mail-io1-f65.google.com with SMTP id e20so34604723iob.9
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 07:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9PfFoi0Vt3M7pnWbYm3AXz3qdS03TnoCi80mJ0iz1x0=;
        b=pVSRNOw/gH9ODvU7oGTyGzwCSmKUTWMicMSJOaLqIIItK/My2HFZVT7AZsPBycGL83
         iPzmpNk9gcZBkv2i52iTDKOzq2XdA2kQB1RW4igCMgwgPh2Jj6uGRDLQcxDzc9pt89zS
         xLEIOM4tI1LWGjpiGCqBt3/b0R15ICAaAFajcoNHOB0pVSlP552ISAMCa3vyKdiqGUhe
         mC+7psTObQR1PcCJKZ1A79gj/0mOWxG5/AZYseVb49KbdzECMKRt96rLeyhrsxD3OioG
         r7pIrnPrDBOfKcj7o5d9CtF8GAqzxVrl+BzK+RphOYl38nj0eVJKwN8TUojSOijt8fvN
         55TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9PfFoi0Vt3M7pnWbYm3AXz3qdS03TnoCi80mJ0iz1x0=;
        b=TvJaQ6NpxOd2733qxt2WS1pD+qoACaAfULG7hLZgzXdLyDsEVifYVjNbkbACIWq6Ms
         hf19iDZVVMDRdwP8NFKgeFixt402kO4YawaZUg4vQrm8enhhiBj7/ZlVLCGVkFu2+XXK
         iPOvLDEo1lrFXMHVCFj2T2tKcdkNFv6GKXPlYPMSkpDw9G/tOe9f3le6t8WkcUdYlDnR
         OEVn1moPgKVLof/YwPyS44Sw9n2u/N2EkNQpmRIHS2P++Pnw4P2ymKWNzibtyAgMvUcj
         J4y5OikWp2WiDidP4F1N8CC15Y+qpbikvNTJFeaYZT/Dy3fKlWz9iZQ2bVa2Brz6g5R/
         woCg==
X-Gm-Message-State: APjAAAUxv4/ZLe9QiCkp9K/7JEbtM8j4J0OnUzo8aiKQqciMpO04wZsj
        40EgGudvBYAnww23uYgaMc0=
X-Google-Smtp-Source: APXvYqwIqwvmVze+7lI0Bs6EWC0+UMUtXe0Wj2hezJ8UQQgb9fDCivaR2B5nDpqTStpkQbAPCUE7Nw==
X-Received: by 2002:a6b:f80e:: with SMTP id o14mr10239367ioh.1.1565014245744;
        Mon, 05 Aug 2019 07:10:45 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:ca5:ef3d:7276:749b? ([2601:282:800:fd80:ca5:ef3d:7276:749b])
        by smtp.googlemail.com with ESMTPSA id v3sm65156556iom.53.2019.08.05.07.10.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 07:10:44 -0700 (PDT)
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
References: <20190730085734.31504-1-jiri@resnulli.us>
 <20190730085734.31504-2-jiri@resnulli.us>
 <20190730153952.73de7f00@cakuba.netronome.com>
 <20190731192627.GB2324@nanopsycho>
 <c4f83be2-adee-1595-f241-de4c26ea55ca@gmail.com>
 <20190731194502.GC2324@nanopsycho>
 <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
 <89dc6908-68b8-5b0d-0ef7-1eaf1e4e886b@gmail.com>
 <20190802074838.GC2203@nanopsycho>
 <6f05d200-49d4-4eb1-cd69-bd88cf8b0167@gmail.com>
 <20190805055422.GA2349@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <796ba97c-9915-9a44-e933-4a7e22aaef2e@gmail.com>
Date:   Mon, 5 Aug 2019 08:10:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190805055422.GA2349@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/19 11:54 PM, Jiri Pirko wrote:
> There was implicit devlink instance creation per-namespace. No relation
> any actual device. It was wrong and misuse of devlink.
> 
> Now you have 1 devlink instance per 1 device as it should be. Also, you
> have fib resource control for this device, also as it is done for real
> devices, like mlxsw.
> 
> Could you please describe your usecase? Perhaps we can handle
> it differently.

I have described this before, multiple times.

It is documented in the commit log for the initial fib.c in netdevsim
(37923ed6b8cea94d7d76038e2f72c57a0b45daab) and
https://lore.kernel.org/netdev/20180328012200.15175-7-dsa@cumulusnetworks.com/

And this comment in the discussion thread:

https://lore.kernel.org/netdev/e9c59b0c-328e-d343-6e8d-d19f643d2e9d@cumulusnetworks.com/:
"The intention is to treat the kernel's tables *per namespace* as a
standalone entity that can be managed very similar to ASIC resources."


So, to state this again, the fib.c in the RFC version
https://lore.kernel.org/netdev/20180322225757.10377-8-dsa@cumulusnetworks.com/

targeted this:

   namespace 1 |  namespace 2  | ... | namespace N
               |               |     |
               |               |     |
   devlink 1   |    devlink 2  | ... |  devlink N

and each devlink instance has resource limits for the number of fib
rules and fib entries *for that namespace* only.

You objected to how the devlink instances per namespace was implemented,
so the non-RFC version limited the devlink instance and resource
controller to init_net only. Fine. I accepted that limitation until
someone had time to work on devlink instances per network namespace
which you are doing now. So, the above goal will be achievable but first
you need to fix the breakage you put into v5.2 and forward.

Your commit 5fc494225c1eb81309cc4c91f183cd30e4edb674 changed that from a
per-namepace accounting to all namespaces managed by a single devlink
instance in init_net - which is completely wrong.

Move the fib accounting back to per namespace as the original code
intended. If you now want the devlink instance to be namespace based
then it should be trivial for you to fix it and will work going forward.


