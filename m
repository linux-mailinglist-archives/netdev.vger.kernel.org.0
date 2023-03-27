Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5386C98FA
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 02:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjC0A2W convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 26 Mar 2023 20:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjC0A2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 20:28:21 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E35527C;
        Sun, 26 Mar 2023 17:28:18 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32R0RXBc8021896, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32R0RXBc8021896
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 27 Mar 2023 08:27:33 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Mon, 27 Mar 2023 08:27:49 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 27 Mar 2023 08:27:49 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Mon, 27 Mar 2023 08:27:49 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Wei Chen <harperchen1110@gmail.com>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] rtlwifi: fix incorrect error codes in rtl_debugfs_set_write_rfreg()
Thread-Topic: [PATCH v2] rtlwifi: fix incorrect error codes in
 rtl_debugfs_set_write_rfreg()
Thread-Index: AQHZX6RFnQxa2kACIk+SZ2DblukJZK8Nxj1Q
Date:   Mon, 27 Mar 2023 00:27:49 +0000
Message-ID: <293ecc07e4f0427f8ebcb44028a7570d@realtek.com>
References: <20230326053138.91338-1-harperchen1110@gmail.com>
In-Reply-To: <20230326053138.91338-1-harperchen1110@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Wei Chen <harperchen1110@gmail.com>
> Sent: Sunday, March 26, 2023 1:32 PM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Wei Chen
> <harperchen1110@gmail.com>
> Subject: [PATCH v2] rtlwifi: fix incorrect error codes in rtl_debugfs_set_write_rfreg()
> 

Subject prefix should be "wifi: rtlwifi: ...".

[...]

