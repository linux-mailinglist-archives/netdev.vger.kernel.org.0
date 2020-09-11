Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3EC2656C7
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 03:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgIKB6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 21:58:11 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11807 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725298AbgIKB6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 21:58:09 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F2BD08D9AA58D4C9B10A;
        Fri, 11 Sep 2020 09:42:25 +0800 (CST)
Received: from [10.174.179.81] (10.174.179.81) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Fri, 11 Sep 2020 09:42:24 +0800
Subject: Re: [PATCH net-next 0/3] Fix some kernel-doc warnings for
 e1000/e1000e
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200910150429.31912-1-wanghai38@huawei.com>
 <20200910123800.74865996@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200910123819.3ce47422@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <53e857ff-f5c7-a2c9-b0ec-67c2d4ad29c3@huawei.com>
Date:   Fri, 11 Sep 2020 09:42:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200910123819.3ce47422@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2020/9/11 3:38, Jakub Kicinski Ð´µÀ:
> On Thu, 10 Sep 2020 12:38:00 -0700 Jakub Kicinski wrote:
>> On Thu, 10 Sep 2020 23:04:26 +0800 Wang Hai wrote:
>>> Wang Hai (3):
>>>    e1000e: Fix some kernel-doc warnings in ich8lan.c
>>>    e1000e: Fix some kernel-doc warnings in netdev.c
>>>    e1000: Fix a bunch of kerneldoc parameter issues in e1000_hw.c
>> You should put some text here but I can confirm this set removes 17
>> warnings.
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> .
Thans for your review, I'll add some description next time
