Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05292226AF9
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389021AbgGTQhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729269AbgGTQhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:37:51 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9604EC061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:37:51 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id g13so13570933qtv.8
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0K9DJzPUSL+DCae6UdjhlSnNer0nil3yzrdIEua9UHQ=;
        b=nZVV0tGF3uKIG74fws6zSqYTeDU1gsyvmCIcXfdQ26+fgPAsqA+vxEjCZg83Zsf4sF
         33Ytw+Lt/7iqpZkTmI1kPtj8XZZ3mVqLOGEOcBXCTndKWis8NuXJThzhs5Jm8wywqB6F
         5Tpx9b/x7qj5+wMj5aB5rsIBAgajG8cpjaMgEEgtTcULTmToApTsCX4rjF/jMUT9wQK/
         hHiQ0Ni17pRJGw4s8gqMUEQ4bIP4k+WfMhqlDjzaC1xxaNVOXrLBJP/XFuUj94X5BG8+
         ULVJBO6oqioZm8ku25p/sq89bc1CkIno4AE4p4oOLeWuuYJt+rJZcRlpvPJC6bI/A/iH
         hglQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0K9DJzPUSL+DCae6UdjhlSnNer0nil3yzrdIEua9UHQ=;
        b=ERU7EO8Nni6lHuXRIMW0wdM5r6sl+PGbdLx4vPCoiYxJdnbbddwV7UqTgB7NTYdqxD
         aQaEnkaoi7IreNNa+IInjh2NXvHXMMjFL5kR5IQFMbNP0T82Hwx/xn7sK8on/05xs7zm
         fxwM3RBEEhf2rHB7RWm41DdrJqrGjV0RlzXvRJVFRclLRmXCsEz5e41BmNeIqmKgT52e
         Pz6OWhNCBPMXH7CUnHDpcSvH2bJarJ+4PZYYSQQaeg8wyaKAzTMvGyvslQY4v5ofJYt9
         AZc2AHFgPGngzHmNhLW1ArXOeZFWIc8kZ2mYUftUUNCxgYogutxDSCoV4diDfWlq5e+i
         9mvg==
X-Gm-Message-State: AOAM532ktN4lYC4xla9fDvQJmNnRr1SkBn5chwmg/J4sQwy5CEp/PGXZ
        uqNuJySCrxBZ1mSRwoPnZFyBhAab
X-Google-Smtp-Source: ABdhPJyTFuW+fRgVFnP85OsgV2LO1OKtdDAJ8TzZnRlpQMNhEm9h3FrKOVfoDiGSpnSb0qPMQeQnKQ==
X-Received: by 2002:ac8:5181:: with SMTP id c1mr25309299qtn.173.1595263070844;
        Mon, 20 Jul 2020 09:37:50 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:247a:2d5a:19c4:a32f? ([2601:282:803:7700:247a:2d5a:19c4:a32f])
        by smtp.googlemail.com with ESMTPSA id f4sm18877168qtv.59.2020.07.20.09.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 09:37:50 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 0/2] Support showing a block bound by
 qevent
To:     Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>
References: <cover.1594917961.git.petrm@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1a00088f-7d25-082c-422c-b3c16bc15f67@gmail.com>
Date:   Mon, 20 Jul 2020 10:37:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1594917961.git.petrm@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/20 10:47 AM, Petr Machata wrote:
> When a list of filters at a given block is requested, tc first validates
> that the block exists before doing the filter query. Currently the
> validation routine checks ingress and egress blocks. But now that blocks
> can be bound to qevents as well, qevent blocks should be looked for as
> well:
> 
>     # ip link add up type dummy
>     # tc qdisc add dev dummy1 root handle 1: \
>          red min 30000 max 60000 avpkt 1000 qevent early_drop block 100
>     # tc filter add block 100 pref 1234 handle 102 matchall action drop
>     # tc filter show block 100
>     Cannot find block "100"
> 
> This patchset fixes this issue:
> 
>     # tc filter show block 100
>     filter protocol all pref 1234 matchall chain 0 
>     filter protocol all pref 1234 matchall chain 0 handle 0x66 
>       not_in_hw
>             action order 1: gact action drop
>              random type none pass val 0
>              index 2 ref 1 bind 1
> 
> In patch #1, the helpers and necessary infrastructure is introduced,
> including a new qdisc_util callback that implements sniffing out bound
> blocks in a given qdisc.
> 
> In patch #2, RED implements the new callback.
> 
> v3:
> - Patch #1:
>     - Do not pass &ctx->found directly to has_block. Do it through a
>       helper variable, so that the callee does not overwrite the result
>       already stored in ctx->found.
> 
> v2:
> - Patch #1:
>     - In tc_qdisc_block_exists_cb(), do not initialize 'q'.
>     - Propagate upwards errors from q->has_block.
> 
> Petr Machata (2):
>   tc: Look for blocks in qevents
>   tc: q_red: Implement has_block for RED
> 
>  tc/q_red.c     | 17 +++++++++++++++++
>  tc/tc_qdisc.c  | 18 ++++++++++++++++++
>  tc/tc_qevent.c | 15 +++++++++++++++
>  tc/tc_qevent.h |  2 ++
>  tc/tc_util.h   |  2 ++
>  5 files changed, 54 insertions(+)
> 


applied to iproute2-next. Thanks

