Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E113A81F70
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbfHEOtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:49:32 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44553 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfHEOtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 10:49:31 -0400
Received: by mail-wr1-f66.google.com with SMTP id p17so84701004wrf.11
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 07:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aDbuV//htd09OYdzyjVmTWFbg/OHBxHEf11PV3rYjQA=;
        b=tOpWcj3g/g+U8iGD2e6H+3G/RHHYcVn2BuEIp4F9LJUnhXAIJMCbu45H5pWMc9NnaZ
         VI/MJlPrpxC9rSD9DzrHErKYwKMKyNZt3uhJWpYN6d5Ko4MNHyrc2s+lMTkd+AEdap1k
         Sjb/XNDUaBS+xfXLnxcxengqT58xtYLtjok1xvfOnk7sAzZTIadSxUb5v/yggbhhZuAb
         wZhq962PSLoiONICs3T5Pw8RUXc6ygrOfo5WHC4zupo3A1+YiANAcNEQHAEnyx3B4kr0
         XMVJTiOEkPkDjoOCr0Gav7bI/FwSHAVQ1fVHQJkWDEL0ykEOL89LVx4hvIR2gGwQa7UW
         4gzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aDbuV//htd09OYdzyjVmTWFbg/OHBxHEf11PV3rYjQA=;
        b=SXIKLr7yEy7NdO5qsJhZgWUcAZSgTyh2PcV1F6hQ224xI/pzXbI5ChBZEfms1lJBSq
         K71PmxMQJS4/FI2z0CQgUHEbSAlg/omxLRaQkXQQ2hEZFVIeY5y/ka4B+9ssnRluekXI
         d2ellefjpjlXxZze51tA6c5HNP9BvYaxgfNEqbLjplT2RvBF4YheZt2Gdz72jJxGe/qO
         CcvDGCFKF/QSj8ixN3c2qo3ddl7ppZGvMIdCPlOvT3Sr4g6hMh5y0xMdeQFhbGB/449P
         NmaDw3RSZCvRh3nwpTClMmLjA1RJSsPuAvOpe7noojM8tRgUwICqoQy0PRZjr5ZbevlR
         IHkA==
X-Gm-Message-State: APjAAAUZN+nlLUjottufC6sVtmFKunoMZfG5mG6tp2J98vWOnNgbLOV3
        3fAPvZtlrIM3ZtIX5TNE5phNmrbr
X-Google-Smtp-Source: APXvYqzPLwxnGQJanP4tXR9MeXGqsCIdAmW2kUwdoQ+0yR6lRLNRH8cLRcTBuDCexVlSsJtMwK+Pgg==
X-Received: by 2002:a5d:5308:: with SMTP id e8mr20775249wrv.219.1565016569263;
        Mon, 05 Aug 2019 07:49:29 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v5sm125439509wre.50.2019.08.05.07.49.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 07:49:28 -0700 (PDT)
Date:   Mon, 5 Aug 2019 16:49:27 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
Message-ID: <20190805144927.GD2349@nanopsycho.orion>
References: <20190730153952.73de7f00@cakuba.netronome.com>
 <20190731192627.GB2324@nanopsycho>
 <c4f83be2-adee-1595-f241-de4c26ea55ca@gmail.com>
 <20190731194502.GC2324@nanopsycho>
 <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
 <89dc6908-68b8-5b0d-0ef7-1eaf1e4e886b@gmail.com>
 <20190802074838.GC2203@nanopsycho>
 <6f05d200-49d4-4eb1-cd69-bd88cf8b0167@gmail.com>
 <20190805055422.GA2349@nanopsycho.orion>
 <796ba97c-9915-9a44-e933-4a7e22aaef2e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <796ba97c-9915-9a44-e933-4a7e22aaef2e@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 05, 2019 at 04:10:39PM CEST, dsahern@gmail.com wrote:
>On 8/4/19 11:54 PM, Jiri Pirko wrote:
>> There was implicit devlink instance creation per-namespace. No relation
>> any actual device. It was wrong and misuse of devlink.
>> 
>> Now you have 1 devlink instance per 1 device as it should be. Also, you
>> have fib resource control for this device, also as it is done for real
>> devices, like mlxsw.
>> 
>> Could you please describe your usecase? Perhaps we can handle
>> it differently.
>
>I have described this before, multiple times.
>
>It is documented in the commit log for the initial fib.c in netdevsim
>(37923ed6b8cea94d7d76038e2f72c57a0b45daab) and
>https://lore.kernel.org/netdev/20180328012200.15175-7-dsa@cumulusnetworks.com/
>
>And this comment in the discussion thread:
>
>https://lore.kernel.org/netdev/e9c59b0c-328e-d343-6e8d-d19f643d2e9d@cumulusnetworks.com/:
>"The intention is to treat the kernel's tables *per namespace* as a
>standalone entity that can be managed very similar to ASIC resources."
>
>
>So, to state this again, the fib.c in the RFC version
>https://lore.kernel.org/netdev/20180322225757.10377-8-dsa@cumulusnetworks.com/
>
>targeted this:
>
>   namespace 1 |  namespace 2  | ... | namespace N
>               |               |     |
>               |               |     |
>   devlink 1   |    devlink 2  | ... |  devlink N
>
>and each devlink instance has resource limits for the number of fib
>rules and fib entries *for that namespace* only.
>
>You objected to how the devlink instances per namespace was implemented,
>so the non-RFC version limited the devlink instance and resource
>controller to init_net only. Fine. I accepted that limitation until
>someone had time to work on devlink instances per network namespace
>which you are doing now. So, the above goal will be achievable but first
>you need to fix the breakage you put into v5.2 and forward.
>
>Your commit 5fc494225c1eb81309cc4c91f183cd30e4edb674 changed that from a
>per-namepace accounting to all namespaces managed by a single devlink
>instance in init_net - which is completely wrong.

No. Not "all namespaces". Only the one where the devlink is. And that is
always init_net, until this patchset.


>
>Move the fib accounting back to per namespace as the original code
>intended. If you now want the devlink instance to be namespace based
>then it should be trivial for you to fix it and will work going forward.

With this patchset, you can create netdevsim instance in a namespace,
set the resources limits on the devlink instance for this netdevsim
and you have what you need and what you had before. You just need to
create one netdevsim instance per network namespace.
Or multiple netdevsim instances in one namespace with different
limitations. Up to you.
