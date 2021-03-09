Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D34C331E08
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 05:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhCIEo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 23:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhCIEod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 23:44:33 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7420C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 20:44:32 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id z128so11797225qkc.12
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 20:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ltvKTW8eEl4RxOaDXTwIFC8Z6ICSvQpFGMDcsXS9kbo=;
        b=O0oM4wJ/TwOxLnmn8rzkoXoWrQ1JckhN/6bnjBK49UwduBSuOnyLjMcKmPo7UbQKCY
         5T+1zFv9d/DEv3u+JoMInPX44I04VL+ZbhUMxlycywt+AXOcPCJ9Nf7PEp80eh2B0Ey4
         E8/HYiVRW0nPx7WgtCkjmIif5MJSKEBTh3Sn3Ds/YS6OotSXNGg7XxBESgBnrmjrb3wr
         FceX+dxexPl5K32DBY0cWIlh1U4PHkKAfbw8SQyYKLPTexYL9u0ZBonqm6RkL7JiAUCs
         0WsN+uRlK4cQhQFRm1qoQ112XV7z2TcrXjQzgZo64uYrgm+3/AGK8d4I6gVX+2bhqYi8
         R93w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ltvKTW8eEl4RxOaDXTwIFC8Z6ICSvQpFGMDcsXS9kbo=;
        b=SU8MDbxYYcKgVtlub6OY4K7MIuEMV3ZSSdVq6AGkwFBwmNexvdInyuqw5juAVyd463
         C69DF+jf/+afSnusT/Sl7B85bSfhOfKKtdC5jA2uH7iWk75oln+RJPYSPEum0xC7NhbD
         mpM4IwaXOFMEguPdqn/zwjpsHjmEPKPnTY1Qk6prvXMVP9yJEK/HJGf6GiwHBuBwvImk
         2ZFcZdOvxPJ38Uyr/sLD6xJmyZETkwHM7suYGeeoGMiHmb4MRrVvr8cYtgBV6vvjSb4W
         8dcUdIfzecKDe1dH/mGruS3gFxSO3PNcQ+8ka7EKdjHc1Cat1pIBbqFV+E5CkFYoZuXz
         XaHA==
X-Gm-Message-State: AOAM530s6eVZ90AGZa+cdn9MtVkkF2N0O8Rqlyh58upc82uLkkFLwfIk
        AExhO4/dnS3p99QniWiUgQ==
X-Google-Smtp-Source: ABdhPJwnsRQkrLT87FEOwa5K2PCohOQHikPFQYrzRabo190fz5LUNdyjUyP7gKox1fdgeaC0sCvPUA==
X-Received: by 2002:ae9:f706:: with SMTP id s6mr24669746qkg.163.1615265072085;
        Mon, 08 Mar 2021 20:44:32 -0800 (PST)
Received: from ICIPI.localdomain ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id l186sm9208853qke.92.2021.03.08.20.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 20:44:31 -0800 (PST)
Date:   Mon, 8 Mar 2021 23:44:24 -0500
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Yogesh Ankolekar <ayogesh@juniper.net>,
        Girish Kumar S <girik@juniper.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Linux Ipv6 stats support
Message-ID: <20210309044424.GA11084@ICIPI.localdomain>
References: <PH0PR05MB7557A2136390919FB11B6714AAA09@PH0PR05MB7557.namprd05.prod.outlook.com>
 <PH0PR05MB755758D4F271A5DB8897864AAABD9@PH0PR05MB7557.namprd05.prod.outlook.com>
 <PH0PR05MB77013792D0D90212B1AA0D9EBABD9@PH0PR05MB7701.namprd05.prod.outlook.com>
 <a1c21b7c-c345-0f05-2db1-3f94a2ad4f6a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1c21b7c-c345-0f05-2db1-3f94a2ad4f6a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 09:05:22AM -0700, David Ahern wrote:
> On 1/25/21 4:26 AM, Yogesh Ankolekar wrote:
> > 
> >    We are looking for below IPv6 stats support in linux. Looks below
> > stats are not supported. Will these stats will be supported in future or
> > it is already supported in some version. Please guide.
> 
> I am not aware of anyone working on adding more stats for IPv6. Stephen
> Suryaputra attempted to add stats a few years back as I believe the
> resistance was around memory and cpu usage for stats in the hot path.

Sorry that I missed this. At that time it was IPv4 ifstats. I'm missing
the rest of the context here. Which IPv6 stats are being discussed here?

For my company, we have been doing the v4 stats using the implementation
that I brought up to netdev then. It is useful to debug forwarding
errors but it is an overhead having the out of tree patch everytime
kernel upgrade is needed, esp on upgrade to a major version.

Thank you,

Stephen.
