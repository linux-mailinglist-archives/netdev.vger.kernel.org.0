Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D473393C4
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbhCLQmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbhCLQls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 11:41:48 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70504C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 08:41:48 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id x78so27475848oix.1
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 08:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4Zs/wPBvV+4qm/zxvGOuuyd5kSdA1r+LgTJhKkXPAgQ=;
        b=PgdmptLOKD4SgSQGMUdVv2qGXZgweKSNeQiV1lG3hSAUMotBPuLlWTbBCUnYcTu7lF
         Ww3iZ5b8edemvmJ0n32tSTjZQ3cex2L2ThY/Ajd56/U8LnPkIBI/Bg7kFv5nGJBeOIGr
         9S6O732AArZ42rDoSH8uV/xxOFvHrRKuH7wfYnk8BS0gqPaSXb9f+RQ5b/O33yBf7/3y
         pRenUqzPPKBI/S/rCXdp9dNZ/uFmp1obU+5o7PK0Eu50jfcTGB2u/hw4a3XCqz6+VN85
         Z4C4DFkndS40MgC4iH77aOI4UTqDLBvRTlG69uwpBzpxCWqeNSqWMQbEbj02i1xLjfj4
         H8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Zs/wPBvV+4qm/zxvGOuuyd5kSdA1r+LgTJhKkXPAgQ=;
        b=lA/WxSsbVJqAkubtwB069AXMvrFw9DxJA4pEpH8IfBk7H6l4IWQpbXxT/LMNotPpZk
         DiO99GPcQufE4AyE19YhaJNCOFVja1SfXwXQI2Bm6o2kJL9CdTmYlbPv048t5rsfVy2z
         e4Pm7w51mu3tLNMjMLEzCO4RO3hBSWemu9IrIiObEdWtyaJ9nz4qDrIVz0eH7oSvtq8w
         uPxE29GktGRmvEC5lFbym7kt4yuQKOov6ORLBb03r9OhvKw17THlmVRqD8shmOzOXiTd
         k3aR2vICETFSJgq2JPme5PI5OGyePC3B2kTVo9A6rq3sI03D/kn6etmh5OAukICl9QyS
         eEnQ==
X-Gm-Message-State: AOAM530PLstJDC2KOyJW3xXalavVuimjKgKZzt/m1qJ1gkBCafV+RkbD
        wT7B5tnSAi8tzrrpugN+QvJ734WZEV4=
X-Google-Smtp-Source: ABdhPJyUyQ1Ov0rJnF8G+EQ83cQID3bp7+UzMTmQBqzx03DDF/oad36H7NP6LFAi3gUEmifKg1ZfYA==
X-Received: by 2002:aca:4fc1:: with SMTP id d184mr10563174oib.31.1615567307764;
        Fri, 12 Mar 2021 08:41:47 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id n12sm1536733otq.42.2021.03.12.08.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 08:41:47 -0800 (PST)
Subject: Re: [PATCH net-next] net: ipv6: addrconf: Add accept_ra_prefix_route.
To:     subashab@codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org
References: <1615402193-12122-1-git-send-email-subashab@codeaurora.org>
 <d7bb2c1d-1e9a-5191-96bd-c3d567df2da1@gmail.com>
 <cbcfa6d3c4fa057051bbee6851e9d4e7@codeaurora.org>
 <b15ef2166740ad67c7685aaed27b5534@codeaurora.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <53896877-38b9-ec01-1c00-28dcc381aec7@gmail.com>
Date:   Fri, 12 Mar 2021 09:41:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <b15ef2166740ad67c7685aaed27b5534@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/21 7:22 PM, subashab@codeaurora.org wrote:
> 
> We are seeing that the interface itself doesn't get the address assigned
> via RA when setting accept_ra_pinfo = 0.
> 
> We would like to have the interface address assigned via SLAAC
> here while the route management would be handled via the userspace daemon.
> In that case, we do not want the kernel installed route to be present
> (behavior controlled via this proc entry).

sysctl's are not free and in this case you want to add a second one to
pick and choose which data in the message you want the kernel to act on.

Why can't the userspace daemon remove the route and add the one it
prefers? Or add another route with a metric that makes it the preferred
route making the kernel one effectively moot?
