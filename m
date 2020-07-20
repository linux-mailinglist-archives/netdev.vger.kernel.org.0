Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133F022613B
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgGTNoz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Jul 2020 09:44:55 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2982 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbgGTNox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 09:44:53 -0400
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 306AE677F5782966166C;
        Mon, 20 Jul 2020 21:44:50 +0800 (CST)
Received: from DGGEMM508-MBX.china.huawei.com ([169.254.2.193]) by
 DGGEMM402-HUB.china.huawei.com ([10.3.20.210]) with mapi id 14.03.0487.000;
 Mon, 20 Jul 2020 21:44:49 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     David Miller <davem@davemloft.net>
CC:     "madalin.bucur@nxp.com" <madalin.bucur@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "laurentiu.tudor@nxp.com" <laurentiu.tudor@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] dpaa_eth: Fix one possible memleak in
 dpaa_eth_probe
Thread-Topic: [PATCH net-next] dpaa_eth: Fix one possible memleak in
 dpaa_eth_probe
Thread-Index: AQHWXKSdSDTU41SMykmEwImi5YWnKKkQfkrQ
Date:   Mon, 20 Jul 2020 13:44:49 +0000
Message-ID: <4F88C5DDA1E80143B232E89585ACE27D129A86F0@dggemm508-mbx.china.huawei.com>
References: <20200717090528.19683-1-liujian56@huawei.com>
 <20200717.184145.1710848863414831357.davem@davemloft.net>
In-Reply-To: <20200717.184145.1710848863414831357.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.177.124]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Saturday, July 18, 2020 9:42 AM
> To: liujian (CE) <liujian56@huawei.com>
> Cc: madalin.bucur@nxp.com; kuba@kernel.org; laurentiu.tudor@nxp.com;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next] dpaa_eth: Fix one possible memleak in
> dpaa_eth_probe
> 
> From: Liu Jian <liujian56@huawei.com>
> Date: Fri, 17 Jul 2020 17:05:28 +0800
> 
> > When dma_coerce_mask_and_coherent() fails, the alloced netdev need
> to be freed.
> >
> > Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")
> > Signed-off-by: Liu Jian <liujian56@huawei.com>
> 
> This is a bug fix introduced in v5.5, therefore it should be targetting 'net'
> instead of 'net-next'.

Thank you David, I will send v2.
