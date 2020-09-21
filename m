Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A28271FBE
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgIUKKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgIUKKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:10:49 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4814C061755;
        Mon, 21 Sep 2020 03:10:48 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id d4so11532546wmd.5;
        Mon, 21 Sep 2020 03:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hF5Xe4zuKeuDnftfLSzTw6Ue5+aphrBIG5w4rc4SzI0=;
        b=KUDrcCnEC87hUXdHNGKHpmSN4RGpG4lGfUYnkcSIU+/DMB5UNxDLHnLgPXAfsdn1H5
         6ltC8XD5HE3eMaTQyPwLEVwHXFeWldTFjtofSfWrvr4Wht6pOyAoOcYj6KVtyv5oG+bZ
         ebKkDc5tiva0tFYGiDFVNK5Hbr7KZvacHLithwz7jB8hgg/qLUBx56eS5VQZI8CAAG2b
         GrvN7R3zK0BhGTG1Dyy7e1b6dET+ZXKs+rb3B348qkowBv2KlJR7u5yhfHcLNLtc+49/
         rpfCdwOJHKF8oLy5+FuQwQxL5NzVH3z5c6zD4X3ftvmQrzS4HeEsUXBqutxFkW+Du2Qr
         iecQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hF5Xe4zuKeuDnftfLSzTw6Ue5+aphrBIG5w4rc4SzI0=;
        b=pANrfQOlb5r+6kH4Jza7fSSGcNOd+EoP4WNxTKh1yZqTdQ2Nfl0sf3Wg19TRkFnPZn
         KDAsUDuAkRqcI0Qxi9VauClPsuX+TKpzkVQLfo2HAnLije1/szQ6F/rBeQ7jNVpdaSlZ
         hAGSZKp6NjSVZ48vwd8SQtNggKVGO8q3mvtV+/c5sweRspC5wfk/9nxl7h8cTc7a/xcu
         poUeHrDhH78fIjg+PcQQ47SJCzBkvQs++gOz/aHf6p+lP62/BQ21t0N83SXG0X5C0vwx
         iX8mUbb5MujBqTzAiFzcj4tsEwG5hmgT2Y+6YXw9btpofCftqyYIT7Ed+dm1LKho/1Ln
         Us8w==
X-Gm-Message-State: AOAM53194NzQwc4KrORWUQC4fLBdVrn3RDkYlHQ6nB10UdDTXunfJ1Qp
        vDTN+uVb57/gjjymeryTvMe211lLbAurrA==
X-Google-Smtp-Source: ABdhPJy7EAdglywRorZS0QXaRmHGvnMqSYV56C3XdsnhvA/r8oTtCwgePUVMY+s1rH1ltxcbV1Oecg==
X-Received: by 2002:a1c:e108:: with SMTP id y8mr29357116wmg.179.1600683047430;
        Mon, 21 Sep 2020 03:10:47 -0700 (PDT)
Received: from ziggy.stardust ([213.195.113.201])
        by smtp.gmail.com with ESMTPSA id y5sm19753599wrh.6.2020.09.21.03.10.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 03:10:46 -0700 (PDT)
Subject: Re: [PATCH net-next v5 0/6] net-next: dsa: mt7530: add support for
 MT7531
To:     David Miller <davem@davemloft.net>, landen.chao@mediatek.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, robh+dt@kernel.org, sean.wang@mediatek.com,
        p.zabel@pengutronix.de, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        frank-w@public-files.de, opensource@vdorst.com, dqfext@gmail.com
References: <cover.1599829696.git.landen.chao@mediatek.com>
 <20200914.163228.1898649357949030454.davem@davemloft.net>
From:   Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <c485e60e-21af-ffd3-856c-dbfd497cf6f0@gmail.com>
Date:   Mon, 21 Sep 2020 12:10:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200914.163228.1898649357949030454.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15/09/2020 01:32, David Miller wrote:
> From: Landen Chao <landen.chao@mediatek.com>
> Date: Fri, 11 Sep 2020 21:48:50 +0800
> 
>> This patch series adds support for MT7531.
>>
>> MT7531 is the next generation of MT7530 which could be found on Mediatek
>> router platforms such as MT7622 or MT7629.
>>
>> It is also a 7-ports switch with 5 giga embedded phys, 2 cpu ports, and
>> the same MAC logic of MT7530. Cpu port 6 only supports SGMII interface.
>> Cpu port 5 supports either RGMII or SGMII in different HW SKU, but cannot
>> be muxed to PHY of port 0/4 like mt7530. Due to support for SGMII
>> interface, pll, and pad setting are different from MT7530.
>>
>> MT7531 SGMII interface can be configured in following mode:
>> - 'SGMII AN mode' with in-band negotiation capability
>>      which is compatible with PHY_INTERFACE_MODE_SGMII.
>> - 'SGMII force mode' without in-band negotiation
>>      which is compatible with 10B/8B encoding of
>>      PHY_INTERFACE_MODE_1000BASEX with fixed full-duplex and fixed pause.
>> - 2.5 times faster clocked 'SGMII force mode' without in-band negotiation
>>      which is compatible with 10B/8B encoding of
>>      PHY_INTERFACE_MODE_2500BASEX with fixed full-duplex and fixed pause.
>   ...
> 
> Series applied, thank you.
> 

Regarding the DTS patches: Please coordinate with me the next time. I want to 
prevent merge conflicts if both mine and your tree add patches to the files.

Thanks,
Matthias
