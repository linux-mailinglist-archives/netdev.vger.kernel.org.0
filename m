Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6507C402160
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 01:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbhIFXFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 19:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhIFXFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 19:05:44 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A871C061575
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 16:04:39 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id k18-20020a4abd92000000b002915ed21fb8so2379933oop.11
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 16:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wrmaRlRPPmTRnnQ/74msivvAO8dxTRgKmoFDMkOFd2Q=;
        b=nmBHruUB/3A4Sqp3d7DFOOLYGHHNHlkVa4KkM15mzFi3fHfIo/2LLrVkNL6R3sCE9x
         bcObl6GMwi3rviIGhyishPwtRqKtOSoMsNEtRTkw3xxMiV2tjZT35jcQz2whnPBwugrq
         hv0/N9MrgtqwEn+jGbXi9vvEdatEUIk5tbr4SO+Od4o+eqlN4qS1v0XB3PRcByUZUZRk
         WzHCMA0A0vkTPl48iVuudzbEX0q1/emQm8feZ2MVwUgN+bV/fnKb5JgMsMoE6jRPC1mo
         j5KwNXVHOY6IrWPs0jbHERwIUxAtxbrNna0BSULztggRAcqbN9vtOQDvemWlltwUjbJI
         h4AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wrmaRlRPPmTRnnQ/74msivvAO8dxTRgKmoFDMkOFd2Q=;
        b=s+96oy/vbGew9w10AF5KRPQrghizCizX8HKeHob30Sl970Kz+HM6ZOjfVhP1MWRFbe
         wkGob8l4r76t+NRmJyVVusXOz8Mil/mw7anDJs//55xymBqU0CrxFaTkiApXHwvcnaC/
         KbdvvNDKLE+DC4wShfyEw4eiJ8DuHY+4VsOMWIHfKlpdl/sjfJa1YcgO7WV4vy3QQHeF
         xDlQsRFT3Na2rJd1ix4C68T0LZlb62UuM1ekKHD7rL1Uz8jrsT7FTsbMNjzEEZIC74B7
         Ry9zyvK0JejjOSB2/Q9laoD026HkeAEUV51Rfk9n70e5lXKQXROXCR6KWcsIMAO371Ew
         Jv/Q==
X-Gm-Message-State: AOAM532PcZWJba4O2hg6Gf0xyaozFFukSeVVO4Bh30IACyNpPJ+p700K
        xEbzDBnkFA24l2Evwa7VBoM=
X-Google-Smtp-Source: ABdhPJwegvMZgjFADGbJc+TZAiHdReNk/vmGwB+NqU5oOnGL+EaKZT62J0Y1xNKoZaphuej7oTGELw==
X-Received: by 2002:a4a:e3cf:: with SMTP id m15mr15565564oov.21.1630969478382;
        Mon, 06 Sep 2021 16:04:38 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id g8sm2055786otk.34.2021.09.06.16.04.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 16:04:37 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/2] bridge: vlan: add support for
 mcast_router option
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210901103816.1163765-1-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <33c59bc1-dc6e-3d72-ac7b-a0a461426295@gmail.com>
Date:   Mon, 6 Sep 2021 17:04:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210901103816.1163765-1-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/21 4:38 AM, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> This set adds support for vlan port/bridge multicast router option. It is
> similar to the already existing bridge-wide mcast_router control. Patch 01
> moves attribute adding and parsing together for vlan option setting,
> similar to global vlan option setting. It simplifies adding new options
> because we can avoid reserved values and additional checks. Patch 02
> adds the new mcast_router option and updates the related man page.
> 
> Example:
>  # mark port ens16 as a permanent mcast router for vlan 100
>  $ bridge vlan set dev ens16 vid 100 mcast_router 2
>  # disable mcast router for port ens16 and vlan 200
>  $ bridge vlan set dev ens16 vid 200 mcast_router 0
>  $ bridge -d vlan show
>  port              vlan-id
>  ens16             1 PVID Egress Untagged
>                      state forwarding mcast_router 1
>                    100
>                      state forwarding mcast_router 2
>                    200
>                      state forwarding mcast_router 0
> 
> Note that this set depends on the latest kernel uapi headers.
> 

applied to iproute2-next.

