Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C03CAA575
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 16:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbfIEOKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 10:10:47 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6231 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727914AbfIEOKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 10:10:47 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0FE5E5BA7995343B8379;
        Thu,  5 Sep 2019 22:10:45 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.68) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Sep 2019
 22:10:41 +0800
Message-ID: <5D711760.20903@huawei.com>
Date:   Thu, 5 Sep 2019 22:10:40 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hostap: remove set but not used variable 'copied' in
 prism2_io_debug_proc_read
References: <1567497430-22539-1-git-send-email-zhongjiang@huawei.com> <5D6E1DF2.1000109@huawei.com> <87zhjij1q6.fsf@tynnyri.adurom.net>
In-Reply-To: <87zhjij1q6.fsf@tynnyri.adurom.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.68]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/9/5 21:45, Kalle Valo wrote:
> zhong jiang <zhongjiang@huawei.com> writes:
>
>> Please ignore the patch.  Because  the hostap_proc.c is marked as 'obsolete'.
> You mean marked in the MAINTAINERS file? I don't see that as a problem,
> I can (and should) still apply any patches submitted to hostap driver.
>
I  hit the following issue when checking the patch by checkpatch.pl

WARNING: drivers/net/wireless/intersil/hostap/hostap_proc.c is marked as 'obsolete' in the MAINTAINERS hierarchy.
No unnecessary modifications please.

I certainly hope it can be appiled to upstream if the above check doesn't matter.

Thanks,
zhong jiang

