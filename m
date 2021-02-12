Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2125731A4E0
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 20:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhBLS6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhBLS6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 13:58:14 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF59C0613D6
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 10:57:33 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id r38so233130pgk.13
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 10:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fTIRaQGDP9OiCHPgNlXrKitHSBKvecMNj6tfXGRdOqI=;
        b=iTIyiLWo7ZTyWWBu8RctIbQlygdiKjzlu/hEfhNitiJcVSEDofxV41jSedomdusypB
         f20MzXOCqklIym+HlK/8CSCmkN00SbaLX1pyoQsOh6itIDWkIX4i5EfkpBV8D4/xTU8L
         vR0HDPITpTz/sm1colxGCYhGximEH7n4y1hn3Ujx1+u5LbvJwfkBg1bctAAScvmYkZat
         sG8lH4JfjCY7Oe7rsYRqz23Xa3fR3azwsfHduPNr1K6KVR2iI8Z+d7DE6xwD7mlUV2Qp
         AaSq4to1RFQs92++K8JjsOnG6CxuhLS7DyiVopb9nzaKTIBrzGsGZphx7rN9Vrqbz134
         0OlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fTIRaQGDP9OiCHPgNlXrKitHSBKvecMNj6tfXGRdOqI=;
        b=pD9bvDuxTYVH5G3wL1srJ+QXn8LjPIrbM4Zyf+oRy280oDW7zPNiEWGgRuKw1TNJi6
         fIckw758cQc8FlXvvYwBBweFKLqOtMZp60NgRh6rImXLa0MjbQwdTA0KTXjSItH5vsZL
         5XWkBOXwTGVWbE/c3DLqeQAWP8hFkwp5MxIRVXCiuziSZH6C2t7Q/Z9lBFUNfSRuX0K8
         h5jXcwCJLzfvXXNMKVVpI30UmZ2wK5xw2Qc4sp5DcbP2iRdrD3baIu+IBNDJjPEus4eP
         wHbMigJ+zVPbzoP2WJbO0FFbQ6SqLdLCjdpuV6bjTpxVm23k0kQrkys0QIvP63ByvKSu
         NUnQ==
X-Gm-Message-State: AOAM530FtOlp+5Uds/sUW+ww1p8/p0J+SkyuSeSi945NkBl8pfnaaPX5
        eJNNoaekRNn+ttwHXwZDqvg92v/bx98=
X-Google-Smtp-Source: ABdhPJyvZ9M4LJtGJdU1qQD36gstGqjWMDXt1U55Io/DZNTPPCwweTsOr482R1zmKl2DHRk2WcSt7w==
X-Received: by 2002:a63:4458:: with SMTP id t24mr3523048pgk.173.1613156253197;
        Fri, 12 Feb 2021 10:57:33 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a9sm9898533pfr.204.2021.02.12.10.57.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 10:57:32 -0800 (PST)
Subject: Re: [PATCH 0/4] Bug fixes to amd-xgbe driver
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com
References: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1e573155-9900-7bdf-9b8d-442359a291fc@gmail.com>
Date:   Fri, 12 Feb 2021 10:57:30 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 10:00 AM, Shyam Sundar S K wrote:
> General fixes on amd-xgbe driver are addressed in this series, mostly
> on the mailbox communication failures and improving the link stability
> of the amd-xgbe device.
> 
> Shyam Sundar S K (4):
>   amd-xgbe: Reset the PHY rx data path when mailbox command timeout
>   amd-xgbe: Fix NETDEV WATCHDOG transmit queue timeout warning
>   amd-xgbe: Reset link when the link never comes back
>   amd-xgbe: Fix network fluctuations when using 1G BELFUSE SFP

If these are all bugfixes there would be an expectation that you provide
appropriate Fixes: tag in your commit messages to designate which commit
introduced the problem, you may also want to make it clear in the patch
subject that this is intended for the "net" tree which collects bug
fixes, see:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/netdev-FAQ.rst#n28

> 
>  drivers/net/ethernet/amd/xgbe/xgbe-common.h | 13 +++++++
>  drivers/net/ethernet/amd/xgbe/xgbe-drv.c    |  1 +
>  drivers/net/ethernet/amd/xgbe/xgbe-mdio.c   |  3 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 39 ++++++++++++++++++++-
>  4 files changed, 53 insertions(+), 3 deletions(-)
> 

-- 
Florian
