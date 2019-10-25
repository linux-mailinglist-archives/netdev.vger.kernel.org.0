Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF89BE4FAB
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440540AbfJYO5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:57:09 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38995 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437476AbfJYO5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 10:57:08 -0400
Received: by mail-io1-f67.google.com with SMTP id y12so2752113ioa.6
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 07:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xDzR+PZpROKL3+5LhbwoWb/bjK6m+YTscKDXD4yOOd0=;
        b=Z5smjl8qk/qgHVdcpBkShzuIpQqPsHnI8q+Y1yF8hKxWZscjqZoZk+JfKygxG0ckH7
         w9oVFwIV3UP1pf+qq9g5MUi0XNB5DaXZZUEM3diYo1F+FDU2AzXem0x47T8J5+bLTVCU
         D/ZJ39XNAz/gDMSCVFJxWpoUEV6GJBTT12N9BDYT2xf3M2lk6WypS2lRYw6usrpTwTzJ
         kgMUgIQifTYL5CUebGVjgwrIwSq9G1F3ysDy+VUsEEH06F1DGF7+HPuYhjIwcmRMz8qI
         SpNglqW94C1WNKHc52RoADs9Zwjt1fWFSta3OqAJrRG0lDWjs8aS1kU+ASU+hk885vzK
         wz0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xDzR+PZpROKL3+5LhbwoWb/bjK6m+YTscKDXD4yOOd0=;
        b=CzERYseRrVLmrvIl3tYCsOj9TqqaJzzh+GufwGzK7XQ0nBfl0MUt+fIPX2j50Kt2zV
         79L7tb6OO2nurMw/uH7nD9M0N21S6cAPEVHfQo+cptGCVVhJLIASv9jKvNTdd+ZDrHAy
         93UQdHIMExiiy4cm+GuLLxaZq2FpI5IafRx5CkaP6niJERWS+ZxKpfqwHU8Ad7VKmSjK
         RRyIzZl/oVGMt+NRldNXni0BUY43zZO+HK7+bI4dlSCcUowmDkL5/D+fsw42D67iVFS3
         9Drp2VhNZP7FLftdCR6ZBB1XsPWJh9wr4cJNOoLdBkpO6nHRrJ8h70oDxVo5U0e7bken
         kIIA==
X-Gm-Message-State: APjAAAVC52f4/CLeLV2itwewnJqHl8AWeQhI7wAQf6mMMeoezugJMsq8
        OQ2QIRKlewEMucY9A8S860+UBg==
X-Google-Smtp-Source: APXvYqwwVNsTWYQa3Ob+S0b8W1I/liqK3/zlMpjfn7VE3AGiLdRIYQnRmokSfLOMk1TVih5ydqk4nw==
X-Received: by 2002:a5d:9a10:: with SMTP id s16mr4056890iol.121.1572015427702;
        Fri, 25 Oct 2019 07:57:07 -0700 (PDT)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id n2sm317242ion.25.2019.10.25.07.57.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 07:57:04 -0700 (PDT)
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
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbftv7wuciu.fsf@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <fab8fd1a-319c-0e9a-935d-a26c535acc47@mojatatu.com>
Date:   Fri, 25 Oct 2019 10:57:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <vbftv7wuciu.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-25 10:26 a.m., Vlad Buslov wrote:

> I've been trying to re-design this change to use high level TLV, but I
> don't understand how to make it backward compatible. If I just put new
> attribute before nested action attributes, it will fail to parse when
> older client send netlink packet without it and I don't see
> straightforward way to distinguish between the new attribute and
> following nested action attribute (which might accidentally have same
> length and fall into allowed attribute range). I don't have much
> experience working with netlink, so I might be missing something obvious
> here. However, extending existing action attributes (which are already
> conveniently parsed in tcf_action_init_1() function) with new optional
> 'flags' value seems like straightforward and backward compatible
> solution.
>

I think i understand what you are saying. Let me take a quick
look at the code and get back to you.

cheers,
jamal
