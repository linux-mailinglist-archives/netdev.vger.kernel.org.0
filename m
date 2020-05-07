Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65511C958B
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgEGPye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726451AbgEGPyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 11:54:33 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F0EC05BD43;
        Thu,  7 May 2020 08:54:32 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f7so3182030pfa.9;
        Thu, 07 May 2020 08:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qODBvlvixTIM4uF++H0GbJezfoy8iTUvBUc/JVUBYxA=;
        b=ThQynXjQezxuTaKhw2P2xZXcypd1fLvesj058Lm/QfVygms1wxRVgrwZJ8E6VZyCAU
         a/tIrJ4oUID7VucfjsVZhlujX0P/iLP1pavLPBc1pGgojhP4kWqL/HT4iTGYEPL6MZF5
         iJdOBAULSeVwFCs/nyjZ6cA/cjDXQJVb2cFgdw1MidNng46W6fIbqhave1digP801gOj
         ZUdPvfhNM8TXiTLx2Cg1ng/mBxGNWlfbRdoBb/9WDxby74I/hiPVtM4f5mjK2EkUSo07
         YZbgoU53WQKH7BZ32FmzRjSGCLq4/ehjKYc8T3y4AO7K78XafmV1b6vPtcXdYa6/z8ZD
         wMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qODBvlvixTIM4uF++H0GbJezfoy8iTUvBUc/JVUBYxA=;
        b=Q5nLh1TWzDhMoOag4c/EJjK2ygZP77CoYni6P9Po6xkaj68fWto4dWvOLgcNN3EuUc
         +98npuxuoPb/fX+tHQRxiJOfk3dBWBMjLAWv73g3CEFAEHspEZDfL2E4R+c5k0aENzF8
         /8pyLfPw5l5x09hNu7v9ls7ODhJj5JsXeyNjgcFLYvz3OzZ9SCyi/lDlAMnBIWu2lMo+
         pG9yCT10sPbtvQne5+6U83DtxkOx3VNEmbEllzOAVuSG7YK10vJ3Ujf766+e0Uv1qbYh
         ygav4pAmA7CKWgvBR3b3zZeY8SgUIVTljbljsIPEVpHcY/Ft1/bp7jtGQYXL/+/U1oOi
         E91w==
X-Gm-Message-State: AGi0PuZ7AUFiQf4HUuGqTSS6mZKNlGF5fcF/rayIA2H6L09RuXO5A4Mn
        H+xQvDC2V6yPQt+n17+Cw6ebJtWH
X-Google-Smtp-Source: APiQypKgQitqAVNooiWscmGva4UImYjtJXRZeHamNUycjPKQVBAqUgiTEZu9zk0Skxn/ZM/jxvhEZA==
X-Received: by 2002:a62:18d7:: with SMTP id 206mr1283594pfy.299.1588866871142;
        Thu, 07 May 2020 08:54:31 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y63sm5191194pfg.138.2020.05.07.08.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 08:54:30 -0700 (PDT)
Subject: Re: [PATCH net v2] net: bcmgenet: Clear ID_MODE_DIS in
 EXT_RGMII_OOB_CTRL when not needed
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Wahren <wahrenst@gmx.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200225131159.26602-1-nsaenzjulienne@suse.de>
 <cf07fae3-bd8f-a645-0007-a317832c51c1@samsung.com>
 <CGME20200507100347eucas1p2bad4d58e4eb23e8abd22b43f872fc865@eucas1p2.samsung.com>
 <a3df217d-f35c-9d74-4069-d47dee89173e@samsung.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <09f9fdff-867f-687f-e5af-a4f82a75e105@gmail.com>
Date:   Thu, 7 May 2020 08:54:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <a3df217d-f35c-9d74-4069-d47dee89173e@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/2020 3:03 AM, Marek Szyprowski wrote:
> Hi
> 
> On 07.05.2020 11:46, Marek Szyprowski wrote:
>> On 25.02.2020 14:11, Nicolas Saenz Julienne wrote:
>>> Outdated Raspberry Pi 4 firmware might configure the external PHY as
>>> rgmii although the kernel currently sets it as rgmii-rxid. This makes
>>> connections unreliable as ID_MODE_DIS is left enabled. To avoid this,
>>> explicitly clear that bit whenever we don't need it.
>>>
>>> Fixes: da38802211cc ("net: bcmgenet: Add RGMII_RXID support")
>>> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
>>
>> I've finally bisected the network issue I have on my RPi4 used for 
>> testing mainline builds. The bisect pointed to this patch. Once it got 
>> applied in v5.7-rc1, the networking is broken on my RPi4 in ARM32bit 
>> mode and kernel compiled from bcm2835_defconfig. I'm using u-boot to 
>> tftp zImage/dtb/initrd there. After reverting this patch network is 
>> working fine again. The strange thing is that networking works fine if 
>> kernel is compiled from multi_v7_defconfig but I don't see any obvious 
>> difference there.
>>
>> I'm not sure if u-boot is responsible for this break, but kernel 
>> definitely should be able to properly reset the hardware to the valid 
>> state.
>>
>> I can provide more information, just let me know what is needed. Here 
>> is the log, I hope it helps:
>>
>> [   11.881784] bcmgenet fd580000.ethernet eth0: Link is Up - 
>> 1Gbps/Full - flow control off
>> [   11.889935] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>>
>> root@target:~# ping host
>> PING host (192.168.100.1) 56(84) bytes of data.
>> From 192.168.100.53 icmp_seq=1 Destination Host Unreachable
>> ...
> 
> Okay, I've played a bit more with this and found that enabling 
> CONFIG_BROADCOM_PHY fixes this network issue. I wonder if Genet driver 
> should simply select CONFIG_BROADCOM_PHY the same way as it selects 
> CONFIG_BCM7XXX_PHY.

Historically GENET has been deployed with an internal PHY and this is
still 90% of the GENET users out there on classic Broadcom STB
platforms, not counting the 2711. For external PHYs, there is a variety
of options here, so selecting CONFIG_BROADCOM_PHY would be just one of
the possibilities, I would rather fix this with the bcm2835_defconfig
and multi_v7_defconfig update. Would that work for you?
-- 
Florian
