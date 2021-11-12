Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5AD44DFED
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 02:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbhKLBuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 20:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbhKLBuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 20:50:05 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A40FC061766;
        Thu, 11 Nov 2021 17:47:14 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id r130so7163057pfc.1;
        Thu, 11 Nov 2021 17:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yZUQpHH8EOsMiGYKbBxxfUUZsq40G12hcknDz/bkzZA=;
        b=E60h2xr9V5L16YiyNWnDmpkAMH1t4Vt+Wn3XlB/2E3ArVZtudebgs4jQmhA77RN/tX
         Yw3l4o2VYyWiEXITZCpeOWdMCv6WsJ8PAhJeqxbDO4jxU+i58gjxDQupWIJEYK35OMdO
         tt7WN3r85xzKcfgQVntQgnZN0iX1yFRA97SfwsVV9TGI7YYxdPqmg/Gwy1PcmezjV6cK
         TVkz2tAwTVjPWq9lwWbddX/kdJhDAhQ2VFWsKeQsv2ZPlVnQVFOK7PQtI6Rlp6KBDzt1
         fmlStLNrEYJfB1XpxMFiWdnXmQWiIkIb9dYuXT+0sSNOKF8foRU6t5s2gDHToktFVSQr
         4EHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yZUQpHH8EOsMiGYKbBxxfUUZsq40G12hcknDz/bkzZA=;
        b=GbmMFRyU/QhDETSzI39E+JZewTFe0RsV13DK6uLBH33mYg59WCO/VDEJBkwlHw8w+D
         U5Ryac6c3EKDIoRCJvhoO5lhIsd7O0D4N2KaNJNZNUsxt4o+fH0F4h8bkZyqNJXnnrmW
         KV3Ma69lGHU/8OBUWUgkClIX5gorSwwLZm0i+HGy+llewMPcB5z/Rp5F785xLTFaPbjw
         mKopjzlL566XE0ycrcVWSBFNeTRnb3WKwpgHQ2efHehkExlTPOAL72rOCLgo6k+nVlWt
         7jCpM4a0sb+Sv8KiZpbXG6D9p6WlbjdfWjxMKrsi7fz422gQVWEXp6wXI/HlOWR15yT8
         XLdg==
X-Gm-Message-State: AOAM533k/0m2uhSBd/dpn4WbUjzAj2LavP/npX9qtxBiRFMDup3GymZs
        X4tbVGhUOn6E6irqkfR1PFo=
X-Google-Smtp-Source: ABdhPJyCg0vfJCfuZAsQaubLcmbzXcF1lpLMAwnpNq/sJRR1FLYoS3zVBTgD7drgjFyc4pu+0ApJ7Q==
X-Received: by 2002:a63:9f1a:: with SMTP id g26mr7570211pge.170.1636681634122;
        Thu, 11 Nov 2021 17:47:14 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id r8sm3084285pgs.50.2021.11.11.17.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 17:47:13 -0800 (PST)
Subject: Re: [PATCH linux-next] ipv6: Remove assignment to 'newinet'
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        luo penghao <cgel.zte@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        luo.penghao@zte.com.cn, zealci@zte.com.cn
References: <20211111092346.159994-1-luo.penghao@zte.com.cn>
 <163667767064.21646.9365544142891525487.git-patchwork-notify@kernel.org>
 <CANn89iL7bO-vspoqTvyWZ22vp7qgiC+jC7fPm8XTtoiF8k+2EQ@mail.gmail.com>
 <20211111173545.2278b479@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <78345c75-fcc4-1b00-4a41-aa0fec1e1e14@gmail.com>
Date:   Thu, 11 Nov 2021 17:47:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211111173545.2278b479@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/11/21 5:35 PM, Jakub Kicinski wrote:
> On Thu, 11 Nov 2021 17:16:32 -0800 Eric Dumazet wrote:
>> On Thu, Nov 11, 2021 at 4:41 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
>>> Here is the summary with links:
>>>   - [linux-next] ipv6: Remove assignment to 'newinet'
>>>     https://git.kernel.org/netdev/net-next/c/70bf363d7adb
>>
>> But why ?
> 
> It's just the bot getting confused because the patch is identical.
> 
> Sorry, I should have marked it as Rejected in pw before I did the pull.
> 
> Note that the commit hash from the bot's reply is identical to the
> commit you quoted.
>

OK, good to now, thanks !

