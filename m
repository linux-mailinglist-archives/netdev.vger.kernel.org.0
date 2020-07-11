Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661E521C1A7
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 03:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgGKBqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 21:46:14 -0400
Received: from relay5.mymailcheap.com ([159.100.241.64]:37468 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgGKBqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 21:46:14 -0400
Received: from relay3.mymailcheap.com (relay3.mymailcheap.com [217.182.119.157])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 7803F20151;
        Sat, 11 Jul 2020 01:46:11 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay3.mymailcheap.com (Postfix) with ESMTPS id D4B303F1CC;
        Sat, 11 Jul 2020 03:46:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 18E7D2A3AA;
        Fri, 10 Jul 2020 21:46:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1594431968;
        bh=dKf0O2fyrFwr3fue2b7pNxfSAL3mgUsSFu+VG2miw+s=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=YlYu5enQFuYpFtO6lY8JlMs8RWVz5GTnhiXccFmt17HTSHiOxrQuZnyiCdB+S+egi
         9C6XBzka9fIAYmIt9wdN9yWrqwQRPa+CIANoxuj768ZCtYnYxwPVUFJSGtn0fQ0S8Y
         RA1XD8LgvCx91erUnxqyu+X2Pb/PnQd72VEaa60s=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ers-42yXCu5f; Fri, 10 Jul 2020 21:46:06 -0400 (EDT)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Fri, 10 Jul 2020 21:46:06 -0400 (EDT)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 104CC413E2;
        Sat, 11 Jul 2020 01:46:05 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="nsem9T/E";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (unknown [38.39.233.131])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id A02D2413E2;
        Sat, 11 Jul 2020 01:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1594431937;
        bh=dKf0O2fyrFwr3fue2b7pNxfSAL3mgUsSFu+VG2miw+s=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=nsem9T/EGQ1kkt+sjJ74Zh5VzkQnrPalkALXdgNMmk2gvIpi9Y/4yQnNExyzDSfSh
         uBlGZK6bzuFHSGFc/3DY8X2E5iiLZmBeyUFA1bEkAwh3lru6md7zvJzZYdc7I6Z99F
         S4zgxSLpD3FYLz73ijoKEmQy9P27xSwlMRfehpWI=
Subject: Re: [PATCH] stmmac: pci: Add support for LS7A bridge chip
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     Zhi Li <lizhi01@loongson.cn>, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net,
        kuba@kernel.org, mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lixuefeng@loongson.cn, chenhc@lemote.com, yangtiezhu@loongson.cn,
        Hongbin Li <lihongbin@loongson.cn>
References: <1594371110-7580-1-git-send-email-lizhi01@loongson.cn>
 <51aeec81-400f-c63b-3a22-e5384ff848f8@flygoat.com>
Message-ID: <bafaf026-9ec4-8cbd-8872-2109676dcdf5@flygoat.com>
Date:   Sat, 11 Jul 2020 09:45:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <51aeec81-400f-c63b-3a22-e5384ff848f8@flygoat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 104CC413E2
X-Spamd-Result: default: False [1.40 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         MID_RHS_MATCH_FROM(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all];
         ML_SERVERS(-3.10)[148.251.23.173];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         RCPT_COUNT_TWELVE(0.00)[13];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         FREEMAIL_TO(0.00)[loongson.cn,st.com,synopsys.com,davemloft.net,kernel.org,gmail.com];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:148.251.0.0/16, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         SUSPICIOUS_RECIPS(1.50)[];
         HFILTER_HELO_BAREIP(3.00)[148.251.23.173,1]
X-Rspamd-Server: mail20.mymailcheap.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2020/7/11 9:35, Jiaxun Yang 写道:
>
>
> 在 2020/7/10 16:51, Zhi Li 写道:
>> Add gmac platform data to support LS7A bridge chip.
>>
>> Co-developed-by: Hongbin Li <lihongbin@loongson.cn>
>> Signed-off-by: Hongbin Li <lihongbin@loongson.cn>
>> Signed-off-by: Zhi Li <lizhi01@loongson.cn>
>> ---
>>   drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 22 
>> ++++++++++++++++++++++
>>   1 file changed, 22 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c 
>> b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
>> index 272cb47..dab2a40 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
>> @@ -138,6 +138,24 @@ static const struct stmmac_pci_info 
>> snps_gmac5_pci_info = {
>>       .setup = snps_gmac5_default_data,
>>   };
>>   +static int loongson_default_data(struct pci_dev *pdev, struct 
>> plat_stmmacenent_data *plat)
>> +{
>> +    common_default_data(plat);
>> +
>> +    plat->bus_id = pci_dev_id(pdev);
>> +    plat->phy_addr = 0;
>> +    plat->interface = PHY_INTERFACE_MODE_GMII;
>> +
>> +    plat->dma_cfg->pbl = 32;
>> +    plat->dma_cfg->pblx8 = true;
>> +
>> +    return 0;
>> +}
>> +
>> +static struct stmmac_pci_info loongson_pci_info = {
>> +    .setup = loongson_default_data;
>> +};
>> +
>>   /**
>>    * stmmac_pci_probe
>>    *
>> @@ -204,6 +222,8 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
>>       res.addr = pcim_iomap_table(pdev)[i];
>>       res.wol_irq = pdev->irq;
>>       res.irq = pdev->irq;
>> +    if (pdev->vendor == PCI_VENDOR_ID_LOONGSON)
>> +        res.lpi_irq = pdev->irq + 1;
>
> This can never work.
> We're allocating IRQs by irq_domain, not ID.
> Please describe IRQ in DeviceTree, and *DO NOT* sne dout untested patch.
Oops, ^ send out

FYI: Here is my solution of GMAC[1] [2], I was too busy to upstream it.
We're using totally different structure than Loongson's out of tree Kernel,
especially in IRQ management.

Please don't simply copy 'n paste code from your company's internal kernel.

Please try to understand how upstream kernel is working and test your 
patches
with upstrem kernel.

[1]: 
https://github.com/FlyGoat/linux/commit/9d6584c186a8007f14dc8bb2524e48a2fd7d689a
[2]: 
https://github.com/FlyGoat/linux/commit/558a256acfeb022e132113e7952a9df3df375302

>
> Thanks.
>
>>         return stmmac_dvr_probe(&pdev->dev, plat, &res);
>>   }
>> @@ -273,11 +293,13 @@ static SIMPLE_DEV_PM_OPS(stmmac_pm_ops, 
>> stmmac_pci_suspend, stmmac_pci_resume);
>>     #define PCI_DEVICE_ID_STMMAC_STMMAC        0x1108
>>   #define PCI_DEVICE_ID_SYNOPSYS_GMAC5_ID        0x7102
>> +#define PCI_DEVICE_ID_LOONGSON_GMAC        0x7a03
>>     static const struct pci_device_id stmmac_id_table[] = {
>>       { PCI_DEVICE_DATA(STMMAC, STMMAC, &stmmac_pci_info) },
>>       { PCI_DEVICE_DATA(STMICRO, MAC, &stmmac_pci_info) },
>>       { PCI_DEVICE_DATA(SYNOPSYS, GMAC5_ID, &snps_gmac5_pci_info) },
>> +    { PCI_DEVICE_DATA(LOONGSON, GMAC, &loongson_pci_info) },
>>       {}
>>   };
> - Jiaxun
