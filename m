Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092A5DA2DE
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 02:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393249AbfJQA4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 20:56:05 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50300 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726521AbfJQA4F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 20:56:05 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F2AB63D1BBA825DC4DFA;
        Thu, 17 Oct 2019 08:56:02 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 17 Oct 2019
 08:55:54 +0800
Subject: Re: [PATCH net-next 00/12] net: hns3: add some bugfixes and
 optimizations
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
References: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
 <20191016101943.415d73cf@cakuba.netronome.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <04c9b43c-e54c-ef52-e45a-b51469df75d1@huawei.com>
Date:   Thu, 17 Oct 2019 08:55:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20191016101943.415d73cf@cakuba.netronome.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/10/17 1:19, Jakub Kicinski wrote:
> On Wed, 16 Oct 2019 15:16:59 +0800, Huazhong Tan wrote:
>> This patch-set includes some bugfixes and code optimizations
>> for the HNS3 ethernet controller driver.
> 
> The code LGTM, mostly, but it certainly seems like patches 2, 3 and 4
> should be a separate series targeting the net tree :(
> 

ok, I will pick out the bugfix and upstream to net tree firstly.
Thanks.

> 

