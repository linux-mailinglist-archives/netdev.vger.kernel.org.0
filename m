Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06CB3C1B17
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 23:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhGHVk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 17:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhGHVk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 17:40:57 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DCAC061574;
        Thu,  8 Jul 2021 14:38:14 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso4860813pjp.2;
        Thu, 08 Jul 2021 14:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ooa5d7zgG8sZhRVFlDxUhQ9CRAI+LnyQ8qvmMnTtbvw=;
        b=E/rHzLgY2qeXdXPFF2/iT6rFe9bveLEY/1fSy3Dh18EAJleBZN4chH8y69C5r62NDK
         2j6Yy9JwU7jQMGDZoO5FD0Wz0DOrzOLjk3dwla9o90tUCarbwzlBFSurolOqRejLKcI2
         0fyLFjJ0Sk5W9YLjk/1EeORmRRPgXMjEz66i1/rgGFKcffhn+588GquWMifp9aF1TW69
         Wzn+Zy6lWE2I15lhyXehHj+XiZqfExmkvwI/ED4tilqvhSuTgzw+n/O2yNid1lifMvGG
         UfZ1w/H/meHkU9MEeUf7dsF2M2+Dia3J3FgQC51+gx8CrH/fLYMmImGh1EHmpZyLmpkH
         9LvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ooa5d7zgG8sZhRVFlDxUhQ9CRAI+LnyQ8qvmMnTtbvw=;
        b=qRkco5SwvSy3YrBfxOjQ7kVcvjzvBKy1QKRDarrBIBRb7xR/qpQ+0Ed1UqjR8FlO8X
         V4Ck7J2NJwhQxtR9kXqGuZfzcaGPYUrSltfiUZYX5gxDw+kNfI/we1e3cGcIjJtfgw53
         dBqthA4q7x5vFvFsFYMH6hH7lkFBkuKQAAldiM4mJig3K9k3BjaOJiyRzbG7uHyVwh5D
         XyWcFHNMO9ovOyy0dMtFF8NazOvswxrzRq1sHREpX6BTKUIuReC6If1tz3TzHHrV2EbQ
         jb39FOV8j0V3gboWzj1vxpJGic/Ynq63bkP2NaJmC+3Seg+K5mN2JpUMaGY9yNyyPoD7
         HBiw==
X-Gm-Message-State: AOAM531ftJU6h2yT8QkPRe9KXJ82+7wo1I2vjl4yCtBDQfUAL1umIAnn
        Be03empgkVnPOqaxj9O0nzsHYGGBR0SKbA==
X-Google-Smtp-Source: ABdhPJxaFNipZhejgmTJnh0jGYYvdIAPv64jXohZYrq3eyUFsHkyVtmXLfyfit0PUWmSAZNyMCarpg==
X-Received: by 2002:a17:90a:8585:: with SMTP id m5mr33890956pjn.224.1625780293792;
        Thu, 08 Jul 2021 14:38:13 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n34sm3301165pji.45.2021.07.08.14.38.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 14:38:13 -0700 (PDT)
Subject: Re: linux-next: Fixes tag needs some work in the net tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20210709073104.7cd2da52@canb.auug.org.au>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <30e28b44-b618-bdf5-cf4a-dc676185372d@gmail.com>
Date:   Thu, 8 Jul 2021 14:38:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709073104.7cd2da52@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/21 2:31 PM, Stephen Rothwell wrote:
> Hi all,
> 
> In commit
> 
>   9615fe36b31d ("skbuff: Fix build with SKB extensions disabled")
> 
> Fixes tag
> 
>   Fixes: Fixes: 8550ff8d8c75 ("skbuff: Release nfct refcount on napi stolen or re-used skbs")
> 
> has these problem(s):
> 
>   - No SHA1 recognised
> 
> Not worth rebasing for, just more care next time.

It is there though:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=8550ff8d8c75416e984d9c4b082845e57e560984

and has the proper format AFAICT, what am I missing?
-- 
Florian
