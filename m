Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BD93E268E
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 10:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243914AbhHFI6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 04:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243591AbhHFI6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 04:58:39 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE2DC061798
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 01:58:22 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id c25so142287ejb.3
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 01:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Iw/Qld2BXHBhuZYypT5bN2CCKgDqDnynAHMjC5IKYhw=;
        b=bAuhZuxuGSyYxPQn5X+Har7aoOkIEccdwEP6EtLovSPxgCEtOc1Xu8fMKZ740wXuY4
         8y2h444bZoljFnbwX5td/YoN0oYU9d+iQM2ArWXpJtbR0ZAajjYfZGt4MK5VLkkKJPon
         n7qiFiw/n6OArpr/D8vO4mauFptmiqu9sJk3jE9lrSg2cH4naqDt7atF29DovPILkgEX
         tAPm0vBv6ySPI2IxPGnFpeDMvSiFvRPzGLk1kbkIokGld4ot4pQGAVNAmU6g/sKwvkAx
         l02Ocaklk5fmuT8P1yC2ib+wjgfmDct3ga28KyLUNKVxCQi+YFe80w3g3838FNNL8wCZ
         AzFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Iw/Qld2BXHBhuZYypT5bN2CCKgDqDnynAHMjC5IKYhw=;
        b=GfpS661fve+P+9zknhASn3ZmhmDbJRiZdWfpiwzma5p6RJL2fAs9G1FFWw0NmoCBse
         78CMO1RdePBcLFAgBrI4SfoC4JjEtZZK+MAbQNTE4xKOtEB1K8j94pG3IhqkHdL27uwE
         3zi1SPnXChT7LaM3TWXa/fO/ygiPAb0bWcIgDQR5tcIoiK8PjoO+MaPP7Jhns79P7oA+
         ZREkjMJrRiymBh8GOBpogARnkV04NDgs4UQl5XWirxERmST9vytt1FtuP06r1JeqWpa1
         NOvIOxBs2VuzILM0o0ejWeFJo1BqKDpnNbsWISFi802yRBDYRCs2qRSZ3KlPwbgFpXTf
         GuIw==
X-Gm-Message-State: AOAM533OkivSay1eXAmKiL8ViM+FT67Kn744KcxOZS1O2O17Mzvtdmbm
        gAXg/SnbeCEm8GPZy/JdySfzMQ==
X-Google-Smtp-Source: ABdhPJwY5LT29MLFMd+DAew3TMJoytUphZsKpnjrTCeSOTD1wf0nQmwfAyslJIIt2cMFwxki8xFdWQ==
X-Received: by 2002:a17:906:138d:: with SMTP id f13mr8998205ejc.34.1628240301420;
        Fri, 06 Aug 2021 01:58:21 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net (94.105.102.61.dyn.edpnet.net. [94.105.102.61])
        by smtp.gmail.com with ESMTPSA id mh10sm2648924ejb.32.2021.08.06.01.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 01:58:21 -0700 (PDT)
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210806063847.21639-1-yajun.deng@linux.dev>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH net-next] net: Remove redundant if statements
Message-ID: <4b175501-50c1-fedf-1eaf-05c0de67c3c8@tessares.net>
Date:   Fri, 6 Aug 2021 10:58:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210806063847.21639-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yajun,

Thank you for sharing this patch.

On 06/08/2021 08:38, Yajun Deng wrote:
> The if statement already move into sock_{put , hold},
> just remove it.

I was wondering in which subtree you had 'sock_put' checking the socket
pointer but then I realised you sent another patch just before adding
this check: "net: sock: add the case if sk is NULL"

Please next time send them in the same series to clearly indicate that
this is the 2nd patch (2/2) and it depends on patch 1/2.

Related to the modification in MPTCP part: it looks OK but we do a few
other calls to 'sock_put()' where we don't need to check if the socket
is NULL or not.

In other words, if your patch "net: sock: add the case if sk is NULL" is
accepted, then the modification in "net/mptcp/subflow.c" is OK for us.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
