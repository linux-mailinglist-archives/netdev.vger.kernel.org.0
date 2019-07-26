Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339C275D08
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 04:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbfGZCdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 22:33:55 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2489 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfGZCdy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 22:33:54 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id B16413CB14A95963F1CF;
        Fri, 26 Jul 2019 10:33:52 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 26 Jul 2019 10:33:52 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Fri, 26
 Jul 2019 10:33:52 +0800
Subject: Re: [PATCH net-next 07/11] net: hns3: adds debug messages to identify
 eth down cause
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
 <1563938327-9865-8-git-send-email-tanhuazhong@huawei.com>
 <ffd942e7d7442549a3a6d469709b7f7405928afe.camel@mellanox.com>
 <30483e38-5e4a-0111-f431-4742ceb1aa62@huawei.com>
 <75a02bbe5b3b0f2755cd901a8830d4a3026f9383.camel@mellanox.com>
 <20190725182846.253ae93f@cakuba.netronome.com>
From:   liuyonglong <liuyonglong@huawei.com>
Message-ID: <fa64d1c8-c851-46ac-71a7-5eabc2277e54@huawei.com>
Date:   Fri, 26 Jul 2019 10:33:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190725182846.253ae93f@cakuba.netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme713-chm.china.huawei.com (10.1.199.109) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Saeed said, we will use netif_msg_drv() which is default off, this
can be easily open with ethtool.
Thanks for your reply!

On 2019/7/26 9:28, Jakub Kicinski wrote:
> On Thu, 25 Jul 2019 21:59:08 +0000, Saeed Mahameed wrote:
>> I couldn't find any rules regarding what to put in kernel log, Maybe
>> someone can share ?. but i vaguely remember that the recommendation
>> for device drivers is to put nothing, only error/warning messages.
> 
> FWIW my understanding is also that only error/warning messages should
> be printed. IOW things which should "never happen".
> 
> There are some historical exceptions. Probe logs for instance may be
> useful, because its not trivial to get to the device if probe fails.
> 
> Another one is ethtool flashing, if it takes time we used to print into
> logs some message like "please wait patiently". But since Jiri added
> the progress messages in devlink that's no longer necessary.
> 
> For the messages which are basically printing the name of the function
> or name of the function and their args - we have ftrace.
> 
> That's my $0.02 :)
> 
> .
> 

