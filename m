Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2C2337890
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbhCKPzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbhCKPzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 10:55:33 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B0AC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:55:33 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id x28so1902436otr.6
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P/8aPwqEHz0qkqDMLcPO+GdeFZCRhh3pnFBeP1EbLs8=;
        b=JRRgD8sWVrnU5kVW2RjT3oOOqbikA3nDoQFCP8fc84/BXopjd67BAjR5ntuZK4H0v1
         FBG0xlm//aOVRfq94dytQ5SdXoZ14aMfIqtWpNqBV+rhRWn4y33D7RuTafm5aPoGkULm
         0k2JsoJHJuiy7MZRedFM4hlOZgRHgrlN+aZaDEJUvYf9JlUticR+a/AX8htk5LoIjgjQ
         VA8w3cakwt3vmJnVN0Z7tkjMxDPC8yIO50hWIRL7KT2OXfIUqT47Ro8lW6ydkoftJ7WN
         1MCf+SLtfnug+Kdye1hP64w/vxALqIgUUktuNFTf0LOmGPZX++UTsT5iX3N6hSdScNGD
         HwLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P/8aPwqEHz0qkqDMLcPO+GdeFZCRhh3pnFBeP1EbLs8=;
        b=hUAz1gkr4hgRLY+mB+ZuRmOKxMcpQ8VjL9aOutKZiuD1YOZ6U9+KTXU/7G1S15D/Eq
         0O+ojsuU8o7XPtURqjEI6hUS/dua3ulIjB7/+ZrzmdPC6HuFG0f/+Yvt3aPBD6YjqoAp
         LTSZfmbjOq4mNfe7fo11CFBEmcz09CX7hd76R0j0Qy5NwoaipKMqkDWw3Umoea3zndns
         Br6f+DUq/5XsLV3oJWGjumGPQrz8cnZLp4K9HPGuTO13Le9xFZQVLZXpphPvvObdFt1p
         ZKVzJgQsdUhw/kzxLmpcO5mSPt9JsF+AcP7sw79HOGjUqZO0G0DnNmlphDQ7OtOL4g4a
         tgng==
X-Gm-Message-State: AOAM530bi9tVmaUFSSjw8ZoCz++yIOgJwi52cv/9LqNw1nt1NPFa9USv
        Er5YSCfKjCbOhOFup0n4QOXOtYlKfzc=
X-Google-Smtp-Source: ABdhPJxucyh/ZzrMp7v2MO/IDv/4smjezM73opaA3qVTNfs9EUYWo+ApEq+9Bmvg4V6TKWC0ni80xQ==
X-Received: by 2002:a9d:4719:: with SMTP id a25mr7727888otf.101.1615478132912;
        Thu, 11 Mar 2021 07:55:32 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id w12sm216019oti.53.2021.03.11.07.55.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 07:55:32 -0800 (PST)
Subject: Re: [PATCH net-next 06/14] nexthop: Add data structures for resilient
 group notifications
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <e4379e00764943a61983ccdfd6e1e90096e30ace.1615387786.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0cca5baa-438f-1ac5-a840-ca754d4818c4@gmail.com>
Date:   Thu, 11 Mar 2021 08:55:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <e4379e00764943a61983ccdfd6e1e90096e30ace.1615387786.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 8:02 AM, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Add data structures that will be used for in-kernel notifications about
> addition / deletion of a resilient nexthop group and about changes to a
> hash bucket within a resilient group.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
> 
> Notes:
>     v1 (changes since RFC):
>     - u32 -> u16 for bucket counts / indices
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


