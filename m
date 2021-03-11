Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6D133790B
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhCKQRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbhCKQRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:17:20 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1165BC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:17:20 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id d16so14387749oic.0
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M4kOLKd8GeeGGqfO0CHOYnH6xZy7c7WX/lQCWbnaf64=;
        b=Gk//FqM5i9MMXtAuYlIP6CvsSucuZ0lq6LcNftEkw+havFeFH90B4CS/BGAqxM0+52
         2jjOF4LQqXutxkqC3FS+VyDwkO4H9rm2zaPRifn4JTihbk36WUH/meJp4cs9jAsw19EQ
         o0nF0mhmCMANrTPYVedC0C6hSvyt8FIxr4fLCNY5oDDkVz/tq9H08iMjSn/JO0CDKkVF
         I9Kr6Xy5AhZ1l9p0Yoh7U4OHCa608iCzRvAm7y4cKEvmtDKWOtgTKHqXaMz7UfgJeU49
         Go4ub1wBCO+CaZ9OU0abeATDEH2+iyZvWwUngiOlTErqgSngLqiTMTY2T9yTmmb1cAgQ
         Irlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M4kOLKd8GeeGGqfO0CHOYnH6xZy7c7WX/lQCWbnaf64=;
        b=kGzF/b/Iavo1GrkN9ieKYkF+Mo38zMT7zoc8fuKRtAHGJAzovmyiCa3wxrc9MBPWbU
         PzKvaLJVYBbOnlwTEgq/Eed4PJ4mU02S0PuToFpztyxEa7t2CYwZv43WufJ7Plz5l0ST
         vFhRDFoo55m2u8mk/L48VEkaQbhvU9+Zr5niBW7b2YL98vp6ikzKqEHeLuXVYY2/xDWZ
         Lk7dgaXM362FLUNBmwA1aKW+GoZBdTSaHyDlJAv+GFdPMzD2woiYU2PqJQtwuE0J+oKp
         tmrBI293Vyy4WT9pirASN1IzYT6SSAviYvhGU16fW7S0Bn3ASMZ35wlRLebHatQpPxZG
         cWdA==
X-Gm-Message-State: AOAM5309kZUNvwZ89wDxPd4lVWxJ9k/RJBxxU7kvKCC+KzonBZQERyP9
        eIBNDmDpKfj3wOxAciFz9as=
X-Google-Smtp-Source: ABdhPJxenbl8Ldm/3hzvt5FCKPCNwU84l6Rv3iZvzrYazjSmLckjwCqqox4C9ypShbDBsGE4aCfBHw==
X-Received: by 2002:aca:bdd7:: with SMTP id n206mr6987845oif.64.1615479439446;
        Thu, 11 Mar 2021 08:17:19 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id z8sm589548oon.10.2021.03.11.08.17.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 08:17:18 -0800 (PST)
Subject: Re: [PATCH net-next 11/14] nexthop: Add netlink handlers for bucket
 dump
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <21f3a52cbe29cacc7aef1f4e559de64b6687ce91.1615387786.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1cf88882-5375-582c-3d22-608f70500143@gmail.com>
Date:   Thu, 11 Mar 2021 09:17:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <21f3a52cbe29cacc7aef1f4e559de64b6687ce91.1615387786.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 8:03 AM, Petr Machata wrote:
> Add a dump handler for resilient next hop buckets. When next-hop group ID
> is given, it walks buckets of that group, otherwise it walks buckets of all
> groups. It then dumps the buckets whose next hops match the given filtering
> criteria.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v1 (changes since RFC):
>     - u32 -> u16 for bucket counts / indices
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


