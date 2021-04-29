Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA3336EE32
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 18:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240893AbhD2QdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 12:33:03 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:45948 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240773AbhD2QdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 12:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619713935; x=1651249935;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=hqg6GCymKi8MGlWIx2XifSrXyOJ+2DS2KKgnhY+o25c=;
  b=UoHQ2nLzkRysW3ZiFJoX38bt904ReKYMsJn3UipLVzjgjQhkWeiZGT5l
   122dWQ4KKl4/7mYkbTFf3CsjGQ5kMeOLvpc2XCkjyTVKjo1JtjSlnTD03
   Ker3QbCk1ZFlWXXoKbV6W2UfKRuemoBYt8O4GKRGSRVh2ne6owCm3GO6z
   /DRQoJukNPPGKANL2D4CmtxDPP/0QhbHlGoIwyM4upUAEJ1+eOxiJ1R4r
   focIX3OvO6jCwtWybgrSvgEXHMDqnlarAslxIzTQcyGggKmmnqdtXX24m
   DZjiq0w7iH8FCwOlv1qy8iazrHzdcEOgxJAWQwLjQQviZFINVVNNeZGLf
   g==;
IronPort-SDR: sa6xaJUC2wpDcfdsfc9/3DuLsY6QIhK+Lij0cF1caQycbtdtzI1AYHt9rqjxJoiAMu7/k52Ys4
 rI/XO6uGRNC+gdkSSylW13+HJOpdp1e4+kTOX92dyzgjAer3v3yNPCi1KUhJWTKI6Q8QN7VnrH
 lClRW075l2fIyGZJCne1R1AnVE/eQBkU7L1lCkCCTB3KADR/YzQI71ZVHE2iF9RFmVeu1aPtcN
 DuuHsCmnX/ij0o27rA0+6GniQZGBxVIwFxQtyjg5cVJoF908gp2la/Ew/njJVS+wp1X18IeQVf
 Sk8=
X-IronPort-AV: E=Sophos;i="5.82,259,1613458800"; 
   d="scan'208";a="112706308"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Apr 2021 09:32:15 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Apr 2021 09:32:15 -0700
Received: from [10.171.246.9] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 29 Apr 2021 09:32:13 -0700
Subject: Re: [PATCH] net: macb: Remove redundant assignment to w0 and queue
To:     Jakub Kicinski <kuba@kernel.org>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
CC:     <claudiu.beznea@microchip.com>, <davem@davemloft.net>,
        <linux@armlinux.org.uk>, <palmer@dabbelt.com>,
        <paul.walmsley@sifive.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>
References: <1619604188-120341-1-git-send-email-jiapeng.chong@linux.alibaba.com>
 <20210428122106.2597718a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <ac269e45-113c-1fc3-192a-97253633e031@microchip.com>
Date:   Thu, 29 Apr 2021 18:32:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210428122106.2597718a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/04/2021 at 21:21, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Wed, 28 Apr 2021 18:03:08 +0800 Jiapeng Chong wrote:
>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>> index 0f6a6cb..5f1dbc2 100644
>> --- a/drivers/net/ethernet/cadence/macb_main.c
>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>> @@ -3248,7 +3248,6 @@ static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
>>        /* ignore field if any masking set */
>>        if (tp4sp_m->ip4src == 0xFFFFFFFF) {
>>                /* 1st compare reg - IP source address */
>> -             w0 = 0;
>>                w1 = 0;
>>                w0 = tp4sp_v->ip4src;
>>                w1 = GEM_BFINS(T2DISMSK, 1, w1); /* 32-bit compare */
>> @@ -3262,7 +3261,6 @@ static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
>>        /* ignore field if any masking set */
>>        if (tp4sp_m->ip4dst == 0xFFFFFFFF) {
>>                /* 2nd compare reg - IP destination address */
>> -             w0 = 0;
>>                w1 = 0;
>>                w0 = tp4sp_v->ip4dst;
>>                w1 = GEM_BFINS(T2DISMSK, 1, w1); /* 32-bit compare */
> 
> Looks like this was written like that on purpose.
> 
>> @@ -4829,7 +4827,7 @@ static int __maybe_unused macb_suspend(struct device *dev)
>>   {
>>        struct net_device *netdev = dev_get_drvdata(dev);
>>        struct macb *bp = netdev_priv(netdev);
>> -     struct macb_queue *queue = bp->queues;
>> +     struct macb_queue *queue;
>>        unsigned long flags;
>>        unsigned int q;
>>        int err;
>> @@ -4916,7 +4914,7 @@ static int __maybe_unused macb_resume(struct device *dev)
>>   {
>>        struct net_device *netdev = dev_get_drvdata(dev);
>>        struct macb *bp = netdev_priv(netdev);
>> -     struct macb_queue *queue = bp->queues;
>> +     struct macb_queue *queue;
>>        unsigned long flags;
>>        unsigned int q;
>>        int err;
> 
> This chunk looks good!
> 
> Would you mind splitting the patch into two (1 - w0 assignments, and
> 2 - queue assignments) and reposting? We can merge the latter, the
> former is up to the driver maintainer to decide.

Good move Jakub, thanks for having suggested this as we are highlighting 
a bug!

Best regards,
   Nicolas

-- 
Nicolas Ferre
