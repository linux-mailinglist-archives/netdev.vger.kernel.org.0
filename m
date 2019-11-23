Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B935C10805F
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 21:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfKWUal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 15:30:41 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36473 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWUak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 15:30:40 -0500
Received: by mail-pj1-f66.google.com with SMTP id cq11so4668488pjb.3
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 12:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KMUdav/WxXuIZJfDjnpOFL7WwVez6r5UDppsJy3Zqj0=;
        b=M7fo6ORnbpwEsXgr94YLWYgS1dt7n/4L4ZCywj5Wz7Z9dyO9SPVtp5pBmGnjnyptSR
         K06MRAwGouKPLPwJlueLjLEJ0cy3Mbw5G4mHEPKYrolw4G+G9HPiGyJ8GeleMmO8rzZa
         Ai6mdXSWT+TdxyupywvWVDsF8p6df0iI2huwYqECelq5m2IiajvnB+LRwkKiMz8YfpCG
         QnDC1naRh6bIOQSmz/KQVNu6ByRPvMvSj9dFdYOMQH8w2oAHy9gRTdKiXsoZYUR+WIje
         zDaU5//MXd5JR3CBTP9F2wUonkAzYYMwZzsNrTNqKREArHdlyP9R4cBGbFX4s/G9du+c
         HThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KMUdav/WxXuIZJfDjnpOFL7WwVez6r5UDppsJy3Zqj0=;
        b=RsCcHQvOBmsum9zya3aduHX+k6d79h8M71VVnA3cBm74XDNvCaAF1XoPt1Fpe0Vnk3
         6037lhsdIBUldwRJ3BS1uVgn5OiE6we9Qt7AQVpkBbCxa2oK1NJxIVli7l4lt3QB7f2b
         rUfHba2a5UXxcMejlZErbb2cZJtyp7n4oP32QaZzPlLt+bPVT45LKybKSJruuRPOatvx
         y1gCadwrnYRERbwFlRmYzC2n3uhaPqOez08/lmc/OU7sKcUm1lwC+/b9qakzU7/m9rBO
         /i+ouRZrzD0mQHacY16liPE6kmzeBWcNDQ4MHKLpV8rdnJw+XhUSoY7MHnzCtJev1M7o
         v7dA==
X-Gm-Message-State: APjAAAXXWNPe1dsVYFrTAsYKbGR11msFrswiEKmIt7oNvBpr6yhYLcap
        mTMNWGvZAHWZNLcHF0/bYQg=
X-Google-Smtp-Source: APXvYqz0lyDJGpXzt0mJ0QZe//CVSkfojLTQPmcnAlh+ld04Zw45/t7op7oLWZ4YpZeX29ckDJ7W9Q==
X-Received: by 2002:a17:90a:a58b:: with SMTP id b11mr28007873pjq.46.1574541038256;
        Sat, 23 Nov 2019 12:30:38 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id r28sm2657133pgk.75.2019.11.23.12.30.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 12:30:37 -0800 (PST)
Subject: Re: [CFT PATCH net-next v2] net: phylink: rename mac_link_state() op
 to mac_pcs_get_state()
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     David Miller <davem@davemloft.net>, andrew@lunn.ch,
        nbd@openwrt.org, radhey.shyam.pandey@xilinx.com,
        alexandre.torgue@st.com, netdev@vger.kernel.org,
        sean.wang@mediatek.com, linux-stm32@st-md-mailman.stormreply.com,
        vivien.didelot@gmail.com, michal.simek@xilinx.com,
        joabreu@synopsys.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, thomas.petazzoni@bootlin.com,
        john@phrozen.org, matthias.bgg@gmail.com, peppe.cavallaro@st.com,
        Mark-MC.Lee@mediatek.com, mcoquelin.stm32@gmail.com,
        hkallweit1@gmail.com
References: <E1iXaSM-0004t1-9L@rmk-PC.armlinux.org.uk>
 <20191121.191417.1339124115325210078.davem@davemloft.net>
 <0a9e016b-4ee3-1f1c-0222-74180f130e6c@gmail.com>
 <20191122092136.GJ25745@shell.armlinux.org.uk>
 <20191123103840.76c5d63f@cakuba.netronome.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <d4d4837e-bea0-4303-0f66-6433e21c4be8@gmail.com>
Date:   Sat, 23 Nov 2019 12:30:36 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191123103840.76c5d63f@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/23/2019 10:38 AM, Jakub Kicinski wrote:
> On Fri, 22 Nov 2019 09:21:37 +0000, Russell King - ARM Linux admin
> wrote:
>> On Thu, Nov 21, 2019 at 07:36:44PM -0800, Florian Fainelli wrote:
>>> Russell, which of this patch or: http://patchwork.ozlabs.org/patch/1197425/
>>>
>>> would you consider worthy of merging?  
>>
>> Let's go with v2 for now - it gets the rename done with less risk that
>> there'll be a problem.  I can always do the remainder in a separate
>> patch after the merge window as a separate patch.
> 
> Florian, I assume you asked because you wanted to do some testing?
> Please let me know if you need more time, otherwise I'll apply this
> later today.

Please go ahead, if there are issues we can always follow-up. Thanks.
-- 
Florian
