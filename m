Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AA8465C14
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 03:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354488AbhLBCXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 21:23:20 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:30581 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1354609AbhLBCXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 21:23:20 -0500
IronPort-Data: =?us-ascii?q?A9a23=3A78o3M6OHihFxhhLvrR0AlcFynXyQoLVcMsFnjC/?=
 =?us-ascii?q?WdQO6hTwh1mRUnGIeXmnVP6qCZzOne9B/a9i/90kFsZ/Vm99gGjLY11k3ESsS9?=
 =?us-ascii?q?pCt6fd1j6vIF3rLaJWFFSqL1u1GAjX7BJ1yHiC0SiuFaOC79CAmjfjQHdIQNca?=
 =?us-ascii?q?fUsxPbV49IMseoUI78wIJqtYAbemRW2thi/uryyHsEAPNNwpPD44hw/nrRCWDE?=
 =?us-ascii?q?xjFkGhwUlQWPZintbJF/pUfJMp3yaqZdxMUTmTId9NWSdovzJnhlo/Y1xwrTN2?=
 =?us-ascii?q?4kLfnaVBMSbnXVeSMoiMOHfH83V4Z/Wpvuko4HKN0hUN/jzSbn9FzydxLnZKtS?=
 =?us-ascii?q?wY1JbCKk+MYO/VdO3gnbfYeou6XehBTtuTWlSUqaUDEz/xwAUQeMYQG9+NzBm9?=
 =?us-ascii?q?Ss/oVNFglYguKh++sxpq0T+BtgoIoK8yDFIACsHhIzjzDC/siB5fZTM3i/t9F1?=
 =?us-ascii?q?TcYhc1UG/vaIc0DZlJHaBXGfg0KOVoNDp86tPmni2O5cDBCrl+R460t7AD7yA1?=
 =?us-ascii?q?3zaioM8HYftKWSN5JtliXq3iA/GnjBBwectuFxlKt9H+wiuLRtT30VZhUF7Ci8?=
 =?us-ascii?q?PNuxlqJyQQu5Lc+PbegiaDhzBfgBJQEcApJkhfCZJMarCSDJuQRlTXhyJJcgiM?=
 =?us-ascii?q?hZg=3D=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3Aqb7+sau6hYAUpminyxjYX4Wa7skDE9V00zEX?=
 =?us-ascii?q?/kB9WHVpm62j9/xG88536faZslwssRIb+OxoWpPufZq0z/ccirX5VY3SPzUO01?=
 =?us-ascii?q?HFEGgN1+Xf/wE=3D?=
X-IronPort-AV: E=Sophos;i="5.87,280,1631548800"; 
   d="scan'208";a="118302983"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 02 Dec 2021 10:19:52 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id C47074D13A0B;
        Thu,  2 Dec 2021 10:19:50 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 2 Dec 2021 10:19:52 +0800
Received: from [192.168.122.212] (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Thu, 2 Dec 2021 10:19:50 +0800
Subject: Re: [PATCH 1/3] selftest: net: Correct case name
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <shuah@kernel.org>, <dsahern@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20211201111025.13834-1-lizhijian@cn.fujitsu.com>
 <20211201175426.2e86322f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Li, Zhijian" <lizhijian@cn.fujitsu.com>
Message-ID: <69dce621-55b7-fdb2-f8f1-57d8d6a43a35@cn.fujitsu.com>
Date:   Thu, 2 Dec 2021 10:19:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20211201175426.2e86322f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-yoursite-MailScanner-ID: C47074D13A0B.ABB91
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


on 2021/12/2 9:54, Jakub Kicinski wrote:
> On Wed, 1 Dec 2021 19:10:23 +0800 Li Zhijian wrote:
>> ipv6_addr_bind/ipv4_addr_bind are function name.
>>
>> Fixes: 34d0302ab86 ("selftests: Add ipv6 address bind tests to fcnal-test")
>> Fixes: 75b2b2b3db4 ("selftests: Add ipv4 address bind tests to fcnal-test")
>> Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
> Please send this patch separately from patches 2 and 3. This one is
> a fix (AFAIU) and needs to be applied to a different tree. Patches 2
> and 3 look like improvements / cleanups.
>
Got it,  I will fix it ASAP

Thanks

Zhijian



