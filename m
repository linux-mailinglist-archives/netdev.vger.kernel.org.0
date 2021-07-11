Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E613C39D8
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 03:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhGKBaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 21:30:11 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:8780 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229640AbhGKBaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 21:30:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UfKzX5f_1625966840;
Received: from B-39YZML7H-2200.local(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0UfKzX5f_1625966840)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 11 Jul 2021 09:27:20 +0800
Subject: Re: [PATCH bpf-next v3 2/2] libbpf: Fix the possible memory leak
 caused by obj->kconfig
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1625798873-55442-1-git-send-email-chengshuyi@linux.alibaba.com>
 <1625798873-55442-3-git-send-email-chengshuyi@linux.alibaba.com>
 <20210710144248.GA1931@kadam>
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
Message-ID: <03eac45f-cc30-f9d3-ab36-892e5757e01b@linux.alibaba.com>
Date:   Sun, 11 Jul 2021 09:27:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210710144248.GA1931@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/21 10:42 PM, Dan Carpenter wrote:
> On Fri, Jul 09, 2021 at 10:47:53AM +0800, Shuyi Cheng wrote:
>> When obj->kconfig is NULL, ERR_PTR(-ENOMEM) should not be returned
>> directly, err=-ENOMEM should be set, and then goto out.
>>
> 
> The commit message needs to say what the problem is that the patch is
> fixing.  Here is a better commit message:
> 
> [PATCH bpf-next v3 2/2] libbpf: Fix the possible memory leak on error
> 
> If the strdup() fails then we need to call bpf_object__close(obj) to
> avoid a resource leak.
> 
> Add a Fixes tag as well.

Agree, Thanks.

After Andrii reviews the patch, I will resend a new patch.

regards,
Shuyi

> 
> regards,
> dan carpenter
> 
