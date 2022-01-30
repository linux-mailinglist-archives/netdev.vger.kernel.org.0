Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106B54A37CF
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 18:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355697AbiA3RHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 12:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiA3RHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 12:07:19 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7C7C061714;
        Sun, 30 Jan 2022 09:07:18 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so15889409pjt.5;
        Sun, 30 Jan 2022 09:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=YUtvVETQ4W7uTMzStV3psNo1qD2DtUJmtWqMjy6DR8w=;
        b=NN78dhDDRCEpTpZpsQG+Py30WVC5QPnEcc9wfQwS/Xn61JzXnxToguU4FDz6MLYMQs
         CkF/tiKlhPMk3rIMWS3d37W3awQAaHJH9LKh5c+Esjo1wh/mqVUuxmy++JGGOlC71bMx
         8pDA12ap/dNnw+RpsoGwG+EDhJiGxal49NIr5HUNYLdwKPCJxUsBmofi5p2aEiUaJ+t5
         nAIKTnC6rl9mk0R9qw4QjX7OW/6Vz4PJZW0+UjNwwV9d+JKYyKWx5hQVHUYIvM/Zc4Hb
         bLAFk43QRdrQ55PWeTiDqjeGi1MMPolHV3xmHR7LE6VXlRtTN+INmysRfGn8A0IehWo3
         EXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YUtvVETQ4W7uTMzStV3psNo1qD2DtUJmtWqMjy6DR8w=;
        b=vKj0BRvX3Xs4bdhmfd1uVC0pZ0AqMeji7O5XQf2/F3M5D5JZtu973jeirmDO9T08in
         +mSdGqjU7SutzBHkXyc3x3E0RDzZVS4Z4I197ZSX7PG8UEPpN+OfReIBNRIjVnD647iy
         0XEH0EIPEaU3UFk0Py1Y+t3KYudBCa0otSEVOwPtF/8i4Bf1XFWsbJJgtXrhgEh50mDY
         8H58OEGcy7g1qbaaCHHSO2kCckbP2Zi1qBoflDNEonf3TN6kObxDojkA8FV9XpnnWIiS
         a4MQ9n6ziBgQ4pde1MlJryt/o3OC8lhyB1eQy/RKiMxLl30aKtQh1D3bt0i3xAOC0pQV
         xTBQ==
X-Gm-Message-State: AOAM532w6GKOj/RKBx5FbHy3TcjG11HpticeeNXVNz3hT5LldMN0jPKo
        AHKQzuwq4Gk1/aOxxB1pHUU4obIzkrk=
X-Google-Smtp-Source: ABdhPJwuQhw9UdnnedQW3xEP9QEFq8KZX6ReEl3AW4G0KVuH6AKWU2r5qjLG+rdP265OmBj2l1ZqJg==
X-Received: by 2002:a17:90a:f198:: with SMTP id bv24mr18687467pjb.32.1643562438325;
        Sun, 30 Jan 2022 09:07:18 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:31be:19f8:e4b4:84c8? ([2600:8802:b00:4a48:31be:19f8:e4b4:84c8])
        by smtp.gmail.com with ESMTPSA id p4sm3187903pfw.133.2022.01.30.09.07.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Jan 2022 09:07:17 -0800 (PST)
Message-ID: <a8244311-175d-79d3-d61b-c7bb99ffdfb7@gmail.com>
Date:   Sun, 30 Jan 2022 09:07:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v7 00/16] Add support for qca8k mdio rw in Ethernet
 packet
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <YfaZrsewBMhqr0Db@Ansuel-xps.localdomain>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YfaZrsewBMhqr0Db@Ansuel-xps.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/30/2022 5:59 AM, Ansuel Smith wrote:
>>
> 
> Hi,
> sorry for the delay in sending v8, it's ready but I'm far from home and
> I still need to check some mdio improvement with pointer handling.
> 
> Anyway I have some concern aboutall the skb alloc.
> I wonder if that part can be improved at the cost of some additional
> space used.
> 
> The idea Is to use the cache stuff also for the eth skb (or duplicate
> it?) And use something like build_skb and recycle the skb space
> everytime...
> This comes from the fact that packet size is ALWAYS the same and it
> seems stupid to allocate and free it everytime. Considering we also
> enforce a one way transaction (we send packet and we wait for response)
> this makes the allocation process even more stupid.
> 
> So I wonder if we would have some perf improvement/less load by
> declaring the mgmt eth space and build an skb that always use that
> preallocate space and just modify data.
> 
> I would really love some feedback considering qca8k is also used in very
> low spec ath79 device where we need to reduce the load in every way
> possible. Also if anyone have more ideas on how to improve this to make
> it less heavy cpu side, feel free to point it out even if it would
> mean that my implemenation is complete sh*t.
> 
> (The use of caching the address would permit us to reduce the write to
> this preallocated space even more or ideally to send the same skb)

I would say first things first: get this patch series included since it 
is very close from being suitable for inclusion in net-next. Then you 
can profile the I/O accesses over the management Ethernet frames and 
devise a strategy to optimize them to make as little CPU cycles 
intensive as possible.

build_skb() is not exactly a magic bullet that will solve all 
performance problems, you still need the non-data portion of the skb to 
be allocated, and also keep in mind that you need tail room at the end 
of the data buffer in order for struct skb_shared_info to be written. 
This means that the hardware is not allowed to write at the end of the 
data buffer, or you must reduce the maximum RX length accordingly to 
prevent that. Your frames are small enough here this is unlikely to be 
an issue.

Since the MDIO layer does not really allow more than one outstanding 
transaction per MDIO device at a time, you might be just fine with just 
have a front and back skb set of buffers and alternating between these two.
-- 
Florian
