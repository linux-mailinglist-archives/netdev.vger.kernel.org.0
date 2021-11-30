Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B06463D4B
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 18:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245102AbhK3R7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 12:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238677AbhK3R7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 12:59:49 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6ADC061574;
        Tue, 30 Nov 2021 09:56:30 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso31304953otf.12;
        Tue, 30 Nov 2021 09:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sP3a2w9TIAvowtRsPrZvQyg1T33o3v6kWhUG+u0tLlE=;
        b=b4upmZcT1t7xQzyUYE8KQU475W7lJjkGOOYfS1joYDLLcIERbWMU/rYjx7209HwrNK
         algIH55puJuHwwc10ZxvR1AEIiK4O2PxuSQVc8xC3OZkhiAusKoWmtGw0R/JSagg5hqj
         KOOgnN/EGXChaY7ZmP60oildRx3fhZZhcDhel4GtuG1xIv6nTDwuRXVJkksQZWh1IagO
         omft/vl1YWdZRzgivXLMgLiuDzpHzGrF4WSVr4AH6Usp1IBVbxoh9j+cH1ov3fP5ziir
         rRlrtvtaHkZ2YdiEPHMCzm8vwp+Gotsvw/4NMmw20OEne3Yob3RGtquWPRUGJqLVs4fO
         gfmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sP3a2w9TIAvowtRsPrZvQyg1T33o3v6kWhUG+u0tLlE=;
        b=XgDoTK2KdmgGZOKfCcXH8MppavQ5Cnv27XeWrioO8OTXLx/e+zkM1B/+ik55tAaaEX
         nx9hy+94HYdvcHt8kp3IGejG1p/113RDYLcpKt+dxha063E53oW+0FNpfgJWTNiYtU5N
         FLJLfLthwU2i6lpg2FKWShQMDN3+wUsL5b+XoS5msMSXqWfiuMpyeP7NNMetdcYf7PFt
         RxBj9pJccork6BWb215fURx7oTjvZobC0Nw0BOliYAp28dhPKowRi1QkjlDLMswwaczZ
         a+OM2kDIUDkzqAbUDHEzKjTM9xizty8nf/nbttfmM8/KPsAjaiID25bPdADVXqmYRe7F
         SHbg==
X-Gm-Message-State: AOAM5321Ve7HOpKNAyaa01KJ73i40OjiDL4xjf9WjM+j7LdnL8bAQu0G
        BF13+PMwQkNKy6JtgWyjmYU=
X-Google-Smtp-Source: ABdhPJzy2Yq4AwU02waQ4hZbuxHokWD5+Xy6wCmmsKNJziTS72PXddbDdSp6ndvI+xhGOJyxmVEkkA==
X-Received: by 2002:a9d:67d5:: with SMTP id c21mr733642otn.128.1638294989887;
        Tue, 30 Nov 2021 09:56:29 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id r5sm3859326oiw.20.2021.11.30.09.56.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 09:56:29 -0800 (PST)
Message-ID: <d9be528c-af35-6c10-c458-9e2f7759bbb3@gmail.com>
Date:   Tue, 30 Nov 2021 10:56:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2 net-next 00/26] net: introduce and use generic XDP
 stats
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
 <20211130155612.594688-1-alexandr.lobakin@intel.com> <871r2x8vor.fsf@toke.dk>
 <20211130090716.4a557036@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211130090716.4a557036@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/21 10:07 AM, Jakub Kicinski wrote:
> On Tue, 30 Nov 2021 17:17:24 +0100 Toke Høiland-Jørgensen wrote:
>>> 1. Channels vs queues vs global.
>>>
>>> Jakub: no per-channel.
>>> David (Ahern): it's worth it to separate as Rx/Tx.
>>> Toke is fine with globals at the end I think?  
>>
>> Well, I don't like throwing data away, so in that sense I do like
>> per-queue stats, but it's not a very strong preference (i.e., I can live
>> with either)...
> 
> We don't even have a clear definition of a queue in Linux.
> 

The summary above says "Jakub: no per-channel", and then you have this
comment about a clear definition of a queue. What is your preference
here, Jakub? I think I have gotten lost in all of the coments.

My request was just to not lump Rx and Tx together under a 'channel'
definition as a new API. Proposals like zctap and 'queues as a first
class citizen' are examples of intentions / desires to move towards Rx
and Tx queues beyond what exists today.
