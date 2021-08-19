Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F1F3F0F06
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 02:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbhHSAEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 20:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbhHSAEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 20:04:49 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C8FC061764
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 17:04:14 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id p2so3169473oif.1
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 17:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wuJPTLAvROCLxKljJTnxJh1ci+qTUrugU6f3PioXaOs=;
        b=LHIMfeusafUrtrrO7Pp/cwKTHqcW0E8bpcyhmoq9EBqgEpdXfRbket616TYKtd8Hyb
         0rmdQqP5miwMB7Y+ecGBtNgf9c8J5wlvghZnQWN0f9mHypqeTLCqndBq/5zgkG+CnGwT
         OB+iQSWrfB8Za13adcafby5VKfp8POkgbdKoakptJvzZFU9WYcLMq2KyHmQSqRMrLcet
         5APmE2OEHOh5YIhd/fG5fGln0jVoh73hEmbxA70aLCfq/Zh7KNC1AsRJoTMo/2zoEKyL
         JszwG4r871rx4FxUCyPRF1OGmoeK9igzVjiiHlAbUcVhZsKOLQlLBMMUNx9zQSJbKCi/
         cAbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wuJPTLAvROCLxKljJTnxJh1ci+qTUrugU6f3PioXaOs=;
        b=ExHI4tKywacn0dh77207N0wf1KAh3+Lqpw9cWPcdh+16S07BcVz91UIWsMUG3bGmYb
         955Qj4fQVzmmFMM/JJVIlUMCYcHKeGyA0t2cuuaxtnHam+tsfF2Gi5VDf2G904BQHD/4
         4QbMjedgp+VfzPBgtVgnSvM/ji3RT09sX8SzrsN4LFm/y1cxC3c1Yu1kcKk3umJawt3r
         HHwPPgxLLpa5ipBOZY0qxGo8KtSfR8p4D6+eidKVceaLSefDvyP+4HVQS/fsB0JIOmpj
         K5d0XcGqmR++7ZXcqcJ9KidMaXMRZO9WUaJqjD6duE9RdTorCVRwWp1P6Tawhyy0l4pe
         DJyA==
X-Gm-Message-State: AOAM533/g5yJajk4FfpU6JtQNtSrdJRIOFOsPaJ763R3NiPq0OyftVIk
        MFJdh5+6FUxa44xa/uxlmxXV4PV/aOYLGQ==
X-Google-Smtp-Source: ABdhPJwMYEvn80hoaQPBkzAQY6Hq33KFJRBrk6aWeQEk34fNTzbJosprg90WJGTy0Ty+xQisxEXzBA==
X-Received: by 2002:aca:bdd5:: with SMTP id n204mr548319oif.129.1629331453642;
        Wed, 18 Aug 2021 17:04:13 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id s35sm323247otv.44.2021.08.18.17.04.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 17:04:13 -0700 (PDT)
Subject: Re: [PATCH net-next] ipmr: ip6mr: Add ability to display non default
 caches and vifs
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20210818200951.7621-1-ssuryaextr@gmail.com>
 <912ed426-68c3-6a44-daec-484b45fdebde@nvidia.com>
 <20210818225022.GA31396@ICIPI.localdomain>
 <e7a1828a-d5bf-fa88-1798-1d77f9875189@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <44c43842-2e5a-4e20-b2e6-9f2f2ae6cf0f@gmail.com>
Date:   Wed, 18 Aug 2021 18:04:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <e7a1828a-d5bf-fa88-1798-1d77f9875189@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/21 5:12 PM, Nikolay Aleksandrov wrote:
> I do not. You can already use netlink to dump any table, I don't see any point
> in making those available via /proc, it's not a precedent. We have a ton of other
> (almost any) information already exported via netlink without any need for /proc,
> there really is no argument to add this new support.

agreed. From a routing perspective /proc files are very limiting. You
really need to be using netlink and table dumps. iproute2 and kernel
infra exist to efficiently request the dump of a specific table. What is
missing beyond that?
