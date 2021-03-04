Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4428932DD48
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhCDWnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbhCDWnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 17:43:35 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D326C061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 14:43:35 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id z13so31600840iox.8
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 14:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oETzd3MxcVSXx2y2bLw59dqUUQ72YS7d4YYmqfF/gQk=;
        b=O0Ci5RK2xt6/MtVK/wyRasw01FyDKUybOL2HmVWRX7enGChKWlaxXTYtlGEHJz8S2G
         Lai7CgiLpgfffuMxGM5HUr/yCqR8kBo1QkDHr1daEMgSL0BDcTx0UVulSGvGyXFG8jm7
         5i9zhi09S1+wxCyR8gjdU2uwdtFmaKjf0wlUlaGGVXK7emed6mXOQBHAUQWW+XdJqkHh
         3IvneXqeUYN11Mw7oTivwn96z4D1Pv9hWCtTr55L356Ke6pwVZOznTUso79KxC5ueYkl
         gRqdtXbMEDafG3LOWBfdMW31l/aBy2hwIj0pX4xCBR9FfK/0th4Bo1rdufR4nRY1uUSg
         AmqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oETzd3MxcVSXx2y2bLw59dqUUQ72YS7d4YYmqfF/gQk=;
        b=YuuAflae4scOscGZabCE8WI4rfTIirRlaQ9JuKLJRRiaFO7kIOkZm8VzC/fwKIp6n5
         nqYCgN1eTkGQNqPZl/tftxa7v1znO70/AhMWWxwQDZ0hnUWnGqZ+r3R8uPC1v1DFu0eh
         xjvPScXqVrTqRS2tVXeERv5vsF3YLAZrRk2QpJpag2hqqavBBavp1RWdQGAVJJnB/Pp+
         dG5oEZkcmV2MWti8ZIIaDHu/wYK9oVlt5Fb60kzfPtzZoHSUBvRFLWmzSSFmAv4O0kJ8
         HwxqL9epE7FBilTxcvxAVIphQXTjuO/RtpbFOu9x514AiCakflcG93eIjwFLygwiKBcU
         7Pcg==
X-Gm-Message-State: AOAM531LuvkY8urvN/zFQfPgTz/0q8ZVeXvtAL7p3X7OH9ew+a/ojgyL
        Yic+IhMk6sAgBRUweXd0/cCGcavl9DJFMA==
X-Google-Smtp-Source: ABdhPJzx1UrBF3ivLInjLSdfVatrZtEPKcX3hB+pjFiKgJn0Tg1jtbjSXhBKlJeV667LwZsm4Fu2Hg==
X-Received: by 2002:a02:a606:: with SMTP id c6mr6778016jam.108.1614897814677;
        Thu, 04 Mar 2021 14:43:34 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id b9sm346283iob.4.2021.03.04.14.43.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 14:43:34 -0800 (PST)
Subject: Re: [PATCH net-next 0/6] net: qualcomm: rmnet: stop using C
 bit-fields
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210304223431.15045-1-elder@linaro.org>
Message-ID: <cdfe3730-97e1-acb3-fa5e-7e016523eab8@linaro.org>
Date:   Thu, 4 Mar 2021 16:43:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210304223431.15045-1-elder@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/21 4:34 PM, Alex Elder wrote:
> This series converts data structures defined in <linux/if_rmnet.h>
> so they use integral field values with bitfield masks rather than
> rely on C bit-fields.

Whoops!  I forgot to check if net-next was open.  I'm very
sorry about that...

   http://vger.kernel.org/~davem/net-next.html

					-Alex

> I first proposed doing something like this long ago when my confusion
> about this code (and the memory layout it was supposed to represent)
> led me to believe it was erroneous:
>    https://lore.kernel.org/netdev/20190520135354.18628-1-elder@linaro.org/
> 
> It came up again recently, when Sharath Chandra Vurukala proposed
> a new structure in "if_rmnet.h", again using C bit-fields.  I asked
> whether the new structure could use field masks, and Jakub requested
> that this be done.
>    https://lore.kernel.org/netdev/1613079324-20166-1-git-send-email-sharathv@codeaurora.org/
> I volunteered to convert the existing RMNet code to use bitfield
> masks, and that is what I'm doing here.
> 
> The first three patches are more or less preparation work for the
> last three.
>    - The first marks two fields in an existing structure explicitly
>      big endian.  They are unused by current code, so this should
>      have no impact.
>    - The second simplifies some code that computes the value of a
>      field in a header in a somewhat obfuscated way.
>    - The third eliminates some trivial accessor macros, open-coding
>      them instead.  I believe the accessors actually do more harm
>      than good.
>    - The last three convert the structures defined in "if_rmnet.h"
>      so they are defined only with integral fields, each having
>      well-defined byte order.  Where sub-fields are needed, field
>      masks are defined so they can be encoded or extracted using
>      functions like be16_get_bits() or u8_encode_bits(), defined
>      in <linux/bitfield.h>.  The three structures converted are,
>      in order:  rmnet_map_header, rmnet_map_dl_csum_trailer, and
>      rmnet_map_ul_csum_header.
> 
> 					-Alex
> 
> Alex Elder (6):
>    net: qualcomm: rmnet: mark trailer field endianness
>    net: qualcomm: rmnet: simplify some byte order logic
>    net: qualcomm: rmnet: kill RMNET_MAP_GET_*() accessor macros
>    net: qualcomm: rmnet: use field masks instead of C bit-fields
>    net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum trailer
>    net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header
> 
>   .../ethernet/qualcomm/rmnet/rmnet_handlers.c  | 11 ++--
>   .../net/ethernet/qualcomm/rmnet/rmnet_map.h   | 12 ----
>   .../qualcomm/rmnet/rmnet_map_command.c        | 11 +++-
>   .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 60 ++++++++---------
>   include/linux/if_rmnet.h                      | 65 +++++++++----------
>   5 files changed, 70 insertions(+), 89 deletions(-)
> 

