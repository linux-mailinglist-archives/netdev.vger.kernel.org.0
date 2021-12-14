Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38881473B79
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 04:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhLNDYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 22:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhLNDYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 22:24:47 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C625BC061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 19:24:47 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id x3-20020a05683000c300b0057a5318c517so19513040oto.13
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 19:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=7nPzF4dKOobV096CkNpB9CTF7uynTVpWUFlhbSX3YLA=;
        b=fs012ym/HMLiwvgb8uN4+vAZewcPSDx+KNr1J3Y42fqOHZXJatsDJDyevAX0fTgHIt
         Xk14+B2Yo57aYhx4SRgEP6J0/cTo9/zSJQ2Yq3QEfedTYSuaPENaWE7+lccCEV0tx5w6
         xyWaBQW4UY/MBbQHhYHPWyFhQbzwdO+WaPubTwLQq1Yi0zg2X/jN1ZwLoKIno856TMVv
         ghgkTpSZ1UKtvE5LnYgJzXNutS8sFCP0KbKpwNn30tHO3ru9gYp2no1MMEg0EM2xnWl1
         yP0GfBMMXY5hFlcmhqVZcN2x3gmT91Xxf6xApizxZu2avswHzbAvSpzAwXkfxTCIA+Nk
         +HYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7nPzF4dKOobV096CkNpB9CTF7uynTVpWUFlhbSX3YLA=;
        b=A1xUHyViNAOX5OKgs7QsNO3qBaNO5dLk8Twsg5WecUztxkaaIO90b9ykCfMNNDVS1g
         UvmpJwY6T39Igh94VmPGRJASx3I+K+dKM0Qz80WYAQWIqBO/erhRSP2y7qbUwtYSLreh
         Ugy7wjQ+qldebml1AKCRSUJ3T3uqUytShVkaGY1FxcSaMbHscQxlpArYLEyzA2EbpHED
         ZsKo4NmgxUrhg1se+rC0rwZoANDl189H7dYuLCT6qpd8hnaQ6NWFtnE/fb6jsnftlNx3
         2VGX36AoqjgFoHBceI5yjpGczJkM5qJquzmLf9rZPtFdWrYQ/p91ueD523WxzCVIMk09
         jmjQ==
X-Gm-Message-State: AOAM530Omnv9E6kMy8tMde4iuGqub7BI1XQcfRC4ux2j51gHtLm2knwB
        +ybtEFlRlnLEU3dofSO/WukubKDoWnE=
X-Google-Smtp-Source: ABdhPJzKcwvgZ3rYTwn6qiitnkEfmdx6zJT/4cKhDxcA0j/a2iU9+oH3TCGLjZWkrWmiq03bSctQ3A==
X-Received: by 2002:a9d:1727:: with SMTP id i39mr2202552ota.48.1639452287227;
        Mon, 13 Dec 2021 19:24:47 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id j2sm2548925oor.18.2021.12.13.19.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 19:24:46 -0800 (PST)
Message-ID: <d7ba6b69-4a17-8d43-b2f1-58b8033684df@gmail.com>
Date:   Mon, 13 Dec 2021 20:24:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH iproute2-next v2] tc: Add support for
 ce_threshold_value/mask in fq_codel
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
References: <20211208124517.10687-1-toke@redhat.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211208124517.10687-1-toke@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/21 5:45 AM, Toke Høiland-Jørgensen wrote:
> Commit dfcb63ce1de6 ("fq_codel: generalise ce_threshold marking for subset
> of traffic") added support in fq_codel for setting a value and mask that
> will be applied to the diffserv/ECN byte to turn on the ce_threshold
> feature for a subset of traffic.
> 
> This adds support to iproute for setting these values. The parameter is
> called ce_threshold_selector and takes a value followed by a
> slash-separated mask. Some examples:
> 
>  # apply ce_threshold to ECT(1) traffic
>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_selector 0x1/0x3
> 
>  # apply ce_threshold to ECN-capable traffic marked as diffserv AF22
>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_selector 0x50/0xfc
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
> v2:
> - Also update man page
> 
>  man/man8/tc-fq_codel.8 | 11 +++++++++++
>  tc/q_fq_codel.c        | 40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+)
> 

please remember to cc Stephen and I on iproute2 patches. Otherwise you
are at the mercy of vger - from wild delays in delivery time to
unsubscribing accounts in which case I would never get it.

