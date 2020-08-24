Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3AC24F197
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 05:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgHXDhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 23:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgHXDhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 23:37:48 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC67C061573
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 20:37:48 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id j13so3473613pjd.4
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 20:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aoxWj6aWSvq0J4q1xbVoBN3aO53KXHL4iUq3nWkCvxM=;
        b=RCjcUl6nuCgH/S6imPZZuOfPL7baWyOT/tatbxkWJoV30qZs1ujhxzfJ3OrNY8swfi
         j3h1N7fzbrXj/pe0ReggDA8m1ierkNTrCUeac7sKJzFejYnJ+oVT9MEU6RQlVu8saWtO
         JeqxeOLvRScTWTHnj7lCwIgwTDriFosVnxKlOiDavS/ivHjDQy5l0jLQu/XwGxFEn1Hd
         7bzwCy1f/ytBCYuLlFfKY4OodTPJGYWe/gR30ue0PrUUKI5SC5HN/EKTDAqxo3gSHRSK
         yBuLNEucUO4W51cDVZO00jNKMqH8exNGY/aN7bvoh7YECGLgndLCWFePqkA+u36YgrCT
         W0pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aoxWj6aWSvq0J4q1xbVoBN3aO53KXHL4iUq3nWkCvxM=;
        b=Ba0GVoT7b2ONCjEvcVLVGdvdbSKwfcHcD/F6QstsPaTj6HgDEwdX0NGjceRV3n9TRZ
         Qdg7E11UQRQlw8Htssp+4IGnv1x3Jl0tkY0g/J4N/2jg9FAkJzcCPL6tm3Q5FeXzIKMC
         33S9awdfdNBORnHRXqr3vOfHneyrAdr7ZoSIow8sZ3imrsqj/wtlsbP+EkRgE/COHz+v
         9akV+uTGSYH1yFL8hUIh33mly2zHtmwyaJam3jXStpDdr84VSR7IVHswj9mc2/AzZxF7
         dBMpPgjoyTcSNaqZl4/gMqMSyZfPrVLY0PO2G3vYic/Ebz9zq9FBaWZaIW1F0mhVtcf5
         IWHQ==
X-Gm-Message-State: AOAM530XyB6HDaLfz76R+nUWhVr3+aZvvyQuVKGNdZzOcRpGwzSF4zva
        W9m572eBL0DAjEsWSSiE5R0=
X-Google-Smtp-Source: ABdhPJw8+5rAi+YD67TfuSrySdzQHB3PdXDJJJ7Bo+HnbZfpyLpaZZ5aBbFSQ3kJuJ7a2xIDC5ASMw==
X-Received: by 2002:a17:90a:e986:: with SMTP id v6mr3194540pjy.88.1598240268312;
        Sun, 23 Aug 2020 20:37:48 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h65sm9544771pfb.210.2020.08.23.20.37.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Aug 2020 20:37:47 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: change PHY error message again
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        vivien.didelot@gmail.com
References: <20200823213520.2445615-1-olteanv@gmail.com>
 <20200823222643.GL2588906@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <08a6381d-ad7d-f1de-6793-be4625014d9b@gmail.com>
Date:   Sun, 23 Aug 2020 20:37:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200823222643.GL2588906@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/23/2020 3:26 PM, Andrew Lunn wrote:
> On Mon, Aug 24, 2020 at 12:35:20AM +0300, Vladimir Oltean wrote:
>> slave_dev->name is only populated at this stage if it was specified
>> through a label in the device tree. However that is not mandatory.
> 
> Hi Vladimir
> 
> It is not mandatory, but it is normal.
> 
>> When it isn't, the error message looks like this:
>>
>> [    5.037057] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
>> [    5.044672] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
>> [    5.052275] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
>> [    5.059877] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
>>
>> which is especially confusing since the error gets printed on behalf of
>> the DSA master (fsl_enetc in this case).
>>
>> Printing an error message that contains a valid reference to the DSA
>> port's name is difficult at this point in the initialization stage, so
>> at least we should print some info that is more reliable, even if less
>> user-friendly. That may be the driver name and the hardware port index.
>>
>> After this change, the error is printed as:
>>
>> [    4.957403] mscc_felix 0000:00:00.5: error -19 setting up PHY for port 0
>> [    4.964231] mscc_felix 0000:00:00.5: error -19 setting up PHY for port 1
>> [    4.971055] mscc_felix 0000:00:00.5: error -19 setting up PHY for port 2
>> [    4.977871] mscc_felix 0000:00:00.5: error -19 setting up PHY for port 3
> 
> I would prefer both the port number and the interface name. With
> setups using D in DSA, there are examples where port 1 on the first
> switch is lan1, and port 1 of the second switch is lan5. Having both
> avoids some confusion.

How about printing the tree, switch id and port number that way we have 
all the uniquely identifying information at hand?

> 
> Another option would be to call dev_alloc_name() after
> alloc_netdev_mqs() if there is no label. The eth%d will then get
> replaced with a unique name.

That would work, too.

> 
>> Fixes: 65951a9eb65e ("net: dsa: Improve subordinate PHY error message")
> 
> I'm not sure this actually meets the stable criteria.

Agreed this might be a little bit too much.
-- 
Florian
