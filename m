Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1EF4F2C15
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 11:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733294AbfKGKY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 05:24:29 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44007 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbfKGKY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 05:24:28 -0500
Received: by mail-wr1-f66.google.com with SMTP id n1so2329758wra.10
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 02:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rqn3G0NsSOa4M0Ymqf5+2taMQLqxpKkT5pEHXRNdsrQ=;
        b=npv+dqLTjcbQWekB1gyLWycZB5q3lFCsQ5v5BdIpA/bM4RHRcRQI81nl/bwdC2xjQW
         kH9aHm/YG+BmY3o31FoYeb+pvgo/BJS/Z/y9ldOpWEx3NLYIlTwv/vkchPRbxlQGa78k
         zj86ofp3gLcIO4ZhE5f6cGfauVwGIjtUikh0L0SlVj189piUBE7LufupSZ3at5v68dJV
         /+Mnlex7mjCEJoqHkHB+qWBkj/oWTBPt5MBQlNFC073ntEpK6gOpD1ZVt9kQhUA9Thro
         pCnfouZAOk71wp4QOBDO6w2AptjS+W1z/H6nAx3vKBLNq6vVn+frQns0LvSsg6PJfiZD
         wsbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rqn3G0NsSOa4M0Ymqf5+2taMQLqxpKkT5pEHXRNdsrQ=;
        b=GUl+lJQIBBPpnl172MU5ztP/NjUhLJ0kePEMmGO2Aq4Reaol9FT0y37tVsZJUdf20Y
         S4w96krCKXM7hnCQP+ZPJY4xRlqFydBJGQMA+XeOX7etdQEc/2+a9oM/lQWQfd0zEPrQ
         oN4QkeMxdsMCOMkffQjiTfCC6jB2hoBL5QpQXzkZ45CsfIOaliDbqcHnE6RCW2DSTHgd
         sPWN4YsCnBc0Rj9/JGRBkTd9PIniSNJ3gxgcCckpsx/VAo1QL/gygmYZY9ERaTG2mg2f
         Cdz42pOF1VuTn9+TlAL5i+CbEIoYoGx7v8gHxPIXLRny3+uc0DsKFdKSa7nAQklXVsJl
         ViuQ==
X-Gm-Message-State: APjAAAUwqh6VSxIno9nbhQ1YZeI70nazZngG64scBHRknVwOWwGRLIry
        aOyWP5pFO355cN4exjJzhS5NWQ==
X-Google-Smtp-Source: APXvYqyKQok0tV9Ga4iophkjT5yJq7KQDNK3sI9nQBDtoSrngXBBD9MFa0wruTZANEpZ+AnwwDtLuQ==
X-Received: by 2002:adf:fe81:: with SMTP id l1mr2024119wrr.165.1573122266724;
        Thu, 07 Nov 2019 02:24:26 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id v8sm2523076wra.79.2019.11.07.02.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 02:24:26 -0800 (PST)
Date:   Thu, 7 Nov 2019 11:24:25 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
Message-ID: <20191107102425.GC2200@nanopsycho>
References: <358c84d69f7d1dee24cf97cc0ad6fe59d5c313f5.camel@mellanox.com>
 <78befeac-24b0-5f38-6fd6-f7e1493d673b@gmail.com>
 <20191104183516.64ba481b@cakuba.netronome.com>
 <3da1761ec4a15db87800a180c521bbc7bf01a5b2.camel@mellanox.com>
 <20191105135536.5da90316@cakuba.netronome.com>
 <8c740914b7627a10e05313393442d914a42772d1.camel@mellanox.com>
 <20191105151031.1e7c6bbc@cakuba.netronome.com>
 <a4f5771089f23a5977ca14d13f7bfef67905dc0a.camel@mellanox.com>
 <20191105173841.43836ad7@cakuba.netronome.com>
 <c5bedde710b0667fd44213d8c64e65f6870a2f07.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5bedde710b0667fd44213d8c64e65f6870a2f07.camel@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 06, 2019 at 11:21:37PM CET, saeedm@mellanox.com wrote:
>On Tue, 2019-11-05 at 17:38 -0800, Jakub Kicinski wrote:
>> On Tue, 5 Nov 2019 23:48:15 +0000, Saeed Mahameed wrote:
>> > On Tue, 2019-11-05 at 15:10 -0800, Jakub Kicinski wrote:
>> > > But switchdev _is_ _here_. _Today_. From uAPI perspective it's
>> > > done,
>> > > and ready. We're missing the driver and user space parts, but no
>> > > core
>> > > and uAPI extensions. It's just L2 switching and there's quite a
>> > > few
>> > > switch drivers upstream, as I'm sure you know :/ 
>> > 
>> > I can say the same about netlink, it also was there, the missing
>> > part
>> > was the netlink ethtool connection and userspace parts .. 
>> 
>> uAPI is the part that matters. No driver implements all the APIs. 
>> I'm telling you that the API for what you're trying to configure
>> already exists, and your driver should use it. Driver's technical 
>> debt is not my concern.
>> 
>> > Just because switchdev uAPI is powerful enough to do anything it
>> > doesn't mean we are ready, you said it, user space and drivers are
>> > not
>> > ready, and frankly it is not on the road map, 
>> 
>> I bet it's not on the road map. Product marketing sees only legacy
>> SR-IOV (table stakes) and OvS offload == switchdev (value add). 
>> L2 switchdev will never be implemented with that mind set.
>> 
>> In the upstream community, however, we care about the technical
>> aspects.
>> 
>> > and we all know that it could take years before we can sit back and
>> > relax that we got our L2 switching .. 
>> 
>> Let's not be dramatic. It shouldn't take years to implement basic L2
>> switching offload.
>> 
>> > Just like what is happening now with ethtool, it been years you
>> > know..
>> 
>> Exactly my point!!! Nobody is going to lift a finger unless there is
>> a
>> loud and resounding "no".
>> 
>
>Ok then, "no" new uAPI, although i still think there should be some
>special cases to be allowed, but ... your call.
>
>In the meanwhile i will figure out something to be driver only as

"something to be driver only". I'm curious what do you mean by that...


>intermediate solution until we have full l2 offload, then i can ask
>every one to move to full switchdev mode with a press of a button.
>
