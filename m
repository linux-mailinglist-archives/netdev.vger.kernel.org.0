Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F1049C266
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 05:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236053AbiAZEC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 23:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbiAZEC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 23:02:56 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647B8C06161C;
        Tue, 25 Jan 2022 20:02:56 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id k17so3758323plk.0;
        Tue, 25 Jan 2022 20:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BU6jp3B4wTy5PfOIId36GrudzFfkIslE1wXZO465ZUA=;
        b=jbViqofb5/Iy8D4y+CaZaM6JfaFR27b6Xv4NUyxaE27s1mYlVfud3cG0FAva+4hWlQ
         9zuufwUFIcHss/8+/9BJbEreBAI2KBWbTpNVK7P370pGjCwudvzbf71HOfp7grViOGhK
         OXBwlXkuLu2J6c8r/t+XbxBHs3bQoe5Eococ3kRhBZZkDOYXHONVqGkIaMSyZOcxkdlr
         lihNWHNidkonb5khVINOueAfeYufVH7m3090H3OjkyYwF27Vj7Ec4lnF6zeRFnQWaXOp
         +41HaVFhWRhj+LRS1cLzVBRwn0SoyClUz3wedOtFU5GZzmbluPmN8+Y68p6j3RRH+5ol
         7WhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BU6jp3B4wTy5PfOIId36GrudzFfkIslE1wXZO465ZUA=;
        b=H/abHo84s0sx0b9oYkGq5QTmeh6TFUkqmng+6fcbbVpLpv9n8SiYjmrQ8yswXVvIrm
         l997YXbwXem9cz9QdjN5pUtJN7RYm94jLAicYvfMD5HH/FNdvE5YlcQ/z0GalMZYWx2q
         ujAzr4fI3lPdDAP9cslgSU6hiFcWyOcGzLwmDCgQBQ5q4PHwEzg8ByaLD++NJBi8hQe+
         eU7mUjV0htULEH4O5y/Ol7Ct6WhQqa/5OxTN90RzYcZdtyvhMFOS503XdThDBRsJCRTp
         nYTK1Ha9htfUOvtSu/wQAGzMrfcdzZb9uq1JOihsKWqR+UEuZOtQgdfVGQEXW8D2QBMo
         a80A==
X-Gm-Message-State: AOAM531kaKBkNheTKE90XrRmI0NVGd4g4CdbxoKSM/Gup0kNFyUkPgdO
        S4vxhEfBrP14T50+QUiU83A=
X-Google-Smtp-Source: ABdhPJwEq9v9K9PVTDn+hVHvyLVeQGshrbM27WPL8XnwX2xMwPlim3ZMo7YqbDTR6OR0kfdpOqMKXA==
X-Received: by 2002:a17:902:c407:b0:14b:6f06:6143 with SMTP id k7-20020a170902c40700b0014b6f066143mr6848889plk.47.1643169775911;
        Tue, 25 Jan 2022 20:02:55 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id j18sm494180pfj.13.2022.01.25.20.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 20:02:55 -0800 (PST)
Message-ID: <ffd2326c-5b66-87d8-ad42-6dea37e290d6@gmail.com>
Date:   Tue, 25 Jan 2022 20:02:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v7 06/16] net: dsa: tag_qca: add define for handling
 mgmt Ethernet packet
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-7-ansuelsmth@gmail.com>
 <70a44baa-4a1c-9c9e-6781-b1b563c787bd@gmail.com>
 <YfDHmpLxqUGWatQC@Ansuel-xps.localdomain>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YfDHmpLxqUGWatQC@Ansuel-xps.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/25/2022 8:01 PM, Ansuel Smith wrote:
> On Tue, Jan 25, 2022 at 07:54:15PM -0800, Florian Fainelli wrote:
>>
>>
>> On 1/22/2022 5:33 PM, Ansuel Smith wrote:
>>> Add all the required define to prepare support for mgmt read/write in
>>> Ethernet packet. Any packet of this type has to be dropped as the only
>>> use of these special packet is receive ack for an mgmt write request or
>>> receive data for an mgmt read request.
>>> A struct is used that emulates the Ethernet header but is used for a
>>> different purpose.
>>>
>>> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
>>> ---
>>
>> [snip]
>>
>>> +/* Special struct emulating a Ethernet header */
>>> +struct mgmt_ethhdr {
>>> +	u32 command;		/* command bit 31:0 */
>>> +	u32 seq;		/* seq 63:32 */
>>> +	u32 mdio_data;		/* first 4byte mdio */
>>> +	__be16 hdr;		/* qca hdr */
>>> +} __packed;
>>
>> Might be worth adding a BUILD_BUG_ON(sizeof(struct mgmt_ethhdr) !=
>> QCA_HDR_MGMT_PKG_LEN) when you start making use of that structure?
> 
> Where should I put this check? Right after the struct definition,
> correct? (I just checked definition of the macro)

It would have to be in a call site where you use the structure, I have 
not checked whether putting it in a static inline function in .h file 
actually works if the inline function is not used at all.
-- 
Florian
