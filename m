Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F8347B6C7
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 02:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhLUBVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 20:21:12 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:29271 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhLUBVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:21:11 -0500
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JHzDH03rRzbjVM;
        Tue, 21 Dec 2021 09:20:47 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 09:21:08 +0800
Subject: Re: [PATCH -next V2] sysctl: returns -EINVAL when a negative value is
 passed to proc_doulongvec_minmax
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     <akpm@linux-foundation.org>, <keescook@chromium.org>,
        <yzaikin@google.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <yukuai3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Baokun Li <libaokun1@huawei.com>
References: <20211220092627.3744624-1-libaokun1@huawei.com>
 <YcDWx1P1NdqgED1i@bombadil.infradead.org>
From:   "libaokun (A)" <libaokun1@huawei.com>
Message-ID: <6ec2155c-c976-4c9b-1975-c28792bb3144@huawei.com>
Date:   Tue, 21 Dec 2021 09:21:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YcDWx1P1NdqgED1i@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2021/12/21 3:17, Luis Chamberlain 写道:
> On Mon, Dec 20, 2021 at 05:26:27PM +0800, Baokun Li wrote:
>> When we pass a negative value to the proc_doulongvec_minmax() function,
>> the function returns 0, but the corresponding interface value does not
>> change.
>>
>> we can easily reproduce this problem with the following commands:
>>      `cd /proc/sys/fs/epoll`
>>      `echo -1 > max_user_watches; echo $?; cat max_user_watches`
>>
>> This function requires a non-negative number to be passed in, so when
>> a negative number is passed in, -EINVAL is returned.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Acked-by: Luis Chamberlain <mcgrof@kernel.org>
>
>   Luis
> .

Thank you for your Ack.

-- 
With Best Regards,
Baokun Li

