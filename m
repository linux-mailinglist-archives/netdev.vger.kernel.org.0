Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BDE3376EB
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhCKPWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbhCKPVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 10:21:41 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F228BC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:21:40 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id u62so7676934oib.6
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zsTtDuV81ykue63gLHj1pGOeWxo0HYnDSXAYKh1qTuY=;
        b=sju+KveO7OwwoEs0cfBD0tQno/P+b4mQNMdB3zRELym6O4hLQIMQzseA9TXHYDrpOc
         bIn68tbTkxCPE9yuOftfeKxaexKlqKe4xjtwbXjhx4/oyLK3WZqht2pJIQUR5n8BDi5v
         +UMMxb8YRQTVHu85FMYVCg3wBjWCCH5GvDTWsZoj2qUYYBvw638RYKw37/hYRez0uU6X
         J5CMoNWoNiDAiSN6XMr4ew7Rr8dgPdvuXTOIYsyuwSjP4gRPGsYFzRgEPHY6nQ9jep2l
         a/e2t8rasJqXET5P9/JFCxXk3Q98b7ASpy7po56lZK2QQb5m5MsqTYRNxBDD6PHXGEgr
         JQVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zsTtDuV81ykue63gLHj1pGOeWxo0HYnDSXAYKh1qTuY=;
        b=HUfWSdlsPiBzqBbBCgRCgr1jpXSWzXb4fse/XwnVKKvTYWSb/IQkmfoC2KA8k0/FcB
         vo6wqD1HyxWhPnNr9cQ3hwXI14ZIWTF1mJKqXxazaIHmANkhRf3LVUXV4nRplxHLGVIj
         bauoEVTUs7o3vTrwrI+ORuZa8JP+oBX65H0PaTllH7sVzQDGXK6xHt2Rq0cmFMsQsFfM
         yo2czw5Sob2alkL+ygOQu4WYasue8z+SV0vACznKG/TjEx03BNBI99Gn9NzRTLLBMJr1
         cTF+pIryRcHpKXMP4vojnFrp4ikTJnsL5bO74J0xb21fNEo4janBoE8RVqflST8Qb2dX
         OtTQ==
X-Gm-Message-State: AOAM530kG1h5dCcmSq3+PtqhQvkRNfheaNxymiAsrV7/hibFKJOtHXb+
        ACmIdpKrN+T1NgrOYii6DH8=
X-Google-Smtp-Source: ABdhPJyghOyUWMYWdd3M61q8zg493VDJR2ClhJfrh2OxvQ13CzJD+FQwC6wdx2GuQeHvcRThIAuM1g==
X-Received: by 2002:aca:482:: with SMTP id 124mr6656908oie.21.1615476100454;
        Thu, 11 Mar 2021 07:21:40 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id b9sm573962ooa.47.2021.03.11.07.21.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 07:21:39 -0800 (PST)
Subject: Re: [PATCH net-next 02/14] nexthop: __nh_notifier_single_info_init():
 Make nh_info an argument
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <4e2447a8266746d01da711fa07566099b9cbc75e.1615387786.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <381ed37c-74ac-4fc4-734b-f1304128e609@gmail.com>
Date:   Thu, 11 Mar 2021 08:21:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <4e2447a8266746d01da711fa07566099b9cbc75e.1615387786.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 8:02 AM, Petr Machata wrote:
> The cited function currently uses rtnl_dereference() to get nh_info from a
> handed-in nexthop. However, under the resilient hashing scheme, this
> function will not always be called under RTNL, sometimes the mutual
> exclusion will be achieved differently. Therefore move the nh_info
> extraction from the function to its callers to make it possible to use a
> different synchronization guarantee.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


