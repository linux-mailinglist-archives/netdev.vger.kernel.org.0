Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB65D3C13C9
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 15:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhGHNHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 09:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhGHNHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 09:07:48 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47475C061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 06:05:06 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id z18so1395606qtq.8
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 06:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5qfYcPMyVY0d19RFoADAlkfefHdnLSYak6F2oYswTus=;
        b=lamKCibmMH9jnu8448iVTAMtHknfMHfiiAA4AbgcG2jjJh4rRuyqYHVcKgdLU97man
         L8YkBfOpFNft062hYENVpm38nxqv0yJRDpNz8MWLDKtir9kVlRnlltxQFoYm2PXBa2la
         S4/HYqj/zmSbZD/GsHfIbBqjQtoelE8UpOSa+rZGv3dhu51ehhvAatfETVVbu1xU0fXk
         R0ljiU/Jj3yMbueJJSXc3ElV/+YKmTPCVsqJ87DPyaKBF698oplFoc2kf3eR8sT02ZiV
         CUMK51Dac67YxjwCK5ajLEwspZgX9h+pTgaqIbBeq8AIYvP3zLezo/5GVuc668jdzhso
         anJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5qfYcPMyVY0d19RFoADAlkfefHdnLSYak6F2oYswTus=;
        b=ZYN8dWGSIaH0DGULMSmm0x2bWLX2vWQ0rZk/1P4/3BH6pRts+YA/iTzQY8+hB6Acm4
         4GxXZbOaO9P8hmeTbR/CgYjFTL+M2w5oj6zorq9EYsdc33mtYRO5gBB1yir1SbuLT093
         Hc2udgMvTKb+XCzuq7ykCtL9nq6XzP8/WeuKZWFyj9+NhCVKF3l/J27L50C68x23slW9
         sO0XzV+Hwms7kUJoyOGUP6wt1oXt2UQRHFKti+Yz3vOxerIsBeNgvuXX/erAsSBr65Dr
         HBneq/to3+XD8er0A8tax4X84omGmpIWR0PktTrb3CfQVc8tuub6/REWr4xSm/vhxz3D
         Z5MQ==
X-Gm-Message-State: AOAM533HdcB0kAL5Y6OKosi58jSGNCv56hYf5GHmhE6ow5dHutC1cw2m
        WbkGwyPSM1dk3Eg+EI+t2FWRYA==
X-Google-Smtp-Source: ABdhPJwfnPQwPTeWfUM0vcU6Dy3JixlN+DUJR+RVD9Ba1G4Az/96JNcH3UrXW1MbRWKcaH1lopnV1Q==
X-Received: by 2002:ac8:4b4b:: with SMTP id e11mr27737211qts.289.1625749505514;
        Thu, 08 Jul 2021 06:05:05 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id g4sm972598qko.89.2021.07.08.06.05.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 06:05:04 -0700 (PDT)
Subject: Re: [PATCH net 1/1] tc-testing: Update police test cases
To:     Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Paul Blakey <paulb@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210708080006.3687598-1-roid@nvidia.com>
 <54d152b2-1a0b-fbc5-33db-4d70a9ae61e6@mojatatu.com>
 <1db8c734-bebe-fbe3-100f-f4e5bf50baaf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <f8328b65-c8db-a6ae-2e57-5d1807be4afd@mojatatu.com>
Date:   Thu, 8 Jul 2021 09:05:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1db8c734-bebe-fbe3-100f-f4e5bf50baaf@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-08 8:11 a.m., Roi Dayan wrote:

[..]
> 
> no. old output doesn't have the string "index" and also output of index
> is in hex.
> 
> it is possible to make the old version work by allowing without index
> and looking for either the unsigned number or hex number/
> 
> but why do we need the old output to work? could use the "old" version
> of the test.

I think that would work if you assume this is only going to run
on the same kernel. But:
In this case because output json, which provides a formally parseable
output, then very likely someone's scripts are dependent on the old
output out there. So things have to be backward/forward compatible.
The new output does look better.
Maybe one approach is to have multiple matchPattern in the tests?
Davide?
We will have to deal with support issues when someone says their
script is broken.


cheers,
jamal
