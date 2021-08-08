Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AEE3E3CC1
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 22:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhHHUib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 16:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbhHHUi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 16:38:29 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CB3C061760;
        Sun,  8 Aug 2021 13:38:09 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so22368550pjn.4;
        Sun, 08 Aug 2021 13:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=a7J4bOd+9Ifv/7o1HNmCABby9Qk92B2TwyOf0BQa9GU=;
        b=E5IU0xJEDan0lm0YAsV0ckwECbhcIhQRSqSNmAnbIa4f1J3W35BVQwoi09fLqdOe0M
         L5mOTa7cFM6+Jd83WL3vmVbP44b6ik4NQlp87fPjni99/tXAmDqfm9HljA9UfTIJR4dS
         1fRaPiL5DGlK7JGqBc4VHFITjKwCP4TxSiURW2WaLh2DPxikxvoFf8IBV4/GlySywX8Z
         8HH5zxm/Bg4hjgp+0RJlAhquZB34EPeHB8QTlAHZL+jOEVypILTmcyRa0A5GhAMpr8vW
         hipKI45cWXS3zkGrrsRducULaqEOhuhqDtN2YaBR4BuTxdkMCEi1Y4kJEZ14GDEpWZqa
         wkXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=a7J4bOd+9Ifv/7o1HNmCABby9Qk92B2TwyOf0BQa9GU=;
        b=UziyuAOGD1/wx3LlKf4ssezm70T7Ew+M4ybAEpWC2DgO4M23gWwh2UMMj/qkd5Jl1w
         37OuIhbeKONo4KEel8qS8claz4bJTjluxRQyv+CHpcyR8o6De2oOQu4UvIWAKQMLY9vG
         wRYi2MojeqdfWmHnoIIZBYsxtoUVaFklzFSMuNMnTzKf5q/cwyaVuXi2rguvBic+luI/
         zG9hmoNudjj+TY2do6giABPtak2pCZ8mUeDcKwpJevXUelkPtXIlAq4bxSCA8QAfJim3
         ly8DAo1Fri52kkmInn7z+RdQqiTkKJFPWx6nZasybC3qR9YsFZ/im7o7lTnC3k2OsGmh
         74FQ==
X-Gm-Message-State: AOAM530gbwd5AIKLFzhw1XwRuYtW6SVGj/0HDHQKuU2pxB83CXYFxi23
        3zOden2VejjfVI4HggDpOu9ajDk9q30=
X-Google-Smtp-Source: ABdhPJwvZ7YuuMRXSEF03F7MoltuiAM3cXlcAu3lCcjQ136N4Um0yllx7EJgPVEx5p0DbauyGW+z+A==
X-Received: by 2002:a17:90a:d3d0:: with SMTP id d16mr16872404pjw.103.1628455088384;
        Sun, 08 Aug 2021 13:38:08 -0700 (PDT)
Received: from ?IPv6:2001:df0:0:200c:34e2:78e2:fa00:101b? ([2001:df0:0:200c:34e2:78e2:fa00:101b])
        by smtp.gmail.com with ESMTPSA id 21sm17440404pfh.103.2021.08.08.13.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Aug 2021 13:38:07 -0700 (PDT)
Subject: Re: [PATCH 0/2] net: ethernet: Remove the 8390 network drivers
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Cai Huoqing <caihuoqing@baidu.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210807145619.832-1-caihuoqing@baidu.com>
 <05a5ddb5-1c51-8679-60a3-a74e0688b72d@gmail.com>
 <CAK8P3a0FUGbwbWuu0R7-Bm4O0MgNfYmE4FTZY9oE9jnRcMK9xQ@mail.gmail.com>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <bd0a1112-af59-16be-3fd3-b0a6aa1f2773@gmail.com>
Date:   Mon, 9 Aug 2021 08:38:02 +1200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0FUGbwbWuu0R7-Bm4O0MgNfYmE4FTZY9oE9jnRcMK9xQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On 9/08/21 7:49 am, Arnd Bergmann wrote:
> On Sun, Aug 8, 2021 at 12:51 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>> Removing the 8390 drivers would leave most m68k legacy systems without
>> networking support.
>>
>> Unless there is a clear and compelling reason to do so, these drivers
>> should not be removed.
> Right, any driver that is tied to a particular machine should generally
> be left working as long as we support that machine.
Thanks - if it was any help to alleviate the maintenance burden, I'd be 
happy to help look after that section of the network drivers.
>
>>>   MAINTAINERS                           |    6 -
>>>   drivers/net/ethernet/8390/8390.c      |  103 --
>>>   drivers/net/ethernet/8390/8390.h      |  236 ----
>>>   drivers/net/ethernet/8390/8390p.c     |  105 --
>>>   drivers/net/ethernet/8390/Kconfig     |  212 ---
>>>   drivers/net/ethernet/8390/Makefile    |   20 -
>>>   drivers/net/ethernet/8390/apne.c      |  619 ---------
>>>   drivers/net/ethernet/8390/ax88796.c   | 1022 ---------------
>>>   drivers/net/ethernet/8390/axnet_cs.c  | 1707 ------------------------
>>>   drivers/net/ethernet/8390/etherh.c    |  856 -------------
>>>   drivers/net/ethernet/8390/hydra.c     |  273 ----
>>>   drivers/net/ethernet/8390/lib8390.c   | 1092 ----------------
>>>   drivers/net/ethernet/8390/mac8390.c   |  848 ------------
>>>   drivers/net/ethernet/8390/mcf8390.c   |  475 -------
>>>   drivers/net/ethernet/8390/ne.c        | 1004 ---------------
>>>   drivers/net/ethernet/8390/ne2k-pci.c  |  747 -----------
>>>   drivers/net/ethernet/8390/pcnet_cs.c  | 1708 -------------------------
>>>   drivers/net/ethernet/8390/smc-ultra.c |  629 ---------
>>>   drivers/net/ethernet/8390/stnic.c     |  303 -----
>>>   drivers/net/ethernet/8390/wd.c        |  574 ---------
>>>   drivers/net/ethernet/8390/xsurf100.c  |  377 ------
>>>   drivers/net/ethernet/8390/zorro8390.c |  452 -------
> Two candidates I can see for removing would be smc-ultra and
> wd80x3, both of them fairly rare ISA cards. The only other
> ISA 8390 variant is the ne2000 driver (ne.c), which is probably
> the most common ISA card overall, and I'd suggest leaving
> that in place for as long as we support CONFIG_ISA.
That particular driver is the one I rely on (via a weird ROM-port to ISA 
bridge). Would be useful even after ISA bus support is gone, in that 
case. Just saying. The Amiga and Mac drivers likewise. Though you may 
well argue that once ISA support has been removed, these can all be 
rewritten to support MMIO more directly (and more flexibly).
> There are a couple of other ISA-only network drivers (localtalk,
> arcnet,  ethernet/amd) that may be candidates for removal,
> or perhaps some PCMCIA ones.

ethernet/amd has the other set of network card drivers used on m68k 
(*lance).

Cheers,

     Michael


>
>        Arnd
