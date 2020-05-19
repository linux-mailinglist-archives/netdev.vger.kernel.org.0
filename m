Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEDA1D9E0F
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 19:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgESRks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 13:40:48 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:46226 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgESRks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 13:40:48 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04JHebBk040254;
        Tue, 19 May 2020 12:40:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589910037;
        bh=TFz3N331lFjPUnBQVApIswhjuR7jDttHzDddCiijuRA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=e29EOXRLkWr3i0S/c8DzqUs8y6brl+DgipZMtzMBN0KpGn6DbhLBODSfniXdJpgGz
         fMAhnQfBTDd3213iwnWGnDIeDHNF2m/SmJWU4SrylCEHd/baJq68Q/eT6l/X4kvR1y
         hHqtD/oOkGxSxqe7Pt9uq6FiYn13jljO9SrK6MX4=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04JHebm5052020;
        Tue, 19 May 2020 12:40:37 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 19
 May 2020 12:40:37 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 19 May 2020 12:40:37 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04JHebNp036178;
        Tue, 19 May 2020 12:40:37 -0500
Subject: Re: [PATCH net-next 2/4] net: phy: dp83869: Set opmode from straps
To:     kbuild test robot <lkp@intel.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <kbuild-all@lists.01.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200519141813.28167-3-dmurphy@ti.com>
 <202005200117.iOd1QuA3%lkp@intel.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <ac286fd2-b77f-9103-d9f2-aa95ad792476@ti.com>
Date:   Tue, 19 May 2020 12:40:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <202005200117.iOd1QuA3%lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kbuild

On 5/19/20 12:19 PM, kbuild test robot wrote:
> Hi Dan,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on net-next/master]
> [also build test WARNING on robh/for-next sparc-next/master net/master linus/master v5.7-rc6 next-20200518]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
>
> url:    https://github.com/0day-ci/linux/commits/Dan-Murphy/DP83869-Enhancements/20200519-222047
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5cdfe8306631b2224e3f81fc5a1e2721c7a1948b
> config: sh-allmodconfig (attached as .config)
> compiler: sh4-linux-gcc (GCC) 9.3.0
> reproduce:
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=sh
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>, old ones prefixed by <<):
>
> drivers/net/phy/dp83869.c: In function 'dp83869_set_strapped_mode':
>>> drivers/net/phy/dp83869.c:171:10: warning: comparison is always false due to limited range of data type [-Wtype-limits]
> 171 |  if (val < 0)

This looks to be a false positive.

phy_read_mmd will return an errno or a value from 0->15

So if errno is returned then this will be true.

Unless I have to do IS_ERR.

Dan

