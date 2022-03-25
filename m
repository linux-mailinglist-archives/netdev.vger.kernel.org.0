Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085D54E6BDE
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 02:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357211AbiCYBRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 21:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347681AbiCYBRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 21:17:18 -0400
Received: from mail.meizu.com (edge07.meizu.com [112.91.151.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B85FA88B4;
        Thu, 24 Mar 2022 18:15:44 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail11.meizu.com
 (172.16.1.15) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 25 Mar
 2022 09:15:42 +0800
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by
 IT-EXMB-1-125.meizu.com (172.16.1.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 25 Mar 2022 09:15:41 +0800
Received: from IT-EXMB-1-125.meizu.com ([fe80::7481:7d92:3801:4575]) by
 IT-EXMB-1-125.meizu.com ([fe80::7481:7d92:3801:4575%3]) with mapi id
 15.01.2308.014; Fri, 25 Mar 2022 09:15:41 +0800
From:   =?gb2312?B?sNe6xs7E?= <baihaowen@meizu.com>
To:     Martin KaFai Lau <kafai@fb.com>
CC:     "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBzZWxmdGVzdHMvYnBmOiBGaXggd2FybmluZyBjb21w?=
 =?gb2312?Q?aring_pointer_to_0?=
Thread-Topic: [PATCH] selftests/bpf: Fix warning comparing pointer to 0
Thread-Index: AQHYPyQY+/rIQg2pqkmK304IAEGadqzOdyMAgADV6A8=
Date:   Fri, 25 Mar 2022 01:15:41 +0000
Message-ID: <c1b8dd58744345538d122468e4c0def3@meizu.com>
References: <1648087725-29435-1-git-send-email-baihaowen@meizu.com>,<20220324202848.2ncrqbzv3dv5qifo@kafai-mbp>
In-Reply-To: <20220324202848.2ncrqbzv3dv5qifo@kafai-mbp>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.137.70]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

aGksIGthZmFpDQoNCi4vc2NyaXB0cy9jb2NjaWNoZWNrIHJlcG9ydCB0aGlzIHdhcm5pbmcuDQpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQq3orz+yMs6IE1hcnRpbiBL
YUZhaSBMYXUgPGthZmFpQGZiLmNvbT4NCreiy83KsbzkOiAyMDIyxOoz1MIyNcjVIDQ6Mjg6NDgN
CsrVvP7IyzogsNe6xs7EDQqzrcvNOiBzaHVhaEBrZXJuZWwub3JnOyBhc3RAa2VybmVsLm9yZzsg
ZGFuaWVsQGlvZ2VhcmJveC5uZXQ7IGFuZHJpaUBrZXJuZWwub3JnOyBzb25nbGl1YnJhdmluZ0Bm
Yi5jb207IHloc0BmYi5jb207IGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbTsga3BzaW5naEBrZXJu
ZWwub3JnOyBsaW51eC1rc2VsZnRlc3RAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBicGZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
DQrW98ziOiBSZTogW1BBVENIXSBzZWxmdGVzdHMvYnBmOiBGaXggd2FybmluZyBjb21wYXJpbmcg
cG9pbnRlciB0byAwDQoNCk9uIFRodSwgTWFyIDI0LCAyMDIyIGF0IDEwOjA4OjQ1QU0gKzA4MDAs
IEhhb3dlbiBCYWkgd3JvdGU6DQo+IEF2b2lkIHBvaW50ZXIgdHlwZSB2YWx1ZSBjb21wYXJlZCB3
aXRoIDAgdG8gbWFrZSBjb2RlIGNsZWFyLg0KV2hpY2ggY29tcGlsZXIgdmVyc2lvbiB0aGF0IHdh
cm5zID8NCkkgZG9uJ3Qgc2VlIGl0IHdpdGggdGhlIGxhdGVzdCBsbHZtLXByb2plY3QgZnJvbSBn
aXRodWIuDQoNClRoZSBwYXRjaCBsZ3RtLg0KDQpBY2tlZC1ieTogTWFydGluIEthRmFpIExhdSA8
a2FmYWlAZmIuY29tPg0K
