Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72597301336
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 06:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbhAWFRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 00:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbhAWFRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 00:17:24 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C01C061786;
        Fri, 22 Jan 2021 21:16:44 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id u7so1345916ooq.0;
        Fri, 22 Jan 2021 21:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zxNG662Tpnsoz8s5rDmsMzt/BLhFhjnXV6eLd4EYb9o=;
        b=OCm+4WEKTHVXtK6/TX7smrp79P/GGOR+w/7KiDo+8jeq/ksAy3rxssV1CuJv6tuYRl
         p/AO5XsNXHgW2UOv1LjNUy9jyWYbacgs8146zP5RAQMwQaqZUA1i9cG4embLRK4R0loy
         wmYN/xM2gMJOdX1ZsfjMYVohVMn6dGF3t1mDM/MU+TyX1a41Z8Asv1xFhaPkiztuxYOJ
         uiHI7g1FFfKkgDaqzWQXf0NpL1tBARdtCv8A6VMZjiVCLg1OAmzEeOzXpuwqMUuJOWVO
         E750pIbTaJ2CZXUxdY8Ex3g0JqKMUYhbBGDr4sMLnHictC8UXeMGtGB5K+dp7Z/v3w+5
         g9Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zxNG662Tpnsoz8s5rDmsMzt/BLhFhjnXV6eLd4EYb9o=;
        b=nkaObXN27mjp4XvW7kYn6qaaoqJgDqe6da9FrA02OH7RWCS71j8OlIncnSr/NJinWz
         6EUwr6jhcNkpajh3DFFifp2kvskU8f5aG7mZvJvy5CfoVYORtH2JEBqiZnud1EMEs7CL
         RcaIcOJUtdnK/DGJt4Ivcka24/zJ2NDdv4X105Co1oJ6bGEdmUgcaL+/J98k0biGTOTT
         39BiQL4QyLmckJ/C+Jrv1OVXKzd7l30EBalHzIquKstXkeTMy8zGjan27SdN998M/Fq2
         c7bqslauz4Iy9wTx1TEBp/ydV3ovALTJR5MXayT0VCpGqLrh02x1QlxeFVOzsIOwSY+u
         Y13Q==
X-Gm-Message-State: AOAM533hA5ovcNIg1U7fPGrIeJXLLEfU7JUNaSrGvojjQxA3iZ3/Bk2M
        KuP/9PBb+MXYakKaGIe+Rww=
X-Google-Smtp-Source: ABdhPJxA+4+j4HTMeDWLI8zan6VNkVXWGoDLVeWMHezRa95zOtEuJmLY0QZf0uyYNHswa/3PTASX8w==
X-Received: by 2002:a4a:52d1:: with SMTP id d200mr813555oob.64.1611379003994;
        Fri, 22 Jan 2021 21:16:43 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id e14sm2628oou.19.2021.01.22.21.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 21:16:43 -0800 (PST)
Subject: Re: [PATCH v3 net-next 1/1] Allow user to set metric on default route
 learned via Router Advertisement.
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>
Cc:     Praveen Chaudhary <praveen5582@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki Yoshifuji <yoshfuji@linux-ipv6.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhenggen Xu <zxu@linkedin.com>
References: <20210119212959.25917-1-pchaudhary@linkedin.com>
 <1cc9e887-a984-c14a-451c-60a202c4cf20@gmail.com>
 <CAHo-Oozz-mGNz4sphOJekNeAgGJCLmiZaiNccXjiQ02fQbfthQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bc855311-f348-430b-0d3c-9103d4fdbbb6@gmail.com>
Date:   Fri, 22 Jan 2021 22:16:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAHo-Oozz-mGNz4sphOJekNeAgGJCLmiZaiNccXjiQ02fQbfthQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/21 9:02 PM, Maciej Żenczykowski wrote:
> Why can't we get rid of the special case for 0 and simply make 1024 the
> default value?

That would work too.

> 
> As for making it an RA option: it's not clear how that would work, the
> use case I see for this is for example two connections to the internet,
> of which one is clearly better (higher throughput, lower latency, lower
> packet loss, etc) then the other.
> 
> The upstream routers would have to somehow coordinate with each other
> the metric values... that seems impossible to achieve in practice -
> unless they do something like report expected down/up
> bandwidth, latency, etc...  While some sort of policy on the machine
> itself seems much more feasible (for example wired interface > wireless
> interface > cell interface or something like that)

I was thinking the admin of the network controls the RAs and knows which
paths are preferred over the admin of the node receiving the RA (not
practical for a mobile setup with cell vs wifi, but is for a DC which is
the driving use case).

But it takes an extension to IPv6/ndisc to add metric as an RA option,
so not realistic in a reasonable time frame.
