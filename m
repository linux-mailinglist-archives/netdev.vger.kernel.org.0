Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC802A8D4F
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 04:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgKFDBh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 5 Nov 2020 22:01:37 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:58131 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgKFDBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 22:01:36 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0A631M8q8019815, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb03.realtek.com.tw[172.21.6.96])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0A631M8q8019815
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 6 Nov 2020 11:01:23 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Fri, 6 Nov 2020 11:01:22 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Fri, 6 Nov 2020 11:01:22 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Thread-Topic: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Thread-Index: AQHWshawQtN/T3fh9kiJgjvtG4xSCKm2a3wAgACIZwCAAC/9AIAAG2OAgAAC9ICAAAcNgIAAAsSAgAARvwCAAWswAIAAEW8AgAGRtDA=
Date:   Fri, 6 Nov 2020 03:01:22 +0000
Message-ID: <21f6ca0a96d640558633d6296b81271a@realtek.com>
References: <20201103192226.2455-4-kabel@kernel.org>
 <20201103214712.dzwpkj6d5val6536@skbuf> <20201104065524.36a85743@kernel.org>
 <20201104084710.wr3eq4orjspwqvss@skbuf> <20201104112511.78643f6e@kernel.org>
 <20201104113545.0428f3fe@kernel.org> <20201104110059.whkku3zlck6spnzj@skbuf>
 <20201104121053.44fae8c7@kernel.org> <20201104121424.th4v6b3ucjhro5d3@skbuf>
 <20201105105418.555d6e54@kernel.org> <20201105105642.pgdxxlytpindj5fq@skbuf>
In-Reply-To: <20201105105642.pgdxxlytpindj5fq@skbuf>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.146]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com>
> Sent: Thursday, November 5, 2020 6:57 PM
> On Thu, Nov 05, 2020 at 10:54:18AM +0100, Marek Behún wrote:
> > I thought that static inline functions are preferred to macros, since
> > compiler warns better if they are used incorrectly...
> 
> Citation needed. Also, how do static inline functions wrapped in macros
> (i.e. your patch) stack up against your claim about better warnings?
> I guess ease of maintainership should prevail here, and Hayes should
> have the final word. I don't really have any stake here.

I agree with Vladimir Oltean.

I prefer to the way of easy maintaining.
I don't understand the advantage which you discuss.
However, if I am not familiar with the code, this patch
would let me take more time to find out the declarations
of these functions. This make it harder to trace the code.

Best Regards,
Hayes

