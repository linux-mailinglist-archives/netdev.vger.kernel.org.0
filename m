Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7963A21AE
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 03:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhFJBDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 21:03:44 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8121 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFJBDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 21:03:43 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0lwZ6q4nzYrx0;
        Thu, 10 Jun 2021 08:58:54 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 09:01:45 +0800
Received: from [127.0.0.1] (10.174.177.72) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 10 Jun
 2021 09:01:44 +0800
Subject: Re: [PATCH 1/1] lib: Fix spelling mistakes
To:     <nicolas.dichtel@6wind.com>, Jason Baron <jbaron@akamai.com>,
        "Stefani Seibold" <stefani@seibold.net>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jens Axboe" <axboe@kernel.dk>, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210607072555.12416-1-thunder.leizhen@huawei.com>
 <eff5217f-74b5-3067-9210-6b2eb5ea5f4d@6wind.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <b8aa70b3-e4ac-e488-85cf-b5d70b8779e4@huawei.com>
Date:   Thu, 10 Jun 2021 09:01:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <eff5217f-74b5-3067-9210-6b2eb5ea5f4d@6wind.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/6/9 23:33, Nicolas Dichtel wrote:
> Le 07/06/2021 à 09:25, Zhen Lei a écrit :
>> Fix some spelling mistakes in comments:
>> permanentely ==> permanently
>> wont ==> won't
>> remaning ==> remaining
>> succed ==> succeed
>> shouldnt ==> shouldn't
>> alpha-numeric ==> alphanumeric
>> storeing ==> storing
>> funtion ==> function
>> documenation ==> documentation
>> Determin ==> Determine
>> intepreted ==> interpreted
>> ammount ==> amount
>> obious ==> obvious
>> interupts ==> interrupts
>> occured ==> occurred
>> asssociated ==> associated
>> taking into acount ==> taking into account
>> squence ==> sequence
>> stil ==> still
>> contiguos ==> contiguous
>> matchs ==> matches
> I don't know if there is already a patch flying somewhere, but it would be good
> to add those typos in scripts/spelling.txt

Sorry, I'm inexperienced, I will add them this week.

> 
> 
> Regards,
> Nicolas
> 
> .
> 

