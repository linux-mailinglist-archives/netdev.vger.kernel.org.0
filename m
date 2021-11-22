Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAE6459344
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240334AbhKVQpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240321AbhKVQpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 11:45:12 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701C2C061714;
        Mon, 22 Nov 2021 08:42:05 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id v19so14593222plo.7;
        Mon, 22 Nov 2021 08:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TjW1TgKLrc7ubU2vSzYzZL8ghSe+3NIEgSN3o9SQOHE=;
        b=UDgbNCCXoGAIYiCSLRb5hkduO/YAB90rSC3X+TjSISze+lhKH0q8YcmDyjQZBd+8Lx
         cu1yqaNvUF49+bdD54ikqPupQzADDJSI3GToC+gtIkPqTw4WKxvtQcO+ufm8eZhZVFJh
         gvw7bITBeLSySdisq2bKOy+R7jjVDafFEq0UR2UCpG05IBWGyll9ihPnZSCZIdz1lEiA
         m8Jy3TXHBQyBO+Jid0cdLA2AMTuokSAgDQzHHyB6FUuibDMcMUi7gp5ibVktzxuuhHsF
         xCTnBdT3zluyVsHQqFCRsbNishB4ysKvgHJlkdnGfTdBaAFthMaAU0b8Nz+T9AinhyUq
         r2/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TjW1TgKLrc7ubU2vSzYzZL8ghSe+3NIEgSN3o9SQOHE=;
        b=uFUGjRVAl3LpdHqzNDbc/Olw6YEEOmy/wb8HB2ZeSs+NZkKiTMNkpD8b6wTMYCVz6S
         +dS0S/bEgzpJ/IQYH6XfnEfs/j7BcLYn6uAq9xyQpfTIUEEja2LPc+CtB17S7uoRg/HQ
         OCh+Zj6n2w5sOVMci/ghWadYtjXwOqUxi8q45PK7qqVqAeEfg0v3mb4qW7APWuA/S9Dl
         tGM/rA2S8ZrMYSWdjcyCrIMHo/LJJPd9U5mOEhvlDSFa2il/vabV+CkLRZqn2BPgr4FA
         UQr/NgjH9MWIMlp5xpE5zXSW5Tm4znNOOVmblOa822hpKEablo/Yc5EaC7QoNlPHlBDF
         NEbw==
X-Gm-Message-State: AOAM533CaPXzTlIj+/a96Cg/Gk8Cqnbn7YWPaLv4+EcALv39IkcL7ZIN
        6oM3s6x9cTeKWMpKKbYpWus=
X-Google-Smtp-Source: ABdhPJyec6f9YsWAT2OCkT7F6eQ/F2n2BFQZH/vHxkGAlhJrB9TuioxLdHWiwgirFHequejdhf8aBA==
X-Received: by 2002:a17:90a:ca81:: with SMTP id y1mr32705590pjt.231.1637599324858;
        Mon, 22 Nov 2021 08:42:04 -0800 (PST)
Received: from [172.16.0.2] ([8.45.47.42])
        by smtp.googlemail.com with ESMTPSA id u22sm9849704pfk.148.2021.11.22.08.42.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 08:42:04 -0800 (PST)
Message-ID: <3672df5b-7e23-f51c-c396-c9b8a782233e@gmail.com>
Date:   Mon, 22 Nov 2021 09:42:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2 net-next 0/2] net: snmp: tracepoint support for snmp
Content-Language: en-US
To:     Menglong Dong <menglong8.dong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, mingo@redhat.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Menglong Dong <imagedong@tencent.com>,
        Yuchung Cheng <ycheng@google.com>, kuniyu@amazon.co.jp,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <20211118124812.106538-1-imagedong@tencent.com>
 <67b36bd8-2477-88ac-83a0-35a1eeaf40c9@gmail.com>
 <CADxym3ZfBVAecK-oFdMVV2gkOV6iUrq5XGkRZx3yXCuXDOS=2A@mail.gmail.com>
 <9ad07da4-8523-b861-6111-729b8d1d6d57@gmail.com>
 <CADxym3bTScvYzpUzvz62zpUvqksbfW-f=JpCUHbEJCagjY6wuQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CADxym3bTScvYzpUzvz62zpUvqksbfW-f=JpCUHbEJCagjY6wuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/21 3:47 AM, Menglong Dong wrote:
> On Fri, Nov 19, 2021 at 11:54 AM David Ahern <dsahern@gmail.com> wrote:
>>
> [...]
>>
>> But it integrates into existing tooling which is a big win.
>>
>> Ido gave the references for his work:
>> https://github.com/nhorman/dropwatch/pull/11
>> https://github.com/nhorman/dropwatch/commit/199440959a288dd97e3b7ae701d4e78968cddab7
>>
> 
> I have been thinking about this all day, and I think your words make sense.
> Indeed, this can make use of the frame of the 'drop monitor' module of kernel
> and the userspace tools of wireshark, dropwatch, etc. And this idea is more
> suitable for the aim of 'get the reason for packet drop'. However, the
> shortcoming
> of this idea is that it can't reuse the drop reason for the 'snmp'
> frame.
> 
> With creating a tracepoint for 'snmp', it can make use of the 'snmp' frame and
> the modifications can be easier. However, it's not friendly to the
> users, such as
> dropwatch, wireshark, etc. And it seems it is a little redundant with what
> the tracepoint for 'kfree_sbk()' do. However, I think it's not
> difficult to develop
> a userspace tool. In fact, I have already write a tool based on BCC, which is
> able to make use of 'snmp' tracepoint, such as:
> 
> $ sudo ./nettrace.py --tracer snmp -p udp --addr 192.168.122.8
> begin tracing......
> 785487.366412: [snmp][udplite_noports]: UDP: 192.168.122.8:35310 ->
> 192.168.122.1:7979
> 
> And it can monitor packet drop of udp with ip 192.168.122.8 (filter by port,
> statistics type are supported too).
> 
> And maybe we can integrate tracepoint of  'snmp' into 'drop monitor' with
> NET_DM_ATTR_SNMP, just link NET_DM_ATTR_SW_DROPS and
> NET_DM_ATTR_HW_DROPS?
> 

you don't need to add 'snmp' to drop monitor; you only need to add
NET_DM_ATTR_ to the existing one.

This is the end of __udp4_lib_rcv:

        __UDP_INC_STATS(net, UDP_MIB_CSUMERRORS, proto == IPPROTO_UDPLITE);
drop:
        __UDP_INC_STATS(net, UDP_MIB_INERRORS, proto == IPPROTO_UDPLITE);
        kfree_skb(skb);

you want to add a tracepoint at both UDP_INC_STATS making 3 consecutive
lines that give access to the dropped skb with only slight variations in
metadata.

The last one, kfree_skb, gives you the address of the drop + the skb for
analysis. Just add the metadata to the existing drop monitor.

