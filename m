Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629EE1BAEAC
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgD0UEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:04:33 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13602 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725919AbgD0UEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:04:33 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RK0S1L014824;
        Mon, 27 Apr 2020 13:04:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=LmQ4RLA3W5bXDqoCJ0wnK9l2lFcer2ycC6bzWlXZwSc=;
 b=aLIiGQKQzUHaVpWsJQFyryMwM1dUFLrsxcdY6zUxQtK5yO4ua3wucQYzd8Jx9kyHkerY
 bvSFkdxD8HrxR+8XjvHGnEPbuROU2KS8jk6M0LrZ364+yw3VcnIWAANns3CLSgMXdYu+
 71uiJBMj1C46Ybh40agXWYyNCroDu9Miitxo5RcyTkNRi+Mnw7NDslz+O+Lgqb7ilVco
 KNVWAqPntP643aucBHQ/3P8tCNMt0ly3EAB5qq8uV0dVr9/Y74NZg+hoqluuqESRisCV
 Ot8JSMOOvhqGbfdXTlIlxLAxtuz85etM4All+AiIVYsiPTsdBhCSSKfxzSoscNpoOzQX 4A== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 30mjjq92e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 13:04:30 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Apr
 2020 13:04:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 27 Apr 2020 13:04:28 -0700
Received: from [10.193.46.2] (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 9BD233F703F;
        Mon, 27 Apr 2020 13:04:26 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH net-next 08/17] net: atlantic: A2
 driver-firmware interface
To:     Jakub Kicinski <kuba@kernel.org>
CC:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
References: <20200424174447.0c9a3291@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200424.182532.868703272847758939.davem@davemloft.net>
 <d02ab18b-11b4-163c-f376-79161f232f3e@marvell.com>
 <20200426.180505.1265322367122125261.davem@davemloft.net>
 <e34bcab1-303e-a4bd-862c-125f254e93d3@marvell.com>
 <20200427120301.693525a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <be1461d3-f87e-0bfa-0b37-6eef4a2519e6@marvell.com>
Date:   Mon, 27 Apr 2020 23:04:24 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101
 Thunderbird/76.0
MIME-Version: 1.0
In-Reply-To: <20200427120301.693525a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>> Please remove __packed unless you can prove it matters.  
>>
>> Just double checked the layout without packed pragma, below is what
> pahole
>> diff gives just on one structure.
> 
> Okay, then mark the appropriate fields of that structure as packed.
> I looked at first 4 structures and they should require no packing.

Hi Jakub.

This means I have to dig each and every structure in this header and
understand whether it may suffer from implicit alignment/holes or not.

Not mentioning the fact that these alignment rules are different on other
compilers, or on say 32-bit archs.

I also see a lot of code through the kernel using pack(1) for the exact same
reason - declare hw sensitive structures and eliminate any unexpected holes.

Regards,
  Igor
