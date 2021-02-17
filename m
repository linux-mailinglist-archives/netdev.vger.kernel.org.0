Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D419731D87D
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 12:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhBQLfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 06:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbhBQL3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 06:29:21 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A49BC06178C
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 03:28:47 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id v15so17007182wrx.4
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 03:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QSLVADKfDjouKtfcxryZ6r5uJuCR2hpGuJxslRznYLE=;
        b=aylGbGkjA6vW5ybyYaPgwOmTFWTdEzeiDOMOnKPIrTfoRZV9iIX5oYwFsWx6xetssO
         foSMxHkL4KEie9okA8BjYMFlKueodBcQNDwJXkEPCDbC79kY73Npb3xRdzDhibQ+qwp3
         oFLydMOGkkh36pvAgnT/UaOG0OvRkssoTJtLhADXlZ06CX7l1+9bDJbu7cIG9V/+h59c
         OuGmOVSNDBCKtoxkZpgZfyjzyzjo1Zus8BV7DKp/ifGwLx9NVZpYPFnAw1xfIMMZvIrp
         T76Me8wNUP8Uaq7TOtaUUq1/TZDzSjDekT1jvOINm6t0D+jjn7Rd3OBuvT/Pxk16NOa5
         ++Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QSLVADKfDjouKtfcxryZ6r5uJuCR2hpGuJxslRznYLE=;
        b=JSDZYjT/wEsKYddgMM2xPyvJeYCOrfKd+mE1ahak7zfsXp2YpKqgPemlR5UK9D+yiJ
         B61TnlRUmRyxpvXo5neCELXAIe8VAt4MkaaKnrPM2z07csg4JW310Ij2wBLGkhWD30jb
         kAN0GjCVLJIZxnTryIr+uC/Erq3RYjESlPfYcDuXF5b1lL615Y6wkU61M3HFmsOtUwJ+
         SfNm9f2oS1U1+ZBIep5gJG8FNCMge4eFi3MHIBP51Onc0Wa/BDOSZqqqJdzpluZoOksw
         HJY+cEjx+TdTzloSsO8Tzqgyi66+aEy5Z2+0yjtjYFgMoF3tOP2ys2ZFFM9AGSyUUCrj
         wwRw==
X-Gm-Message-State: AOAM53210FDXMw7xVumnSw/HcGlnO4yMW4OpEuTqNXDGigbY/uB2NL6l
        U/dYLNXszFoxtNfmTHVmqYDZQ2eGfvHn1Q==
X-Google-Smtp-Source: ABdhPJzIiJA2Oixvdvv0woQqoog5iAqelyw1I5N718VgwgJttQaFeZOyBO1DxSMRqXtGl1eAWGKBUA==
X-Received: by 2002:a5d:44cf:: with SMTP id z15mr28811412wrr.191.1613561326299;
        Wed, 17 Feb 2021 03:28:46 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:ac39:4391:1da8:84ef? (p200300ea8f395b00ac3943911da884ef.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:ac39:4391:1da8:84ef])
        by smtp.googlemail.com with ESMTPSA id j14sm3331026wru.43.2021.02.17.03.28.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 03:28:45 -0800 (PST)
Subject: Re: [RFC net-next 1/2] net: dsa: add Realtek RTL8366S switch tag
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
References: <20210217062139.7893-1-dqfext@gmail.com>
 <20210217062139.7893-2-dqfext@gmail.com>
 <e395ad31-9aeb-0afe-7058-103c6dce942d@gmail.com>
 <CACRpkdYQthFgjwVzHyK3DeYUOdcYyWmdjDPG=Rf9B3VrJ12Rzg@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <dd9d6ce8-cd87-2612-bcc1-26df717d4e81@gmail.com>
Date:   Wed, 17 Feb 2021 12:28:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CACRpkdYQthFgjwVzHyK3DeYUOdcYyWmdjDPG=Rf9B3VrJ12Rzg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.02.2021 12:01, Linus Walleij wrote:
> On Wed, Feb 17, 2021 at 8:08 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>>> +#define RTL8366S_HDR_LEN     4
>>> +#define RTL8366S_ETHERTYPE   0x8899
>>
>> I found this protocol referenced as Realtek Remote Control Protocol (RRCP)
>> and it seems to be used by few Realtek chips. Not sure whether this
>> protocol is officially registered. If yes, then it should be added to
>> the list of ethernet protocol id's in include/uapi/linux/if_ether.h.
>> If not, then it may be better to define it using the usual naming
>> scheme as ETH_P_RRCP in realtek-smi-core.h.
> 
> It's actually quite annoying, Realtek use type 0x8899 for all their
> custom stuff, including RRCP and internal DSA tagging inside
> switches, which are two completely different use cases.
> 
> When I expose raw DSA frames to wireshark it identifies it
> as "Realtek RRCP" and then naturally cannot decode the
> frames since this is not RRCP but another protocol identified
> by the same ethertype.
> 
> Inside DSA it works as we explicitly asks tells the kernel using the
> tagging code in net/dsa/tag_rtl4_a.c that this is the DSA version
> of ethertype 0x8899 and it then goes to dissect the actual
> 4 bytes tag.
> 
> There are at least four protocols out there using ethertype 0x8899.
> 

Ugly .. Thanks for the details!

> Yours,
> Linus Walleij
> 

