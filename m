Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E785630EECB
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 09:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhBDIq0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 4 Feb 2021 03:46:26 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3003 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbhBDIqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 03:46:25 -0500
Received: from dggeme705-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4DWXCx6g35zRB4X;
        Thu,  4 Feb 2021 16:44:29 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 dggeme705-chm.china.huawei.com (10.1.199.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Thu, 4 Feb 2021 16:45:41 +0800
Received: from dggeme758-chm.china.huawei.com ([10.6.80.69]) by
 dggeme758-chm.china.huawei.com ([10.6.80.69]) with mapi id 15.01.2106.006;
 Thu, 4 Feb 2021 16:45:41 +0800
From:   "Wanghongzhe (Hongzhe, EulerOS)" <wanghongzhe@huawei.com>
To:     Kees Cook <keescook@chromium.org>
CC:     "luto@amacapital.net" <luto@amacapital.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "wad@chromium.org" <wad@chromium.org>, "yhs@fb.com" <yhs@fb.com>
Subject: RE: [PATCH v1 1/1] Firstly, as Andy mentioned, this should be
 smp_rmb() instead of rmb(). considering that TSYNC is a cross-thread
 situation, and rmb() is a mandatory barrier which should not be used to
 control SMP effects, since mandatory barriers imp...
Thread-Topic: [PATCH v1 1/1] Firstly, as Andy mentioned, this should be
 smp_rmb() instead of rmb(). considering that TSYNC is a cross-thread
 situation, and rmb() is a mandatory barrier which should not be used to
 control SMP effects, since mandatory barriers imp...
Thread-Index: AQHW+ZYNG0ZM5IaKEU+toWEn31X/L6pGJRPg
Date:   Thu, 4 Feb 2021 08:45:41 +0000
Message-ID: <0cf4c1e8bfd140aba69cfd36a0dac048@huawei.com>
References: <B1DC6A42-15AF-4804-B20E-FC6E2BDD1C8E@amacapital.net>
 <1612260787-28015-1-git-send-email-wanghongzhe@huawei.com>
 <202102021100.DB383A44@keescook>
In-Reply-To: <202102021100.DB383A44@keescook>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.177.164]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Let's start with a patch that just replaces rmb() with smp_rmb() and then work
> on optimizing. Can you provide performance numbers that show
> rmb() (and soon smp_rmb()) is causing actual problems here?
Ok, I will send a patch that just replaces rmb() with smp_rmb() and give performance numbers.

> BUG() should never be used[1]. This is a recoverable situation, I think, and
> should be handled as such.

I just follow the default case behind. Let's discuss this issue in next patches. 

-- 
wanghongzhe
