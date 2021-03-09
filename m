Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB823331F1
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 00:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhCIXjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 18:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbhCIXjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 18:39:23 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD1FC06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 15:39:22 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id p16so15951134ioj.4
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 15:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NaIHW2oIK0pVkcFX+WgzEga219yv3WvbZC+V/hdymdU=;
        b=qjOxHI9jaX99CYH8Hnhj91miA4ntOyiYEjniIy7wIaWN0NDo02iAlWPSfzNWFjjRSK
         axp6HHe8EyicXvK7K8BFyq3MyguoKqQFDP32+WTjy3ZJxsKrtS7FUTEqRtB9f6sNRxee
         VOQKFJPK/7qvQsewzparTawy4QcyekkVGXriE7KEA0Q9So75o0t74zIJIQuqYZrR/C/9
         LoE52ZtDXwjADbGAu6kd/c1SU9DgMrv84TK3b2xMQitNsPTzGi2CW1zaRchZGyxce89N
         QFD1cgBy4Kw/URU0kE1fl0nJazMk+DSlNHCIPnzHRzGuKnRb2z5Rnwqb7Xg3amX9TKOx
         egTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NaIHW2oIK0pVkcFX+WgzEga219yv3WvbZC+V/hdymdU=;
        b=QCT/bPaLp9x3e3rOYDBXNyz++hzXg4+WgiWCBygsIIZwUjod4CfZNQSG4Fcr7Cb/Js
         EaRQCCqlvxUxvRZy8voT9QsHTt3Tn/lr7+VKAcU6IypUfF4SGXmQ5ZRaz4O9eA54v6W3
         kL+sdmapf8hV35pgEphaLO4Tp8QpCAr4j6PWFsj3IDzM5pS2yN/kwuyp9G6UEkme8lTH
         7Nc2VToetl+osrTQCt4BQ2490G9mr427gWA9ho8StwsBuf9w8jf5qM9L2gbfEpUv+p2Y
         d06JusM7tcG354R36lCeKF21zjfs9rV+o2/AhwutqXIJpGfYfZ0pE3IC6yfbPHrEdT4J
         4I4w==
X-Gm-Message-State: AOAM530yquyXOXniAQ7msQCaHG96TWIrdp1wK8p5nweDTM2P7LGPJvgk
        eLwyteLPx21oaSRjf1PWGfW/Tw==
X-Google-Smtp-Source: ABdhPJxZz6FXADhzp4Qm9Mq/rVhZIInWIo0Pi9yvEk4bHLQTeMuo+SC2E/X5AlbvTteZlf4BKHkTcQ==
X-Received: by 2002:a5e:841a:: with SMTP id h26mr430732ioj.179.1615333162353;
        Tue, 09 Mar 2021 15:39:22 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id r3sm8438815ilq.42.2021.03.09.15.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 15:39:21 -0800 (PST)
Subject: Re: [PATCH net-next v3 0/6] net: qualcomm: rmnet: stop using C
 bit-fields
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210309124848.238327-1-elder@linaro.org>
Message-ID: <bb7608cc-4a83-0e1d-0124-656246ec4a1f@linaro.org>
Date:   Tue, 9 Mar 2021 17:39:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210309124848.238327-1-elder@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/21 6:48 AM, Alex Elder wrote:
> Version 3 of this series uses BIT() rather than GENMASK() to define
> single-bit masks.  It then uses a simple AND (&) operation rather
> than (e.g.) u8_get_bits() to access such flags.  This was suggested
> by David Laight and really prefer the result.  With Bjorn's
> permission I have preserved his Reviewed-by tags on the first five
> patches.

Nice as all this looks, it doesn't *work*.  I did some very basic
testing before sending out version 3, but not enough.  (More on
the problem, below).

		--> I retract this series <--

I will send out an update (version 4).  But I won't be doing it
for a few more days.

The problem is that the BIT() flags are defined in host byte
order.  But the values they're compared against are not always
(or perhaps, never) in host byte order.

I regret the error, and will do a complete set of testing on
version 4 before sending it out for review.

					-Alex

> Version 2 fixed bugs in the way the value written into the header
> was computed.
> 
> The series was first posted here:
>    https://lore.kernel.org/netdev/20210304223431.15045-1-elder@linaro.org/
> Below is a summary of the original description.
> 
> This series converts data structures defined in <linux/if_rmnet.h>
> so they use integral field values with bitfield masks rather than
> relying on C bit-fields.
>    - The first three patches lay the ground work for the others.
>        - The first adds endianness notation to a structure.
>        - The second simplifies a bit of complicated code.
>        - The third open-codes some macros that needlessly
>          obscured some simple code.
>    - Each of the last three patches converts one of the structures
>      defined in <linux/if_rmnet.h> so it no longer uses C bit-fields.
> 
>      					-Alex
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

