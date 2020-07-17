Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E302235F4
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 09:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgGQHeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 03:34:36 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11160 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725995AbgGQHef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 03:34:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06H7VNdC017380;
        Fri, 17 Jul 2020 00:34:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=hiqHHD/FFk3T/pf4CWAMdAodtG1NPrbcvZZsV02Jx4Q=;
 b=kg38CGDkY0O480YJ3Ik6i3mbXS2aWatKAbRj0ZFyf3R26NtahhKDKLlVVBV3YnL3/P9l
 73uNTePbSGfc4i+zbli/F3rbtN/kTYkMF2xIcS5SxfN5gqVyf3At+XzKu++cT/GRfQ6P
 NgPKXE+zXABgM4lO7ltbSAd6qYxraP+MM2/vyYsi8tenvYNwA5Y4CFKdb+mwwNxdKW/S
 PgGC9TMSo8zV7yQ7I0BwyhscruN2JlcJQPtEzcDwhyIH7gmSWWWfG2ypbb11Co+oixHL
 VuoykkFEMgEvgBskgRHAV2UkBVkIkcYC85QxoVefEs4yRTonjTAO9L1yiavQsC5+yB1O JA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmj3ghj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 00:34:30 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Jul
 2020 00:34:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 17 Jul 2020 00:34:28 -0700
Received: from [10.193.54.28] (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id E74F53F703F;
        Fri, 17 Jul 2020 00:34:26 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH net-next 01/10] net: atlantic: media detect
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200713114233.436-1-irusskikh@marvell.com>
 <20200713114233.436-2-irusskikh@marvell.com>
 <20200713142500.GB1078057@lunn.ch>
 <f4870c58-14ff-cb30-c793-f577b02336c1@marvell.com>
 <20200715154657.GT1078057@lunn.ch>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <b462ac8e-51f2-6770-7146-eb12253fa481@marvell.com>
Date:   Fri, 17 Jul 2020 10:34:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200715154657.GT1078057@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_04:2020-07-17,2020-07-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> 
> Hi Igor
> 
> Can you point to some section of the PHY datasheet? I could not find
> anything which fit the vague description you have of this feature in
> your patch. Maybe Heiner or I can implement and verify the PHY driver
> using this feature.

Will try to findout. Not found in customer datasheets yet.

> Since this feature can be implemented directly in the PHY driver, and
> indirectly via the MAC in firmware, it would be good to have a uniform
> interface to do this. So please do add a PHY tunable via MAC driver.

Yep, had the same thought. Will do.

> Does the MAC also have the ability to configure PHY downshift? You
> could implement that tunable as well.

Right, its also possible and this is what I'm thinking on as well.

This will require a minor change in ethtool infrastructure code to allow
MAC driver to handle phy tunable requests.

Regards,
  Igor
