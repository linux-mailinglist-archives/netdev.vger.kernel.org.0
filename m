Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F851DA021
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgESS72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:59:28 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:53522 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgESS72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 14:59:28 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04JIxMI4057912;
        Tue, 19 May 2020 13:59:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589914762;
        bh=rwh2Gt4nspEOd6+g3pYcOtsRvF3IZkaE/t4GtEJf3FQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=X7kZZGEm/RJjJ3rU1QkdE411IjXMFSO7PcjOriXyTCwdIlBTPGFbEv5gIdshzvoY/
         FcKM+L5hhDGaOc406bfPtb9VA+Yv8vcd/H2cE8qGsh2dKqpOsRvRJ1EM69tgYYq15M
         CCvR1H4wcKJHkW112X+UQJS+XvZCVl5FI1kIEowY=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04JIxM8m038237
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 13:59:22 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 19
 May 2020 13:59:21 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 19 May 2020 13:59:21 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04JIxLbs037318;
        Tue, 19 May 2020 13:59:21 -0500
Subject: Re: [PATCH net-next 2/4] net: phy: dp83869: Set opmode from straps
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
References: <20200519141813.28167-1-dmurphy@ti.com>
 <20200519141813.28167-3-dmurphy@ti.com>
 <20200519095818.425d227b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200519182916.GM624248@lunn.ch>
 <c45bae32-d26f-cbe5-626b-2afae4a557b3@ti.com>
 <20200519114843.34e65bcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <5d6d799f-f7b6-566a-5038-5901590f2e7b@ti.com>
Date:   Tue, 19 May 2020 13:59:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200519114843.34e65bcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub

On 5/19/20 1:48 PM, Jakub Kicinski wrote:
> On Tue, 19 May 2020 13:41:40 -0500 Dan Murphy wrote:
>>> Is this now a standard GCC warning? Or have you turned on extra
>>> checking?
>> I still was not able to reproduce this warning with gcc-9.2.  I would
>> like to know the same
> W=1 + gcc-10 here, also curious to know which one of the two makes
> the difference :)

W=1 made the difference I got the warning with gcc-9.2

Dan

