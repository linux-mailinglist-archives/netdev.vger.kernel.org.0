Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18D53F1885
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 13:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238586AbhHSLvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 07:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238449AbhHSLvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 07:51:53 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE3CC061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 04:51:17 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id u21so1325806qtw.8
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 04:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cbP82UlIfol2JXQX0LVVoH+XQZqR80DNX2oKYEBRcwg=;
        b=VWA+qHUOb7biPgWExsjKYzgYkr4x4AbOYuR47f1+F9KFsDSqHwPsAxIQtmio+zhTGd
         BwbTveWluUOyCQUXnMCPzTYsPltYSAyLU97PqjUTRvj30uhSBwwwDxEeSkdVOE9qGQwL
         OI0cPJNUO7XUgkpQ0Y9Le7AStbtXqSZM8lwrcJ1j0Lu5BQzEJKE/lkDnaOV0s9BDE+WO
         Mtecm5FKjN75dLuoiMmHQwAf5jG1e+RXTdFTv5r/P0n9dky+0xhdIKwBn066AVeDKokQ
         BpaMGjFO1ehbVsGTGcACJeQBnsQBgUv/m+quJ9EpBlfcGPqwpb3x2AgNhoRB0TRgoWJ5
         +BXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cbP82UlIfol2JXQX0LVVoH+XQZqR80DNX2oKYEBRcwg=;
        b=TpaeOgs7H5qSrK8hYxYDTUuc5eQ9FzKbqbowIJvl0yTx4Smvjlq7E1eFNF8qUABVdz
         EYpxbHYp656yIxUs4BeIWOY5ZCLOgOY2Pio3TBrFTcDhMS1n1CHRRl5JHSUv5FUjN5kl
         h+gKLKwugzkwkXWrNFwBCEfr0e4uqvPYCUdEHZtLyPwbHUqodYcAibAY6aIz5vLbO/LF
         vh8rpRY4MbQI+L/ghELebVaCPn8qmlk4Ck/VIQXrQb/Fs6p4on+hHdWNofyyLKs63r1v
         pUZRvX+oA3acGw7i58omRB/y5gSWpeTf3a8a+YsDmt2s/dyW9+4fEOiXPbLhjnlsXsz5
         SIFQ==
X-Gm-Message-State: AOAM53095o0CuozIVol+8BUFbtwMCNKezbWMLv7KcBbFogyWZbjHTQfa
        iX51hQrW9x8Xhuw5e8+c/RvWFA==
X-Google-Smtp-Source: ABdhPJzX88zsfGsC6OxvvLIXIbOP233sJP0o/2/vsBwKxmyOAc3XQsLuEl+4osMuMEoLX4aWvU5ggQ==
X-Received: by 2002:ac8:5753:: with SMTP id 19mr8185704qtx.202.1629373876918;
        Thu, 19 Aug 2021 04:51:16 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id j26sm968283qki.26.2021.08.19.04.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 04:51:16 -0700 (PDT)
Subject: Re: [PATCH net] Revert "flow_offload: action should not be NULL when
 it is referenced"
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>,
        gushengxian <gushengxian@yulong.com>
References: <20210819105842.1315705-1-idosch@idosch.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <75084a98-f274-9d28-db5f-61eb00492e2a@mojatatu.com>
Date:   Thu, 19 Aug 2021 07:51:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210819105842.1315705-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-19 6:58 a.m., Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This reverts commit 9ea3e52c5bc8bb4a084938dc1e3160643438927a.
> 
> Cited commit added a check to make sure 'action' is not NULL, but
> 'action' is already dereferenced before the check, when calling
> flow_offload_has_one_action().
> 
> Therefore, the check does not make any sense and results in a smatch
> warning:
> 
> include/net/flow_offload.h:322 flow_action_mixed_hw_stats_check() warn:
> variable dereferenced before check 'action' (see line 319)
> 
> Fix by reverting this commit.
> 
> Cc: gushengxian <gushengxian@yulong.com>
> Fixes: 9ea3e52c5bc8 ("flow_offload: action should not be NULL when it is referenced")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
