Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0845D9F81E
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 04:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfH1CE3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Aug 2019 22:04:29 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:33371 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfH1CE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 22:04:28 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7S24L8N029188, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7S24L8N029188
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Aug 2019 10:04:21 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0468.000; Wed, 28 Aug 2019 10:04:20 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Prashant Malani <pmalani@chromium.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "grundler@chromium.org" <grundler@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH] r8152: Add rx_buf_sz field to struct r8152
Thread-Topic: [PATCH] r8152: Add rx_buf_sz field to struct r8152
Thread-Index: AQHVXQGFHGIN0Ioi6USY1WqcmS7SJKcPz1Pw
Date:   Wed, 28 Aug 2019 02:04:20 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18D8C55@RTITMBSVM03.realtek.com.tw>
References: <20190827180146.253431-1-pmalani@chromium.org>
In-Reply-To: <20190827180146.253431-1-pmalani@chromium.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prashant Malani [mailto:pmalani@chromium.org]
> Sent: Wednesday, August 28, 2019 2:02 AM
> To: Hayes Wang; davem@davemloft.net
> Cc: grundler@chromium.org; netdev@vger.kernel.org; nic_swsd; Prashant
> Malani
> Subject: [PATCH] r8152: Add rx_buf_sz field to struct r8152
> 
> tp->rx_buf_sz is set according to the specific version of HW being used.
> 
> agg_buf_sz was originally added to support LSO (Large Send Offload) and
> then seems to have been co-opted for LRO (Large Receive Offload). But RX
> large buffer size can be larger than TX large buffer size with newer HW.
> Using larger buffers can result in fewer "large RX packets" processed
> by the rest of the networking stack to reduce RX CPU utilization.
> 
> This patch is copied from the r8152 driver (v2.12.0) published by
> Realtek (www.realtek.com).
> 
> Signed-off-by: Prashant Malani <pmalani@chromium.org>
> Reviewed-by: Grant Grundler <grundler@chromium.org>
> ---

It seems as same as the commit ec5791c202ac ("r8152: separate the rx
buffer size").

https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/
commit/?id=ec5791c202aca90c1b3b99dff268a995cf2d6aa1

Best Regards,
Hayes

