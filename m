Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D113F18E574
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 00:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgCUXaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 19:30:03 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52443 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbgCUXaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 19:30:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id z18so1588621wmk.2
        for <netdev@vger.kernel.org>; Sat, 21 Mar 2020 16:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pCececYyUKX0Dl2ZPEMbe6UxZs4Z6GF1p33hg7vvG5g=;
        b=DLsTNNJQyI7tPJtc4CfRWdxoxZHPnUnLcvsHLfWk0e5XWvKyMG0EJBp42Q4kdecqCy
         ZvoihV92JQfXt8uMzNKAHxb09MTTnIG7+isvNRipJa16VQ/w8TlOhjsBXMa026LtQ2Z7
         7j5zRtewCFwJZNgk4NzipVaKndhp80zfXJ9+Py9pMwNsgol64oIGAlPr99BDIDbaqIBh
         BONBhRkrLXOBeiBK2d8VR8i6m2pd3yscvd6/D5FQ1qqGOsdvHLvvyrWRxRURnzp4Xn62
         F+0J/YwLxAFXdTWDehwq3sga3weGySCbsF2PcmSAeMaftshGuKtb04f+IM2yc2pkb3PG
         OcxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pCececYyUKX0Dl2ZPEMbe6UxZs4Z6GF1p33hg7vvG5g=;
        b=NyO/X2FbZGnVDzVDXS++Io1ZTJgZmZwO5qcDBQiXucoTXkVdoY6xup/u5vTCdiWrtJ
         /UHAq3AyiaABtkDCNlLd/BXDqXpMV08UbYM1GDcdw5S2GA0rcGX3jeZzWhZ5F7PlIhDe
         N9jErOOKWkR05ZPlSdaImldFsMXcCqve7TVbUgyAgwhvJkhJ+BsTkL8JPF4DnLQXdGo4
         qr6RLyJpOgmJT/U+SOul0rKkr1KFmQF/ndwdg1t2TkbYiBLyvijl6n4rXKd8GDAk7OK3
         7kaERxZKLFXcE6lJ7eXWuAyY7K7ekXAuSjNGO2OhMdLJ5p0KB5G+D35TvyO1MaFuNWuN
         hdYA==
X-Gm-Message-State: ANhLgQ2EPwrU5vBRu3wjZHaclKwNKv+rgJKIcr8sww1/EgN7+kGWBClg
        drgAmji13aXjQ9fK8MrQjP8nKYjZ
X-Google-Smtp-Source: ADFU+vubn+SDNwwuIMSimMv3tZLAftMXlZaGIMc8V8B7vxeWuGa5fiZ/oU0YcNuvosnJoVpOQyLKyg==
X-Received: by 2002:a05:600c:44c:: with SMTP id s12mr9997505wmb.127.1584833400324;
        Sat, 21 Mar 2020 16:30:00 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:156c:1d7d:2d87:4798? (p200300EA8F296000156C1D7D2D874798.dip0.t-ipconnect.de. [2003:ea:8f29:6000:156c:1d7d:2d87:4798])
        by smtp.googlemail.com with ESMTPSA id k133sm15446640wma.11.2020.03.21.16.29.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Mar 2020 16:29:59 -0700 (PDT)
Subject: Re: [PATCH net-next] r8169: add new helper rtl8168g_enable_gphy_10m
To:     Joe Perches <joe@perches.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <743a1fd7-e1b2-d548-1c22-7c1a2e3b268e@gmail.com>
 <8906876a59cfd1db917953fbf49475c9efc67023.camel@perches.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <792711d6-6c35-02b3-2df6-1af02c581ef3@gmail.com>
Date:   Sun, 22 Mar 2020 00:29:51 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <8906876a59cfd1db917953fbf49475c9efc67023.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.03.2020 19:55, Joe Perches wrote:
> On Sat, 2020-03-21 at 19:08 +0100, Heiner Kallweit wrote:
>> Factor out setting GPHY 10M to new helper rtl8168g_enable_gphy_10m.
> []
>> diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
> []
>> @@ -796,6 +796,11 @@ static void rtl8168g_disable_aldps(struct phy_device *phydev)
>>  	phy_modify_paged(phydev, 0x0a43, 0x10, BIT(2), 0);
>>  }
>>  
>> +static void rtl8168g_enable_gphy_10m(struct phy_device *phydev)
>> +{
>> +	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(11));
>> +}
> 
> Perhaps this should be some generic to set characteristics like:
> 
> enum rtl8168g_char {
> 	...
> }
> 
> static void rtl8168g_enable_char(struct phy_device *phydev,
> 				 enum rtl8168g_char type)
> {
> 	switch (type) {
> 	case FOO:
> 		etc...
> 	}
> 
> 

Then we'd need one more such generic to disable characteristics like
in rtl8168g_disable_aldps(). Also we have existing functions like
rtl8168g_phy_adjust_10m_aldps() that change a characteristic, and
the function name is used to describe what the function does.
So yes, it would be an option, but I don't see that we would gain
anything. More the opposite, it would add overhead and we'd have a
mix of fct_what_it_does() and fct_generic(WHAT_IT_DOES).
