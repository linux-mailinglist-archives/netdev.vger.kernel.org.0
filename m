Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9477E3795
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 18:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439755AbfJXQMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 12:12:37 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46909 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439732AbfJXQMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 12:12:37 -0400
Received: by mail-io1-f67.google.com with SMTP id c6so30127367ioo.13
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 09:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=anJv3VLJIwno4S9hJGFaEhVurnYD4TuUs93wQHzn4B0=;
        b=XX8UM5t97Z+NWeFcVuf7KW+0NgUrk1r49z25fGFRJEUnonQ5F+MSqDdQa8F6yGk+Yy
         gQI0Eg5Scl5XMsamBsZm+9tqGHd8/f00uKojDr1x7fbYvafW6GeROgU5yNWDb22ECGBp
         5EMA5yivnFHaSeNmZwxfSsKZCtmIoNgE9I7vyaxdz+rCms1MKePa7jMwA174Wtpoapge
         Hwb0CtM0Vh7YdtWmUxF5zqK2dgUmgq11otg5PLojEX7+mD6tPYXGT+1cfeDFw47wh9aK
         gHt+XkPNpwWyhoXVjIVpOQXRZPASiT5Sp9t8LkI8ZZwlW/VpvwmyaldwVc5t21W/LgcT
         hh3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=anJv3VLJIwno4S9hJGFaEhVurnYD4TuUs93wQHzn4B0=;
        b=g475BQ9AJMjDHc1mrXuFjfIY2bk5IOmiW3zs2xhmMauZVWgs/Y4qKHNnrhH8BaMVyr
         9GkPiN61+X0CB0yQvUldOXl77Q5yoZz8mwd2mYFUGVtck/1azp6Yx59fV2t++o2weWdf
         66i07Ihsce6tzeNvcUfmiK3JKYEmeW4p3FNZxAZEoS0b3WbxDKHL+aXf4dJmwRgqsnqg
         tUtGQh0e7bfPiIsUoRcDPdwjyzvgSACenkNZ8NQMxZ66ASDSI3qlkUEiP2kBXvm6dbjD
         j26+RQGMOKHDr4pTFMqCW+qIo9Dxcdn3MhniBBrru0ii2nYRrS0u+12OQZgRJvwUigA8
         ov1w==
X-Gm-Message-State: APjAAAX/TpdeZiuOsW5SVgSDT/GomcIk1p/hJEdOm/SbrQUThWR/Lmoi
        xVtxMdK5bzZA+kj0Pl7nejxgyw==
X-Google-Smtp-Source: APXvYqwnPRXyQhCVksUSR1QD0wlNoLHgVFlxZ7bz85ryO9WR6BHhBb1kkIYyHr38Au5gvQBNYTHGXg==
X-Received: by 2002:a02:c519:: with SMTP id s25mr15760385jam.3.1571933554142;
        Thu, 24 Oct 2019 09:12:34 -0700 (PDT)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id o5sm9322351ilc.68.2019.10.24.09.12.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 09:12:33 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
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
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
Date:   Thu, 24 Oct 2019 12:12:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <vbfwocuupyz.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-24 11:23 a.m., Vlad Buslov wrote:
> On Thu 24 Oct 2019 at 10:35, Jiri Pirko <jiri@resnulli.us> wrote:
>> Wed, Oct 23, 2019 at 04:21:51PM CEST, jhs@mojatatu.com wrote:
>>> On 2019-10-23 9:04 a.m., Vlad Buslov wrote:
>>>>

[..]
>>> Jiri complains constantly about all these new per-action TLVs
>>> which are generic. He promised to "fix it all" someday. Jiri i notice
>>> your ack here, what happened? ;->
>>
>> Correct, it would be great. However not sure how exactly to do that now.
>> Do you have some ideas.
>>
 >>
>> But basically this patchset does what was done many many times in the
>> past. I think it was a mistake in the original design not to have some
>> "common attrs" :/ Lesson learned for next interfaces.
> 

Jiri, we have a high level TLV space which can be applied to all
actions. See discussion below with Vlad. At least for this specific
change we can get away from repeating that mistake.

> Jamal, can we reach some conclusion? Do you still suggest to refactor
> the patches to use TCA_ROOT_FLAGS and parse it in act API instead of
> individual actions?
> 

IMO this would certainly help us walk away from having
every action replicate the same attribute with common semantics.
refactoring ->init() to take an extra attribute may look ugly but
is cleaner from a uapi pov. Actions that dont implement the feature
can ignore the extra parameter(s). It doesnt have to be TCA_ROOT_FLAGS
but certainly that high level TLV space is the right place to put it.
WDYT?

cheers,
jamal
