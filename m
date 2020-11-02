Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A332A2A5D
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 13:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgKBMGb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 Nov 2020 07:06:31 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:52808 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbgKBMGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 07:06:30 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0A2C6Gi14022908, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb01.realtek.com.tw[172.21.6.94])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0A2C6Gi14022908
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 2 Nov 2020 20:06:16 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Mon, 2 Nov 2020 20:06:16 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Mon, 2 Nov 2020 20:06:16 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Lee Jones <lee.jones@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Jakub Kicinski <kuba@kernel.org>, nic_swsd <nic_swsd@realtek.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 27/30] net: usb: r8152: Fix a couple of spelling errors in fw_phy_nc's docs
Thread-Topic: [PATCH 27/30] net: usb: r8152: Fix a couple of spelling errors
 in fw_phy_nc's docs
Thread-Index: AQHWsQ26i+Ha1HJ410uPy134btT0Dam0ve5A
Date:   Mon, 2 Nov 2020 12:06:15 +0000
Message-ID: <dd3786ee76dc4c1c897f68fa2bc24f0a@realtek.com>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
 <20201102114512.1062724-28-lee.jones@linaro.org>
In-Reply-To: <20201102114512.1062724-28-lee.jones@linaro.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.146]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org>
> Sent: Monday, November 2, 2020 7:45 PM
[...]
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/usb/r8152.c:992: warning: Function parameter or member
> 'mode_pre' not described in 'fw_phy_nc'
>  drivers/net/usb/r8152.c:992: warning: Function parameter or member
> 'mode_post' not described in 'fw_phy_nc'
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Hayes Wang <hayeswang@realtek.com>
> Cc: nic maintainers <nic_swsd@realtek.com>
> Cc: linux-usb@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Hayes Wang <hayeswang@realtek.com>
