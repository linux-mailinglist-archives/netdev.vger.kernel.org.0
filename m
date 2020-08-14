Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDCC244B81
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 16:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgHNO6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 10:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgHNO6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 10:58:32 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959B3C061384
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 07:58:32 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o5so4668489pgb.2
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 07:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pcg5CucYS1Dubmcf/WH/5lZ7jSjqcBaoXBcYvG0rEdI=;
        b=ky8rzvgMFTCFERNv6zjb6o1YDKEATGWA8wJx/tl0MKb4OdELEeQE7mHG91nEY+Ft7A
         EWU2vYKNzr5Y9JHbWhowzb/mnpsl/BKEm3Wph+O+LavSDHvh/v2FEbvrB0RKE2OwPEOF
         Se0DyXyvQJyWd3u+3RkgJi+/TBLNHB/SoWEBDLXRynMHTOc8wBq3xeflsaIXpB0SdygH
         gc2Rd15yxaImLBQ1k0ixR8Q9bA7632r9EsIM+w0yrADGj0Sre1KR+5aTF2yiX0ltyKzw
         nbCBPmBCT5LpyNtrKKOSbMNRQohKl3hMXNpwKyYZXn0aUvFyjVRncH20YRdAJ4QmmgRD
         B2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pcg5CucYS1Dubmcf/WH/5lZ7jSjqcBaoXBcYvG0rEdI=;
        b=bSaUTYz2wPEDU0cYlZOVMhmfRVMHY4dhVkHRZhMtbB1w5xgZ80UQfgwa0O1auZLGMS
         lP254t7wgdX4c3ZAkOoT5eZLSQkqtCRZEAjAKpVTK16Oeh1fvpNL5VGEMlCrpoLl5shE
         7rbqS01CuT9aqWhPcGVMYK76cuFLxgDmA+M0zL7olQKikMS1jNVR9Z9NM0lJ+fjFqrry
         p6t1kMTmy9ra5i1fliOsQCMZBfUdS3SIZLVjfAZgcoWsGPfnzh4kmzyZCATFgqzLCOvj
         QqzbDIEdrHMYm701uUhMaGyRbFGCmi+CHp4oCFbgyDNEz+lKuQChS7oUL5bx1T+YroJC
         Qbjg==
X-Gm-Message-State: AOAM530IPTH2sl4BePGtt5QsDA4H7zI/o8KYqAuTKIGw5F3gsUC1MQnr
        5a+1tj+4bKqFzqtCf4d5x2S1q89u6WQ=
X-Google-Smtp-Source: ABdhPJwyjchJLbhnHqjleQOo75tu7U0TwAF6SCX0QakJIxi0+UwI6AKO6NN3bNxldRd+ozglawwW1A==
X-Received: by 2002:a62:7794:: with SMTP id s142mr2015371pfc.99.1597417111659;
        Fri, 14 Aug 2020 07:58:31 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id p20sm8486931pjz.49.2020.08.14.07.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2020 07:58:30 -0700 (PDT)
Subject: Re: [PATCH net 0/3] ethtool-netlink bug fixes
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20200814131627.32021-1-maximmi@mellanox.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <02b7cf0b-8c02-903e-6838-2108fb51f8ca@gmail.com>
Date:   Fri, 14 Aug 2020 07:58:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200814131627.32021-1-maximmi@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/14/2020 6:16 AM, Maxim Mikityanskiy wrote:
> This series contains a few bug fixes for ethtool-netlink. These bugs are
> specific for the netlink interface, and the legacy ioctl interface is
> not affected. These patches aim to have the same behavior in
> ethtool-netlink as in the legacy ethtool.
> 
> Please also see the sibling series for the userspace tool.

Since you are targeting the net tree, should not those changes also have 
corresponding Fixes tag?

Thanks

> 
> Maxim Mikityanskiy (3):
>    ethtool: Fix preserving of wanted feature bits in netlink interface
>    ethtool: Account for hw_features in netlink interface
>    ethtool: Don't omit the netlink reply if no features were changed
> 
>   net/ethtool/features.c | 19 ++++++++++---------
>   1 file changed, 10 insertions(+), 9 deletions(-)
> 

-- 
Florian
