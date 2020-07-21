Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1E32278BE
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 08:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgGUGQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 02:16:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7802 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbgGUGQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 02:16:35 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 60ACBE0D13EC4424A248;
        Tue, 21 Jul 2020 14:16:32 +0800 (CST)
Received: from [127.0.0.1] (10.174.178.16) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Tue, 21 Jul 2020
 14:16:28 +0800
Subject: Re: [PATCH] net-sysfs: add a newline when printing 'tx_timeout' by
 sysfs
To:     David Miller <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1595243869-57100-1-git-send-email-wangxiongfeng2@huawei.com>
 <20200720.174432.702526374205425580.davem@davemloft.net>
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
Message-ID: <f9dd7249-3606-8ebe-8913-082953735817@huawei.com>
Date:   Tue, 21 Jul 2020 14:16:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200720.174432.702526374205425580.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.16]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2020/7/21 8:44, David Miller wrote:
> From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> Date: Mon, 20 Jul 2020 19:17:49 +0800
> 
>> -	return sprintf(buf, "%lu", trans_timeout);
>> +	return sprintf(buf, "%lu\n", trans_timeout);
> 
> Better to replace it with 'fmt_ulong'.

Thanks for your advice. I will change it in the next version.

Thanks,
Xiongfeng

> 
> .
> 

