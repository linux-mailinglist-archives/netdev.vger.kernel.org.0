Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A603AFAFE
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 04:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhFVCTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 22:19:48 -0400
Received: from mail.loongson.cn ([114.242.206.163]:48240 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231164AbhFVCTs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 22:19:48 -0400
Received: from [10.130.0.191] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9BxQOIqSNFgap8VAA--.27352S3;
        Tue, 22 Jun 2021 10:17:14 +0800 (CST)
Subject: Re: stmmac: pci: Add dwmac support for Loongson
To:     Colin Ian King <colin.king@canonical.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <37057fe8-f7d1-7ee0-01c7-916577526b5b@canonical.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   zhangqing <zhangqing@loongson.cn>
Message-ID: <8f142063-5db7-58b4-d4b1-381760921eb1@loongson.cn>
Date:   Tue, 22 Jun 2021 10:17:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <37057fe8-f7d1-7ee0-01c7-916577526b5b@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9BxQOIqSNFgap8VAA--.27352S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ArW3GFyDtr4DCFWkGw4fAFb_yoW8Zry7p3
        y5Kas8tr9xGrZayFWrJF4UJ3W8urW3Kr4xCFW2yFW7GF15JFZxXw1UK3y2ya97uFykCay5
        Wr4jqa1vqa4kCw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9Kb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4
        vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
        Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJV
        W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkI
        wI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_Gr1l42xK82IYc2Ij64vIr41l4I
        8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AK
        xVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcV
        AFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8I
        cIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
        v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzxhLUUUUU
X-CM-SenderInfo: x2kd0wptlqwqxorr0wxvrqhubq/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/21/2021 11:51 PM, Colin Ian King wrote:
> Hi,
>
> Static analysis by Coverity on today's linux-next has found an issue in
> function loongson_dwmac_probe with the following commit:
>
> commit 30bba69d7db40e732d6c0aa6d4890c60d717e314
> Author: Qing Zhang <zhangqing@loongson.cn>
> Date:   Fri Jun 18 10:53:34 2021 +0800
>
>      stmmac: pci: Add dwmac support for Loongson
>
> The analysis is as follows:
>
> 110        plat->phy_interface = device_get_phy_mode(&pdev->dev);
>
> Enum compared against 0
> (NO_EFFECT)
> unsigned_compare: This less-than-zero comparison of an
> unsigned value is never true. plat->phy_interface < 0U.
>
> 111        if (plat->phy_interface < 0)
> 112                dev_err(&pdev->dev, "phy_mode not found\n");
>
> Enum plat->phy_interface is unsigned, so can't be negative and so the
> comparison will always be false.

Hi，Colin

Thanks for your advice,

I see this judgment in stmmac_platform.c:

plat->phy_interface = device_get_phy_mode(&pdev->dev);
if (plat->phy_interface < 0)
return ERR_PTR(plat->phy_interface);

plat->interface = stmmac_of_get_mac_mode(np);
if (plat->interface < 0)

>
> A possible fix is to use int variable ret for the assignment and check:
>
>
>          ret = device_get_phy_mode(&pdev->dev);
>          if (ret < 0)
>                  dev_err(&pdev->dev, "phy_mode not found\n");
>          plat->phy_interface = ret;
>
> ..however, I think the dev_err may need handling too, e.g.
>
>          ret = device_get_phy_mode(&pdev->dev);
>          if (ret < 0) {
>                  dev_err(&pdev->dev, "phy_mode not found\n");
> 		ret = -ENODEV;
> 		goto cleanup;		/* needs to be written */
> 	}
>          plat->phy_interface = ret;
>
> Colin
looks ok, but can be written to use of_get_phy_mode() , like this:

phy_interface_t interface;
ret = of_get_phy_mode(pdev->dev->of_node, &interface);
if (ret)
        return -EINVAL;


plat_dat->interface = interface;
if(!plat->interface)
dev_err(&pdev->dev, "Unsupported interface mode: %s",
         phy_modes(plat->interface));

Thanks

-Qing

