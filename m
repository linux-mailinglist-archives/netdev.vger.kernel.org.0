Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254F33210CC
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 07:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhBVGUG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Feb 2021 01:20:06 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:55909 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhBVGUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 01:20:05 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 11M6JJr44021384, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs02.realtek.com.tw[172.21.6.95])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 11M6JJr44021384
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 22 Feb 2021 14:19:19 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 22 Feb 2021 14:19:18 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::a98b:ac3a:714:c542]) by
 RTEXMBS04.realtek.com.tw ([fe80::a98b:ac3a:714:c542%6]) with mapi id
 15.01.2106.006; Mon, 22 Feb 2021 14:19:18 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net] r8152: move r8153_mac_clk_spd
Thread-Topic: [PATCH net] r8152: move r8153_mac_clk_spd
Thread-Index: AQHXBqMAJ3OTyCv8zUmnDZYto1N0JKpfRQOAgARwDfA=
Date:   Mon, 22 Feb 2021 06:19:18 +0000
Message-ID: <200646aefe2b461cbfe10b2eec96d118@realtek.com>
References: <1394712342-15778-346-Taiwan-albertk@realtek.com>
 <20210219102237.024917a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210219102237.024917a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, February 20, 2021 2:23 AM
[...] 
> Any word on what user-visible misbehavior this causes?
I think it influences the power saving for suspending.
I am checking it with our engineers.

> Can you provide a Fixes tag?
Yes. I will add it when I updating this patch.

Best Regards,
Hayes

