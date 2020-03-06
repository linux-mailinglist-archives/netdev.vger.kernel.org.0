Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6989217B45C
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 03:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgCFCUC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 5 Mar 2020 21:20:02 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:35793 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgCFCUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 21:20:02 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 0262Joaw024576, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTEXMB06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 0262Joaw024576
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 6 Mar 2020 10:19:50 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 6 Mar 2020 10:19:50 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999]) by
 RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999%6]) with mapi id
 15.01.1779.005; Fri, 6 Mar 2020 10:19:50 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 4/7] r8152: reject unsupported coalescing params
Thread-Topic: [PATCH net-next 4/7] r8152: reject unsupported coalescing params
Thread-Index: AQHV81OGKoKGuBe19UiZmoGvvFI9rag608lQ
Date:   Fri, 6 Mar 2020 02:19:50 +0000
Message-ID: <1056f557dea84ef08aa7a0ac2fd21fef@realtek.com>
References: <20200306010602.1620354-1-kuba@kernel.org>
 <20200306010602.1620354-5-kuba@kernel.org>
In-Reply-To: <20200306010602.1620354-5-kuba@kernel.org>
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

Jakub Kicinski [mailto:kuba@kernel.org]
> Sent: Friday, March 06, 2020 9:06 AM
[...]
> Subject: [PATCH net-next 4/7] r8152: reject unsupported coalescing params
> 
> Set ethtool_ops->supported_coalesce_params to let
> the core reject unsupported coalescing parameters.
> 
> This driver did not previously reject unsupported parameters.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Acked-by: Hayes Wang <hayeswang@realtek.com>

Best Regards,
Hayes

