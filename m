Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4FB3DF572
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 21:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239458AbhHCTUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 15:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239336AbhHCTUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 15:20:41 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088FAC061757;
        Tue,  3 Aug 2021 12:20:30 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u3so316903lff.9;
        Tue, 03 Aug 2021 12:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+PSJHn15EPtSaTCYgfVP3snmYPoR20AL2TlKBSlCfG8=;
        b=oRcfU4q14hvDC3RJYDNpBErH2tm+8SMWAVJjcguQRz+hsn2VfzmqEodX4DUpQbMb0I
         gKSIq83t0K3LxaefRbkb0plpAqGqAxEeVAF/OIARwB4lWYCl2XQqExdTZOjwxe+yEDbe
         CiJNBSFs2jpJqI2qtyaYqHI85obbJepMax38BUDeJjRETBZ7VHZQKmWoHUR+UbOmTqpG
         1Np1Gm12k3rnOAULHt2xt+2tvckDv+ed0ZNDhdDE5WMfe/UV7ydTRCQRjZr5R/AJuXan
         NOYzOZgK0WClNIAtxlh8yRsNWd1IhN5x7UKO06uAqMtJKfUuaS5ALfZ0qsA9zfCmVJvw
         gFyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+PSJHn15EPtSaTCYgfVP3snmYPoR20AL2TlKBSlCfG8=;
        b=c+CgbbbT5RLezN1erc4nWpyOQivCEVRXY2R9knaudZ+xJqPpE1iesWKnLv+FaL2eVc
         7S102POmlpXACvIcPxHaYesE0833aUOFJOIyU421OpBQVai8VLjZanBHXMrPvdgGEbhf
         mJf4G17A8wWBrLevethwN+5M+p0nhXB6il3LiMt5kXc7SlrMYVMzBxm5IBE1V47fcAvd
         SG6xFoeifGWn57bIjq2pEqlx7nl9sAGe9g18Zf32eMCuuHcfB7xwfkwSdBIRaVGWPjjO
         8goG9HI0b6LSr47/aZSxHzoOibZyjqJePnpXr0aULpkkczMvwFzI0XoCjmTX+Q3EiJxJ
         CR4g==
X-Gm-Message-State: AOAM5334/SxtsZbDy+BbguwEhLsYBB51Sqd4XXbaBvUrKkzl9PfG2xpg
        /y7SMGYNCuKi3oHpVHQckqw=
X-Google-Smtp-Source: ABdhPJxOaF+OkQwcf3KvalCxOV29JXKzrVnlyJAHezyhnAjMQ11zEGojqc546KvIi9ugjydF9E2DYQ==
X-Received: by 2002:a05:6512:3b20:: with SMTP id f32mr17881270lfv.279.1628018428459;
        Tue, 03 Aug 2021 12:20:28 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.73.7])
        by smtp.gmail.com with ESMTPSA id o24sm1054485lfr.41.2021.08.03.12.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 12:20:28 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/8] ravb: Add stats_len to struct
 ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-5-biju.das.jz@bp.renesas.com>
 <766c4067-d8b3-6aaa-5818-b4d9d5c6f42d@gmail.com>
 <OS0PR01MB5922AEAA259BECBED6286CF086F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <b9c594b8-0353-6e24-54fa-de10171daeff@gmail.com>
Date:   Tue, 3 Aug 2021 22:20:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB5922AEAA259BECBED6286CF086F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21 9:47 PM, Biju Das wrote:

[...]
>>> R-Car provides 30 device stats, whereas RZ/G2L provides only 15. In
>>> addition, RZ/G2L has stats "rx_queue_0_csum_offload_errors" instead of
>>> "rx_queue_0_missed_errors".
>>>
>>> Replace RAVB_STATS_LEN macro with a structure variable stats_len to
>>> struct ravb_hw_info, to support subsequent SoCs without any code
>>> changes to the ravb_get_sset_count function.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>> [...]
>>
>>    Finally a patch that I can agree with. :-)
>>
>> Reviewed-by: ergei Shtylyov <sergei.shtylyov@gmail.com>
>               ^Typo here.

   Sorry, here's a good one:

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

> Cheers,
> Biju

MBR, Sergei
