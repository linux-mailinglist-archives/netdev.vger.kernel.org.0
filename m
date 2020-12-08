Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18F22D2DA3
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgLHO4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbgLHO4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 09:56:38 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2392C061749
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 06:55:57 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id x6so12595745wro.11
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 06:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RpoOB4SsMWdHs6nxGfrQI11gBbJ7r+aNGucdh2ApF9E=;
        b=iG2Akie/C8iOA4AoP/BrYYn4RnEecoss9rAmtZKg+2j1nUi+jmWt9AMtU+zLS2Pw6Q
         6lD/UNGQoMes+YoCU7n0x3xO1iNyNNVFx/Si1vvI21PGN3Z+RAfjlmMCPhMvZ965yHZa
         bvp7O+XrfU3YKZT1B9OnsyyazaziLMlY8n/y+zZXGY36fsRpvIYfDZpl6lLnQRwab00i
         +EDnh3CMPiWHgsKpvko1N7zsbtmMaWeIVWoE65jcSz2H7y6tO8tf0xlXXziismeLysY3
         p7+drHRkv6RnWtIrzZe9mRazkX7XE1Ot0sjZ6T77MvvQv4k0ChNx5EDTw3C+mN2Yd1Wu
         dR7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RpoOB4SsMWdHs6nxGfrQI11gBbJ7r+aNGucdh2ApF9E=;
        b=sQnBE55/5K04UFog3nF5dlP9ghatfH5adCgSAOnX/sNDQPsUvHsUJuSxLKLDP4xhxE
         p6fcduiHDnSnQRNSGtuA1g3zv0BkN8ZH672nQm2eoatAKg4cKyTZxd3lN1tbCWuSWAcG
         jOpuO9s0QHhtk02KG+ePExmLcH8q03KdaxSp4wBcE+95JXxqgCJihFmcdAk/kBU/Clow
         x6FombWIrAnZLLUDOqTM5h3YMCapdphf9ZF+2q8Hghu4cDU6Ci5xdHY3k1fnagF9kMQW
         2OAkonMOE+RPaqW3dj2rDfR5+pnu87mq2Tm6EPr9eoUZ444ET1novFwRBD1aruYoAWQr
         nZqA==
X-Gm-Message-State: AOAM531pf9L7s0FvjKGnpQwj/yq1EhSCb6HTCwNwq1YJq5TEPTW/u8dU
        vNP5hdA5XLloOd21XvkvJF7Tgw==
X-Google-Smtp-Source: ABdhPJymceEIiI/XPBYiJyKoLr/Mvlj37/77whhfEuNNagY6lrn2k5V2RspZGLa3ZzDA+UYl6cWfIw==
X-Received: by 2002:a5d:554e:: with SMTP id g14mr8416974wrw.264.1607439356429;
        Tue, 08 Dec 2020 06:55:56 -0800 (PST)
Received: from [10.8.0.46] (ip-188-118-3-185.reverse.destiny.be. [188.118.3.185])
        by smtp.gmail.com with ESMTPSA id h20sm8365273wrb.21.2020.12.08.06.55.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 06:55:55 -0800 (PST)
Subject: Re: [PATCH net 1/4] net: freescale/fman: Split the main resource
 region reservation
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20201203135039.31474-1-patrick.havelange@essensium.com>
 <20201203135039.31474-2-patrick.havelange@essensium.com>
 <AM6PR04MB39764190C3CC885EAA84E8B3ECF20@AM6PR04MB3976.eurprd04.prod.outlook.com>
From:   Patrick Havelange <patrick.havelange@essensium.com>
Message-ID: <e488ed95-3672-fdcb-d678-fdd4eb9a8b4b@essensium.com>
Date:   Tue, 8 Dec 2020 15:55:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <AM6PR04MB39764190C3CC885EAA84E8B3ECF20@AM6PR04MB3976.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-03 16:47, Madalin Bucur wrote:
>> -----Original Message-----
>> From: Patrick Havelange <patrick.havelange@essensium.com>
>> Sent: 03 December 2020 15:51
>> To: Madalin Bucur <madalin.bucur@nxp.com>; David S. Miller
>> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
>> Cc: Patrick Havelange <patrick.havelange@essensium.com>
>> Subject: [PATCH net 1/4] net: freescale/fman: Split the main resource
>> region reservation
>>
>> The main fman driver is only using some parts of the fman memory
>> region.
>> Split the reservation of the main region in 2, so that the other
>> regions that will be used by fman-port and fman-mac drivers can
>> be reserved properly and not be in conflict with the main fman
>> reservation.
>>
>> Signed-off-by: Patrick Havelange <patrick.havelange@essensium.com>
> 
> I think the problem you are trying to work on here is that the device
> tree entry that describes the FMan IP allots to the parent FMan device the
> whole memory-mapped registers area, as described in the device datasheet.
> The smaller FMan building blocks (ports, MDIO controllers, etc.) are
> each using a nested subset of this memory-mapped registers area.
> While this hierarchical depiction of the hardware has not posed a problem
> to date, it is possible to cause issues if both the FMan driver and any
> of the sub-blocks drivers are trying to exclusively reserve the registers
> area. I'm assuming this is the problem you are trying to address here,
> besides the stack corruption issue.

Yes exactly.
I did not add this behaviour (having a main region and subdrivers using 
subregions), I'm just trying to correct what is already there.
For example: this is some content of /proc/iomem for one board I'm 
working with, with the current existing code:
ffe400000-ffe4fdfff : fman
   ffe4e0000-ffe4e0fff : mac
   ffe4e2000-ffe4e2fff : mac
   ffe4e4000-ffe4e4fff : mac
   ffe4e6000-ffe4e6fff : mac
   ffe4e8000-ffe4e8fff : mac

and now with my patches:
ffe400000-ffe4fdfff : /soc@ffe000000/fman@400000
   ffe400000-ffe480fff : fman
   ffe488000-ffe488fff : fman-port
   ffe489000-ffe489fff : fman-port
   ffe48a000-ffe48afff : fman-port
   ffe48b000-ffe48bfff : fman-port
   ffe48c000-ffe48cfff : fman-port
   ffe4a8000-ffe4a8fff : fman-port
   ffe4a9000-ffe4a9fff : fman-port
   ffe4aa000-ffe4aafff : fman-port
   ffe4ab000-ffe4abfff : fman-port
   ffe4ac000-ffe4acfff : fman-port
   ffe4c0000-ffe4dffff : fman
   ffe4e0000-ffe4e0fff : mac
   ffe4e2000-ffe4e2fff : mac
   ffe4e4000-ffe4e4fff : mac
   ffe4e6000-ffe4e6fff : mac
   ffe4e8000-ffe4e8fff : mac

> While for the latter I think we can
> put together a quick fix, for the former I'd like to take a bit of time
> to select the best fix, if one is really needed. So, please, let's split
> the two problems and first address the incorrect stack memory use.

I have no idea how you can fix it without a (more correct this time) 
dummy region passed as parameter (and you don't want to use the first 
patch). But then it will be useless to do the call anyway, as it won't 
do any proper verification at all, so it could also be removed entirely, 
which begs the question, why do it at all in the first place (the 
devm_request_mem_region).

I'm not an expert in that part of the code so feel free to correct me if 
I missed something.

BR,

Patrick H.
