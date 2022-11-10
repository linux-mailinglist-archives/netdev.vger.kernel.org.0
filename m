Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 579A2624CD2
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbiKJVVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiKJVVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:21:18 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76ED812082;
        Thu, 10 Nov 2022 13:21:17 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id o13so1670392ilc.7;
        Thu, 10 Nov 2022 13:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NJTtFMk9IclrsPZ9bH5dYLYGp8zVd3QiiY7z+IF5nlY=;
        b=SGgOEck9s8MJVqYRKp7ulJYa2RvHlAfha4mZbeGvt2QHcw/gVlrUmSbQ05Mn7IyDJ+
         T+T57zpIL8t2dtaYHRQOydJQzz4CmCkfDlu6aaa/sPGuIoifSGEdMW/Y9I3vkU7XOujV
         msAgn28nX9IV+ubuWCknWbELarl6gc6fph9TOeazYpom5dEtvNMx+vA/n9LqEv81TqzL
         1996ALeQkazRsbhKLnZXQnW5ZBXyPfqMgtw9dAG0zzqATOml3mkdssi5gjFGpw9c2Y9P
         Y3wf0yfWbYe/8tKvfHjxHdqBCXY8CrCuB8kjeBZZ/DnM/3KGkAZ9zopaxNF8pkyL+FJd
         xVqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NJTtFMk9IclrsPZ9bH5dYLYGp8zVd3QiiY7z+IF5nlY=;
        b=zuw/eFKn7X7oS54HSz2uWnQrHMlNFJ0RJTS42VvgCpqlLrVNomnXdIiCp8mIM1WM3e
         KkJUkaAPqvUhVss+D9xvoNbDcO7OTsJzPHWXjx62qEuq7ITtRSF1hc5o/Fav+LzMeXOw
         YmhCBx3WhoCSVSitzEr2vo1sIsq/zMqlM9rd4TIBoOMPp/ggNg8HiximNL38QV6V/5IT
         umDoQ23TasXZZ4V5eYaqNRNZpH8dD2DXM5txzemYk1sg/4PMGrkXr0eMRFdBDay4nJZc
         qb0BbIGWFTX0OCdwKK88MhyihpXkOZYn9DHaY1pAup6I9flwQaOcsR37nosuqoT5Emtw
         J/GA==
X-Gm-Message-State: ACrzQf28pVq5wTZ394cGxGeLQs+t7cOgqurmclbU3HAUSgMVXpjZYjHK
        swInwFZ/RlI8+K5/EAtpRXY=
X-Google-Smtp-Source: AMsMyM5cof5VwkRpjF9dTMXmLIMUk9LM8fqk8PswJUUBw7dzIXzAyzvEcaRhpStE/mnVj0bJorUDrg==
X-Received: by 2002:a05:6e02:20cb:b0:2ff:d44c:67e1 with SMTP id 11-20020a056e0220cb00b002ffd44c67e1mr3614105ilq.104.1668115276866;
        Thu, 10 Nov 2022 13:21:16 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:41d2:94a2:b558:c66e? ([2601:282:800:dc80:41d2:94a2:b558:c66e])
        by smtp.googlemail.com with ESMTPSA id s5-20020a0566022bc500b006a102cb4900sm78796iov.39.2022.11.10.13.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 13:21:16 -0800 (PST)
Message-ID: <bb0f7a70-8504-d402-d759-bef2ebb5d649@gmail.com>
Date:   Thu, 10 Nov 2022 14:21:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp metadata into skb
 context
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-7-sdf@google.com>
 <636c4f5a3812f_13c9f4208b1@john.notmuch>
 <CAKH8qBuv29gSDme+XUaFOMvPWcsrar+U0GjhT9y7ZcKaPrsydA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CAKH8qBuv29gSDme+XUaFOMvPWcsrar+U0GjhT9y7ZcKaPrsydA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/22 11:44 PM, Stanislav Fomichev wrote:
>>> @@ -423,14 +425,25 @@ XDP_METADATA_KFUNC_xxx
>>>  MAX_XDP_METADATA_KFUNC,
>>>  };
>>>
>>> +struct xdp_to_skb_metadata {
>>> +     u32 magic; /* xdp_metadata_magic */
>>> +     u64 rx_timestamp;
>>
>> Slightly confused. I thought/think most drivers populate the skb timestamp
>> if they can already? So why do we need to bounce these through some xdp
>> metadata? Won't all this cost more than the load/store directly from the
>> descriptor into the skb? Even if drivers are not populating skb now
>> shouldn't an ethtool knob be enough to turn this on?
> 
> dsahern@ pointed out that it might be useful for the program to be
> able to override some of that metadata.

Examples that come to mind from previous work:
1. changing vlans on a redirect: Rx on vlan 1 with h/w popping the vlan
so it is provided in metadata. Then on a redirect it shifts to vlan 2
for Tx. But this example use case assumes Tx accesses the metadata to
ask h/w to insert the header.

2. popping or updating an encap header and wanting to update the checksum

3. changing the h/w provided hash to affect steering of a subsequent skb
