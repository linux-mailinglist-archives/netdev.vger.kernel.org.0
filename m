Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6615944253D
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhKBBkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhKBBku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 21:40:50 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A821C061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 18:38:16 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id x16-20020a9d7050000000b00553d5d169f7so26171468otj.6
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 18:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PdIrRORsH0x7UXACCq3RrzkYTj4dNEzjRkyYU49r+Y8=;
        b=l+2w28uVTOtZhQSMJ48Va1BdZdlJJFrm2DILQTKmEAKg7OF+5w8DVpoTs7ffj31JeH
         2M1FgysCFydk823Hw1Cb2hPRhnBVVbvvoKgtvgcULb6Dv+BSmJAi5KbcE025StU5CgXW
         cxURqC6K07zHo1hbqzY0EHjoa6IXiBbpG9Q+Xb8141EvT8wZdVW9BcJGSwuNW5wZKV8Y
         +DBChEAJCaEN6oTvqTcV6mtc0FvHrNgF1wiw03W7ODoXmyC/eDAJ3HMIkVaGg4w91It6
         AkdKRVgMj/azc5FcmpEH/EVK8hL2pXy+hoJmV12w8WOGDasU0fzIYLW1AUofnzfv8NQj
         jrCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PdIrRORsH0x7UXACCq3RrzkYTj4dNEzjRkyYU49r+Y8=;
        b=3qInws/G+Qgef0nGQLZZc531u9U2HQ554vePkSE5BBW3h4U+RUU4bv5//8JPKrN5pP
         3X4/hwbld3Oe/rgz1w7+KlsqBRwbwKr3BVHN8Po+65vYY1T+W9Hz3lIHO9NkjnDtvrZu
         JVJemMa4V24c9asjPUKORqHnXwMppmsp/61l2+6fwr6YTnQ3RF4obJrwOwtanEbZICJx
         pZ0k6KfdWnfNlOdHQ2VmZKAuvxdno83wGsH4QGP+C9DgiOhnx7F2u+ldq7pY3y/nYfMa
         vpY1FGQGPgJ1c2eLFr8oLpexklY9U2MJEi4PXPk+kVLFZNnlvQm1Q9WUYMPJ/kSuISr/
         zPDQ==
X-Gm-Message-State: AOAM533ophpPn0ahWKbZOckCJYjGbM9huV3sORLN+jinBHTnpPQXkm4B
        wcthvZI4XFXvelFNWeIoV9I=
X-Google-Smtp-Source: ABdhPJzrl6aSPO2DMxyQnKIzZkeanRXGNXm0bfLfzzmOjx5N+eiDav4ljg87HRGs6PU6/Kc9SRlxVA==
X-Received: by 2002:a9d:5cc4:: with SMTP id r4mr7501192oti.19.1635817096069;
        Mon, 01 Nov 2021 18:38:16 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id i5sm2557116oto.29.2021.11.01.18.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 18:38:15 -0700 (PDT)
Message-ID: <bfcde722-6583-0677-0922-838212046960@gmail.com>
Date:   Mon, 1 Nov 2021 19:38:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 3/3] selftests: net: add arp_ndisc_evict_nocarrier
Content-Language: en-US
To:     James Prestwood <prestwoj@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, roopa@nvidia.com,
        daniel@iogearbox.net, vladimir.oltean@nxp.com, idosch@nvidia.com,
        nikolay@nvidia.com, yajun.deng@linux.dev, zhutong@amazon.com,
        johannes@sipsolutions.net, jouni@codeaurora.org
References: <20211101173630.300969-1-prestwoj@gmail.com>
 <20211101173630.300969-4-prestwoj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211101173630.300969-4-prestwoj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 11:36 AM, James Prestwood wrote:
> This tests the sysctl options for ARP/ND:
> 
> /net/ipv4/conf/<iface>/arp_evict_nocarrier
> /net/ipv4/conf/all/arp_evict_nocarrier
> /net/ipv6/conf/<iface>/ndisc_evict_nocarrier
> /net/ipv6/conf/all/ndisc_evict_nocarrier
> 
> Signed-off-by: James Prestwood <prestwoj@gmail.com>
> ---
>  .../net/arp_ndisc_evict_nocarrier.sh          | 220 ++++++++++++++++++
>  1 file changed, 220 insertions(+)
>  create mode 100755 tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

