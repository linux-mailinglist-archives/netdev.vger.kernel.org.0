Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B95B1BD67F
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 04:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633833AbfIYCvQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Sep 2019 22:51:16 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:59673 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411415AbfIYCvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 22:51:16 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x8P2p9NU013907, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x8P2p9NU013907
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Sep 2019 10:51:09 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Wed, 25 Sep
 2019 10:51:08 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Prashant Malani <pmalani@chromium.org>
CC:     "grundler@chromium.org" <grundler@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH v2] r8152: Use guard clause and fix comment typos
Thread-Topic: [PATCH v2] r8152: Use guard clause and fix comment typos
Thread-Index: AQHVco2030kwyeY/tkuYMVeTq1aLQKc7rAuA
Date:   Wed, 25 Sep 2019 02:51:06 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18E3B89@RTITMBSVM03.realtek.com.tw>
References: <20190924040052.71713-1-pmalani@chromium.org>
In-Reply-To: <20190924040052.71713-1-pmalani@chromium.org>
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
> Sent: Tuesday, September 24, 2019 12:01 PM
> To: Hayes Wang
> Cc: grundler@chromium.org; netdev@vger.kernel.org; nic_swsd; Prashant
> Malani
> Subject: [PATCH v2] r8152: Use guard clause and fix comment typos
> 
> Use a guard clause in tx_bottom() to reduce the indentation of the
> do-while loop.
> 
> Also, fix a couple of spelling and grammatical mistakes in the
> r8152_csum_workaround() function comment.
> 
> Change-Id: I460befde150ad92248fd85b0f189ec2df2ab8431
> Signed-off-by: Prashant Malani <pmalani@chromium.org>
> Reviewed-by: Grant Grundler <grundler@chromium.org>

Acked-by: Hayes Wang <hayeswang@realtek.com>

Best Regards,
Hayes


