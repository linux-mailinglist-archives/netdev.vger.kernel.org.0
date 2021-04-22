Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0683B367930
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 07:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhDVFVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 01:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhDVFVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 01:21:47 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B580BC06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 22:21:13 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id b9so14589697iod.13
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 22:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BxySs4mZ50Sl4m/lAP9NacbpbY2vXX78s/hjs7G+D/Q=;
        b=D6dhaabc4Mc0Z329tOKK+WVgvg4DdcycgwZfJ8/fr5Dhbe4h4oGqIegoBTmdS+1C0g
         ZLtOEBdH3veesqr5GSAUNkQdX9ydCAsqz0m8KkPeTsiQUNSl8UVyp+xtmYSxwqoUAtsv
         VKpYg9njjxafnOoUgEblBauN2dJqTGJnQEVTVHHiGCXc3uvrPRYSUApfoPotjfGZSgvZ
         agacPHiCE1EQLn6MOP9BWPf6yxSRcSXtlZ+m7ICkQbm6cyeLgDVTJPHRZt4Lp9bM4Y3R
         2qUUs1hNjr/GO3wcFT5kdYl9xQwvLYYDlaIzegqIIatt8S0WFQxywsEGgPEcox6Bws9w
         YIbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BxySs4mZ50Sl4m/lAP9NacbpbY2vXX78s/hjs7G+D/Q=;
        b=bNbAviTpO+SEUMawG48VUDsUxGHcjavM2BZ8X2RSarC5WwxptBfTxcWSgJEG4ZzNO7
         WXu/lBCBe6XcRNVoQUcM/Tm5sJ08bbOOp7DUWJHKEt74eRmAFYsyGbt2fooi8MZmr4O2
         uAjZ8oCXzAKskG1MvlyWvaFosmkQu6/qG62hlCWPXmQYsWC0Ipvy/VhCnClxhF2JWiaI
         xKXQITp1lsnuOdydRJYtJB57VziIkR+nX7oyt+bsW1I86HS0hp2wrcSx2YGkRP32ZZu1
         HH6T59aHP4AkyiHSDr3cXzIura6hRJ6aCHXDnrePSHl4PZcYrehHrUJi5xT/0axYnYew
         aU+A==
X-Gm-Message-State: AOAM533xubrfdzKCvZXzYINcaIt9yDM4m/aJ4RkiDML1ARm4XcWSM2eT
        VqWzeB20FfBxHK8SKObJanDbMFE+rzs=
X-Google-Smtp-Source: ABdhPJxeo0QhlqVjoM7ctXuqgddM4nLYt1VtOSKII3EKTBiPCXBQKlPpkpE1y8vYX8gWRy3cwpdKwQ==
X-Received: by 2002:a02:4e45:: with SMTP id r66mr1593946jaa.137.1619068872915;
        Wed, 21 Apr 2021 22:21:12 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.15])
        by smtp.googlemail.com with ESMTPSA id q11sm685409ile.56.2021.04.21.22.21.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 22:21:12 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/6] bridge: vlan: add per-vlan options
 support
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210418120137.2605522-1-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <01b06927-754d-2f09-ecdc-f5d61847c689@gmail.com>
Date:   Wed, 21 Apr 2021 22:21:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210418120137.2605522-1-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/18/21 5:01 AM, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> This set extends the bridge vlan code to use the new vlan RTM calls
> which allow to dump detailed per-port, per-vlan information and also to
> manipulate the per-vlan options. It also allows to monitor any vlan
> changes (add/del/option change). The rtm vlan dumps have an extensible
> format which allows us to add new options and attributes easily, and
> also to request the kernel to filter on different vlan information when
> dumping. The new kernel dump code tries to use compressed vlan format as
> much as possible (it includes netlink attributes for vlan start and
> end) to reduce the number of generated messages and netlink traffic.
> The iproute2 support is activated by using the "-d" flag when showing
> vlan information, that will cause it to use the new rtm dump call and
> get all the detailed information, if "-s" is also specified it will dump
> per-vlan statistics as well. Obviously in that case the vlans cannot be
> compressed. To change per-vlan options (currently only STP state is
> supported) a new vlan command is added - "set". It can be used to set
> options of bridge or port vlans and vlan ranges can be used, all of the
> new vlan option code uses extack to show more understandable errors.
> The set adds the first supported per-vlan option - STP state.
> Man pages and usage information are updated accordingly.
> 
> Example:
>  $ bridge -d vlan show
>  port              vlan-id
>  ens13             1 PVID Egress Untagged
>                      state forwarding
>  bridge            1 PVID Egress Untagged
>                      state forwarding
> 
>  $ bridge vlan set vid 1 dev ens13 state blocking
>  $ bridge -d vlan show
>  port              vlan-id
>  ens13             1 PVID Egress Untagged
>                      state blocking
>  bridge            1 PVID Egress Untagged
>                      state forwarding
> 
> We plan to add many more per-vlan options in the future.
> 

applied. Thanks, Nik

