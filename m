Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFFB440ECB
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 15:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhJaOW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 10:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhJaOW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 10:22:26 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9B4C061570
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 07:19:55 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id bu11so1766106qvb.0
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 07:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=gJ+Yv2QFWmckkfdIiof2II8KoZuBAzmaaRASWU3VJFQ=;
        b=6oFxJXCRRl+crTsVApePE81JLvByppsU2cjs7KkV0OBXcds01yuYecjBP1yvGVLbT3
         a/+lwhNEHsaoZRBsk68vMXC5Myab9PV+BzsD6eUMYPGM4pmr0/2E2ygFKvBq/tpE76y9
         5in3Nfbebx1XOE7TyQvorVtDo9P/lOE+Cka0VbXND0uxpF9ltvhAyitbEUMtVvAoB6p1
         Q3OcW/e9yoQLniFlXeVU9HOSlC3IscXPcgC0VB4qMAiJrwa4jgDdIQOAcho9EiNleA1r
         I2kUK/A+GZDd5CM9W+8kERaScuvqNHFvQa82XWUMv77G65lYVYzwcpV8Raox0cdoigN+
         GY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=gJ+Yv2QFWmckkfdIiof2II8KoZuBAzmaaRASWU3VJFQ=;
        b=WgaZgjLe6oIuC7eKtChNj/MoqMipWBC2eMIdFOY5tU8XqI4C1cXKCLtuD1936GQoWc
         i9vzMJSyx+aDcsens3WNMQlmBz9sYXe8a4J0zOgv/GkAvaMAGNQsK5amWpkcJewZU5tT
         CNzvATlUVL4kPpLSXp71ob+qI/DnubU4iK8PbF3XdQOPdo7rRAqepyT1e1e+q83/GxYe
         q9yE4eQcm5J1aFyABKw+a8NqTe3O5kTjAiYbo/jUPe3VES7j+C+zErXFy7p8Ry/IeFsV
         SPa0dWDvnXaTKOI9mj3XYZeVAOe7QbKBT1PHyS+ZmTn2DvaDNs6mz8r5lBNbViw53wLS
         OQCw==
X-Gm-Message-State: AOAM531oaiQfyLYrM4/GE2sncWTPy0rkb5zZGIsYhDS8/YmJWXuwCVXW
        7EBjvUg7GDAVwpHLLMUIpNjxmw==
X-Google-Smtp-Source: ABdhPJyHsTZ8Qtk59ZcM51eSRBY9M4qm6sk+LmdQHq1r7jxtXXXisTDIZcs6YK7Sag6w33BSnGkPIw==
X-Received: by 2002:a05:6214:cce:: with SMTP id 14mr23111239qvx.49.1635689994188;
        Sun, 31 Oct 2021 07:19:54 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id a11sm2588963qtx.9.2021.10.31.07.19.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 07:19:53 -0700 (PDT)
Message-ID: <09480c67-32eb-03d6-4f71-95387263bd3e@mojatatu.com>
Date:   Sun, 31 Oct 2021 10:19:52 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 0/8] allow user to offload tc action to
 net device
Content-Language: en-US
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Dave Taht <dave.taht@gmail.com>, Oz Shlomo <ozsh@nvidia.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Yossi Kuperman <yossiku@nvidia.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <b409b190-8427-2b6b-ff17-508d81175e4d@nvidia.com>
 <CAA93jw4VphJ17yoV1S6aDRg2=W7hg=02Yr3XcX_aEBTzAt0ezw@mail.gmail.com>
 <4247ecd8-e4ca-0c35-5c0f-1124a043080f@mojatatu.com>
In-Reply-To: <4247ecd8-e4ca-0c35-5c0f-1124a043080f@mojatatu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-31 10:14, Jamal Hadi Salim wrote:

> BTW, Some mellanox NICs offload HTB. See for example:
             ^^^^^^^^

Sorry, to be politically correct s/mellanox/Nvidia ;->

cheers,
jamal
