Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1793F6992
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 21:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbhHXTLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 15:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbhHXTLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 15:11:55 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B634EC061757;
        Tue, 24 Aug 2021 12:11:10 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id j2so8426764pll.1;
        Tue, 24 Aug 2021 12:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=6cBUiSOtd7GLWQqjZBxYFQzvcsAy6/iPF7YIUaVMAQ8=;
        b=IBpYAYLpwmg1DARBdeXPfUPxWCZuQLSJbZBpClIL79ZCdist2koSowVt1Iaxqswk22
         w3QTxmwBDaWWKZiI0z5qlr8k+4pYU97C8LxrJuk6dicTuypC7OQLl5XJ5HDKF+ViZQmx
         GMriFtvdBR2u2TkA66P3c4GBHsB7SDvosH4IfJSu41cq4C1If2fFk/YI8sb2gc1iyBcr
         qDsT5jEwraH7RxeLzvYeGabg2eWIiI9cjrLVVOvROpSt7z/O8u1sulOnjrpaxVY3JUhf
         gDgxWlDfpfqcWZLFItoPmHmT0GS0qpnVEj3cOebj5tBrE38ePlw2LyD2YRtYc8lay6xS
         tX1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6cBUiSOtd7GLWQqjZBxYFQzvcsAy6/iPF7YIUaVMAQ8=;
        b=ZhgN+R38nd8rBtdEmXR6M87kDQIo7KntyOUPrJEuFRJkCcmKc/L3MsRTcAcrSzjpFX
         HaL/TQxRhOz/n0FKejVCUoQCCO0yB8RwT6Pw+05SHDGPJ/A6cmOYvCI/IAfzKPCpN2uf
         /v0paYNU4X7mM5v17BszZQ77zup1tMGrCKmChdGDWLbKGj4biOjEoFJj9WEf4uqSA13b
         ESx2e0X+oUVtUBZtDVRYkbaD7o95QG/qy4u3AliJSolguGJ9cyoHD9jQG6piV2KsHy/I
         VDSBwXHDd+7p9ljkf/idFyeigpgVsE9V6MqUhYTt+TDndSU3S0UMEyTC9W+a6FU+vrXW
         Yk2A==
X-Gm-Message-State: AOAM533UbswBAh45Km5t+Ax3gBwwYT+Eu0ZKSwjw3+JQ9R55zsJZiFVk
        by+I0syFFcbQJ7DxZq77Jpc=
X-Google-Smtp-Source: ABdhPJwC4xMBis5/hy1NZQsWk/mciUadCOIB6uuUXtUb8GxGjEiF8HGW5zTJuSbbxtO35uYjUhqG3g==
X-Received: by 2002:a17:90a:5147:: with SMTP id k7mr6122884pjm.73.1629832270282;
        Tue, 24 Aug 2021 12:11:10 -0700 (PDT)
Received: from [192.168.1.22] (amarseille-551-1-7-65.w92-145.abo.wanadoo.fr. [92.145.152.65])
        by smtp.gmail.com with UTF8SMTPSA id x16sm22848098pgc.49.2021.08.24.12.11.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 12:11:08 -0700 (PDT)
Message-ID: <92f006f1-bcd2-1d27-3f46-491242565e0b@gmail.com>
Date:   Tue, 24 Aug 2021 21:11:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH net-next] net: dsa: mt7530: manually set up VLAN ID 0
Content-Language: en-US
To:     DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        "open list:MEDIATEK SWITCH DRIVER" <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210824165253.1691315-1-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210824165253.1691315-1-dqfext@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/24/2021 6:52 PM, DENG Qingfang wrote:
> The driver was relying on dsa_slave_vlan_rx_add_vid to add VLAN ID 0. After
> the blamed commit, VLAN ID 0 won't be set up anymore, breaking software
> bridging fallback on VLAN-unaware bridges.
> 
> Manually set up VLAN ID 0 to fix this.
> 
> Fixes: 06cfb2df7eb0 ("net: dsa: don't advertise 'rx-vlan-filter' when not needed")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
