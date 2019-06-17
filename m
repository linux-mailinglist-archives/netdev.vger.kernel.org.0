Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50AB247793
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 03:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfFQBWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 21:22:52 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43747 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727238AbfFQBWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 21:22:52 -0400
Received: by mail-io1-f66.google.com with SMTP id k20so17601216ios.10
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 18:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2EZMn5anbPLfRQBVWd21SeZYbpeivIhOwGvH9CL6loc=;
        b=Vxivjzb2iCHKuNxWBaJyPUpZMaKC0XKvVuUk3lBAprG0+HouSMSFw3IB6hjILFxtQQ
         bc21hgDVS9SfIRkArrAJzsMZMolhYbs3n4HMWRmJcGaJgWChUPqVdBXPOFoXNPnilM8y
         aAL8U4rGHfK3S3rDDyhhqYkZggdCHavvQ6Xto8Trkn9PloaGoakI6stJzEOJqtcoGUxD
         Wbs9toBnzyGaTEYJPtieK606LFcI7TD9zREE5XVW6LOyEW3xboMaPlb3aJb822IT0Pfs
         tosbBpQCSn9K/Eb14/HjWBQ1IgFLH+Bhs8Kr7ZaiaroYSsAMWTmYApZIhkHskyFn6h1A
         XnOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2EZMn5anbPLfRQBVWd21SeZYbpeivIhOwGvH9CL6loc=;
        b=P93+JsXua+0UtD5PR1bX6TaugXOC4geebXGMnjKKwmmfj7MFe/UAk3bg0qy3gx+8Dd
         Cj+n/4SQ5KzSoCoZLHikrTS65MFjFzMR/lKToQ0qQdtmEdCR6Q5OYcFpCCOzV/+wfPRj
         pG4b0fjPFoHYa2gEip96oUUXLYfq2vfFWQImwTpVEkLpc2F+Nm5rkLHTwAs/hqvzIVHI
         2rMLKsCNOAp3Qy+HztzOIeEZTtbNvLjkuEGuNh7M8+7H/jfDV0GG8CAJbMYUhiyMUjZN
         /AgsBst/RHZLxJ2ldeE6fLLezVMyGz6EE91GztdZM/FMVSesDdaaa8+292YBeR0Lm4i3
         ftuQ==
X-Gm-Message-State: APjAAAUL8WxdisFUQH1UUl+N2GYXzKaRdR7cTRdqxkRbuMC3gwPRvg77
        +nVBzSjzk8qd4ABpEF35waU=
X-Google-Smtp-Source: APXvYqysPlXQlVQhkqPByMhrXRzfO5XHuWAjXY9tlQ5Rdb6cauiVO/5Bumjl2bihilKfU4W9DHp5Ag==
X-Received: by 2002:a5e:a708:: with SMTP id b8mr8760033iod.25.1560734571361;
        Sun, 16 Jun 2019 18:22:51 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:e47c:7f99:12d2:ca2e? ([2601:282:800:fd80:e47c:7f99:12d2:ca2e])
        by smtp.googlemail.com with ESMTPSA id u26sm12779570iol.1.2019.06.16.18.22.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jun 2019 18:22:50 -0700 (PDT)
Subject: Re: [PATCH net-next 03/17] ipv6: Extend notifier info for multipath
 routes
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, alexpe@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20190615140751.17661-1-idosch@idosch.org>
 <20190615140751.17661-4-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0bd8a588-0c6a-de20-c2d4-39e46e433a7e@gmail.com>
Date:   Sun, 16 Jun 2019 19:22:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190615140751.17661-4-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/19 8:07 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Extend the IPv6 FIB notifier info with number of sibling routes being
> notified.
> 
> This will later allow listeners to process one notification for a
> multipath routes instead of N, where N is the number of nexthops.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/net/ip6_fib.h |  7 +++++++
>  net/ipv6/ip6_fib.c    | 17 +++++++++++++++++
>  2 files changed, 24 insertions(+)
> 

The need for a second notifier stems from the append case? versus using
call_fib6_entry_notifiers and letting the nsiblings fallout from
rt->fib6_nsiblings? The append case is a weird thing for userspace to
maintain order, but it seems like the offload case should not care.

Also, .multipath_rt seems redundant with .nsiblings > 1
