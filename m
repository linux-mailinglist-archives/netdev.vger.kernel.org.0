Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1891FFED2
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 01:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgFRXmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 19:42:35 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:42272 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgFRXmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 19:42:35 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05INgOWb106387;
        Thu, 18 Jun 2020 18:42:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592523744;
        bh=WqB3gWaQP6mPg47uckt0LvQ0Gj/lq4E6tx3hHJW7j0A=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=uP9Q5txuOubqoYf960FLd5xNqb1sxbiRiPdWXeAxd9o0XxQivdZ9Fr+GwJqcaTO4F
         UpBGypviIGXTgScxQMCB1gif+pobTVC5Etn7IwF63jmvQuST3CoFxQcXSvH4tBjRNx
         YTn4H/Ps1Gwi3yRFiVUZVmMMnp7AnReBXktXirEM=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05INgOeI113983
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 18:42:24 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 18
 Jun 2020 18:42:24 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 18 Jun 2020 18:42:24 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05INgNkh067455;
        Thu, 18 Jun 2020 18:42:23 -0500
Subject: Re: [PATCH net-next v8 2/5] net: phy: Add a helper to return the
 index for of the internal delay
To:     kernel test robot <lkp@intel.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <kbuild-all@lists.01.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200618211011.28837-3-dmurphy@ti.com>
 <202006190753.uZWR7VTH%lkp@intel.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <83735f8a-efe6-5648-4925-d4a945e0c070@ti.com>
Date:   Thu, 18 Jun 2020 18:42:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <202006190753.uZWR7VTH%lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

On 6/18/20 6:29 PM, kernel test robot wrote:
> Hi Dan,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Dan-Murphy/RGMII-Internal-delay-common-property/20200619-051238
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git cb8e59cc87201af93dfbb6c3dccc8fcad72a09c2
> config: i386-defconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-13) 9.3.0
> reproduce (this is a W=1 build):
>          # save the attached .config to linux build tree
>          make W=1 ARCH=i386
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>     drivers/net/phy/phy_device.c: In function 'phy_get_int_delay_property':
>>> drivers/net/phy/phy_device.c:2678:1: error: expected ';' before '}' token
>      2678 | }
>           | ^
>
> vim +2678 drivers/net/phy/phy_device.c
>
>    2660	
>    2661	#if IS_ENABLED(CONFIG_OF_MDIO)
>    2662	static int phy_get_int_delay_property(struct device *dev, const char *name)
>    2663	{
>    2664		s32 int_delay;
>    2665		int ret;
>    2666	
>    2667		ret = device_property_read_u32(dev, name, &int_delay);
>    2668		if (ret)
>    2669			return ret;
>    2670	
>    2671		return int_delay;
>    2672	}
>    2673	#else
>    2674	static inline int phy_get_int_delay_property(struct device *dev,
>    2675						     const char *name)
>    2676	{
>    2677		return -EINVAL

Ack missed compiling this use case.

Dan

>> 2678	}
>    2679	#endif
>    2680	
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
