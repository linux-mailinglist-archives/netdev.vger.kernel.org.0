Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C573CC461
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 18:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhGQQNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 12:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhGQQNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 12:13:19 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFF2C06175F;
        Sat, 17 Jul 2021 09:10:22 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id a6so6128618pgw.3;
        Sat, 17 Jul 2021 09:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xddb+N0v+hHcIs8maktgerWuQ0JfLKpmotpQrY+Dm6o=;
        b=K3mWlWtGp3+sZiNKnyZo4q4zcJSrUR5+nVVmPc7EEIkqndxaK2XG0NxzboGgqTyI9k
         ziUHif5h6yzGkfjh5Tv1/V32G8rT94a1NOHTqopO8SE3nO87QRCpewBwgo206Ot2Nx7R
         rRKPI5A3FXsFw5d55LPFq6E8F47JFzf4ONaVIuw2Myy1+XaBf9BNkWkbykeP5NtRxN7k
         i7rsh0THw5OPhfe+271i50THyl/bj7/8GDExFn5mlp/iiLn+QKQWz/46TnLTboHZyurG
         v1+IRkBFdpx2sMM3xRn2NLj4iKODOamwtU2W158P+xus55bIwiQCQPMu0thHWAACaAoE
         WjDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xddb+N0v+hHcIs8maktgerWuQ0JfLKpmotpQrY+Dm6o=;
        b=WhhYoXZJvbUsSSHkF/rnwC61r0nPc2RVzq478yl/zQQVvD4uM5FDOO/asK7h+nV58C
         CCbgWEwqpNM75Wc+xXZqGvdv0IAPRfkb/AA8wUHOJP0ggAFh9gXYL3K6Eq+MnL80tj4w
         vTNzAENiofn/k4c6nCtouL4bal51MaXdEe7R87Y6rlJHWwGt5TQqf+NxY74/TYS4lHVq
         J/VuTs73VVbBFMY/vaQqKtFTvazaIC5GV9KPRD/CbU9/8CXShWNeIdQA7Hu93iNtGbhR
         25Xh3v6L87MgNT+Ff98MHUrj3QoRE0qg6MRDqMZSZOhiPQMV3C8XujGYJG+BltuoWywa
         NsRQ==
X-Gm-Message-State: AOAM531MfyZ3dH+AH8Y1SNWW/pFrrDYRuKUJizOs5i3mxPCyp4o7Pa6G
        oQ5z81Mt4Wiwure+poaWj1Q=
X-Google-Smtp-Source: ABdhPJwcTd76xSeBEG+xnuCq2rCXkuZNbJtwb9EbT6snml/J+5qteEAFArnsBXdPZt5MrtYlzAFO8g==
X-Received: by 2002:a63:171e:: with SMTP id x30mr16045233pgl.368.1626538222307;
        Sat, 17 Jul 2021 09:10:22 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u16sm15735548pgh.53.2021.07.17.09.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Jul 2021 09:10:21 -0700 (PDT)
Subject: Re: [PATCH net, v2] net: Update MAINTAINERS for MediaTek switch
 driver
To:     DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <landen.chao@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, frank-w@public-files.de,
        steven.liu@mediatek.com
References: <20210601024508.iIbiNrsg-6lZjXwIt9-j76r37lcQSk3LsYBoZyl3fUM@z>
 <20210717154523.82890-1-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d62aa80d-9ee2-23b8-f68f-449b488a3b0f@gmail.com>
Date:   Sat, 17 Jul 2021 09:10:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210717154523.82890-1-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/2021 8:45 AM, DENG Qingfang wrote:
> On Tue, Jun 01, 2021 at 10:45:08AM +0800, Landen Chao wrote:
>> Update maintainers for MediaTek switch driver with Deng Qingfang who
>> contributes many useful patches (interrupt, VLAN, GPIO, and etc.) to
>> enhance MediaTek switch driver and will help maintenance.
>>
>> Signed-off-by: Landen Chao <landen.chao@mediatek.com>
>> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> 
> Ping?

You might have to resend, when you do:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
