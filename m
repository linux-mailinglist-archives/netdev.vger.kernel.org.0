Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9B33588AA
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 17:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhDHPjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 11:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbhDHPjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 11:39:45 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD69BC061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 08:39:33 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id y19-20020a0568301d93b02901b9f88a238eso2668701oti.11
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 08:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bKc1r2Vmq53+TApmDq8AWFH9fuVpRl/nl5FHWe0FT74=;
        b=PNZrVWNOMMjDaT2GqUcshTPDCz4U+EdFtVGmYZFyZb2I75N6uix/9bTICcZQ5Ki/Mj
         QyYHChURDfIKWtIxo8m/1ZNRsUlb369pSLphZan8mAPFlX6i0y5o6RYT7EtlmtfnPfZ7
         pjUHMFieyQq8nrcVO81gK83575ZFO4mBzKU5ZtrGNtZ8htMT8lV9Exy5obau4bsZKjJ5
         tDfA/hfluhVgYXAUP9KaF0cnbp9ayOStJ5nni3+xukDzYlzBYGDTkioBTtLi+8n6X8IU
         B7Nsz8iOY/5ckekIB2EHtcdTiPqbdZyT17Dt2pUJjP3D8uA6p9EVLP60n1nup5BqBWUI
         Oq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bKc1r2Vmq53+TApmDq8AWFH9fuVpRl/nl5FHWe0FT74=;
        b=pAOlUCKlgHvlnECPxXktvBBYLmMQmD1XrsrlinrkWT99xFBBD6RwWfe0kei/mGMWlw
         8g2ZVRhV73BYcJephH3Q5fsFhgEc8WYY/X+1wIvvZ1jojNyPPTkhCHbfoTtuTc0ixYN8
         hibuO/us9mvPGzT+FS7CrfkrkGuHTnv0V19vKyAtlQjirkJoBtCWaOVNAPtBS2pxEYZc
         J6uhVDNBvy+O2mIkEwtSFtCUgkvaz0RpyNznng1oIJ8mNytw6Lod8VWRxVkZPkThh6zH
         3pu2hSGLsvZX1irW0gDxXUCESaUCtyPBhiP1USWSc1mPkN8d1jOdUISCZ2HMJ6BrS+Ko
         IoJw==
X-Gm-Message-State: AOAM533x/d8kaRTTWzk6hY1QEHRRCEsf0kSCQ1ngARsum023C0n78tIp
        KNppuKvCznbFONEDPGb8OYPWNrwA9a4=
X-Google-Smtp-Source: ABdhPJyfFkhYB5FVs8PKH+cupeq1vhD1D0+Yky0UYyiGR//C9nUlU27aLQXwmcFxXqgRXFNTd2QYqA==
X-Received: by 2002:a9d:5a5:: with SMTP id 34mr8478132otd.353.1617896373120;
        Thu, 08 Apr 2021 08:39:33 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id n12sm6396294otq.42.2021.04.08.08.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 08:39:32 -0700 (PDT)
Subject: Re: [PATCH v3] ip-nexthop: support flush by id
To:     Chunmei Xu <xuchunmei@linux.alibaba.com>, idosch@idosch.org
Cc:     netdev@vger.kernel.org
References: <20210406013323.24618-1-xuchunmei@linux.alibaba.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bab23ec9-30ca-defc-6338-825e17927d54@gmail.com>
Date:   Thu, 8 Apr 2021 09:39:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210406013323.24618-1-xuchunmei@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/21 7:33 PM, Chunmei Xu wrote:
> since id is unique for nexthop, it is heavy to dump all nexthops.
> use existing delete_nexthop to support flush by id
> 
> Signed-off-by: Chunmei Xu <xuchunmei@linux.alibaba.com>
> ---
>  ip/ipnexthop.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 

applied to iproute2-next. Thanks,

