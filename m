Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4715C740E9
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbfGXVgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:36:12 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39505 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728343AbfGXVgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 17:36:12 -0400
Received: by mail-wm1-f68.google.com with SMTP id u25so32502715wmc.4
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 14:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BJO3bn+udImiRfuXLGRvo3kdZGEe0wn+EYqVZ6drGPc=;
        b=cQr8YhtWUCJiPew+czvOjw75h33ov4Gy4JNRt5ZutNV60rOYUSOqyFAoUW9vMFHoMG
         fSaEcEfmY9nEvQLKiD5+t8JjFC9dKvcg+oB9tV+OpDFRqVm7pYpNiMXMePDYXlWvBd8j
         izphfieIJxP5hRHbq4scgZ/aBhUAbK4NzYdMGUr2+ZbLpLaEdmRJSOOhdv+Fu3LO+uTZ
         BUkiF2/LQxNN2bGUmAtai01bJLf2QQcigT5mf973N8xaiXXZGg+4GA7yDd3K83fhJz4j
         gEQL18iQDTmiLFDBYp3dG2gaxrZhOS1Lksk4KEAyAXVDYasgsUQLpBSwdcv/Y4fPPeXw
         jO8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BJO3bn+udImiRfuXLGRvo3kdZGEe0wn+EYqVZ6drGPc=;
        b=AN8QsaNk8BGqQGoJ4Z6HGHnqPlUbolakPCcz1/jDuK2hMGRtB36HXKHJF06wX34dOr
         ZnFEUPE21rQPhJ8HTvXqhlGjC/ybdfNoJ5GXpC7giOjCZ77bEUCNGFTyE6yk+n76Mpqm
         6lPq0G+jAbxdtpYz3xJHyTKRIHBjPPQJI7+3NUJuqugfE3Z8GDqp0120FIUdx6ADwA6C
         3P8ed5xkIwKfJYNy+w+DM0C+AX6DfPwGcjq9BMC2rTZe6WvbGaNInrGAFQZ9H9QAbs5d
         c52duE0la4kubg8wzJgzi7d6EuJ31ZtvZpI5HXETovJd+WCQx6YbdVIK4N3M2DWdm35f
         aGCA==
X-Gm-Message-State: APjAAAXGMYdf3VCvr3twwqmQDFRmgSlpVIHTtDHyvx0kIredy79oj69f
        scnfhtZQZ/L+TzVtrDFAuA6HIUnV
X-Google-Smtp-Source: APXvYqymw2SY/Gp7bBJtwXqiKwTA0GiG32RPDrv1Bzag2qJAr269EXf0+fJUMB1PfNJ2EM7x8rnodQ==
X-Received: by 2002:a7b:c202:: with SMTP id x2mr73239892wmi.49.1564004170830;
        Wed, 24 Jul 2019 14:36:10 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:60e4:dd99:f7ec:c519? (p200300EA8F43420060E4DD99F7ECC519.dip0.t-ipconnect.de. [2003:ea:8f43:4200:60e4:dd99:f7ec:c519])
        by smtp.googlemail.com with ESMTPSA id o20sm119449396wrh.8.2019.07.24.14.36.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 14:36:10 -0700 (PDT)
Subject: Re: [PATCH net-next] r8169: improve rtl_set_rx_mode
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "nic_swsd@realtek.com" <nic_swsd@realtek.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d9900738-0eaf-63cc-dbbf-41ca05539794@gmail.com>
 <228e1254af247a66ebbae649f5a1385b8da64597.camel@mellanox.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <bbc963fe-6fcb-1802-aae8-a45aa41ee510@gmail.com>
Date:   Wed, 24 Jul 2019 23:36:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <228e1254af247a66ebbae649f5a1385b8da64597.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.07.2019 23:24, Saeed Mahameed wrote:
> On Wed, 2019-07-24 at 23:04 +0200, Heiner Kallweit wrote:
>> This patch improves and simplifies rtl_set_rx_mode a little.
>> No functional change intended.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 52 ++++++++++-----------
>> --
>>  1 file changed, 22 insertions(+), 30 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c
>> b/drivers/net/ethernet/realtek/r8169_main.c
>> index 9c743d2fc..c39d3a77c 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -61,7 +61,7 @@
>>  
>>  /* Maximum number of multicast addresses to filter (vs. Rx-all-
>> multicast).
>>     The RTL chips use a 64 element hash table based on the Ethernet
>> CRC. */
>> -static const int multicast_filter_limit = 32;
>> +#define	MC_FILTER_LIMIT	32
>>  
>>  #define TX_DMA_BURST	7	/* Maximum PCI burst, '7' is unlimited */
>>  #define InterFrameGap	0x03	/* 3 means InterFrameGap =
>> the shortest one */
>> @@ -4147,53 +4147,45 @@ static void rtl8169_set_magic_reg(struct
>> rtl8169_private *tp, unsigned mac_versi
>>  static void rtl_set_rx_mode(struct net_device *dev)
>>  {
>>  	struct rtl8169_private *tp = netdev_priv(dev);
>> -	u32 mc_filter[2];	/* Multicast hash filter */
>> -	int rx_mode;
>> -	u32 tmp = 0;
>> +	/* Multicast hash filter */
>> +	u32 mc_filter[2] = { 0xffffffff, 0xffffffff };
>> +	u32 rx_mode = AcceptBroadcast | AcceptMyPhys | AcceptMulticast;
>> +	u32 tmp;
>>  
> 
> While you are here, maybe improve the declaration order with a reversed
> xmas tree ..
> 
Indeed .. Thanks.
