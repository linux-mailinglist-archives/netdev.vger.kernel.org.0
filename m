Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D29ADA458
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 05:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407621AbfJQD1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 23:27:18 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50468 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732869AbfJQD1S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 23:27:18 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6D5C04454FFB9CF198AE;
        Thu, 17 Oct 2019 11:27:16 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Thu, 17 Oct 2019
 11:27:09 +0800
Subject: Re: [PATCH net-next 00/12] net: hns3: add some bugfixes and
 optimizations
To:     David Miller <davem@davemloft.net>, <jakub.kicinski@netronome.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>
References: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
 <20191016101943.415d73cf@cakuba.netronome.com>
 <20191016.135003.672960397161023411.davem@davemloft.net>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <d76b854c-5f6d-27b6-d40e-e3c0404b5695@huawei.com>
Date:   Thu, 17 Oct 2019 11:27:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20191016.135003.672960397161023411.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/10/17 1:50, David Miller wrote:
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Wed, 16 Oct 2019 10:19:43 -0700
> 
>> On Wed, 16 Oct 2019 15:16:59 +0800, Huazhong Tan wrote:
>>> This patch-set includes some bugfixes and code optimizations
>>> for the HNS3 ethernet controller driver.
>>
>> The code LGTM, mostly, but it certainly seems like patches 2, 3 and 4
>> should be a separate series targeting the net tree :(
> 
> Agreed, there are legitimate bug fixes.
> 
> I have to say that I see this happening a lot, hns3 bug fixes targetting
> net-next in a larger series of cleanups and other kinds of changes.
> 
> Please handle this delegation properly.  Send bug fixes as a series targetting
> 'net', and send everything else targetting 'net-next'.
> 

Hi, David & Jakub.

BTW, patch01 is a cleanup which is needed by patch02,
if patch01 targetting 'net-next', patch02 targetting 'net',
there will be a gap again. How should I deal with this case?

MBR.
Huazhong.

> .
> 

