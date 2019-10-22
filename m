Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 302FFDFD39
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 07:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387523AbfJVF4e convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Oct 2019 01:56:34 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:49469 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfJVF4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 01:56:34 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9M5uScL025584, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9M5uScL025584
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Oct 2019 13:56:28 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0468.000; Tue, 22 Oct 2019 13:56:27 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pmalani@chromium.org" <pmalani@chromium.org>,
        "grundler@chromium.org" <grundler@chromium.org>
Subject: RE: [PATCH net-next 4/4] r8152: support firmware of PHY NC for RTL8153A
Thread-Topic: [PATCH net-next 4/4] r8152: support firmware of PHY NC for
 RTL8153A
Thread-Index: AQHVh8FvTRaFw2OX3UCuAY94UXOizqdlfiOAgACsfLA=
Date:   Tue, 22 Oct 2019 05:56:25 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18EC964@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-330-Taiwan-albertk@realtek.com>
        <1394712342-15778-334-Taiwan-albertk@realtek.com>
 <20191021203625.448da742@cakuba.netronome.com>
In-Reply-To: <20191021203625.448da742@cakuba.netronome.com>
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

Jakub Kicinski [mailto:jakub.kicinski@netronome.com]
> Sent: Tuesday, October 22, 2019 11:36 AM
> To: Hayes Wang
> Cc: netdev@vger.kernel.org; nic_swsd; linux-kernel@vger.kernel.org;
> pmalani@chromium.org; grundler@chromium.org
> Subject: Re: [PATCH net-next 4/4] r8152: support firmware of PHY NC for
> RTL8153A
> 
> On Mon, 21 Oct 2019 11:41:13 +0800, Hayes Wang wrote:
> > Support the firmware of PHY NC which is used to fix the issue found
> > for PHY. Currently, only RTL_VER_04, RTL_VER_05, and RTL_VER_06 need
> > it.
> >
> > The order of loading PHY firmware would be
> >
> > 	RTL_FW_PHY_START
> > 	RTL_FW_PHY_NC
> 
> Perhaps that's obvious to others, but what's NC? :)

The PHY has several micro controllers which deal with different features.
The NC is our internal name helping us to know which one is specified.

Best Regards,
Hayes


