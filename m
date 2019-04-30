Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C68B4FB7B
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 16:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbfD3O2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 10:28:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33474 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725942AbfD3O2W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 10:28:22 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C0A3FBD7A962FC3D7C33;
        Tue, 30 Apr 2019 22:28:19 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 22:28:15 +0800
Subject: Re: [PATCH] 9p/virtio: Add cleanup path in p9_virtio_init
To:     Dominique Martinet <asmadeus@codewreck.org>
References: <20190430115942.41840-1-yuehaibing@huawei.com>
 <20190430140907.GA19422@nautica>
CC:     <davem@davemloft.net>, <ericvh@gmail.com>, <lucho@ionkov.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <v9fs-developer@lists.sourceforge.net>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <a22ebdaa-0dcd-8ed0-44e8-2d1218708eb0@huawei.com>
Date:   Tue, 30 Apr 2019 22:28:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190430140907.GA19422@nautica>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/4/30 22:09, Dominique Martinet wrote:
> YueHaibing wrote on Tue, Apr 30, 2019:
>> KASAN report this:
> 
> That's not KASAN, but fair enough - fix looks good. I'll queue this for
> 5.2 unless you absolutely want this in 5.1

Yes, this is not KASAN, just FAULT INJECTION.

> 
> If you're feeling nice p9_trans_xen_init has the exact same problem and
> could use the same fix :)

ok, I can fix it in another patch, thanks!

> 

