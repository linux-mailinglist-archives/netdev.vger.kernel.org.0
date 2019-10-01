Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1431FC3367
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 13:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfJALzL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Oct 2019 07:55:11 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:37735 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfJALzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 07:55:10 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x91Bt7nh004267, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x91Bt7nh004267
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 1 Oct 2019 19:55:07 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0468.000; Tue, 1 Oct 2019 19:55:06 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Prashant Malani <pmalani@chromium.org>
CC:     "grundler@chromium.org" <grundler@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net-next] r8152: Factor out OOB link list waits
Thread-Topic: [PATCH net-next] r8152: Factor out OOB link list waits
Thread-Index: AQHVeDNfmaxBtpNUCEmUKe17zwc5HKdFrTkw
Date:   Tue, 1 Oct 2019 11:55:05 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18E5B1B@RTITMBSVM03.realtek.com.tw>
References: <20191001083556.195271-1-pmalani@chromium.org>
In-Reply-To: <20191001083556.195271-1-pmalani@chromium.org>
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
> Sent: Tuesday, October 01, 2019 4:36 PM
> To: Hayes Wang
> Cc: grundler@chromium.org; netdev@vger.kernel.org; nic_swsd; Prashant
> Malani
> Subject: [PATCH net-next] r8152: Factor out OOB link list waits
> 
> The same for-loop check for the LINK_LIST_READY bit of an OOB_CTRL
> register is used in several places. Factor these out into a single
> function to reduce the lines of code.
> 
> Change-Id: I20e8f327045a72acc0a83e2d145ae2993ab62915
> Signed-off-by: Prashant Malani <pmalani@chromium.org>
> Reviewed-by: Grant Grundler <grundler@chromium.org>

Acked-by: Hayes Wang <hayeswang@realtek.com>

Best Regards,
Hayes

