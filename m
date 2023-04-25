Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9165A6EDAED
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 06:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbjDYEmp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Apr 2023 00:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjDYEmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 00:42:43 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2BE3AAA;
        Mon, 24 Apr 2023 21:42:42 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 33P4gUxZ5000552, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 33P4gUxZ5000552
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Tue, 25 Apr 2023 12:42:30 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Tue, 25 Apr 2023 12:42:32 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 25 Apr 2023 12:42:31 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d]) by
 RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d%5]) with mapi id
 15.01.2375.007; Tue, 25 Apr 2023 12:42:31 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Gregg Wonderly <greggwonderly@seqtechllc.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: pull-request: wireless-next-2023-04-21
Thread-Topic: pull-request: wireless-next-2023-04-21
Thread-Index: AQHZdD60u8zT35eBqkOmWCVcBjPBJa81U6EAgAX6SUD//5x0gIAAjSlw
Date:   Tue, 25 Apr 2023 04:42:31 +0000
Message-ID: <038b1ab2cf7043908ee7dd399627fd7c@realtek.com>
References: <20230421104726.800BCC433D2@smtp.kernel.org>
 <20230421075404.63c04bca@kernel.org>
 <e31dae6daa6640859d12bf4c4fc41599@realtek.com>
 <92FFD14B-6BE0-4AC1-9281-A37508817A3B@seqtechllc.com>
In-Reply-To: <92FFD14B-6BE0-4AC1-9281-A37508817A3B@seqtechllc.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gregg,

(no top posting for wireless mailing list, so I move your post to bottom)

> -----Original Message-----
> From: Gregg Wonderly <greggwonderly@seqtechllc.com>
> Sent: Tuesday, April 25, 2023 12:15 PM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; Kalle Valo <kvalo@kernel.org>; netdev@vger.kernel.org;
> linux-wireless@vger.kernel.org
> Subject: Re: pull-request: wireless-next-2023-04-21
> 
> > On Apr 24, 2023, at 9:41 PM, Ping-Ke Shih <pkshih@realtek.com> wrote:
> >
> >
> >
> >> -----Original Message-----
> >> From: Jakub Kicinski <kuba@kernel.org>
> >> Sent: Friday, April 21, 2023 10:54 PM
> >> To: Kalle Valo <kvalo@kernel.org>
> >> Cc: netdev@vger.kernel.org; linux-wireless@vger.kernel.org
> >> Subject: Re: pull-request: wireless-next-2023-04-21
> >>
> >> On Fri, 21 Apr 2023 10:47:26 +0000 (UTC) Kalle Valo wrote:
> >>> .../net/wireless/realtek/rtw89/rtw8851b_table.c    | 14824 +++++++++++++++++++
> >>> .../net/wireless/realtek/rtw89/rtw8851b_table.h    |    21 +
> >>
> >> We should load these like FW, see the proposal outlined in
> >> https://lore.kernel.org/all/20221116222339.54052a83@kernel.org/
> >> for example. Would that not work?
> >>
> >
> > That would work, and I think struct fields addr and val should be __le32.
> > And, I have some draft ideas to handle some situations we will face:
> >
> > 1. upgrading to newer driver without built-in tables will break user space
> >   if people don't download table file from linux-firmware.git.
> >   Maybe, we can keep the built-in tables and support loading from files
> >   for couple years at least.
> >
> > 2. c code can do changes along with these tables, so driver should do some
> >   compatibility things for register version.
> >
> > 3. The file contains not only simple registers tables but also TX power tables
> >   and power tracking tables. These tables are multiple dimensions, and
> >   dimensions can be changed due to more channels are supported, for example.
> >   To be backward compatible, we need to add conversion function from
> >   v1, v2 ... to current.
> >
> > I will think further to make this change smooth.
> >
> 
> Could this be expressed in a /proc structure of files and directories?
> 

I'm not clear what you meant. Could you please give me an example for reference?

Ping-Ke


