Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32139C737
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 04:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfHZC0J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 25 Aug 2019 22:26:09 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:38113 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbfHZC0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 22:26:08 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7Q2Q1IX024262, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7Q2Q1IX024262
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 26 Aug 2019 10:26:01 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Mon, 26 Aug
 2019 10:26:00 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Prashant Malani <pmalani@chromium.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "grundler@chromium.org" <grundler@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH] r8152: Set memory to all 0xFFs on failed reg reads
Thread-Topic: [PATCH] r8152: Set memory to all 0xFFs on failed reg reads
Thread-Index: AQHVWlcLPpwg5hBXK0C2BUy2CpMhq6cMtNeQ
Date:   Mon, 26 Aug 2019 02:25:59 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18D6324@RTITMBSVM03.realtek.com.tw>
References: <20190824083619.69139-1-pmalani@chromium.org>
In-Reply-To: <20190824083619.69139-1-pmalani@chromium.org>
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
> Sent: Saturday, August 24, 2019 4:36 PM
[...]
> get_registers() blindly copies the memory written to by the
> usb_control_msg() call even if the underlying urb failed.
> 
> This could lead to junk register values being read by the driver, since
> some indirect callers of get_registers() ignore the return values. One
> example is:
>   ocp_read_dword() ignores the return value of generic_ocp_read(), which
>   calls get_registers().
> 
> So, emulate PCI "Master Abort" behavior by setting the buffer to all
> 0xFFs when usb_control_msg() fails.
> 
> This patch is copied from the r8152 driver (v2.12.0) published by
> Realtek (www.realtek.com).
> 
> Signed-off-by: Prashant Malani <pmalani@chromium.org>
> ---

Acked-by: Hayes Wang <hayeswang@realtek.com>

Best Regards,
Hayes

