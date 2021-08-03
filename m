Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02A03DF7D7
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 00:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhHCWcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 18:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbhHCWcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 18:32:18 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C408AC061757;
        Tue,  3 Aug 2021 15:32:06 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id u25so612212oiv.5;
        Tue, 03 Aug 2021 15:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IxvJ3kNcHqPJOltM6QEZR4op6Xq6Iap0fFQoq3XfjDk=;
        b=pNRU89QYktJGX/U529VWINcWShMtjw+tMcMUL8zyoreyigdHRuNOICggg5JhqFCuJ0
         Vj/JIorfE6IQQtxMfub4IACvm0IcyVPDbwkPmdG2pqXikHzPoLLu6TsHLeypOpTe7EqS
         vHea/r/QJfSwSspbmR5f9/Aw3fUt+6u5MP6/kJfzQwBtZu0kUzJcpISTdAjT0IwU5jNQ
         H2wDBn3US0wE9xW81pnN7M+fYFoB4cL2t7y6PHanNwQyUGztXu6Bbfokyns3HYwWkgDA
         8qd3b3r38KE+t/kUquWc+aBwBTvEVtaWYC9RKL9n9hzq4NukICNQAUbgN98Uht+6EUpd
         vduQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IxvJ3kNcHqPJOltM6QEZR4op6Xq6Iap0fFQoq3XfjDk=;
        b=mvU/OGrd0xBtNQaGyo3k4WzO0fzUxIbgMfHdC9FASFKL12LUgBI54NhL8qkx0U53Fu
         nQpU4gsHbLhzWxVgTjH4eJTooNBEbgMH6+JmT0pRBIASFor7OAT1dpcjc3FUAbJ9Hwty
         1MfPWlgl9a7sgp3miwbZGCC3gx1c4q2nLjskbrpUO7f84KsTEnlsr1SFaxzuHmZdOgD9
         QkcTdeST8ev6vW0ijg6q5cJxozlLtLLvJgx7JflV3J/0UvQyid0ItIzJOs7ccRqLHHy/
         XkBREF8gcbM0T7qcwOC+pwx9YIYENA3tBQR45uOf8cAZAyCqn79QACjjWQg6472OrF7v
         0xHA==
X-Gm-Message-State: AOAM530bB5SF2ASkIMPFdbmZ+Ozu1aRM89xLxT7+kJ907jbD0qmnHM1y
        iDORjdxsBGN+NvtTPORvaSw=
X-Google-Smtp-Source: ABdhPJx22+N8LhOKX2RMU2RBTaJNKQQaf2Coj+Sqbg+fHUB7PaFmYJ/ium+/IiiVJuS3aHhzLnoYFw==
X-Received: by 2002:aca:f354:: with SMTP id r81mr4913255oih.99.1628029924767;
        Tue, 03 Aug 2021 15:32:04 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id a7sm73851oti.47.2021.08.03.15.32.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 15:32:04 -0700 (PDT)
Subject: Re: [syzbot] net-next boot error: WARNING: refcount bug in
 fib_create_info
To:     Jakub Kicinski <kuba@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>
Cc:     syzbot <syzbot+c5ac86461673ef58847c@syzkaller.appspotmail.com>,
        davem@davemloft.net, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
References: <0000000000005e090405c8a9e1c3@google.com>
 <02372175-c3a1-3f8e-28fe-66d812f4c612@gmail.com>
 <e6eab0c9-7b2e-179b-b9c0-459dd9a75ed1@gmail.com>
 <20210803140435.19e560fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <80ea9025-05a7-ab21-ed53-5527356c4464@gmail.com>
Date:   Tue, 3 Aug 2021 16:32:02 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210803140435.19e560fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21 3:04 PM, Jakub Kicinski wrote:
>>>
>>> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
>>> index f29feb7772da..bb9949f6bb70 100644
>>> --- a/net/ipv4/fib_semantics.c
>>> +++ b/net/ipv4/fib_semantics.c
>>> @@ -1428,6 +1428,7 @@ struct fib_info *fib_create_info(struct fib_config
>>> *cfg,
>>>    	}
>>>
>>>    	fib_info_cnt++;
>>> +	refcount_set(&fi->fib_treeref, 1);
>>>    	fi->fib_net = net;
>>>    	fi->fib_protocol = cfg->fc_protocol;
>>>    	fi->fib_scope = cfg->fc_scope;
>>
>> Oops, it's already fixed in -next, so
>>
>> #syz fix: ipv4: Fix refcount warning for new fib_info
>>
>>
>> BTW: there is one more bug with refcounts:
>>
>> link_it:
>> 	ofi = fib_find_info(fi);
>> 	if (ofi) {
>> 		fi->fib_dead = 1;
>> 		free_fib_info(fi);
>> 		refcount_inc(&ofi->fib_treeref);
>>
>> 		^^^^^^^^^^^^^^^^^^^^^^^
>> 		/ *fib_treeref is 0 here */
> 
> Why 0? ofi is an existing object it's already initialized.

yes, it is an existing object with a non-0 refcount.

> 
>> 		return ofi;
>> 	}
>>
>> 	refcount_set(&fi->fib_treeref, 1);
>>
>>
>> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
>> index f29feb7772da..38d1fc4d0be1 100644
>> --- a/net/ipv4/fib_semantics.c
>> +++ b/net/ipv4/fib_semantics.c
>> @@ -1543,6 +1543,8 @@ struct fib_info *fib_create_info(struct fib_config 
>> *cfg,
>>   	}
>>
>>   link_it:
>> +	refcount_set(&fi->fib_treeref, 1);

moving the refcount_set here causes all kinds of problems with the
release and error paths in this function.

