Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADF230191F
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 02:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbhAXBOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 20:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbhAXBOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 20:14:06 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9ECC0613D6;
        Sat, 23 Jan 2021 17:13:25 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id i20so9206674otl.7;
        Sat, 23 Jan 2021 17:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5Icjrpeb+L2s/mj15Tw7Q1FswVhzcXC/VPJXUrmZrXM=;
        b=IYeJjUj4acPE8n91fk33LHXpGEnEbFlHXcY6rSRQQn+G4byAjySghoF31eLzE8jinM
         mqA8wbPzNi5F5e5qf4Q+ZelKlkQGbDAzBltS6sH40zCUVqJzqRB5q/Oh7JzbDBw3hLri
         VQSH2sA9ocqV8DF+MNFLH69o2T0XRn9D0cu+B56G+Wre1woPY1CzeHeaBARzdux473iE
         z436ocwWOxVKCXgv5y2IiEQxv9iz/9kmOFhiRcMNlrsER7XNzEV4PJg0erxfMSVNTvD4
         J8Vb1pjoPwEVzHe29ApjC+L+wETljfy2awUIsOmQl8GSNc6WyqUK0i8plF/gNWxx8YgC
         +bbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Icjrpeb+L2s/mj15Tw7Q1FswVhzcXC/VPJXUrmZrXM=;
        b=unSkoJZMtpVJFCkdTGO68fTF6o7+ewFAp7R+fhwYhivMhTrXMyMPYKyYk+idR4flu9
         A3xfLdchKTdWrKX6zJbicAe4qmxrldfc0xV6RduRJPkB54aD5QQIpCi/ae88oDY241yt
         OXcXqC0Y0n7gNwjt2H7qgjxAyuF/imV6dIFNTBQzuVwiYDCE/hH1eJSXQifBUzKRDEIm
         YieJZu4mVHaGMY5ceo7EuAlzRnTYBvW8xRyTuVB4BNgX1OwInXKJswiCdNpH9VBeFMNU
         pFsWftN4/SflUCBwwix51SOYyG8wBgc4eiXEQcjcDlA8NlTnCfVdvetn9li+bXgIqR6Z
         OKfw==
X-Gm-Message-State: AOAM5315zxP69NcOTlFj5I4/uKY037e3XxwmcYKrBpuUnrViGOqp1j+t
        Z+a2u8WrMjoW7UV51m+ZNG8=
X-Google-Smtp-Source: ABdhPJw5/DQvnXmrrk5eMS61A2vfrQxfRFFdt3nPvUqKzGXHcH6foCbdiPnHPicjidRaLKvljpfMng==
X-Received: by 2002:a9d:61d0:: with SMTP id h16mr7902159otk.1.1611450804961;
        Sat, 23 Jan 2021 17:13:24 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id i26sm2311209oov.47.2021.01.23.17.13.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Jan 2021 17:13:24 -0800 (PST)
Subject: Re: [PATCH v3 net-next 1/1] Allow user to set metric on default route
 learned via Router Advertisement.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki Yoshifuji <yoshfuji@linux-ipv6.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhenggen Xu <zxu@linkedin.com>
References: <20210119212959.25917-1-pchaudhary@linkedin.com>
 <1cc9e887-a984-c14a-451c-60a202c4cf20@gmail.com>
 <CAHo-Oozz-mGNz4sphOJekNeAgGJCLmiZaiNccXjiQ02fQbfthQ@mail.gmail.com>
 <bc855311-f348-430b-0d3c-9103d4fdbbb6@gmail.com>
 <20210123120001.50a3f676@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2de4989b-5b72-cb0a-470f-9bd0dcb96e53@gmail.com>
Date:   Sat, 23 Jan 2021 18:13:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210123120001.50a3f676@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/21 1:00 PM, Jakub Kicinski wrote:
> On Fri, 22 Jan 2021 22:16:41 -0700 David Ahern wrote:
>> On 1/22/21 9:02 PM, Maciej Żenczykowski wrote:
>>> Why can't we get rid of the special case for 0 and simply make 1024 the
>>> default value?  
>>
>> That would work too.
> 
> Should we drop it then? Easier to bring it back than to change the
> interpretation later. It doesn't seem to serve any clear purpose right
> now.
> 
> (Praveen if you post v4 please take a look at the checkpatch --strict
> warnings and address the ones which make sense, e.g. drop the brackets
> around comparisons, those are just noise, basic grasp of C operator
> precedence can be assumed in readers of kernel code).
> 

let's do a v4.

Praveen: set the initial value to IP6_RT_PRIO_USER, do not allow 0,
remove the checks on value and don't forget to update documentation.

Oh and cc me on the next otherwise the review depends on me finding time
to scan netdev.
