Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D716EFE96
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242741AbjD0Anx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Apr 2023 20:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239903AbjD0Anw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:43:52 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EE93AB3;
        Wed, 26 Apr 2023 17:43:51 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 33R0hIY01023488, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 33R0hIY01023488
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 27 Apr 2023 08:43:18 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 27 Apr 2023 08:43:20 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 27 Apr 2023 08:43:20 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d]) by
 RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d%5]) with mapi id
 15.01.2375.007; Thu, 27 Apr 2023 08:43:20 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Zhang Shurong <zhang_shurong@foxmail.com>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_*
Thread-Topic: [PATCH v3 2/2] wifi: rtw88: fix incorrect error codes in
 rtw_debugfs_set_*
Thread-Index: AQHZeGDstDkyg3+QP0qft6HC8zIpZa8+UavA
Date:   Thu, 27 Apr 2023 00:43:20 +0000
Message-ID: <61160eece9d545b5bfd2569437482fb5@realtek.com>
References: <cover.1682526135.git.zhang_shurong@foxmail.com>
 <tencent_53140CC2A3468101955F02EB66AA96780B05@qq.com>
In-Reply-To: <tencent_53140CC2A3468101955F02EB66AA96780B05@qq.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Zhang Shurong <zhang_shurong@foxmail.com>
> Sent: Thursday, April 27, 2023 1:02 AM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: tony0620emma@gmail.com; kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> Zhang Shurong <zhang_shurong@foxmail.com>
> Subject: [PATCH v3 2/2] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_*
> 
> If there is a failure during copy_from_user or user-provided data
> buffer is invalid, rtw_debugfs_set_* should return negative
> error code instead of a positive value count.
> 
> Fix this bug by returning correct error code.
> 
> Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

[...]

