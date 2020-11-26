Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80202C4C74
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 02:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgKZBPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 20:15:04 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2444 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729131AbgKZBPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 20:15:04 -0500
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ChKYD6vgTz4yNM;
        Thu, 26 Nov 2020 09:14:40 +0800 (CST)
Received: from [127.0.0.1] (10.57.36.170) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1913.5; Thu, 26
 Nov 2020 09:15:01 +0800
Subject: Re: [PATCH v3 net-next] net: phy: realtek: read actual speed on
 rtl8211f to detect downshift
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Antonio Borneo <antonio.borneo@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Willy Liu <willy.liu@realtek.com>,
        <linux-kernel@vger.kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>, <linuxarm@huawei.com>,
        <linux-stm32@st-md-mailman.stormreply.com>
References: <20201124143848.874894-1-antonio.borneo@st.com>
 <20201124230756.887925-1-antonio.borneo@st.com>
 <d62710c3-7813-7506-f209-fcfa65931778@huawei.com>
 <f24476cc-39f0-ea5f-d6af-faad481e3235@huawei.com>
 <20201125170714.GK1551@shell.armlinux.org.uk>
From:   Yonglong Liu <liuyonglong@huawei.com>
Message-ID: <3fdb1d11-d59e-9d3d-a5a8-8f20e4ca7f0a@huawei.com>
Date:   Thu, 26 Nov 2020 09:15:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20201125170714.GK1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.57.36.170]
X-ClientProxiedBy: dggeme715-chm.china.huawei.com (10.1.199.111) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Russell:

     I found this message in kernel log, thanks!

On 2020/11/26 1:07, Russell King - ARM Linux admin wrote:
> On Thu, Nov 26, 2020 at 12:57:37AM +0800, Yonglong Liu wrote:
>> Hi, Antonio:
>>
>>      Could you help to provide a downshift warning message when this happen?
>>
>>      It's a little strange that the adv and the lpa support 1000M, but
>> finally the link speed is 100M.
> That is an identifying feature of downshift.
>
> Downshift can happen at either end of the link, and since we must not
> change the "Advertised link modes" since this is what userspace
> configured, if a downshift occurs at the local end, then you will get
> the ethtool output you provide, where the speed does not agree with
> the reported advertisements.
>
> You should already be getting a warning in the kernel log when this
> happens; phy_check_downshift() which is part of the phylib core code
> will check this every time the link comes up. You should already
> have a message "Downshift occurred ..." in your kernel log. Please
> check.
>

