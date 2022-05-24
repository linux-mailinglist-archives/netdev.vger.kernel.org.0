Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8783C531FEE
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 02:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiEXAll convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 23 May 2022 20:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiEXAlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 20:41:39 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D813EA88;
        Mon, 23 May 2022 17:41:37 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 24O0fDkxD006008, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 24O0fDkxD006008
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 24 May 2022 08:41:13 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 24 May 2022 08:41:13 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 24 May 2022 08:41:13 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Tue, 24 May 2022 08:41:13 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "colin.king@intel.com" <colin.king@intel.com>
Subject: RE: [PATCH net-next 3/8] wifi: rtlwifi: remove always-true condition pointed out by GCC 12
Thread-Topic: [PATCH net-next 3/8] wifi: rtlwifi: remove always-true condition
 pointed out by GCC 12
Thread-Index: AQHYbIHjnrV5IT1AtUasPUOuHqV18a0rwWxwgABa7oCAARgbsA==
Date:   Tue, 24 May 2022 00:41:12 +0000
Message-ID: <d9690c0a1e444dcdbab8a9c1eb0f98df@realtek.com>
References: <20220520194320.2356236-1-kuba@kernel.org>
        <20220520194320.2356236-4-kuba@kernel.org>
        <8fb9d491692a4a2dabe783ffefc76ded@realtek.com>
 <20220523085701.3d7550ff@kernel.org>
In-Reply-To: <20220523085701.3d7550ff@kernel.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/5/23_=3F=3F_10:00:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, May 23, 2022 11:57 PM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: kvalo@kernel.org; johannes@sipsolutions.net; netdev@vger.kernel.org; linux-wireless@vger.kernel.org;
> keescook@chromium.org; colin.king@intel.com
> Subject: Re: [PATCH net-next 3/8] wifi: rtlwifi: remove always-true condition pointed out by GCC 12
> 
> On Mon, 23 May 2022 02:35:32 +0000 Ping-Ke Shih wrote:
> > This is a typo since initial commit. Correct it by
> > -			     value[0] != NULL)
> > +			     value[0][0] != 0)
> >
> > So, NACK this patch.
> 
> Too, late, the patches were already applied, sorry. Please post a fixup.

I have sent a patch to correct it: 
https://lore.kernel.org/linux-wireless/20220524003750.3989-1-pkshih@realtek.com/T/#u

Please take it into net-next tree.

Thank you
Ping-Ke

